from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, count, avg, trim
import pandas as pd
from datetime import datetime

def create_spark_session():
    """Create Spark session"""
    spark = SparkSession.builder \
        .appName("MovieETL") \
        .getOrCreate()
    return spark

def remove_duplicates(df):
    """Remove duplicate records from DataFrame"""
    initial_count = df.count()
    df_unique = df.dropDuplicates()
    final_count = df_unique.count()
    print(f"Removed {initial_count - final_count} duplicates")
    return df_unique

def handle_outliers(df):
    """Remove outlier records"""
    df_clean = df.filter((col('rating') > 0) & (col('rating') <= 10))
    print(f"Filtered to {df_clean.count()} valid records")
    return df_clean

def data_validation(df):
    """Validate data quality"""
    # Check for null values
    null_counts = df.select([count(when(col(c).isNull(), c)).alias(c) for c in df.columns])
    print("Null value counts:")
    null_counts.show()
    return df

def transform_data(df):
    """Apply transformations to data"""
    spark = create_spark_session()
    
    # Convert to Spark DataFrame
    df_spark = spark.createDataFrame(df) if isinstance(df, pd.DataFrame) else df
    
    # Remove duplicates
    df_spark = remove_duplicates(df_spark)
    
    # Handle outliers
    df_spark = handle_outliers(df_spark)
    
    # Validate data
    df_spark = data_validation(df_spark)
    
    # Add processing timestamp
    df_spark = df_spark.withColumn('processed_at', datetime.now())
    
    # Trim string columns
    for col_name in df_spark.columns:
        if 'text' in col_name:
            df_spark = df_spark.withColumn(col_name, trim(col(col_name)))
    
    return df_spark

if __name__ == "__main__":
    print("Data transformation complete")
