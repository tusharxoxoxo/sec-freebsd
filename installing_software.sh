#!/bin/sh

pkg install neovim drm-kmod
sysrc kld_list+=amdgpu
