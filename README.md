# Monitoring Project with Docker Compose

This project consists of three containers: `node-exporter`, `Prometheus`, and `Grafana`, all under the same network named `monitoring_network`.

## Project Structure

- `docker-compose.yml`: Configuration file for Docker Compose to set up the monitoring environment.
- `prometheus.yml`: Configuration file for Prometheus.

## Setup Instructions

### Step 1: Start Docker Compose

Run the following command to start the `node-exporter` container:

```bash
docker-compose up -d
```
### Step 2: Run Prometheus Container
Run the Prometheus container using the command below:
```bash
docker run --name prometheus -d -p 9090:9090 \
  --mount type=bind,source=$(pwd)/prometheus.yml,target=/etc/prometheus/prometheus.yml \
  --network monitoring_network \
  prom/prometheus
```
### Step 3: Create Grafana Data Volume
Create a Docker volume for Grafana:
```bash
docker volume create grafana_data
```
### Step 4: Run Grafana Container
Run the Grafana container using the following command:
```bash
docker run -d --name=grafana -p 3000:3000 \
  -v grafana_data:/var/lib/grafana \
  --network monitoring_network \
  grafana/grafana
```
### Step 5: Access Grafana
Open your web browser and go to:
```
http://<server-ip>:3000
```
### Step 6: Login to Grafana

- Use the default login credentials:
   -  Username: admin
   -  Password: admin
- After logging in, you will be prompted to change the password.

  ### Step 7: Add Prometheus as Data Source
  1- Choose Complete to start.
  2- Click on Add your first data source.
  3- Select Prometheus.
  4- Enter the following URL in the Prometheus server URL field:
  ```
  http://<server-ip>:9090
  ```
  5- Click Save.

  ### Step 8: Import Node Exporter Dashboard

  1- Go to Dashboard.
  2- Click on Import.
  3- Enter the ID for the Node Exporter Full dashboard: 1860.
  4- Click Load and follow the prompts to import the dashboard.
ذذذ```
ذذ
