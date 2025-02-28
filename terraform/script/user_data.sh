#!/bin/bash
# Garante que o script rode apenas após a rede estar totalmente funcional
sleep 180
while ! ping -c 1 -W 1 google.com; do
    echo "Esperando pela rede..."
    sleep 10
done

# Atualiza os pacotes
sudo apt-get update -y
sudo apt-get upgrade -y

# Instala dependências para adicionar repositórios
sudo apt-get install -y software-properties-common dirmngr apt-transport-https ca-certificates curl

# Adiciona o repositório oficial do MariaDB
sudo curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

# Atualiza novamente a lista de pacotes
sudo apt-get update -y

# Instala o MariaDB Server, Cliente e Pacote de Compatibilidade
sudo apt-get install -y mariadb-server mariadb-client mariadb-client-compat

# Habilita e inicia o serviço do MariaDB
sudo systemctl daemon-reload
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Verifica se o MariaDB está rodando e reinicia se necessário
if ! systemctl is-active --quiet mariadb; then
    echo "MariaDB não iniciou, tentando novamente..."
    sudo systemctl restart mariadb
    sleep 10
    sudo systemctl status mariadb
fi

# Cria um link simbólico para o comando mysql (compatibilidade)
sudo ln -s /usr/bin/mariadb /usr/bin/mysql

# Verifica a instalação do MySQL (MariaDB)
mysql --version || echo "ERRO: O comando mysql não foi encontrado." | sudo tee -a /var/www/html/index.html

# Instala o Apache (httpd) no Ubuntu
sudo apt-get install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# Cria o arquivo index.html com informações do servidor
echo "Hello World i am Nadin" | sudo tee /var/www/html/index.html
curl http://checkip.amazonaws.com | sudo tee -a /var/www/html/index.html
echo "--------------------------------------------------" | sudo tee -a /var/www/html/index.html
echo "--------------------------------------------------" | sudo tee -a /var/www/html/index.html
echo -e "this is my private IP" | sudo tee -a /var/www/html/index.html
hostname -I | awk '{print $1}' | sudo tee -a /var/www/html/index.html

# Verifica novamente a versão do MySQL (MariaDB)
mysql --version | sudo tee -a /var/www/html/index.html
