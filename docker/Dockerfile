FROM debian:bookworm


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV HOME=/root

RUN apt update && apt install -y \
	software-properties-common \
	&& apt autoremove --purge -y && apt clean

RUN apt update && apt install -y \
	ca-certificates \
	curl \
	gnupg \
	screen \
	wget \
	locales \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& locale-gen \
	&& update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
	&& apt autoremove --purge -y && apt clean

RUN NODE_MAJOR=22 \
	&& curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
	&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
	&& apt update \
	&& apt install -y nodejs \
	&& apt clean && rm -rf /var/lib/apt/lists/*


############################
# App dependencies

RUN cd /usr/local/bin/ \
	&& apt update && apt install -y \
	lib32gcc-s1 \
	&& apt autoremove --purge -y && apt clean \
	&& wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
	&& tar -xvzf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz \
	&& mv steamcmd.sh steamcmd \
	&& chmod 755 steamcmd \
	&& cd / \
	&& steamcmd +login anonymous +quit


############################
# Game server

COPY docker/install.sh /root/install.sh
RUN chmod +x /root/install.sh \
	&& /root/install.sh \
	&& rm /root/install.sh


############################
# BepInEx (if server uses mods)

COPY data/mods/ /tmp/mods/
RUN if [ "$(ls -A /tmp/mods/ 2>/dev/null)" ]; then \
        cp -r /tmp/mods/* /app/ && \
        rm -rf /tmp/mods/; \
    fi


############################
# Monitor server

COPY docker/monitor/ /monitor/
RUN cd /monitor \
	&& npm i express helmet moment moment-timezone


############################
# Docker server

COPY docker/start-docker-server.sh /app/start-docker-server.sh
RUN chmod +x /app/start-docker-server.sh

WORKDIR /app
CMD ["/app/start-docker-server.sh"]
