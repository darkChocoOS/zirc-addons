#!/usr/bin/env bash

set -eoux pipefail

# copy over any added system files to the new image
cp -avf "/ctx/files"/. /

# adw-gtk3
dnf -y install adw-gtk3-theme

# trivalent
dnf -y config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf -y config-manager setopt secureblue.enabled=0
dnf -y install --enablerepo secureblue \
  trivalent

# trivalent subresource filter
dnf -y copr enable secureblue/trivalent
dnf -y copr disable secureblue/trivalent
dnf -y install --enablerepo copr:copr.fedorainfracloud.org:secureblue:trivalent \
  trivalent-subresource-filter

# trivalent expects this file to exist because hardened-malloc would generally create it
touch /etc/ld.so.preload

# asus linux packages
dnf -y copr enable lukenukem/asus-linux
dnf -y copr disable lukenukem/asus-linux
dnf -y --enablerepo copr:copr.fedorainfracloud.org:lukenukem:asus-linux install \
  asusctl \
  asusctl-rog-gui \
  supergfxctl
systemctl enable supergfxd.service

