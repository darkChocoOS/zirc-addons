#!/usr/bin/env bash

# save space
rm -rf /usr/share/doc
rm -rf /usr/bin/chsh
 
KERNEL_VERSION="$(ls /usr/lib/modules | head -n1)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --zstd -v --omit pcsc --add ostree -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/${KERNEL_VERSION}/initramfs.img"
