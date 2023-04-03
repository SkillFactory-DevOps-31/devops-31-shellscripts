#!/bin/sh

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

EXTERNAL_IP="84.201.154.102"
INTERNAL_IP="192.168.10.35"
PORT=6443

iptables -t nat -A POSTROUTING -p tcp -d ${EXTERNAL_IP} --dport ${PORT} -j SNAT --to-source ${INTERNAL_IP}
