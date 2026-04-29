# Ghidra VM Setup with Ansible

This directory contains Ansible configuration to automatically set up an Ubuntu 24.04 VM for malware analysis with Ghidra.

## Prerequisites

1. **Fresh Ubuntu 24.04 VM** installed in VirtualBox or UTM
   - **x86_64:** Ubuntu 24.04 Server for Intel/AMD
   - **ARM (Apple Silicon):** Ubuntu 24.04 Server ARM64 for M1/M2/M3/M4 Macs
2. **Ansible** installed on your control machine (the machine you'll run Ansible from)
3. **SSH access** to the VM
4. **User swarm** created on the VM with password `swarm` and sudo privileges

**Note on Architecture:** The playbook automatically detects your VM's architecture and installs the appropriate desktop environment:
- x86_64: Xfce (lightweight, full-featured)
- ARM: LXDE (optimized for ARM performance)

## Quick Start

### 1. Set up the swarm user on the fresh VM

**For x86_64 (VirtualBox on Intel/AMD):**

Download Ubuntu 24.04 Server from: https://ubuntu.com/download/server

**For ARM (UTM on Apple Silicon Macs):**

Download Ubuntu 24.04 Server ARM64 from: https://cdimage.ubuntu.com/releases/24.04/release/

Then, SSH into your fresh Ubuntu 24.04 VM and run:

```bash
# Create swarm user with sudo privileges
sudo useradd -m -s /bin/bash -G sudo swarm
echo "swarm:swarm" | sudo chpasswd

# Install openssh-server if not already installed
sudo apt update
sudo apt install -y openssh-server python3

# Enable SSH
sudo systemctl enable --now ssh
```

### 2. Find your VM's IP address

On the VM, run:
```bash
hostname -I
```

### 3. Update the inventory file

Edit `inventory.ini` and replace `192.168.1.100` with your VM's actual IP address.

### 4. Install Ansible on your control machine

**macOS:**
```bash
brew install ansible
```

**Ubuntu/Debian:**
```bash
sudo apt install ansible
```

**Using pip:**
```bash
pip3 install ansible
```

### 5. Run the playbook

```bash
ansible-playbook -i inventory.ini setup_ghidra_vm.yml
```

The playbook will:
- Install essential utilities (vim, htop, net-tools, etc.)
- Install Wireshark and network analysis tools
- Install Java 21 (required for Ghidra)
- Download and install Ghidra 11.2.1
- Clone the Mirai source code repository
- Configure the environment for analysis
- Create helpful aliases and desktop shortcuts

## What Gets Installed

### Desktop Environment
- **x86_64 (Intel/AMD):** Xfce desktop with LightDM
- **ARM (Apple Silicon):** LXDE desktop with LightDM
- Auto-login configured for swarm user

### Utilities
- net-tools, vim, htop, tmux
- curl, wget, git, tree, unzip
- build-essential, python3-pip

### Network Analysis
- Wireshark (GUI)
- tshark (command-line)
- tcpdump
- nmap

### Reverse Engineering
- Ghidra 11.2.1 (latest as of Nov 2024)
- Java 21 JDK

### Malware Samples
- Mirai source code (cloned to ~/Mirai-Source-Code)

## Student VM Details

**Login Credentials:**
- Username: `swarm`
- Password: `swarm`

**Important Directories:**
- `/opt/ghidra` - Ghidra installation
- `~/Mirai-Source-Code` - Mirai botnet source code
- `~/GhidraProjects` - Ghidra project storage
- `~/malware-analysis` - Working directory

**Helpful Commands:**
- `ghidra` - Launch Ghidra
- `mirai` - cd to Mirai source directory
- `workspace` - cd to analysis workspace

## Troubleshooting

### Connection Issues

If Ansible can't connect:
```bash
# Test SSH connection
ssh swarm@<VM_IP>

# If SSH keys cause issues, use password auth
ansible-playbook -i inventory.ini setup_ghidra_vm.yml -k -K
# (-k asks for SSH password, -K asks for sudo password)
```

### ARM/Apple Silicon Specific Issues

**UTM Networking:**
- Make sure the VM is using "Shared Network" mode in UTM settings
- Find the VM's IP with: `hostname -I` from within the VM
- On some UTM configurations, you may need to use "Bridged" networking instead

**Desktop Environment Not Loading:**
```bash
# Check if LightDM is running
sudo systemctl status lightdm

# If not running, start it
sudo systemctl start lightdm

# Check logs if issues persist
sudo journalctl -u lightdm
```

### Ghidra Download Issues

If the Ghidra download fails, you can:
1. Manually download from https://ghidra-sre.org
2. Update the `ghidra_version` and `ghidra_release_date` variables in the playbook
3. Or place the .zip file in /tmp/ghidra_download/ghidra.zip on the VM

## Updating Ghidra Version

To install a different version of Ghidra, edit the variables in `setup_ghidra_vm.yml`:

```yaml
vars:
  ghidra_version: "11.2.1"  # Change version here
  ghidra_release_date: "20241105"  # Change release date here
```

Check https://github.com/NationalSecurityAgency/ghidra/releases for the latest version.

## Security Notes

⚠️ **IMPORTANT:** This VM will contain real malware samples. 

Best practices:
- Keep the VM isolated from production networks
- Use NAT or host-only networking in VirtualBox
- Take snapshots before analysis
- Never run the malware binaries
- Export this VM as an OVA for distribution to students

## Post-Installation Verification

After the playbook completes, restart the VM and verify:

1. **Desktop loads automatically:** VM should auto-login to the desktop environment
2. **Ghidra desktop icon visible:** Check the Desktop folder for the Ghidra launcher
3. **Ghidra launches:** Double-click the icon or run `ghidra` from terminal
4. **Mirai source available:** Check `~/Mirai-Source-Code` directory exists
5. **Network tools work:** Test with `wireshark`, `tshark -v`, `nmap --version`

Quick verification commands:
```bash
# Check desktop environment
echo $XDG_CURRENT_DESKTOP

# Verify Ghidra installation
/opt/ghidra/ghidraRun --version

# Check Mirai source
ls -la ~/Mirai-Source-Code

# Verify network tools
wireshark --version
tshark --version
```

## Creating Student Distribution

Once configured, export the VM:

1. **VirtualBox:** File → Export Appliance → Select VM → Choose OVA format
2. Compress the OVA file for distribution
3. Include VM import instructions for students

## License

The tools installed by this playbook are subject to their respective licenses:
- Ghidra: Apache License 2.0
- Ubuntu: Various open source licenses
- Malware samples: For educational use only
