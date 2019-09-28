#!/bin/sh

export AWS_IP=$(ping -c 1 s3-1.amazonaws.com | awk 'NR==1{gsub(/\(|\)/,"",$3);print $3}')
export LOCAL_AWS=$(ping -c 1 ${AWS_CONTAINER_NAME} | awk 'NR==1{gsub(/\(|\)/,"",$3);print $3}')
echo "${AWS_IP} s3-1.amazonaws.com" >> /etc/hosts
echo "${AWS_IP} s3.amazonaws.com" >> /etc/hosts
iptables -t nat -I OUTPUT -p tcp --dport 80 -d ${AWS_IP} -j DNAT --to-destination ${LOCAL_AWS}:${LOCAL_S3_PORT}
iptables -t nat -I OUTPUT -p tcp --dport 443 -d ${AWS_IP} -j DNAT --to-destination ${LOCAL_AWS}:${LOCAL_S3_PORT}
iptables-save >> /etc/iptables.rules

$LIVY_HOME/bin/livy-server $@