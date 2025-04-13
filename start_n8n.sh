#!/bin/bash

echo "--------- 🟢 Start install docker -----------"
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce docker-compose-plugin
echo "--------- 🔴 Finish install docker -----------"

# Check if user is in docker group
if groups $USER | grep -q '\bdocker\b'; then
  echo "✅ User '$USER' is already in the docker group."
else
  echo "⚠️  Adding user '$USER' to the docker group..."
  sudo usermod -aG docker $USER
  echo "✅ Added user to docker group. Please log out and log back in (or run: newgrp docker)"
fi

echo "--------- 🟢 Start creating folder -----------"
cd ~
echo "🟢 Ensure volume folder exists..."
mkdir -p vol_n8n
sudo chown -R 1000:1000 vol_n8n
sudo chmod -R 755 vol_n8n
echo "--------- 🔴 Finish creating folder -----------"

echo "--------- 🟢 Start docker compose up  -----------"
wget https://raw.githubusercontent.com/Kira7dn/n8n_docker/refs/heads/main/docker-compose.yaml -O compose.yaml

echo "🟢 Starting n8n + ngrok..."
# Use sudo if user not in docker group
if groups $USER | grep -q '\bdocker\b'; then
  docker compose up -d
else
  sudo docker compose up -d
fi

echo "✅ Done. Visit Ngrok web UI at: http://localhost:4040"
