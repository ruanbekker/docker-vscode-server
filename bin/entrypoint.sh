#!/bin/sh
set -eu

export PS1='\w $ '

EXTENSIONS="${EXTENSIONS:-none}"
LAB_REPO="${LAB_REPO:-none}"

eval "$(fixuid -q)"

mkdir -p /home/coder/workspace
mkdir -p /home/coder/.local/share/code-server/User
cat > /home/coder/.local/share/code-server/User/settings.json << EOF
{
    "workbench.colorTheme": "Visual Studio Dark"
}
EOF
chown -R coder:coder /home/coder/workspace
chown -R coder:coder /home/coder/.local

if [ "${DOCKER_USER-}" ]; then
  echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
  sudo usermod --login "$DOCKER_USER" coder
  sudo groupmod -n "$DOCKER_USER" coder
  USER="$DOCKER_USER"
  sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd
fi

if [ ${EXTENSIONS} != "none" ]
    then
      echo "Installing Extensions"
      for extension in $(echo ${EXTENSIONS} | tr "," "\n")
        do
          if [ "${extension}" != "" ]
            then
              dumb-init /usr/bin/code-server \
                --install-extension "${extension}" \
                /home/coder
	  fi
        done
fi

if [ ${LAB_REPO} != "none" ]
  then
    cd workspace
    git clone ${LAB_REPO}
    cd ..
fi

if [ ${HTTPS_ENABLED} = "true" ]
  then
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      --cert /home/coder/.certs/cert.pem \
      --cert-key /home/coder/.certs/key.pem \
      /home/coder/workspace
else
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      /home/coder/workspace
fi
