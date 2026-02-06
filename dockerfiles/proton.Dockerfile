FROM steamcmd/steamcmd:ubuntu-24@sha256:4a94b626e5f5952bebe55c0c8f8f19a1fddcebfcf2675ffde39fe1f56e8aed7c AS builder

ARG GE_PROTON_VERSION="10-28"

# Install prerequisites
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        curl \
        tar \
        dbus \
    && apt autoremove --purge && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install proton
RUN curl -sLOJ "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz" \
    && mkdir -p /tmp/proton \
    && tar -xzf GE-Proton*.tar.gz -C /tmp/proton --strip-components=1 \
    && rm GE-Proton*.* \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id


FROM steamcmd/steamcmd:ubuntu-24@sha256:4a94b626e5f5952bebe55c0c8f8f19a1fddcebfcf2675ffde39fe1f56e8aed7c
LABEL maintainer="docker@mornedhels.de"

# Install dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        curl \
        supervisor \
        jq \
        zip \
        python3 \
        python3-pip \
        libfreetype6 \
        libfreetype6:i386 \
    && apt autoremove --purge && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install supercronic (cron alternative for containers, runs as non-root)
ARG SUPERCRONIC_VERSION=v0.2.33
ARG SUPERCRONIC_ARCH=linux-amd64
RUN curl -fsSL "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-${SUPERCRONIC_ARCH}" -o /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic

# Install winetricks (unused)
RUN curl -o /tmp/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /tmp/winetricks && install -m 755 /tmp/winetricks /usr/local/bin/winetricks \
    && rm -rf /tmp/*

# MISC - Create directories with open permissions for rootless mode
# The container runs as the user specified via docker --user flag
RUN mkdir -p /usr/local/etc /var/log/supervisor /var/run/enshrouded /usr/local/etc/supervisor/conf.d/ /opt/enshrouded /home/enshrouded/.steam/sdk32 /home/enshrouded/.steam/sdk64 /home/enshrouded/.config/protonfixes /home/enshrouded/.cache/protonfixes \
    && chmod 777 /var/log/supervisor /var/run/enshrouded /opt/enshrouded /home/enshrouded /home/enshrouded/.steam /home/enshrouded/.steam/sdk32 /home/enshrouded/.steam/sdk64 /home/enshrouded/.config /home/enshrouded/.config/protonfixes /home/enshrouded/.cache /home/enshrouded/.cache/protonfixes \
    && ln -f /root/.steam/sdk32/steamclient.so /home/enshrouded/.steam/sdk32/steamclient.so \
    && ln -f /root/.steam/sdk64/steamclient.so /home/enshrouded/.steam/sdk64/steamclient.so \
    && echo '# No cron jobs configured' > /var/run/enshrouded/crontab \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /tmp/proton /usr/local/bin
COPY --from=builder /etc/machine-id /etc/machine-id

COPY ../supervisord.conf /etc/supervisor/supervisord.conf
COPY --chmod=755 ../scripts/default/* ../scripts/proton/* /usr/local/etc/enshrouded/

# Make supervisor config readable by all users
RUN chmod 644 /etc/supervisor/supervisord.conf

WORKDIR /usr/local/etc/enshrouded
CMD ["/usr/local/etc/enshrouded/bootstrap"]
ENTRYPOINT []
