#!/bin/sh

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

EXTERNAL_IP=""
INTERNAL_IP=""
EXTERNAL_PORT=6443
INTERNAL_PORT=6443

iptables -t nat -A POSTROUTING -p tcp -d ${EXTERNAL_IP} --dport ${PORT} -j SNAT --to-source ${INTERNAL_IP}
iptables -t nat -A PREROUTING -p tcp --dport ${EXTERNAL_PORT} -j DNAT --to-destination ${INTERNAL_IP}:${INTERNAL_PORT}
