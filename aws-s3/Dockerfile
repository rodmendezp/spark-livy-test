FROM ubuntu:18.04

ENV LOCAL_S3_PORT=${LOCAL_S3_PORT:-4572}
ENV AWS_CONTAINER_NAME=${AWS_CONTAINER_NAME:-aws-s3}

RUN apt update && apt install iptables iputils-ping net-tools awscli -y

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-foobar}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-foobar}

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]