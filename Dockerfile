FROM debian:10

ENV HTTPS_ENABLED false
ENV APP_BIND_HOST 0.0.0.0
ENV APP_PORT 8080

RUN apt-get update \
 && apt-get install -y \
    sudo curl dumb-init htop locales \
    git procps ssh vim lsb-release \
  && curl -fsSL https://code-server.dev/install.sh | sh \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

RUN chsh -s /bin/bash
ENV SHELL /bin/bash

RUN adduser --gecos '' --disabled-password coder \
  && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN ARCH="$(dpkg --print-architecture)" \
  && curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - \
  && chown root:root /usr/local/bin/fixuid \
  && chmod 4755 /usr/local/bin/fixuid \
  && mkdir -p /etc/fixuid \
  && printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

USER 1000
ENV USER=coder
WORKDIR /home/coder

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
