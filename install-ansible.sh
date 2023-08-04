#! /bin/bash

# Atenção: esse script foi criado para instalar o ansible no Debian 12.

# Atualiza os repositórios, pacotes e instala o Ansible.
sudo apt update -y
sudo apt install -y ansible 

# Verifica a versão do Ansible instalada
ansible --version

# Verifica se o diretório /etc/ansible existe e cria caso não exista
if [ ! -d "/etc/ansible" ] 
then
    sudo mkdir /etc/ansible
fi

# Verifica se o arquivo ansible.cfg existe e remove caso exista
if [ -e "/etc/ansible/ansible.cfg" ]
then
    sudo rm /etc/ansible/ansible.cfg
fi

# Cria o arquivo ansible.cfg
echo [defaults] | sudo tee /etc/ansible/ansible.cfg
echo inventory = /etc/ansible/hosts | sudo tee -a /etc/ansible/ansible.cfg
echo remote_user = root | sudo tee -a /etc/ansible/ansible.cfg
echo private_key_file = /root/.ssh/id_ed25519 | sudo tee -a /etc/ansible/ansible.cfg

# Verifica se o arquivo hosts existe e remove caso exista
if [ -e "/etc/ansible/hosts" ]
then
    sudo rm /etc/ansible/hosts
fi

# Cria o arquivo hosts
echo [ansible-node] | sudo tee /etc/ansible/hosts
echo <ip-do-ansible-node> | sudo tee -a /etc/ansible/hosts  # Coloque o IP do ansible-node
echo [webapp-node] | sudo tee -a /etc/ansible/hosts
echo <ip-do-webapp-node> | sudo tee -a /etc/ansible/hosts # Coloque o IP do webapp-node
