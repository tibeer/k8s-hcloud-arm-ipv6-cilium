#!/bin/bash
#
# Deploy kubernetes using kubeadm for calico
#
##########################################

kubeadm init \
  --control-plane-endpoint vanilla \
  --pod-network-cidr=2a01:4f8:c012:f602::/64 \
  --service-cidr=2a01:4f8:c012:f602:2::/112

# configure kubectl
mkdir -p "${HOME}/.kube"
sudo cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
sudo chown "$(id -u)":"$(id -g)" "${HOME}/.kube/config"

# allow pods on controleplane
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# configure calico (copy tigera operator chart manually)
helm install calico ./tigera-operator --namespace tigera-operator --create-namespace --set installation.registry="quay.io"
# ingress is not needed any more, since every service get's a public IPv6 address now
#helm install ingress-nginx ./ingress-nginx --set controller.keda.service.ipFamilies={IPv6}
# if you want to deploy an example workload, you can use github.com/tibeer/helm-charts's nginx-welcome
# keep in mind, that you would have to access the service via the IP address, DNS will work after deployment and record creation
#helm repo add tibeer https://tibeer.github.io/helm-charts/
#helm install foo tibeer/nginx-welcome --set ingress.host="foo.bar"
