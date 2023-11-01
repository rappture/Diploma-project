#!/bin/bash

#Checking and installing all available updates via apt
printf "\n*********************\n*********************\nCHECKING AND INSTALLING ALL AVAILABLE UPDATES VIA APT\n*********************\n*********************\n\n"

sudo apt -qq update;
sudo apt -qq upgrade;

#Go downloading and installation
printf "\n*********************\n*********************\nGO DOWNLOADING AND INSTALLATION\n*********************\n*********************\n\n"

wget -P /tmp/ https://go.dev/dl/go1.20.10.linux-amd64.tar.gz;
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.20.10.linux-amd64.tar.gz;
export PATH=$PATH:/usr/local/go/bin;

#Installing Git
printf "\n*********************\n*********************\nINSTALLING GIT\n*********************\n*********************\n\n"

sudo apt install git;

#Downloading and building terraform-provider-yandex from Github repository
printf "\n*********************\n*********************\nDOWNLOADING AND BUILDING terraform-provider-yandex FROM GITHUB REPOSITORY\n*********************\n*********************\n\n"

mkdir /tmp/download_provider;
cd /tmp/download_provider;
git clone https://github.com/yandex-cloud/terraform-provider-yandex.git;
cd /tmp/download_provider/terraform-provider-yandex;
make build;

#Creating a file for Terraform provider installation
printf "\n*********************\n*********************\nCREATING A FILE FOR TERRAFORM PROVIDER INSTALLATION\n*********************\n*********************\n\n"

cat <<EOF > ~/.terraformrc
provider_installation {
  dev_overrides {
    "yandex-cloud/yandex" = "/home/$(whoami)/go/bin/"
  }

  direct {}
}
EOF

#Downloading and installing a pre-compiled binary of Terraform from Yandex-mirror
printf "\n*********************\n*********************\nDOWNLOADING AND INSTALLING A PRE-COMPILED BINARY OF TERRAFORM FROM YANDEX MIRROR\n*********************\n*********************\n\n"

wget -P /tmp/ https://hashicorp-releases.yandexcloud.net/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip;
sudo unzip /tmp/terraform_1.6.1_linux_amd64.zip -d /usr/local/bin;
sudo chown $(whoami):$(whoami) /usr/local/bin/terraform;
chmod 766 /usr/local/bin/terraform;
terraform -install-autocomplete;

#Installing pip3 and ansible
printf "\n*********************\n*********************\nINSTALLING PIP3 AND ANSIBLE\n*********************\n*********************\n\n"

echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin' >> ~/.bashrc;
#source ~/.bashrc;
export PATH=$PATH:$HOME/.local/bin;
sudo apt install python3-distutils;
wget https://bootstrap.pypa.io/get-pip.py;
python3 get-pip.py --user;
python3 -m pip install --user ansible;
python3 -m pip install --user argcomplete;
activate-global-python-argcomplete --user;

#Printing the installed versions of Terraform and Ansible
printf "\n*********************\n*********************\nPRINTING THE INSTALLED VERSIONS  OF TERRAFORM AND ANSIBLE\n*********************\n*********************\n\n"
printf "TERRAFORM VERSION:\n\n"
terraform -v;
printf "\nANSIBLE VERSION:\n\n"
ansible --version;
#go version;

#Downloading project files (USELESS)
printf "\n*********************\n*********************\nDownloading project files (USELESS)\n*********************\n*********************\n\n"
printf "sudo cp -r ~/Public/c_terraform ~/terraform;\nsudo chown $(whoami):$(whoami) ~/terraform/;\nsudo chown $(whoami):$(whoami) ~/terraform/*;\n"
mkdir  ~/ansible

sudo cp -r ~/Public/c_terraform ~/terraform;
sudo chown $(whoami):$(whoami) ~/terraform/;
sudo chown $(whoami):$(whoami) ~/terraform/*;

#Checking and applying terraform configuration
printf "\n*********************\n*********************\nCHECKING AND APPLYING TERRAFORM CONFIGURATION\n*********************\n*********************\n\n"

cd ~/terraform;
terraform plan;
terraform validate;
terraform apply;
mkdir ~/.ssh
terraform output -raw "_ssh-config" > ~/.ssh/config
terraform output -raw "ansible-inventory" > ~/ansible/hosts
terraform output -raw "public-ip-addresses"