#!/bin/sh
# FreeBSD LAN-only firewall setup
# Shell: sh

set -e  # Exit on any error

# Configuration
LAN_IF="wlan0"        # change to re0/re1 if using Ethernet
LAN_NET="192.168.68.0/24"
LOG_FILE="/var/log/pf-setup.log"
BACKUP_DIR="/var/backups/pf"

# Logging setup
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo "[!] $1" >&2 | tee -a "$LOG_FILE"
    exit 1
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root"
fi

log "Starting PF firewall configuration for LAN-only access..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Validate network interface
if ! ifconfig "$LAN_IF" >/dev/null 2>&1; then
    error "Interface $LAN_IF does not exist. Available interfaces: $(ifconfig -l)"
fi

log "Using interface: $LAN_IF with network: $LAN_NET"

# 1. Enable PF in rc.conf
if [ -f /etc/rc.conf ]; then
    # Backup original rc.conf
    cp /etc/rc.conf "$BACKUP_DIR/rc.conf.backup.$(date +%Y%m%d_%H%M%S)"
    
    if ! grep -q '^pf_enable="YES"' /etc/rc.conf; then
        echo 'pf_enable="YES"' >> /etc/rc.conf || error "Failed to add pf_enable to rc.conf"
        log "Added pf_enable to rc.conf"
    fi
    if ! grep -q '^pf_rules="/etc/pf.conf"' /etc/rc.conf; then
        echo 'pf_rules="/etc/pf.conf"' >> /etc/rc.conf || error "Failed to add pf_rules to rc.conf"
        log "Added pf_rules to rc.conf"
    fi
else
    error "rc.conf not found"
fi

# 2. Ensure PF loads at boot
if [ -f /boot/loader.conf ]; then
    # Backup original loader.conf
    cp /boot/loader.conf "$BACKUP_DIR/loader.conf.backup.$(date +%Y%m%d_%H%M%S)"
    
    if ! grep -q '^pf_load="YES"' /boot/loader.conf; then
        echo 'pf_load="YES"' >> /boot/loader.conf || error "Failed to add pf_load to loader.conf"
        log "Added pf_load to loader.conf"
    fi
else
    echo 'pf_load="YES"' > /boot/loader.conf || error "Failed to create loader.conf"
    log "Created loader.conf with pf_load"
fi

# 3. Write /etc/pf.conf
# Backup existing pf.conf if it exists
if [ -f /etc/pf.conf ]; then
    cp /etc/pf.conf "$BACKUP_DIR/pf.conf.backup.$(date +%Y%m%d_%H%M%S)"
    log "Backed up existing pf.conf"
fi

cat > /etc/pf.conf <<EOF
# PF rules: LAN-only access
# Generated on $(date)

# Block everything by default
block all

# Allow loopback
set skip on lo

# Allow only LAN traffic
pass in  on ${LAN_IF} from ${LAN_NET} to any
pass out on ${LAN_IF} from any to ${LAN_NET}
EOF

chmod 600 /etc/pf.conf || error "Failed to set permissions on pf.conf"
log "Created /etc/pf.conf with LAN-only rules"

# 4. Load PF kernel module (if not already)
if ! kldstat | grep -q pf.ko; then
    log "Loading PF kernel module..."
    kldload pf || error "Failed to load PF kernel module"
    log "PF kernel module loaded"
else
    log "PF kernel module already loaded"
fi

# 5. Restart PF service
log "Restarting PF service..."
service pf restart || error "Failed to restart PF service"
log "PF service restarted successfully"

# 6. Verify PF is working
if ! service pf onestatus >/dev/null 2>&1; then
    error "PF service is not running after restart"
fi

# 7. Show active rules
log "Active PF rules:"
pfctl -sr || error "Failed to show PF rules"

log "PF firewall configuration completed successfully"
log "Backup files saved in: $BACKUP_DIR"
