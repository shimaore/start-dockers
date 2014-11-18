#!/bin/bash
set -e
# Create user.
getent passwd docker >/dev/null || /usr/sbin/useradd -m -g docker --uid 9999 docker
# Put in group `docker`.
/usr/sbin/adduser docker docker
# Install the startup script.
cat > ~docker/start.sh <<'SCRIPT'
#!/bin/bash
exec >> ~docker/startup.log 2>&1
echo '**** start ****'
date
until /etc/init.d/docker status; do
  echo "Waiting for docker to be ready."
  sleep 5
done
export DOCKER_BASE=~docker/start/
cd "${DOCKER_BASE}" && for DOCKER_NAME in [0-9]*; do
  export DOCKER_NAME
  (cd "${DOCKER_NAME}" && ./init start)
done
SCRIPT
chmod +x ~docker/start.sh
cat > ~docker/stop.sh <<'SCRIPT'
#!/bin/bash
exec >> ~docker/startup.log 2>&1
echo '**** stop ****'
date
export DOCKER_BASE=~docker/start/
cd "${DOCKER_BASE}" && for DOCKER_NAME in [0-9]*; do
  export DOCKER_NAME
  (cd "${DOCKER_NAME}" && ./init stop)
done
SCRIPT
chmod +x ~docker/stop.sh
mkdir -p ~docker/start/
chown docker.docker ~docker/start/
echo @reboot ~docker/start.sh | crontab -u docker -
