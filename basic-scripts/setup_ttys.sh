#!/bin/sh

# Configure /etc/ttys for thin client mode
# Disable all local shells, enable only X server on vt7

# Backup original ttys file
cp /etc/ttys /etc/ttys.backup

# Create new ttys configuration for thin client
cat > /etc/ttys <<EOF
# /etc/ttys - terminal configuration for thin client
# Disable all local shells, enable only X server

# Console - disabled (no local shell access)
console none                            unknown off secure

# Virtual terminals - all disabled except vt7 for X server
ttyv0   "/usr/libexec/getty Pc"         xterm   off secure
ttyv1   "/usr/libexec/getty Pc"         xterm   off secure
ttyv2   "/usr/libexec/getty Pc"         xterm   off secure
ttyv3   "/usr/libexec/getty Pc"         xterm   off secure
ttyv4   "/usr/libexec/getty Pc"         xterm   off secure
ttyv5   "/usr/libexec/getty Pc"         xterm   off secure
ttyv6   "/usr/libexec/getty Pc"         xterm   off secure
ttyv7   "/usr/local/bin/xdm -nodaemon"  xterm   on  secure

# Serial terminals - disabled
ttyu0   "/usr/libexec/getty 3wire"      vt100   off secure
ttyu1   "/usr/libexec/getty 3wire"      vt100   off secure
ttyu2   "/usr/libexec/getty 3wire"      vt100   off secure
ttyu3   "/usr/libexec/getty 3wire"      vt100   off secure

# Pseudo terminals - enabled for XDMCP sessions
ttyp0   none                            network off
ttyp1   none                            network off
ttyp2   none                            network off
ttyp3   none                            network off
ttyp4   none                            network off
ttyp5   none                            network off
ttyp6   none                            network off
ttyp7   none                            network off
ttyp8   none                            network off
ttyp9   none                            network off
ttypa   none                            network off
ttypb   none                            network off
ttypc   none                            network off
ttypd   none                            network off
ttype   none                            network off
ttypf   none                            network off
EOF

echo "TTY configuration completed"
echo "All local shells disabled, X server enabled on vt7"
echo "Users can only access the jail via XDMCP"
