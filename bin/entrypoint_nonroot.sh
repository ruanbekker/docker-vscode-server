#!/bin/sh
set -eu

EXTENSIONS="${EXTENSIONS:-none}"

eval "$(fixuid -q)"

mkdir -p /home/coder/workspace
mkdir -p /home/coder/.local/share/code-server/User
cat > /home/coder/.local/share/code-server/User/settings.json << EOF
{
    "workbench.colorTheme": "Visual Studio Dark"
}
EOF
chown coder /home/coder/workspace
chown -R coder /home/coder/.local

if [ "${DOCKER_USER-}" ]; then
  #sudo usermod --login "$DOCKER_USER" coder
  #sudo groupmod -n "$DOCKER_USER" coder
  USER="$DOCKER_USER"
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
