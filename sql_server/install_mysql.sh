#!/bin/bash

# Add Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Add the Microsoft SQL Server repository
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"

# Install SQL Server
sudo apt-get install -y mssql-server

# Run the SQL Server setup
sudo /opt/mssql/bin/mssql-conf setup

# Check the status of SQL Server
sudo systemctl status mssql-server

# Add the SQL Server tools repository
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list 

# Update package lists
sudo apt-get update 

# Install SQL Server tools and Unix ODBC developer package
sudo apt-get install -y mssql-tools unixodbc-dev

# Add SQL Server tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Source the updated bashrc
source ~/.bashrc

# Install MySQL Server
sudo apt install -y mysql-server
