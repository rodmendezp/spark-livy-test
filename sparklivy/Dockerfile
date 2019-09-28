FROM ubuntu:18.04

RUN apt update && apt install -yq --no-install-recommends \
	wget \
	git \
	gradle \
	debconf-utils \
	g++ \
	curl \
	build-essential \
	python3-pip python3-dev \
	software-properties-common && \
	add-apt-repository -y ppa:webupd8team/java && \
	add-apt-repository -y ppa:ubuntu-security-proposed/ppa && \
	apt-get update -yq && \
	debconf-set-selections && \
	apt install -yq openjdk-8-jdk && \
	apt install -y libkrb5-dev && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir app

ENV INSTALL_LOC /app

ENV SPARK_VERSION 2.4.4
ENV HADOOP_VERSION 2.7
ENV LIVY_VERSION 0.6.0-incubating

ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV LIVY_VERSION_STRING livy-$LIVY_VERSION-bin

ENV SPARK_HOME $INSTALL_LOC/spark
ENV LIVY_HOME $INSTALL_LOC/livy
ENV HADOOP_CONF_HOME $INSTALL_LOC/hadoop-conf
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install Spark
RUN mkdir -p $SPARK_HOME
RUN wget --continue http://apache.mirror.iphh.net/spark/spark-$SPARK_VERSION/$SPARK_VERSION_STRING.tgz && tar -xvzf $SPARK_VERSION_STRING.tgz -C /tmp
RUN cp -rf /tmp/$SPARK_VERSION_STRING/* $SPARK_HOME
RUN rm -rf /tmp/$SPARK_VERSION_STRING
RUN rm $SPARK_VERSION_STRING.tgz

# Install Livy
ENV PYTHONPATH "$PYTHONPATH:$SPARK_HOME/python:`echo $SPARK_HOME/python/lib/py4j*-src.zip`"

ENV LIVY_DOWNLOAD_URL http://apache.claz.org/incubator/livy/$LIVY_VERSION/apache-$LIVY_VERSION_STRING.zip
RUN mkdir -p $HADOOP_CONF_HOME
RUN mkdir -p $LIVY_HOME

RUN wget --continue $LIVY_DOWNLOAD_URL && unzip apache-$LIVY_VERSION_STRING.zip -d /tmp
RUN cp -rf /tmp/apache-$LIVY_VERSION_STRING/* $LIVY_HOME
RUN rm -rf /tmp/apache-$LIVY_VERSION_STRING
RUN rm apache-$LIVY_VERSION_STRING.zip

RUN mkdir -p $LIVY_HOME/logs

ADD spark-defaults.conf $SPARK_HOME/conf/
ADD livy-defaults.conf $LIVY_HOME/conf/
ADD log4j.properties $LIVY_HOME/conf/

# Run spark once to download jars in packages
RUN $SPARK_HOME/bin/spark-shell
RUN cp /root/.ivy2/jars/* $SPARK_HOME/jars/
RUN rm -rf /root/.ivy2

# Config Livy
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -yq && apt install -yq python-tk

# INSTALL CUSTOM HADOOP-AWS JAR
ENV HADOOP_AWS_LOCALSTACK=hadoop-2.7.3-spark-localstack
ENV HADOOP_HOME=$INSTALL_LOC/$HADOOP_AWS_LOCALSTACK
RUN apt install maven -y
RUN git clone https://github.com/suburbanmtman/$HADOOP_AWS_LOCALSTACK $HADOOP_HOME
RUN mvn -f $HADOOP_HOME/hadoop-tools/hadoop-aws/ install
RUN cp ~/.m2/repository/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar $SPARK_HOME/jars/
RUN sed -i -e 's/spark.jars.packages=com.amazonaws:aws-java-sdk-pom:1.10.34,org.apache.hadoop:hadoop-aws:2.7.3//g' $SPARK_HOME/conf/spark-defaults.conf

# Configure AWS CLI
RUN apt install awscli -y

ENV LOCAL_S3_PORT=${LOCAL_S3_PORT:-4572}
ENV AWS_CONTAINER_NAME=${AWS_CONTAINER_NAME:-aws-s3}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-foobar}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-foobar}

EXPOSE 8998

ENTRYPOINT ["sh"]
ADD entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]