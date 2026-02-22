#!/usr/bin/env bash

set -eoux pipefail

cp -avf "/ctx/files"/. /

dnf -y install adw-gtk3-theme

# trivalent
dnf -y config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf -y config-manager setopt secureblue.enabled=0
dnf -y install --enablerepo secureblue \
  trivalent

dnf -y copr enable secureblue/trivalent
dnf -y copr disable secureblue/trivalent
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:trivalent \
  trivalent-subresource-filter

touch /etc/ld.so.preload

# asus linux packages
dnf install -y --enablerepo=terra \
  asusctl \
  asusctl-rog-gui \
  supergfxctl
systemctl enable supergfxd.service

# replace tuned with ppd
dnf install -y --allowerasing \
  power-profiles-daemon
systemctl enable power-profiles-daemon.service

powerprofilesctl configure-action amdgpu_panel_power --enable
echo "1" | tee cat /sys/class/drm/card2/card2-eDP-2/amdgpu/panel_power_savings
powerprofilesctl configure-action amdgpu_dpm --enable
