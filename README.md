# sparkBDE

Docker project to create a spark big data environment with s3 storage,
jupyter and other features for testing applications locally

### about the environment

- spark standalone cluster with 1 worker 
- iceberg support
- hive catalog 
- the hive-metastore is persisted on mysql backend
- the data is stored on minio
- spark-events log directory is configured to minio 
- S3AFileSystem implementation is used to read/write data from minio

### how to start the image

NOTE: while starting the containers for first time make sure you 
uncomment below line to make sure hive create the metadata tables

```yaml
SKIP_SCHEMA_INIT: false
```
then execute the below to make sure you are running all containers

```shell
docker compose --profile '*' up
```

to bring down the containers

```shell
docker compose --profile '*' down
```

for next run onwards you can start it using, this will make sure you do not start 
mc container which is used to just create the initial buckets for warehouse and spark-events
```shell
docker compose --profile default up
```

### port and volume mappings

the volumes for minio and mysql are persisted under mysql_data and minio_date 
so that the work is not lost once you bring down the containers.
also jupyter notebooks are mapped to spark/notebook.
also the `spark-defaults.conf` and `hive-site.xml` is mapped if anyone want's to play around the spark config's

- Jupyter is accessible on : 8888
- spark history server on : 18080
- spark UI on : 8080