FROM docker.io/alpine:latest AS download_assets

ARG VELOCITY_VERSION=3.1.1
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl jq
COPY utils/velocity.sh /velocity/

# Download tools
WORKDIR /tmp
RUN wget -O packy.tar.gz https://github.com/synchthia/packy/releases/latest/download/packy_${TARGETOS}_${TARGETARCH}.tar.gz && \
    tar -xvzf ./packy.tar.gz && \
    wget -O yq https://github.com/mikefarah/yq/releases/latest/download/yq_${TARGETOS}_${TARGETARCH} && \
    chmod +x yq

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
COPY --from=download_assets /tmp/packy /tmp/yq /usr/local/bin/

# Install velocity
COPY --from=download_assets /velocity/velocity.jar /velocity/

RUN apt-get update -qq && \
    apt-get install -y gosu && \
    apt-get clean

# Copy Entry point
COPY entrypoint.sh launcher.sh autoconfig.sh /

RUN addgroup --gid 1000 app && \
    useradd app --uid 1000 -g app -s /bin/bash

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
