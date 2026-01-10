#!/usr/bin/env bash

set -eoux pipefail

TMPDIR=$(mktmp -d)
pushd "$TMPDIR"

dnf -y copr enable bieszczaders/kernel-cachyos
dnf -y copr disable bieszczaders/kernel-cachyos

dnf download --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos --arch x86_64 --resolve --destdir "$TMPDIR" \
  kernel-cachyos \
  kernel-cachyos-devel-matched

dnf -y remove --no-autoremove kernel{,-core,-modules,-modules-core,-modules-extra,-tools,-tools-libs}

rpm -u --noscripts --notriggers *.rpm

popd
rm -rf "$TMPDIR"

rpm --rebuilddb
dnf clean alll
dnf makecache
dnf check
dnf -y distro-sync

dnf versionlock add kernel-cachyos kernel-cachyos-devel-matched
