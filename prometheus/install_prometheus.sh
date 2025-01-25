#!/bin/bash

# Update package lists
sudo apt update

# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.27.1/prometheus-2.27.1.linux-amd64.tar.gz

# Extract the files
tar xvf prometheus-2.27.1.linux-amd64.tar.gz
cd prometheus-2.27.1.linux-amd64

# Create necessary directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Move the binaries to the appropriate directory
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# Print the version of Prometheus
prometheus --version

# Create a system group and user for Prometheus
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Set ownership and permissions
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

# Create the service file for Prometheus
echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=always
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

# Start the Prometheus service and enable it to start on boot
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
