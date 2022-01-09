FROM docker.io/alpine:latest AS download_velocity
WORKDIR /velocity

RUN apk add --no-cache curl jq
COPY utils/velocity.sh /velocity/

# Download velocity
RUN sh /velocity/velocity.sh 3.1.1
# ---
# ---
FROM docker.io/eclipse-temurin:17-alpine
EXPOSE 25565
ENV LANG en_US.UTF-8

# Config
ENV ONLINE_MODE true
ENV PORT 25565

# Install velocity
COPY --from=download_velocity /velocity/velocity.jar /velocity/

# Setup user
RUN chmod u+s /bin/*
RUN apk --no-cache add su-exec shadow yq

# Copy Entry point
COPY entrypoint.sh starter.sh autoconfig.sh /

RUN addgroup -g 1000 app && \
    adduser app -u 1000 -S -G app

# Copy basements...
COPY plugins/ /app/plugins/
COPY ./velocity.toml /app/

WORKDIR /app

CMD ["sh", "/entrypoint.sh"]
