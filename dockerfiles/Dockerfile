FROM steamcmd/steamcmd:ubuntu-26@sha256:076bc1bae5c7da8e96ac19ec93beafabdc7f1c379287d97f3e529f9a236074c6
LABEL maintainer="docker@mornedhels.de"

# Install prerequisites
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        curl \
        supervisor \
        jq \
        zip \
        python3 \
        python3-pip \
    && apt autoremove --purge && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install supercronic (cron alternative for containers, runs as non-root)
# The updater counts connected players with python-a2s before it updates or restarts the server.
# Installed here, system-wide, because the server runs unprivileged: an install at start-up can only
# go into one user's home, which the updater (HOME=/root under supervisord) never looks in. 1.3.0
# fails on Python 3.14 (KeyError: '__annotations__').
ARG PYTHON_A2S_VERSION=1.4.2
RUN pip3 install --no-cache-dir --break-system-packages "python-a2s==${PYTHON_A2S_VERSION}"

ARG SUPERCRONIC_VERSION=v0.2.33
ARG SUPERCRONIC_ARCH=linux-amd64
RUN curl -fsSL "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-${SUPERCRONIC_ARCH}" -o /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic

# Install wine
ARG WINE_BRANCH=stable
RUN dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && curl -fsSL https://dl.winehq.org/wine-builds/winehq.key -o /etc/apt/keyrings/winehq-archive.asc \
    && CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME") \
    && curl -fsSL "https://dl.winehq.org/wine-builds/ubuntu/dists/${CODENAME}/winehq-${CODENAME}.sources" \
       | sed 's/winehq-archive\.key/winehq-archive.asc/' > "/etc/apt/sources.list.d/winehq-${CODENAME}.sources" \
    && apt update && DEBIAN_FRONTEND="noninteractive" apt -y --install-recommends install wine-${WINE_BRANCH} \
    && ln -s /opt/wine-$WINE_BRANCH/bin/* /usr/local/bin/ \
    && apt autoremove --purge -y && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install winetricks (unused)
RUN curl -o /tmp/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /tmp/winetricks && install -m 755 /tmp/winetricks /usr/local/bin/winetricks \
    && rm -rf /tmp/*

# MISC - Create directories with open permissions for rootless mode
# The container runs as the user specified via docker --user flag
RUN mkdir -p /usr/local/etc /var/log/supervisor /var/run/enshrouded /usr/local/etc/supervisor/conf.d/ /opt/enshrouded /home/enshrouded/.steam \
    && chmod 777 /var/log/supervisor /var/run/enshrouded /opt/enshrouded /home/enshrouded /home/enshrouded/.steam \
    && echo '# No cron jobs configured' > /var/run/enshrouded/crontab \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ../supervisord.conf /etc/supervisor/supervisord.conf
COPY --chmod=755 ../scripts/default/* ../scripts/wine/* /usr/local/etc/enshrouded/

# Make supervisor config readable by all users
RUN chmod 644 /etc/supervisor/supervisord.conf

WORKDIR /usr/local/etc/enshrouded
CMD ["/usr/local/etc/enshrouded/bootstrap"]
ENTRYPOINT []
