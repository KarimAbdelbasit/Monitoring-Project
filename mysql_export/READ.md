# Installing MySQL Exporter

This guide will help you install MySQL Exporter on your system.

## Steps to Install MySQL Exporter
1. **Create the installation script**:
   Create a new file named `install_mysql_exporter.sh`:

   ```bash
   nano install_mysql_exporter.sh
   ```
   Then, add the following script to the file install_mysql_exporter.sh.

2. **Make the script executable**:
   After saving the script, run the following command to make it executable:
```
chmod +x install_mysql_exporter.sh
```
3. **Run the installation script**:
   Finally, execute the installation script:
   ```
   ./install_mysql_exporter.sh
   ```
4. **Configure MySQL endpoint to be scraped by Prometheus Server**:
   Login to your Prometheus server and configure the endpoint to scrape. Below is an example for two MySQL database servers.
   ```
  scrape_configs:
  - job_name: server1_db
    static_configs:
      - targets: ['10.10.1.10:9104']
        labels:
          alias: db1

  - job_name: server2_db
    static_configs:
      - targets: ['10.10.1.11:9104']
        labels:
          alias: db2
   ```
The first server has the IP address 10.10.1.10 and the second one is 10.10.1.11. Add other targets using a similar format. Job names should be unique for each target.
