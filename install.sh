#!/bin/bash
set -e
# Create user.
getent passwd docker >/dev/null || /usr/sbin/useradd -m -g docker docker
# Put in group `docker`.
/usr/sbin/adduser docker docker
# Install the startup script.
cat > ~docker/start.sh <<'SCRIPT'
#!/bin/bash
export DOCKER_BASE=~docker/start/
cd "${DOCKER_BASE}" && for DOCKER_NAME in [0-9]*; do
  export DOCKER_NAME
  (cd "${DOCKER_NAME}" && ./start.sh)
done
SCRIPT
chmod +x ~docker/start.sh
cat > ~docker/stop.sh <<'SCRIPT'
#!/bin/bash
export DOCKER_BASE=~docker/start/
cd "${DOCKER_BASE}" && for DOCKER_NAME in [0-9]*; do
  export DOCKER_NAME
  (cd "${DOCKER_NAME}" && ./stop.sh)
done
SCRIPT
chmod +x ~docker/stop.sh
mkdir -p ~docker/start/
chown docker.docker ~docker/start/
echo @reboot ~docker/start.sh | crontab -u docker -
