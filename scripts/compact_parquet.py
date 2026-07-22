from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Compact Ride Sharing Parquet Files") \
    .getOrCreate()

# Read existing parquet files
df = spark.read.parquet("/RideSharingAnalytics/processed/rides")

print("Total records:", df.count())

# Write into fewer files
df.coalesce(10) \
  .write \
  .mode("overwrite") \
  .parquet("/RideSharingAnalytics/processed/rides_compact")

spark.stop()
