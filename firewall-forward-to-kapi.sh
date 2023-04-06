#!/bin/sh

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

INTERNAL_CLUSTER_IP="192.168.10.35"
EXTERNAL_API_PORT=6443
INTERNAL_API_PORT=6443

EXTERNAL_APP_PORT=8080
INTERNAL_APP_PORT=13531

iptables -t nat -A PREROUTING -p tcp --dport ${EXTERNAL_API_PORT} -j DNAT --to-destination ${INTERNAL_CLUSTER_IP}:${INTERNAL_API_PORT}
iptables -t nat -A PREROUTING -p tcp --dport ${EXTERNAL_APP_PORT} -j DNAT --to-destination ${INTERNAL_CLUSTER_IP}:${INTERNAL_APP_PORT}
