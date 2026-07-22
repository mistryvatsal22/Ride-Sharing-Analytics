from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

# ==========================================================
# Create Spark Session
# ==========================================================

spark = SparkSession.builder \
    .appName("RideSharingAnalytics") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

print("=" * 60)
print("Spark Session Created Successfully")
print("=" * 60)

# ==========================================================
# Kafka Stream
# ==========================================================

df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "ride_analytics") \
    .option("startingOffsets", "latest") \
    .load()

print("Connected to Kafka Successfully")

# ==========================================================
# Define JSON Schema
# ==========================================================

schema = StructType([

    StructField("booking_id", StringType()),

    StructField("pickup_date", StringType()),
    StructField("pickup_time", StringType()),

    StructField("pickup_city", StringType()),
    StructField("pickup_latitude", DoubleType()),
    StructField("pickup_longitude", DoubleType()),

    StructField("drop_city", StringType()),
    StructField("dropoff_latitude", DoubleType()),
    StructField("dropoff_longitude", DoubleType()),

    StructField("fare_amount", IntegerType()),
    StructField("final_fare", IntegerType()),

    StructField("trip_distance", DoubleType()),
    StructField("ride_duration", IntegerType()),

    StructField("passenger_count", IntegerType()),

    StructField("ride_category", StringType()),

    StructField("driver_id", StringType()),
    StructField("driver_name", StringType()),
    StructField("driver_rating", DoubleType()),

    StructField("customer_rating", DoubleType()),

    StructField("trip_status", StringType()),

    StructField("payment_type", StringType()),
    StructField("payment_status", StringType()),

    StructField("surge_multiplier", DoubleType()),

    StructField("traffic_condition", StringType()),
    StructField("weather", StringType())

])

# ==========================================================
# Parse JSON
# ==========================================================

json_df = df.selectExpr("CAST(value AS STRING)") \
    .select(from_json(col("value"), schema).alias("data")) \
    .select("data.*")

print("JSON Parsed Successfully")

# ==========================================================
# Data Cleaning
# ==========================================================

clean_df = json_df.dropDuplicates(["booking_id"])

clean_df = clean_df.na.fill({
    "payment_type": "Unknown",
    "trip_status": "Unknown"
})

print("Data Cleaning Completed")

# ==========================================================
# Feature Engineering
# ==========================================================

clean_df = clean_df.withColumn(
    "pickup_timestamp",
    to_timestamp(
        concat_ws(" ", col("pickup_date"), col("pickup_time")),
        "yyyy-MM-dd HH:mm:ss"
    )
)

clean_df = clean_df \
.withColumn("year", year("pickup_timestamp")) \
.withColumn("month", month("pickup_timestamp")) \
.withColumn("day", dayofmonth("pickup_timestamp")) \
.withColumn("hour", hour("pickup_timestamp")) \
.withColumn("day_of_week", date_format("pickup_timestamp", "EEEE"))

print("Feature Engineering Completed")

# ==========================================================
# Display Streaming Data
# ==========================================================

query1 = clean_df.writeStream \
    .outputMode("append") \
    .format("console") \
    .option("truncate", False) \
    .start()

# ==========================================================
# Save into HDFS (Parquet)
# ==========================================================

query2 = clean_df.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "/RideSharingAnalytics/processed/rides") \
    .option("checkpointLocation",
            "/RideSharingAnalytics/checkpoints/rides") \
    .start()

query1.awaitTermination()
query2.awaitTermination()
