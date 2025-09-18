#!/bin/sh
# FreeBSD revert PF LAN-only firewall setup
# Shell: sh

set -e  # Exit on any error

# Configuration
LOG_FILE="/var/log/pf-remove.log"
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

log "Starting PF firewall removal process..."

# 1. Stop PF service if running
if service pf onestatus >/dev/null 2>&1; then
    log "Stopping PF service..."
    service pf stop || error "Failed to stop PF service"
    log "PF service stopped"
else
    log "PF service is not running"
fi

# 2. Unload PF kernel module if loaded
if kldstat | grep -q pf.ko; then
    log "Unloading PF kernel module..."
    kldunload pf || error "Failed to unload PF kernel module"
    log "PF kernel module unloaded"
else
    log "PF kernel module is not loaded"
fi

# 3. Remove PF enable lines from /etc/rc.conf
if [ -f /etc/rc.conf ]; then
    # Create backup before modification
    cp /etc/rc.conf "$BACKUP_DIR/rc.conf.removal-backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove PF lines
    sed -i.bak '/^pf_enable="YES"$/d' /etc/rc.conf || error "Failed to remove pf_enable from rc.conf"
    sed -i.bak '/^pf_rules="\/etc\/pf.conf"$/d' /etc/rc.conf || error "Failed to remove pf_rules from rc.conf"
    
    # Clean up the .bak file created by sed
    rm -f /etc/rc.conf.bak
    
    log "Cleaned /etc/rc.conf (backup saved in $BACKUP_DIR)"
else
    log "rc.conf not found, skipping"
fi

# 4. Remove PF load line from /boot/loader.conf
if [ -f /boot/loader.conf ]; then
    # Create backup before modification
    cp /boot/loader.conf "$BACKUP_DIR/loader.conf.removal-backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove PF load line
    sed -i.bak '/^pf_load="YES"$/d' /boot/loader.conf || error "Failed to remove pf_load from loader.conf"
    
    # Clean up the .bak file created by sed
    rm -f /boot/loader.conf.bak
    
    log "Cleaned /boot/loader.conf (backup saved in $BACKUP_DIR)"
else
    log "loader.conf not found, skipping"
fi

# 5. Remove PF rules file
if [ -f /etc/pf.conf ]; then
    # Create backup before deletion
    cp /etc/pf.conf "$BACKUP_DIR/pf.conf.removal-backup.$(date +%Y%m%d_%H%M%S)"
    
    log "Deleting /etc/pf.conf..."
    rm -f /etc/pf.conf || error "Failed to remove /etc/pf.conf"
    log "Removed /etc/pf.conf (backup saved in $BACKUP_DIR)"
else
    log "/etc/pf.conf not found, skipping"
fi

# 6. Verify PF is completely disabled
if service pf onestatus >/dev/null 2>&1; then
    error "PF service is still running after removal attempt"
fi

if kldstat | grep -q pf.ko; then
    error "PF kernel module is still loaded after removal attempt"
fi

log "PF firewall successfully disabled and configuration removed"
log "All backup files saved in: $BACKUP_DIR"
log "You may need to reboot for all changes to take effect"
