# k8s-hcloud-arm-ipv6-only

Deploy a single node kubernetes cluster on an ARM server in the Hetzner Cloud using kubeadm and cilium or calico with only IPv6 connectivity.

## Getting startet

It is expected, that you have already created an account and a project inside the Hetzner Cloud.
You should also be familiar with Terraform and therefore have created and exportet a token (`HCLOUD_TOKEN`).

To preapre your playground go to the _hetzner_cloud_ folder and do the usual stuff:

```sh
terraform init
terraform apply -auto-approve
```

__WARNING__ This will generate resources, that have to be paid.
At the time of creation, this was 0,0072€ per hour.

You should now have a ARM based VM with 2 vCPUs and 4GB of RAM.

## Deployment

Copy all scripts to the VM. SCP to IPv6 is somewhat special:

```sh
scp *.sh root@\[2a01:4f8:c010:9384::1\]:/root/
```

You might also want to install k9s, depending on your needs. Unfortunately github.com is still not reachable via IPv6, so you have to download the releases to your machine first and need to copy them via scp to the VM.

Now it's time to start them in order. Depending on your desired network plugin, execute the ones matching cilium or calico. __WARNING__ cilium is still not working, due to a bug in cilium itself: <https://github.com/cilium/cilium/issues/17240>

### calico

```sh
bash 00_prepare.sh
# edit the 11_deploy_kubernetes_for_calico.sh file and change the network to your values
bash 11_deploy_kubernetes_for_calico.sh
bash 21_deploy_calico.sh
# 22_calico_config.yaml should NOT be required (kubectl apply -f ...)
```

### cilium

```sh
bash 00_prepare.sh
# edit the 10_deploy_kubernetes_for_cilium.sh file and change the network to your values
bash 10_deploy_kubernetes_for_cilium.sh
bash 20_deploy_cilium.sh
```

## Cleanup

If you want to remove kubernetes again, use this script. This will not uninstall kubelet, helm, etc.

```sh
bash 99_cleanup.sh
```
