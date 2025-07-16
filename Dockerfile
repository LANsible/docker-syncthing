FROM golang:1.24-alpine AS builder

# https://github.com/syncthing/syncthing/releases
ENV VERSION=v2.0.0-rc.23

# Add unprivileged user
RUN echo "syncthing:x:1000:1000:syncthing:/:" > /etc_passwd
RUN echo "syncthing:x:1000:syncthing" > /etc_group

# Install build needs
RUN apk add --no-cache \
  git \
  upx

# Get syncthing from Github
RUN git clone --depth 1 --branch "${VERSION}" https://github.com/syncthing/syncthing.git /syncthing

WORKDIR /syncthing

# Compile static syncthing
# https://github.com/syncthing/syncthing/blob/main/Dockerfile#L10
RUN --mount=type=cache,target=/root/.cache \
  CGO_ENABLED=0 go run build.go -no-upgrade build syncthing

# Minify binaries and create config folder
# no upx: 23.6M
# upx: 9.4M
# --best: 9.1M
# --brute: breaks the binary
RUN upx --best syncthing && \
    upx -t syncthing && \
    mkdir /config

FROM scratch

ENV STGUIADDRESS=0.0.0.0:8384 \
    STHOMEDIR=/config

# Copy the unprivileged user
COPY --link --from=builder /etc_passwd /etc/passwd
COPY --link --from=builder /etc_group /etc/group

# ca-certificates are required to resolve https// syncthing domains:
COPY --link --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Add static syncthing binary
COPY --link --from=builder /syncthing/syncthing /usr/bin/syncthing

# Add /config placeholder (empty dir)
COPY --link --from=builder --chown=syncthing /config /config

USER syncthing
ENTRYPOINT ["/usr/bin/syncthing"]
# Expose the webinterface and the protocol ports
EXPOSE 8384 22000
