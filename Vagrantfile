# -*- mode: ruby -*-
# vi: set ft=ruby :
$centos_docker_script = <<SCRIPT
# Install Docker
sudo yum remove docker \
          docker-client \
          docker-client-latest \
          docker-common \
          docker-latest \
          docker-latest-logrotate \
          docker-logrotate \
          docker-engine
sudo yum install -y yum-utils \
            device-mapper-persistent-data \
            lvm2
sudo yum-config-manager \
                --add-repo \
                https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce \
              docker-ce-cli \
              containerd.io
sudo systemctl start docker && sudo docker --version
SCRIPT
$ubuntu_docker_script = <<SCRIPT
# Get Docker Engine - Community for Ubuntu
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker --version
# Manage Docker as a non-root user
# https://docs.docker.com/install/linux/linux-postinstall/
sudo groupadd docker && sudo usermod -aG docker vagrant # add user to the docker group
sudo systemctl enable docker
docker --version
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # vbox template for all vagranth instances
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = 2
  end

  # customize vagrant instance
  config.vm.define "control01" do |dockercluster|
    dockercluster.vm.box = "bento/ubuntu-19.04"
    dockercluster.vm.provider "virtualbox" do |vb|
      vb.name = "control01"
     end
     dockercluster.vm.network "private_network", ip: "172.28.128.12"
     dockercluster.vm.network "forwarded_port", guest: 80, host: 81
     dockercluster.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "deploy.yml"
       ansible.become = true
       ansible.compatibility_mode = "2.0"
       ansible.version = "2.9.4"
     end
     dockercluster.vm.provision "shell", inline: $ubuntu_docker_script, privileged: false
     dockercluster.vm.provision "shell", inline: <<-SHELL
     echo "===================================================================================="
                               hostnamectl status
     echo "===================================================================================="
     echo "         \   ^__^                                                                  "
     echo "          \  (oo)\_______                                                          "
     echo "             (__)\       )\/\                                                      "
     echo "                 ||----w |                                                         "
     echo "                 ||     ||                                                         "
     SHELL


  end

  # customize vagrant instance
  config.vm.define "control02" do |dockercluster|
    dockercluster.vm.box = "bento/centos-7.7"
    dockercluster.vm.network "private_network", ip: "172.28.128.15"
    dockercluster.vm.network "forwarded_port", guest: 80, host: 82
    dockercluster.vm.provider "virtualbox" do |vb|
      vb.name = "control02"
     end
     dockercluster.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "deploy.yml"
       ansible.become = true
       ansible.compatibility_mode = "2.0"
       ansible.version = "2.9.2"
     end
    dockercluster.vm.provision "shell", inline: $centos_docker_script, privileged: false
    dockercluster.vm.provision "shell", inline: <<-SHELL
    echo "===================================================================================="
                              hostnamectl status
    echo "===================================================================================="
    echo "         \   ^__^                                                                  "
    echo "          \  (oo)\_______                                                          "
    echo "             (__)\       )\/\                                                      "
    echo "                 ||----w |                                                         "
    echo "                 ||     ||                                                         "
    SHELL
  end



end
