#!/bin/bash
#
# Deploy cilium in kubernetes
#
##########################################

# METHOD A
# deploy cilium network via cilium client
#curl -sL --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)/cilium-linux-amd64.tar.gz{,.sha256sum}
#sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
#sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
#rm cilium-linux-amd64.tar.gz{,.sha256sum}
#cilium install
#cilium status
#cilium hubble enable --ui

# METHOD B:
# deploy cilium network via helm
helm repo add cilium https://helm.cilium.io/
helm repo update
helm install cilium cilium/cilium \
  --version 1.13.2 \
  --namespace kube-system \
  --set kubeProxyReplacement=strict \
  --set operator.replicas=1 \
  --set hubble.ui.enabled=true \
  --set hubble.relay.enabled=true \
  --set ipv4.enabled=false \
  --set ipv6.enabled=true
# known bug: https://github.com/cilium/cilium/issues/17240
  #--set hubble.ui.ingress.enabled=true \
  #--set hubble.ui.ingress.className=nginx \
  #--set hubble.ui.ingress.hosts={213.131.230.103.nip.io}
