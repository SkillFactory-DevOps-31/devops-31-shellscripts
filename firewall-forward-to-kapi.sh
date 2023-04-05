#!/bin/sh

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

INTERNAL_IP="192.168.10.35"
EXTERNAL_PORT=6443
INTERNAL_PORT=6443

iptables -t nat -A PREROUTING -p tcp --dport ${EXTERNAL_PORT} -j DNAT --to-destination ${INTERNAL_IP}:${INTERNAL_PORT}
