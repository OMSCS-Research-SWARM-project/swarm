#!/bin/bash

# Dynamic Network Interface Configuration for Cross-Platform VMs
# Place this script in /usr/local/bin/configure-network-interface.sh
# and call it from /etc/rc.local

NETPLAN_FILE="/etc/netplan/50-cloud-init.yaml"
BACKUP_FILE="/etc/netplan/50-cloud-init.yaml.backup"

# Create backup of original netplan file if it doesn't exist
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$NETPLAN_FILE" "$BACKUP_FILE"
fi

# Function to detect the primary network interface
detect_primary_interface() {
    # Get all network interfaces except loopback and virtual ones
    for interface in $(ls /sys/class/net/ | grep -v lo | grep -v docker | grep -v br-); do
        # Check if the interface has a carrier (is physically connected)
        if [ -f "/sys/class/net/$interface/carrier" ]; then
            carrier=$(cat "/sys/class/net/$interface/carrier" 2>/dev/null)
            if [ "$carrier" = "1" ]; then
                echo "$interface"
                return 0
            fi
        fi
        
        # If no carrier file, check if interface is up
        if ip link show "$interface" | grep -q "state UP"; then
            echo "$interface"
            return 0
        fi
    done
    
    # Fallback: return first non-loopback interface
    ls /sys/class/net/ | grep -v lo | grep -v docker | grep -v br- | head -n1
}

# Function to update netplan configuration
update_netplan() {
    local interface_name="$1"

    # Read the current netplan file and replace the interface name
    # This assumes a standard cloud-init netplan structure
    cat > "$NETPLAN_FILE" << EOF
network:
    ethernets:
        $interface_name:
            dhcp4: true
            dhcp6: false
            optional: true
    version: 2
EOF

    # Set proper permissions for netplan file
    chmod 600 "$NETPLAN_FILE"

    echo "Updated $NETPLAN_FILE with interface: $interface_name"
}

# Function to update netplan while preserving existing configuration
update_netplan_preserve() {
    local new_interface="$1"
    local temp_file

    # Create a secure temp file
    temp_file=$(mktemp) || {
        echo "Error: Could not create temp file, using simple template instead"
        update_netplan "$new_interface"
        return 1
    }

    # Use awk to replace the interface name while preserving the rest of the config
    # This finds the line after "ethernets:" and replaces the interface name
    awk -v new_int="$new_interface" '
    /^[[:space:]]*ethernets:[[:space:]]*$/ {
        print $0
        getline
        # Capture leading whitespace and replace interface name
        match($0, /^[[:space:]]*/)
        indent = substr($0, 1, RLENGTH)
        print indent new_int ":"
        next
    }
    { print }
    ' "$BACKUP_FILE" > "$temp_file"

    # Validate the YAML syntax
    if python3 -c "import yaml; yaml.safe_load(open('$temp_file'))" 2>/dev/null; then
        mv "$temp_file" "$NETPLAN_FILE"
        chmod 600 "$NETPLAN_FILE"
        echo "Successfully updated netplan with interface: $new_interface"
        return 0
    else
        echo "Error: Generated invalid YAML, using simple template instead"
        rm -f "$temp_file"
        update_netplan "$new_interface"
        return 1
    fi
}

# Main execution
main() {
    echo "Starting dynamic network interface configuration..."
    
    # Detect the primary network interface
    PRIMARY_INTERFACE=$(detect_primary_interface)
    
    if [ -z "$PRIMARY_INTERFACE" ]; then
        echo "Error: Could not detect network interface"
        exit 1
    fi
    
    echo "Detected primary network interface: $PRIMARY_INTERFACE"
    
    # Check if the interface in netplan already matches
    if grep -q "$PRIMARY_INTERFACE:" "$NETPLAN_FILE" 2>/dev/null; then
        echo "Network interface already configured correctly: $PRIMARY_INTERFACE"
        exit 0
    fi
    
    # Update the netplan configuration
    if ! update_netplan_preserve "$PRIMARY_INTERFACE"; then
        echo "Fallback update completed"
    fi
    
    # Update RestartNetworking.sh script with detected interface
    RESTART_SCRIPT="/home/pentest/pentestproject/RestartNetworking.sh"
    if [ -f "$RESTART_SCRIPT" ]; then
        echo "Updating RestartNetworking.sh with interface: $PRIMARY_INTERFACE"
        cat > "$RESTART_SCRIPT" << EOF
#!/bin/bash
ip link set $PRIMARY_INTERFACE down
ip link set $PRIMARY_INTERFACE up
echo "Networking services restarted."
EOF
        chmod 0755 "$RESTART_SCRIPT"
        chown pentest:pentest "$RESTART_SCRIPT"
        echo "RestartNetworking.sh updated successfully"
    else
        echo "Warning: RestartNetworking.sh not found at $RESTART_SCRIPT"
    fi

    # Apply the new configuration
    echo "Applying netplan configuration..."
    netplan apply

    echo "Network interface configuration completed successfully"
}

# Run main function
main "$@"
