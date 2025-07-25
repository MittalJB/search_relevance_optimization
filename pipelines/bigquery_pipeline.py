!pip install pyspark --quiet
!pip install google-cloud-bigquery --quiet

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("GCP BigQuery") \
    .config("spark.jars.packages", "com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.25.2") \
    .getOrCreate()

# Load BigQuery table (replace with your project/dataset/table)
df = spark.read \
  .format("bigquery") \
  .option("table", "search123_project-id.seach123_dataset_id.seach123_table_id") \
  .load()

df.show()
