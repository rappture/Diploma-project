#!/bin/bash

#Checking and installing all available updates via apt
printf "\n*********************\n*********************\nCHECKING AND INSTALLING ALL AVAILABLE UPDATES VIA APT\n*********************\n*********************\n\n"

sudo apt -qq update;
sudo apt -qq upgrade;

#Generating ssh-keys and updating ~/terraform/meta.yml
printf "\n*********************\n*********************\nGENERATING SSH-KEYS AND UPDATING ~/terraform/meta.yml\n*********************\n*********************\n\n"
ssh-keygen;
pubkey=$(cat ~/.ssh/id_rsa.pub);
sed -i "s|ssh-rsa|$pubkey|" ~/terraform/meta.yml;

#Creating a file for Terraform provider installation (~/.terraformrc)
printf "\n*********************\n*********************\nCREATING A FILE FOR TERRAFORM PROVIDER INSTALLATION (~/.terraformrc)\n*********************\n*********************\n\n"

cat <<EOF > ~/.terraformrc
provider_installation {
    network_mirror {
        url = "https://terraform-mirror.yandexcloud.net/"
        include = ["registry.terraform.io/*/*"]
}
    direct {
        exclude = ["registry.terraform.io/*/*"]
    }
}
EOF

#Downloading and installing a pre-compiled binary of Terraform v. 1.6.1 from Yandex-mirror
printf "\n*********************\n*********************\nDOWNLOADING AND INSTALLING A PRE-COMPILED BINARY OF TERRAFORM v. 1.6.1 FROM YANDEX MIRROR\n*********************\n*********************\n\n"

wget -P /tmp/ https://hashicorp-releases.yandexcloud.net/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip;
sudo unzip /tmp/terraform_1.6.1_linux_amd64.zip -d /usr/local/bin;
sudo chown $(whoami):$(whoami) /usr/local/bin/terraform;
chmod 766 /usr/local/bin/terraform;
terraform -install-autocomplete;

#Installing pip3 and ansible
printf "\n*********************\n*********************\nINSTALLING PIP3 AND ANSIBLE\n*********************\n*********************\n\n"

echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc;
#source ~/.bashrc;
export PATH=$PATH:$HOME/.local/bin;
sudo apt install python3-distutils;
wget -P /tmp/ https://bootstrap.pypa.io/get-pip.py;
python3 /tmp/get-pip.py --user;
python3 -m pip install --user ansible;
python3 -m pip install --user argcomplete;
activate-global-python-argcomplete --user;

#Printing the installed versions of Terraform and Ansible
printf "\n*********************\n*********************\nPRINTING THE INSTALLED VERSIONS  OF TERRAFORM AND ANSIBLE\n*********************\n*********************\n\n"
printf "TERRAFORM VERSION:\n\n"
terraform -v;
printf "\nANSIBLE VERSION:\n\n"
ansible --version;

#Checking and applying terraform configuration
printf "\n*********************\n*********************\nCHECKING AND APPLYING TERRAFORM CONFIGURATION\n*********************\n*********************\n\n"

cd ~/terraform;
terraform init;
#terraform plan;
terraform validate;
terraform apply;
mkdir ~/.ssh;
terraform output -raw "_ssh-config" > ~/.ssh/config;
terraform output -raw "ansible-inventory" > ~/ansible/hosts;
#terraform output -raw "zabbix-server-private-ip" > ~/ansible/zabbix-agent-role/files/diploma-zabbix-agent.conf;

#Setting ssh 'StrictHostKeyChecking' directive to 'accept-new' instead of 'ask'
printf "\n*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO 'accept-new' INSTEAD OF 'ask'\n*********************\n*********************\n\n"

sudo sed -i "s|#   StrictHostKeyChecking ask|   StrictHostKeyChecking accept-new|" /etc/ssh/ssh_config;
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking;


#Cheking connection to managed hosts via ansible
printf "\n*********************\n*********************\nCHECKING CONNECTION TO MANAGED HOSTS VIA ANSIBLE\n*********************\n*********************\n\n"

cd ~/ansible;
ansible all -m ping;

#Setting ssh 'StrictHostKeyChecking' directive to its default value
printf "\n*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO ITS DEFAULT VALUE\n*********************\n*********************\n\n"

sudo sed -i "s|   StrictHostKeyChecking accept-new|#   StrictHostKeyChecking ask|" /etc/ssh/ssh_config;
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking;

#Running ansible playbooks ~/diploma-playbook-web-servers.yml and ~/diploma-playbook-zabbix-server.yml;
printf "\n*********************\n*********************\nRUNNING ANSIBLE PLAYBOOKS ~/ansible/diploma-playbook.yml AND ~/diploma-playbook-zabbix-server.yml\n*********************\n*********************\n\n"

ansible-playbook diploma-playbook.yml;
#ansible-playbook diploma-playbook-web-servers.yml;
#ansible-playbook diploma-playbook-zabbix-server.yml;

#Step n: all done. Below are the public ip addresses of your resources. Please do not forget to use 'terraform destroy' whenever you don't need the infrastructure.
printf "\n*********************\n*********************\nSTEP N: ALL DONE. BELOW ARE THE PUBLIC IP ADDRESSES OF YOUR RESOURCES. PLEASE DO NOT FORGET TO USE 'terraform destroy' WHENEVER YOU DON'T NEED THE INFRASTRUCTURE.\n*********************\n*********************\n\n"

cd ~/terraform;
terraform output -raw "public-ip-addresses";

#Restart bash to enable ansible and terraform autocompletion

exec bash;