#!/bin/bash

descriptionFont=$(tput setaf 34)
normalFont=$(tput sgr0)

check_updates () {
printf "\n${descriptionFont}*********************\n*********************\nCHECKING FOR AVAILABLE UPDATES VIA APT\n*********************\n*********************\n\n${normalFont}" && \

sudo apt -qq update && \
sudo apt -qq upgrade 
}

terraform_install () {
printf "\n${descriptionFont}*********************\n*********************\nCREATING A FILE FOR TERRAFORM PROVIDER INSTALLATION (~/.terraformrc)\n*********************\n*********************\n\n${normalFont}" && \

{
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
} && \

printf "DONE"

printf "\n${descriptionFont}*********************\n*********************\nDOWNLOADING AND INSTALLING A PRE-COMPILED BINARY OF TERRAFORM v. 1.6.1 FROM YANDEX MIRROR\n*********************\n*********************\n\n${normalFont}" && \

wget -P /tmp/ https://hashicorp-releases.yandexcloud.net/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip && \
sudo unzip /tmp/terraform_1.6.1_linux_amd64.zip -d /usr/local/bin && \
sudo chown $(whoami):$(whoami) /usr/local/bin/terraform && \
chmod 766 /usr/local/bin/terraform && \
terraform -install-autocomplete
}

ansible_install () {
printf "\n${descriptionFont}*********************\n*********************\nINSTALLING PIP3 AND ANSIBLE\n*********************\n*********************\n\n${normalFont}" && \

echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc && \
export PATH=$PATH:$HOME/.local/bin && \
sudo apt install -y python3-distutils && \
wget -P /tmp/ https://bootstrap.pypa.io/get-pip.py && \
python3 /tmp/get-pip.py --user && \
python3 -m pip install --user ansible && \
python3 -m pip install --user argcomplete && \
activate-global-python-argcomplete --user
}

printf "\n${descriptionFont}*********************\n*********************\nWELCOME TO THE DIPLOMA SCRIPT!\n\033[7mPLEASE MAKE SURE YOU PLACED THE PROJECT FILES INTO YOUR HOME DIRECTORY (~/Diploma-project/).\033[m\n${descriptionFont}TO CONTINUE CHOOSE ONE OF THE FOLLOWING OPTIONS (TYPE 1 OR 2):\n  1 - INSTALL TERRAFORM, INSTALL ANSIBLE, APPLY TERRAFORM CONFIGURATION, EXECUTE ANSIBLE PLAYBOOK.\n  2 - SKIP THE INSTALLATION (TERRAFORM AND ANSIBLE ARE ALREADY INSTALLED), APPLY TERRAFORM CONFIGURATION, EXECUTE ANSIBLE PLAYBOOK.\nANY OTHER INPUT WILL INTERRUPT THE SCRIPT.\n*********************\n*********************\n\n${normalFont}" 
 
read EXEC_OPTION
if [ $EXEC_OPTION == '1' ]
then
	check_updates;
       	terraform_install && \
	ansible_install
elif [ $EXEC_OPTION == '2' ]
then
	printf "\n${descriptionFont}TERRAFORM/ANSIBLE INSTALLATION SKIPPED\n\n${normalFont}"
else
	printf "\nINVALID OPTION!!!\n\n" && \
	exit 1
fi

printf "\n${descriptionFont}*********************\n*********************\nGENERATING SSH-KEYS AND UPDATING ~/Diploma-project/terraform/meta.yml WITH ~/.ssh/id_rsa.pub CONTENT\n*********************\n*********************\n\n${normalFont}" && \
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa;
pubkey=$(cat ~/.ssh/id_rsa.pub) && \
sed -i "s|ssh-rsa|$pubkey|" ~/Diploma-project/terraform/meta.yml && \


printf "\n${descriptionFont}*********************\n*********************\nCHECKING AND APPLYING TERRAFORM CONFIGURATION\n*********************\n*********************\n\n${normalFont}" && \

cd ~/Diploma-project/terraform && \
terraform init && \
#terraform plan && \
terraform validate && \
terraform apply && \

printf "\n${descriptionFont}*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO 'accept-new' INSTEAD OF 'ask'\n*********************\n*********************\n\n${normalFont}" && \

sudo sed -i "s|#   StrictHostKeyChecking ask|   StrictHostKeyChecking accept-new|" /etc/ssh/ssh_config && \
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking && \


printf "\n${descriptionFont}*********************\n*********************\nCHECKING CONNECTION TO MANAGED HOSTS VIA ANSIBLE\n*********************\n*********************\n\n${normalFont}" && \

cd ~/Diploma-project/ansible && \
ansible all -m ping && \

printf "\n${descriptionFont}*********************\n*********************\nSETTING SSH 'StrictHostKeyChecking' DIRECTIVE TO ITS DEFAULT VALUE\n*********************\n*********************\n\n${normalFont}" && \

sudo sed -i "s|   StrictHostKeyChecking accept-new|#   StrictHostKeyChecking ask|" /etc/ssh/ssh_config && \
sudo cat /etc/ssh/ssh_config | grep StrictHostKeyChecking && \

printf "\n${descriptionFont}*********************\n*********************\nRUNNING ANSIBLE PLAYBOOK ~/Diploma-project/ansible/diploma-playbook.yml\n*********************\n*********************\n\n${normalFont}" && \

ansible-playbook diploma-playbook.yml && \

printf "\n${descriptionFont}*********************\n*********************\nALL DONE. BELOW ARE THE PUBLIC IP ADDRESSES OF YOUR RESOURCES.\nPLEASE DO NOT FORGET TO USE 'terraform destroy' WHENEVER YOU DON'T NEED THE INFRASTRUCTURE.\n*********************\n*********************\n\n${normalFont}" && \

cd ~/Diploma-project/terraform && \
terraform output -raw "public-ip-addresses" && \

#Restart bash to ensure ansible and terraform autocompletions are enabled
exec bash
