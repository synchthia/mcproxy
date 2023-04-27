FROM docker.io/alpine:latest AS download_waterfall
WORKDIR /waterfall

ARG WATERFALL_VERSION=latest

RUN apk add --no-cache curl jq
COPY utils/waterfall.sh /waterfall/

# Download waterfall
RUN sh /waterfall/waterfall.sh ${WATERFALL_VERSION}
# ---
# ---
FROM docker.io/eclipse-temurin:17-alpine
EXPOSE 25565
ENV LANG en_US.UTF-8

# Config
ENV ONLINE_MODE true
ENV PORT 25565

# Install waterfall
COPY --from=download_waterfall /waterfall/waterfall.jar /waterfall/

# Setup user
RUN chmod u+s /bin/* && \
    apk --no-cache add su-exec shadow yq

# Copy Entry point
COPY entrypoint.sh launcher.sh autoconfig.sh /

RUN addgroup -g 1000 app && \
    adduser app -u 1000 -S -G app

# Copy basements...
COPY templates/ /app/templates/
COPY server/ /app/server/

# Create internal directories
# Make symbolic link (for compatibility)
RUN mkdir -p \
    /app/plugins \
    && ln -sfnv /app/plugins /app/server/plugins

WORKDIR /app/server

CMD ["sh", "/entrypoint.sh"]
