#!/bin/sh

# XDMCP configuration for thin client
JAIL_IP="192.168.68.17"

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

echo "XDMCP configuration completed"
echo "X server will auto-launch and query ${JAIL_IP} on display :0"
