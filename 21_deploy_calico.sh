#!/bin/bash
#
# Deploy calico in kubernetes
#
##########################################

# as nearly all helm charts are hosted on github.com, you have to manually
# download and copy them them to the IPv6 host

#helm repo add projectcalico https://docs.tigera.io/calico/charts
helm install calico ./tigera-operator --namespace tigera-operator --create-namespace

# Ingress is not required any more since every service get's it's own IPv6 address
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm install ingress-nginx ./ingress-nginx --set controller.keda.service.ipFamilies={IPv6}

#helm repo add tibeer https://tibeer.github.io/helm-charts/
helm install foo ./default-helmchart --set ingress={}
