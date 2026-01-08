FROM scratch as ctx

COPY build_files /build
COPY system_files /files
COPY cosign.pub /files/etc/pki/containers/bootc-template.pub

# base image - replace with the image url of whatever you want to build from
# other options for a baseimage are:
#    ghcr.io/ublue-os/aurora:stable
#    quay.io/fedora/fedora-bootc:43
#    quay.io/fedora-ostree-desktops/silverblue:43
FROM ghcr.io/ublue-os/bluefin:stable

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
# Make modifications to your image by making changes in build.sh
# you can also add more script files to make modifications, and run them by using the command below
# just copy the command and swap out `build.sh` with the name of the new script file

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/build.sh

### LINTING
# cleanup any changes made to /var and verify final image and contents are correct
RUN rm -rf /var/* && mkdir /var/tmp && bootc container lint
