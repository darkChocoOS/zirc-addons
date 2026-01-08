#!/usr/bin/env bash

set -eoux pipefail

# copy over any added system files to the new image
cp -avf "/ctx/files"/. /

## installing trivalent

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

## HWE features 

# remove old kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase $pkg --nodeps
done

# disable initramfs generation
ln -sf /bin/true /usr/lib/kernel/install.d/05-rpmostree.install
ln -sf /bin/true /usr/lib/kernel/install.d/50-dracut.install

# install cachy kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos \
  kernel-cachyos-devel-matched

# install addons
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap \
  zram-generator-defaults \
  cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager

# asus linux packages
dnf -y copr enable lukenukem/asus-linux
dnf -y copr disable lukenukem/asus-linux
dnf -y --enablerepo copr:copr.fedorainfracloud.org:lukenukem:asus-linux install \
  asusctl \
  asusctl-rog-gui \
  supergfxctl
systemctl enable supergfxd.service

# kargs
tee /usr/lib/bootc/kargs.d/01-HWE.toml << 'EOF'
kargs = ["amdgpu.dcdebugmask=0x10"]
EOF
