#!/bin/bash
#
# Remove kubernetes
#
##########################################

sudo kubeadm reset -f
sudo rm -rf /etc/cni/net.d
