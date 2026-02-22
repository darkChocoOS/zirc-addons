FROM scratch as ctx

COPY build_files /build
COPY system_files /files
COPY cosign.pub /files/etc/pki/containers/zirc-addons.pub

FROM ghcr.io/zirconium-dev/zirconium-nvidia:latest

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/01-packages.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build/99-cleanup.sh

RUN rm -rf /var/* && mkdir /var/tmp && bootc container lint
