FROM docker.io/alpine:latest AS download_waterfall
WORKDIR /waterfall

ARG WATERFALL_VERSION=latest

RUN apk add --no-cache curl jq
COPY utils/waterfall.sh /waterfall/

# Download waterfall
RUN sh /waterfall/waterfall.sh "${WATERFALL_VERSION}"
# ---
# ---
FROM docker.io/eclipse-temurin:21
EXPOSE 25565
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ENV LANG en_US.UTF-8

# Config
ENV ONLINE_MODE true
ENV PORT 25565

# Install waterfall
COPY --from=download_waterfall /waterfall/waterfall.jar /waterfall/

# Setup user
RUN apt-get update -qq && \
    apt-get install -y gosu && \
    apt-get clean

RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_${TARGETOS}_${TARGETARCH} && \
    chmod a+x /usr/local/bin/yq

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
