FROM ubuntu:22.04

ENV MACHINE_NAME vscode-remote-tunnel

# hadolint ignore=DL3008
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install -y --no-install-recommends \
  tzdata \
  gnome-keyring wget curl python3-minimal ca-certificates \
  git build-essential

# install vscode-server
RUN apt install software-properties-common apt-transport-https wget -y
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y
RUN apt install code -y


RUN useradd -rm -s /bin/bash -g root -G sudo -u 1001 dev
RUN echo dev:docker | chpasswd

RUN apt install -y sudo

USER dev
WORKDIR /home/dev/repo

# expose port
EXPOSE 8000

ENTRYPOINT [ "code tunnel --accept-server-license-terms --disable-telemetry --name ${MACHINE_NAME}",
              ""
            ]

