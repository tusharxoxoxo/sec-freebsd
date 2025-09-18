#!/bin/sh
# FreeBSD LAN-only firewall setup
set -e

# Configuration
LAN_IF="wlan0"
LAN_NET="192.168.68.0/24" # we can make it more specific if needed  

echo "Setting up PF firewall for LAN-only access..."

# Enable PF in rc.conf
if ! grep -q '^pf_enable="YES"' /etc/rc.conf 2>/dev/null; then
    echo 'pf_enable="YES"' >> /etc/rc.conf
fi

# Load PF at boot
if ! grep -q '^pf_load="YES"' /boot/loader.conf 2>/dev/null; then
    echo 'pf_load="YES"' >> /boot/loader.conf
fi

# Create PF rules
cat > /etc/pf.conf <<EOF
# LAN-only firewall rules
block all
set skip on lo
pass in  on ${LAN_IF} from ${LAN_NET} to any
pass out on ${LAN_IF} from any to ${LAN_NET}
EOF

chmod 600 /etc/pf.conf

# Load PF module and start service
kldload pf 2>/dev/null || true
service pf restart

echo "PF firewall configured successfully"
echo "Interface: $LAN_IF, Network: $LAN_NET"