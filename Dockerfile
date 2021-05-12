ARG ARCHITECTURE
FROM multiarch/alpine:${ARCHITECTURE}-v3.13 as builder

ENV VERSION=v1.16.1

# Add unprivileged user
RUN echo "syncthing:x:1000:1000:syncthing:/:" > /etc_passwd

# Install build needs
RUN apk add --no-cache \
  git \
  go \
  ca-certificates

# Get syncthing from Github
RUN git clone --depth 1 --branch "${VERSION}" https://github.com/syncthing/syncthing.git /syncthing

WORKDIR /syncthing

# Compile static syncthing
# https://github.com/syncthing/syncthing/blob/main/Dockerfile#L10
RUN CGO_ENABLED=0 go run build.go -no-upgrade build syncthing

# 'Install' upx from image since upx isn't available for aarch64 from Alpine
COPY --from=lansible/upx /usr/bin/upx /usr/bin/upx
# Minify binaries
# no upx: 23.6M
# upx: 9.4M
# --best: 9.1M
# --brute: 7.1M
RUN upx --brute syncthing && \
    upx -t syncthing


FROM scratch

# Force GUI on 0.0.0.0
ENV STGUIADDRESS=0.0.0.0:8384

# Copy the unprivileged user
COPY --from=builder /etc_passwd /etc/passwd

# ca-certificates are required to resolve https// syncthing domains:
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Add static syncthing binary
COPY --from=builder /syncthing/syncthing /usr/bin/syncthing

USER syncthing
ENTRYPOINT ["/usr/bin/syncthing", "-home", "/config"]
# Expose the webinterface and the protocol ports
EXPOSE 8384 22000
