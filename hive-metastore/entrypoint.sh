#!/bin/bash

export HADOOP_VERSION=3.3.4
export HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
export HADOOP_CLASSPATH=$HADOOP_HOME/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.262.jar:$HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-3.3.4.jar
export HIVE_AUX_JARS_PATH=$HADOOP_CLASSPATH:${HADOOP_HOME}/share/hadoop/tools/lib/iceberg-hive-runtime-1.6.0.jar:${HADOOP_HOME}/share/hadoop/tools/lib/iceberg-aws-bundle-1.6.0.jar
export JAVA_HOME=/usr/local/openjdk-8
export DB_HOSTNAME=${DB_HOSTNAME:-localhost}
export SKIP_SCHEMA_INIT=${SKIP_SCHEMA_INIT:-true}
echo "Waiting for MySQL database on ${DB_HOSTNAME} to launch..."
while ! nc -z $DB_HOSTNAME 3306; do
    sleep 1
done

echo "Starting Hive metastore service on $DB_HOSTNAME:3306"

if [[ "${SKIP_SCHEMA_INIT}" == "false" ]]; then
  # handles schema initialization
  echo "schema_initilization started..."
  /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -initSchema -dbType mysql
fi

/opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore
