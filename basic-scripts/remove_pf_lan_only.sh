#!/bin/sh
# FreeBSD PF firewall removal
set -eu

echo "Removing PF firewall configuration..."

# Stop PF service
service pf stop 2>/dev/null || true

# Unload PF module
kldunload pf 2>/dev/null || true

# Remove from rc.conf
sed -i '' '/^pf_enable="YES"$/d' /etc/rc.conf 2>/dev/null || true
sed -i '' '/^pf_rules="\/etc\/pf.conf"$/d' /etc/rc.conf 2>/dev/null || true

# Remove from loader.conf
sed -i '' '/^pf_load="YES"$/d' /boot/loader.conf 2>/dev/null || true

# Remove PF rules file
rm -f /etc/pf.conf

echo "PF firewall removed successfully"
echo "Reboot recommended for complete cleanup"