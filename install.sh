#!/bin/bash
# Create user.
useradd -m -g docker docker
# Put in group `docker`.
adduser docker docker
# Install the startup script.
cat > ~docker/start.sh <<'SCRIPT'
#!/bin/bash
for vm in ~/start/*; do
  (cd "$vm" && ./start.sh)
done
SCRIPT
chmod +x ~docker/start.sh
echo @reboot ~docker/start.sh | crontab -u docker -
