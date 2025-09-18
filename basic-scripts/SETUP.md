# FreeBSD Thin Client Setup

Secure thin client configuration for FreeBSD mini-PCs.

## Setup Sequence

Run scripts in this exact order:

1. `./installing_software.sh` - Install required packages
2. `./setup_xdmcp.sh` - Configure XDMCP client
3. `./setup_ttys.sh` - Lock down local shells
4. `./setup_pf_lan_only.sh` - Configure firewall
5. `reboot` - Apply all changes

## Result

- Users: Can only log into jail via XDMCP (192.168.68.17)
- Admins: Can SSH from local subnet (192.168.68.0/24)
- No local shell access for users
- Auto-launches X server on boot
