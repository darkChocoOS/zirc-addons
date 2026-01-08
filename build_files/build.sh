#!/usr/bin/env bash

set -eoux pipefail

# copy over any added system files to the new image
cp -avf "/ctx/files"/. /

# install packages or run commands to edit image properties, go wild
# just be careful with installing nvidia drivers, those are a PITA
# for those, i'd recommend copying what zirconium does

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
