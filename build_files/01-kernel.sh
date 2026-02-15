#!/usr/bin/env bash

set -eoux pipefail

# remove stock kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase $pkg --nodeps
done

# disable initramfs generation by the kernel
ln -sf /usr/bin/true /usr/lib/kernel/install.d/05-rpmostree.install
ln -sf /usr/bin/true /usr/lib/kernel/install.d/50-dracut.install

# install cachyos kernel
dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos install \
  kernel-cachyos \
  kernel-cachyos-devel-matched

# install cachyos kernel addons
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings

# Remove leftover kernel-devel and clean up sources
rm -rf /usr/src/kernels/*

# add karg for weird amd-related screen bug
tee /usr/lib/bootc/kargs.d/01-HWE.toml << 'EOF'
kargs = ["amdgpu.dcdebugmask=0x10"]
EOF
