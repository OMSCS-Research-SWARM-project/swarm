# Architecture-Specific Setup Reference

## Quick Comparison

| Feature | x86_64 (Intel/AMD) | ARM (Apple Silicon) |
|---------|-------------------|---------------------|
| **Hypervisor** | VirtualBox | UTM |
| **Ubuntu ISO** | Ubuntu 24.04 Server (AMD64) | Ubuntu 24.04 Server (ARM64) |
| **Desktop Environment** | Xfce | LXDE |
| **Download URL** | https://ubuntu.com/download/server | https://cdimage.ubuntu.com/releases/24.04/release/ |

## Detection in Ansible

The playbook uses `ansible_architecture` fact to detect the system:
- `x86_64` → Installs Xfce
- `aarch64` → Installs LXDE

## Why Different Desktop Environments?

### Xfce (x86_64)
- Full-featured desktop environment
- Good balance of features and performance
- Familiar interface for most users
- Better compatibility with VirtualBox Guest Additions

### LXDE (ARM)
- Lightweight and optimized for ARM
- Lower memory footprint
- Better performance on UTM/ARM virtualization
- Faster startup times

## Testing Your Setup

### Check Architecture
```bash
# On the VM after setup
uname -m
# x86_64 → Intel/AMD
# aarch64 → ARM

# Check installed desktop
echo $XDG_CURRENT_DESKTOP
# XFCE → x86 setup
# LXDE → ARM setup
```

### Verify Desktop Environment Packages

**x86_64:**
```bash
dpkg -l | grep xfce4
# Should show xfce4 and xfce4-goodies packages
```

**ARM:**
```bash
dpkg -l | grep lxde
# Should show LXDE packages
```

## Common Issues by Architecture

### x86_64 Specific
- **VirtualBox Guest Additions:** May need manual installation for better resolution
- **3D Acceleration:** Can be enabled in VirtualBox settings for smoother graphics

### ARM Specific
- **UTM SPICE Guest Tools:** Install for better clipboard/resolution support:
  ```bash
  sudo apt install spice-vdagent spice-webdavd
  ```
- **Display Resolution:** May need manual adjustment in UTM display settings
- **Network Bridge Mode:** Some UTM versions require specific network configuration

## Performance Optimization

### x86_64 VMs
- Allocate at least 4GB RAM (8GB recommended)
- Enable 2+ CPU cores
- Enable VT-x/AMD-V in BIOS if not already enabled

### ARM VMs
- Allocate at least 4GB RAM (6-8GB recommended for better performance)
- Enable Rosetta 2 in UTM if running x86 binaries (not needed for Ghidra)
- Use "Emulated" rather than "Virtualized" mode in UTM for better compatibility

## Distribution to Students

When creating the OVA/export:

**For x86_64:**
1. Shutdown the VM cleanly
2. VirtualBox → File → Export Appliance
3. Choose OVA 2.0 format
4. Filename: `swarm-ghidra-vm-x86_64.ova`

**For ARM:**
1. Shutdown the VM cleanly
2. UTM → Right-click VM → Share
3. Export as: `swarm-ghidra-vm-arm64.utm`
4. Or compress the VM bundle: `swarm-ghidra-vm-arm64.zip`

**Provide both versions to students:**
- Intel/AMD Mac users: Use x86_64 OVA with VirtualBox
- Apple Silicon Mac users: Use ARM64 UTM bundle with UTM

## Student Instructions by Platform

### Intel/AMD Mac or PC (x86_64)
1. Install VirtualBox from virtualbox.org
2. Double-click the `swarm-ghidra-vm-x86_64.ova` file
3. Import with default settings
4. Start the VM
5. Auto-login as swarm (password: swarm if prompted)

### Apple Silicon Mac (M1/M2/M3/M4)
1. Install UTM from getutm.app (free)
2. Open UTM
3. Import the `swarm-ghidra-vm-arm64.utm` or extract the ZIP
4. Start the VM
5. Auto-login as swarm (password: swarm if prompted)

## Ansible Playbook Logic

The key conditional tasks in the playbook:

```yaml
# Desktop Environment Selection
- name: Install Xfce desktop environment (x86_64)
  apt:
    name:
      - xfce4
      - xfce4-goodies
  when: ansible_architecture == "x86_64"

- name: Install LXDE desktop environment (ARM)
  apt:
    name:
      - lxde
  when: ansible_architecture == "aarch64"
```

This ensures the appropriate environment is installed without manual intervention.
