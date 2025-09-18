#!/bin/sh
set -eu

# XDMCP configuration for thin client
JAIL_IP="192.168.68.17"

# Create X.org configuration directory
mkdir -p /usr/local/etc/X11/xorg.conf.d

# Create XDM configuration
cat > /etc/X11/xdm/xdm-config <<EOF
DisplayManager.requestPort: 0
DisplayManager*resources: /etc/X11/xdm/Xresources
DisplayManager*setup: /etc/X11/xdm/Xsetup
DisplayManager*startup: /etc/X11/xdm/Xstartup
DisplayManager*session: /etc/X11/xdm/Xsession
DisplayManager*authComplain: false
DisplayManager*authorize: false
DisplayManager*chooser: /etc/X11/xdm/Xchooser
DisplayManager*daemonMode: false
DisplayManager*reset: true
DisplayManager*userPath: /bin:/usr/bin:/usr/local/bin
DisplayManager*userAuthDir: /var/run/xdm
DisplayManager*lockPidFile: /var/run/xdm.pid
DisplayManager*errorLogFile: /var/log/xdm.log
DisplayManager*debugLevel: 1
DisplayManager*servers: /etc/X11/xdm/Xservers
DisplayManager*resources: /etc/X11/xdm/Xresources
DisplayManager*setup: /etc/X11/xdm/Xsetup
DisplayManager*startup: /etc/X11/xdm/Xstartup
DisplayManager*session: /etc/X11/xdm/Xsession
DisplayManager*authComplain: false
DisplayManager*authorize: false
DisplayManager*chooser: /etc/X11/xdm/Xchooser
DisplayManager*daemonMode: false
DisplayManager*reset: true
DisplayManager*userPath: /bin:/usr/bin:/usr/local/bin
DisplayManager*userAuthDir: /var/run/xdm
DisplayManager*lockPidFile: /var/run/xdm.pid
DisplayManager*errorLogFile: /var/log/xdm.log
DisplayManager*debugLevel: 1
DisplayManager*servers: /etc/X11/xdm/Xservers
EOF

# Create Xservers file for XDMCP query
cat > /etc/X11/xdm/Xservers <<EOF
:0 local /usr/bin/X :0 -query ${JAIL_IP}
EOF

# Create Xsetup script
cat > /etc/X11/xdm/Xsetup <<EOF
#!/bin/sh
# XDM setup script
EOF

chmod +x /etc/X11/xdm/Xsetup

# Create Xstartup script
cat > /etc/X11/xdm/Xstartup <<EOF
#!/bin/sh
# XDM startup script
EOF

chmod +x /etc/X11/xdm/Xstartup

# Create Xsession script
cat > /etc/X11/xdm/Xsession <<EOF
#!/bin/sh
# XDM session script
exec "\$@"
EOF

chmod +x /etc/X11/xdm/Xsession

# Create Xresources
cat > /etc/X11/xdm/Xresources <<EOF
XTerm*background: black
XTerm*foreground: white
XTerm*scrollBar: true
XTerm*rightScrollBar: true
EOF

# Create X.org configuration for thin client
cat > /usr/local/etc/X11/xorg.conf.d/10-thinclient.conf <<EOF
Section "ServerLayout"
    Identifier "ThinClient"
    Screen 0 "Screen0" 0 0
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "Card0"
    Monitor "Monitor0"
EndSection

Section "Device"
    Identifier "Card0"
    Driver "amdgpu"
EndSection

Section "Monitor"
    Identifier "Monitor0"
    Option "DPMS"
EndSection
EOF

echo "XDMCP configuration completed"
echo "X server will auto-launch and query ${JAIL_IP} on display :0"
