#!/bin/sh
set -eu

pkg install neovim drm-kmod xorg xdm openssh-portable
sysrc kld_list+=amdgpu
sysrc sshd_enable=YES
sysrc xdm_enable=YES
#vidcontrol -f terminus-b32
pw groupmod video -m tushar1 # add user to video group
