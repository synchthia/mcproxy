FROM docker.io/alpine:latest AS download_assets
WORKDIR /velocity

ARG VELOCITY_VERSION=3.3.0-SNAPSHOT
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl jq
COPY utils/velocity.sh /velocity/

# Download tools
WORKDIR /tmp
RUN wget -O packy.tar.gz https://github.com/synchthia/packy/releases/latest/download/packy_${TARGETOS}_${TARGETARCH}.tar.gz && \
    tar -xvzf ./packy.tar.gz

# Download velocity
WORKDIR /velocity
RUN sh /velocity/velocity.sh ${VELOCITY_VERSION}

# ---
# ---
FROM docker.io/eclipse-temurin:21
EXPOSE 25565

ENV LANG=en_US.UTF-8

# Config
ENV ONLINE_MODE=true
ENV PORT=25565

# Install assets
COPY --from=download_assets /tmp/packy /usr/local/bin/

# Install velocity
COPY --from=download_assets /velocity/velocity.jar /velocity/

# Setup user
RUN apt-get update -qq && \
    apt-get install -y gosu && \
    apt-get clean

# Copy Entry point
COPY entrypoint.sh launcher.sh autoconfig.sh /

RUN userdel -rf $(cat /etc/passwd | grep 1000 | cut -d ':' -f 1) && \
    useradd app --uid 1000 -U -s /bin/bash

# Copy basements...
COPY templates/ /app/templates/
COPY server/ /app/server/

# Create internal directories
# Make symbolic link (for compatibility)
RUN mkdir -p \
    /app/plugins \
    && ln -sfnv /app/plugins /app/server/plugins

WORKDIR /app/server

CMD ["bash", "/entrypoint.sh"]
