#!/usr/bin/env bash

set -eoux pipefail

cp -avf "/ctx/files"/. /

dnf -y install adw-gtk3-theme

# trivalent
dnf -y config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf -y config-manager setopt secureblue.enabled=0
dnf -y install --enablerepo secureblue --setopt=install_weak_deps=False\
  trivalent

dnf -y copr enable secureblue/trivalent fedora-43-x86_64
dnf -y copr disable secureblue/trivalent
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:trivalent \
  trivalent-subresource-filter

touch /etc/ld.so.preload

# HWE
dnf install -y --enablerepo=terra \
  asusctl \
  asusctl-rog-gui \
  supergfxctl \
  solaar
systemctl enable supergfxd.service

# proton
dnf -y install https://repo.protonvpn.com/fedora-44-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm

mkdir -p /var/tmp
chmod 1777 /var/tmp

dnf download proton-vpn-gnome-desktop proton-vpn-daemon --repo=protonvpn-fedora-stable "--arch=noarch" "--destdir=/var/tmp"
dnf -y install proton-vpn-gtk-app python3-proton-keyring-linux python3-proton-vpn-api-core

rpm -i "/var/tmp/*proton-vpn-daemon*.rpm" --noscripts
rpm -i "/var/tmp/*proton-vpn-gnome-desktop*.rpm" --noscripts
