#!/bin/bash

descriptionFont=$(tput setaf 34)
normalFont=$(tput sgr0)

printf "\n${descriptionFont}*********************\n*********************\nCHECKING FOR AVAILABLE UPDATES VIA APT (DECISION WHETER TO INSTALL THEM IS UP TO YOU)\n*********************\n*********************\n\n${normalFont}" && \

sudo apt -qq update && \
sudo apt -qq upgrade; 

printf "\n${descriptionFont}*********************\n*********************\nGENERATING SSH-KEYS AND UPDATING ~/terraform/meta.yml\n*********************\n*********************\n\n${normalFont}" && \
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa;
pubkey=$(cat ~/.ssh/id_rsa.pub) && \
sed -i "s|ssh-rsa|$pubkey|" ~/terraform/meta.yml && \

printf "\n*********************\n*********************\nGO DOWNLOADING AND INSTALLATION\n*********************\n*********************\n\n"

wget -P /tmp/ https://go.dev/dl/go1.20.10.linux-amd64.tar.gz;
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.20.10.linux-amd64.tar.gz;
export PATH=$PATH:/usr/local/go/bin;

printf "\n*********************\n*********************\nINSTALLING GIT\n*********************\n*********************\n\n"

sudo apt install git;

printf "\n*********************\n*********************\nDOWNLOADING AND BUILDING terraform-provider-yandex FROM GITHUB REPOSITORY\n*********************\n*********************\n\n"

mkdir /tmp/download_provider;
cd /tmp/download_provider;
git clone https://github.com/yandex-cloud/terraform-provider-yandex.git;
cd /tmp/download_provider/terraform-provider-yandex;
make build;

printf "\n${descriptionFont}*********************\n*********************\nCREATING A FILE FOR TERRAFORM PROVIDER INSTALLATION (~/.terraformrc)\n*********************\n*********************\n\n${normalFont}" && \

{
cat <<EOF > ~/.terraformrc
provider_installation {
  dev_overrides {
    "yandex-cloud/yandex" = "/home/$(whoami)/go/bin/"
  }

  direct {}
}
EOF
} && \

printf "\n${descriptionFont}*********************\n*********************\nDOWNLOADING AND INSTALLING A PRE-COMPILED BINARY OF TERRAFORM v. 1.6.1 FROM YANDEX MIRROR\n*********************\n*********************\n\n${normalFont}" && \

wget -P /tmp/ https://hashicorp-releases.yandexcloud.net/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip && \
sudo unzip /tmp/terraform_1.6.1_linux_amd64.zip -d /usr/local/bin && \
sudo chown $(whoami):$(whoami) /usr/local/bin/terraform && \
chmod 766 /usr/local/bin/terraform && \
terraform -install-autocomplete && \

printf "\n${descriptionFont}*********************\n*********************\nINSTALLING PIP3 AND ANSIBLE\n*********************\n*********************\n\n${normalFont}" && \

echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc && \
export PATH=$PATH:$HOME/.local/bin && \
sudo apt install -y python3-distutils && \
wget -P /tmp/ https://bootstrap.pypa.io/get-pip.py && \
python3 /tmp/get-pip.py --user && \
python3 -m pip install --user ansible && \
python3 -m pip install --user argcomplete && \
activate-global-python-argcomplete --user && \

printf "\n${descriptionFont}*********************\n*********************\nPRINTING THE INSTALLED VERSIONS  OF GO, TERRAFORM AND ANSIBLE\n*********************\n*********************\n\n${normalFont}" && \
printf "GO VERSION:\n\n" && \
go version && \
printf "\nTERRAFORM VERSION:\n\n" && \
terraform -v && \
printf "\nANSIBLE VERSION:\n\n" && \
ansible --version && \

printf "\n${descriptionFont}*********************\n*********************\nCHECKING AND APPLYING TERRAFORM CONFIGURATION\n*********************\n*********************\n\n${normalFont}" && \

cd ~/terraform && \
terraform init && \
#terraform plan && \
terraform validate && \
terraform apply && \
mkdir ~/.ssh;
terraform output -raw "_ssh-config" > ~/.ssh/config && \
terraform output -raw "ansible-inventory" > ~/ansible/hosts && \

printf "\n${descriptionFont}*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO 'accept-new' INSTEAD OF 'ask'\n*********************\n*********************\n\n${normalFont}" && \

sudo sed -i "s|#   StrictHostKeyChecking ask|   StrictHostKeyChecking accept-new|" /etc/ssh/ssh_config && \
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking && \


printf "\n${descriptionFont}*********************\n*********************\nCHECKING CONNECTION TO MANAGED HOSTS VIA ANSIBLE\n*********************\n*********************\n\n${normalFont}" && \

cd ~/ansible && \
ansible all -m ping && \

printf "\n${descriptionFont}*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO ITS DEFAULT VALUE\n*********************\n*********************\n\n${normalFont}" && \

sudo sed -i "s|   StrictHostKeyChecking accept-new|#   StrictHostKeyChecking ask|" /etc/ssh/ssh_config && \
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking && \

printf "\n${descriptionFont}*********************\n*********************\nRUNNING ANSIBLE PLAYBOOK ~/ansible/diploma-playbook.yml\n*********************\n*********************\n\n${normalFont}" && \

ansible-playbook diploma-playbook.yml && \

printf "\n${descriptionFont}*********************\n*********************\nALL DONE. BELOW ARE THE PUBLIC IP ADDRESSES OF YOUR RESOURCES. PLEASE DO NOT FORGET TO USE 'terraform destroy' WHENEVER YOU DON'T NEED THE INFRASTRUCTURE.\n*********************\n*********************\n\n${normalFont}" && \

cd ~/terraform && \
terraform output -raw "public-ip-addresses" && \

#Restart bash to enable ansible and terraform autocompletion
exec bash
