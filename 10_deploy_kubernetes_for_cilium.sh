#!/bin/bash
#
# Deploy kubernetes using kubeadm for cilium
#
##########################################

kubeadm init \
  --control-plane-endpoint vanilla \
  --skip-phases=addon/kube-proxy \
  --pod-network-cidr=2a01:4f8:c010:9384::/64 \
  --service-cidr=2a01:4f8:c010:9384:2::/112
  #--apiserver-advertise-address=fd02::1

# configure kubectl
mkdir -p "${HOME}/.kube"
sudo cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
sudo chown "$(id -u)":"$(id -g)" "${HOME}/.kube/config"

# allow pods on controleplane
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
