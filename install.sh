#!/bin/bash
# Create user.
/usr/sbin/useradd -m -g docker docker
# Put in group `docker`.
/usr/sbin/adduser docker docker
# Install the startup script.
cat > ~docker/start.sh <<'SCRIPT'
#!/bin/bash
export DOCKER_BASE=~docker/start/
for vm in "$DOCKER_BASE"/*; do
  (cd "$vm" && ./start.sh)
done
SCRIPT
chmod +x ~docker/start.sh
mkdir -p ~docker/start/
chown docker.docker ~docker/start/
echo @reboot ~docker/start.sh | crontab -u docker -
