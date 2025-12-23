-- Create BigQuery dataset and tables for Movie Reviews ETL Pipeline

-- Step 1: Create Dataset (if not exists)
CREATE SCHEMA IF NOT EXISTS `movie_reviews_db`
OPTIONS(
  description="Movie reviews database for ETL pipeline",
  location="US"
);

-- Step 2: Create raw_reviews table
CREATE TABLE IF NOT EXISTS `movie_reviews_db.raw_reviews` (
  movie_id INT64,
  movie_title STRING,
  rating FLOAT64,
  review_text STRING,
  release_date DATE,
  votes INT64,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(created_at)
CLUSTER BY movie_id;

-- Step 3: Create cleaned_reviews table
CREATE TABLE IF NOT EXISTS `movie_reviews_db.cleaned_reviews` (
  movie_id INT64,
  movie_title STRING,
  rating FLOAT64,
  review_text STRING,
  release_date DATE,
  votes INT64,
  rating_category STRING,
  review_length INT64,
  processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(processed_at)
CLUSTER BY movie_id;

-- Step 4: Create movie_stats table
CREATE TABLE IF NOT EXISTS `movie_reviews_db.movie_stats` (
  movie_title STRING NOT NULL,
  avg_rating FLOAT64,
  review_count INT64,
  total_votes INT64,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Step 5: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_movie_title ON `movie_reviews_db.cleaned_reviews`(movie_title);
CREATE INDEX IF NOT EXISTS idx_rating ON `movie_reviews_db.cleaned_reviews`(rating);

-- Verification queries
SELECT COUNT(*) as table_count FROM `movie_reviews_db.INFORMATION_SCHEMA.TABLES`;
SHOW TABLES IN `movie_reviews_db`;
