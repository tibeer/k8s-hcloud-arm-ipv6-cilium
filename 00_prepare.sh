#!/bin/bash
#
# Prepare machine
#
##########################################

# disable swap!
sudo swapoff -a

# install containerd, etc.
sudo apt-get update
sudo apt-get install -y runc containerd apt-transport-https ca-certificates curl

# install kubernetes components
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# set system parameters
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
net.ipv6.conf.all.forwarding        = 1
net.ipv6.conf.default.forwarding    = 1
EOF
sudo sysctl --system
# validate
#lsmod | grep br_netfilter
#lsmod | grep overlay
#sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward net.ipv6.conf.all.forwarding net.ipv6.conf.default.forwarding

##########################################
# k9s needs to be installed manually as
# github is not reachable via IPv6!
##########################################
#curl -sL --remote-name-all https://github.com/derailed/k9s/releases/download/v0.27.3/k9s_Linux_amd64.tar.gz
#sudo tar xzvfC k9s_Linux_amd64.tar.gz /usr/local/bin --wildcards --no-anchored 'k9s'
#rm k9s_Linux_amd64.tar.gz
#sudo rm /usr/local/bin/README.md
#sudo rm /usr/local/bin/LICENSE

# install helm
curl -6Ls --remote-name-all https://get.helm.sh/helm-v3.11.3-linux-arm64.tar.gz
sudo tar xzvfC helm-v3.11.3-linux-arm64.tar.gz /usr/local/bin/ --wildcards --no-anchored 'helm' --strip-components 1
rm helm-v3.11.3-linux-arm64.tar.gz

# configure containerd
sudo mkdir -p /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

# set hostname
sudo sed -i 's/\:\:1 localhost ip6-localhost ip6-loopback/\:\:1 localhost ip6-localhost ip6-loopback vanilla/g' /etc/hosts
