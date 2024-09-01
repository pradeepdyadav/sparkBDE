FROM openjdk:8-jre-slim

WORKDIR /opt

ENV HADOOP_VERSION=3.3.4
ENV METASTORE_VERSION=3.0.0
ENV MYSQL_VERSION=8.0.19
ENV ICEBERG_VERSION=1.6.0

RUN apt-get update && \
    apt-get install -y curl netcat --no-install-recommends && \
    apt-get clean

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV METASTORE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

# Download and install Hadoop & standalone Hive metastore
RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf -

# Download iceberg-hive-runtime
RUN curl -s https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-hive-runtime/1.6.0/iceberg-hive-runtime-1.6.0.jar -Lo ${HADOOP_HOME}/share/hadoop/tools/lib/iceberg-hive-runtime-1.6.0.jar

# Download AWS bundle
RUN curl -s https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar -Lo ${HADOOP_HOME}/share/hadoop/tools/lib/iceberg-aws-bundle-${ICEBERG_VERSION}.jar

# Download and install MySQL jar used by Hive metastore
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz | tar zxf - && \
    cp mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}.jar ${METASTORE_HOME}/lib/ && \
    rm -rf  mysql-connector-java-${MYSQL_VERSION}

COPY entrypoint.sh /entrypoint.sh

# Assign permissions (unsecured, for testing only)
RUN groupadd -r testing --gid=1000
RUN useradd -r -g testing --uid=1000 -d ${METASTORE_HOME} hive
RUN chown hive:testing -R ${METASTORE_HOME} && \
    chown hive:testing /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER hive

# Expose metastore port (default)
EXPOSE 9083

CMD ["sh", "-c", "/entrypoint.sh"]