#!/bin/bash

# Step 1: Create Prometheus user and group
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Step 2: Download and install Prometheus MySQL Exporter
curl -s https://api.github.com/repos/prometheus/mysqld_exporter/releases/latest | \
grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
tar xvf mysqld_exporter*.tar.gz
sudo mv mysqld_exporter-*.linux-amd64/mysqld_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/mysqld_exporter

# Step 3: Create Prometheus exporter database user
sudo mysql -e "CREATE USER 'mysqld_exporter'@'localhost' IDENTIFIED BY 'StrongPassword';"
sudo mysql -e "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqld_exporter'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Step 4: Configure database credentials
echo "[client]
user=mysqld_exporter
password=StrongPassword" | sudo tee /etc/.mysqld_exporter.cnf

sudo chown root:prometheus /etc/.mysqld_exporter.cnf

# Step 5: Create systemd unit file
echo "[Unit]
Description=Prometheus MySQL Exporter
After=network.target
User=prometheus
Group=prometheus

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/mysqld_exporter \
--config.my-cnf /etc/.mysqld_exporter.cnf \
--collect.global_status \
--collect.info_schema.innodb_metrics \
--collect.auto_increment.columns \
--collect.info_schema.processlist \
--collect.binlog_size \
--collect.info_schema.tablestats \
--collect.global_variables \
--collect.info_schema.query_response_time \
--collect.info_schema.userstats \
--collect.info_schema.tables \
--collect.perf_schema.tablelocks \
--collect.perf_schema.file_events \
--collect.perf_schema.eventswaits \
--collect.perf_schema.indexiowaits \
--collect.perf_schema.tableiowaits \
--collect.slave_status \
--web.listen-address=0.0.0.0:9104

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/mysql_exporter.service

# Step 6: Reload systemd and start mysql_exporter service
sudo systemctl daemon-reload
sudo systemctl enable mysql_exporter
sudo systemctl start mysql_exporter
sudo systemctl status mysql_exporter
