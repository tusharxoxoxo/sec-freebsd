#!/bin/sh
set -eu

pkg install neovim drm-kmod xorg-minimal xdm openssh-portable
sysrc kld_list+=amdgpu
sysrc sshd_enable=YES
sysrc xdm_enable=YES
vidcontrol -f terminus-b32
