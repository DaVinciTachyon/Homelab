# My Homelab

## Installation

1. Install the os on each node with the configuration files in 'os/'.
2. Set up each node to have a static ip on the router.
3. Ensure the k3s cluster is accessible on the LAN. Copy '/etc/rancher/k3s/k3s.yaml' from control node to '~/.kube/config'. Edit '127.0.0.1' to be control node ip.
4. Set the final DHCP IP address to '192.168.1.191' (To allow the loadbalancer to use '192.168.1.192' to '192.168.1.255')
5. Set kube/helm/values/pihole.values.yml:ingress/enabled = true
6. Run kube/apply.sh
7. Set kube/helm/values/pihole.values.yml:ingress/enabled = false
8. Run kube/apply.sh
9. Change router to static DNS, first entry should point to '192.168.1.250', the rest to '0.0.0.0'.
<!-- 10. Forward request to your router to internal dns server. -->
10. Add services to your heart's content.

## Upgrade

- OS - Talos
- Beelink EQ12 * 2+
- 32 GB RAM
- 1TB+ Storage
- NAS