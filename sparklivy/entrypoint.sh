#!/bin/bash

export LOCALSTACK_DOCKER_IP=$(ping -c 1 ${LOCALSTACK_DOCKER_NAME} | awk 'NR==1{gsub(/\(|\)/,"",$3);print $3}')
echo "${LOCALSTACK_DOCKER_IP} s3-1.amazonaws.com" >> /etc/hosts
echo "${LOCALSTACK_DOCKER_IP} s3.amazonaws.com" >> /etc/hosts
iptables -t nat -I OUTPUT -p tcp --dport 80 -d ${LOCALSTACK_DOCKER_IP} -j DNAT --to-destination ${LOCALSTACK_DOCKER_IP}:${LOCALSTACK_S3_PORT}
iptables -t nat -I OUTPUT -p tcp --dport 443 -d ${LOCALSTACK_DOCKER_IP} -j DNAT --to-destination ${LOCALSTACK_DOCKER_IP}:${LOCALSTACK_S3_PORT}
iptables-save >> /etc/iptables.rules

export LOCALSTACK_S3_URL=$(if [[ $AWS_SSL_ENABLED == "false" ]]; then echo "http://"; else echo "https://"; fi;)${LOCALSTACK_DOCKER_NAME}:${LOCALSTACK_S3_PORT}
echo 'alias aws="aws --endpoint-url='${LOCALSTACK_S3_URL}'"' >> ~/.bashrc

$LIVY_HOME/bin/livy-server $@