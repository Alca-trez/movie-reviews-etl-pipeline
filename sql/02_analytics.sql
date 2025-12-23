-- ============================================================================
-- MOVIE REVIEWS ETL PIPELINE - ANALYTICS QUERIES
-- ============================================================================
-- These queries provide insights and analytics from the cleaned movie review data
-- Run these queries in BigQuery Console for real-time analytics

-- ============================================================================
-- QUERY 1: TOP 10 HIGHEST RATED MOVIES
-- ============================================================================
-- Shows the movies with the highest average ratings
SELECT 
  movie_title,
  COUNT(*) as total_reviews,
  AVG(rating) as avg_rating,
  MIN(rating) as min_rating,
  MAX(rating) as max_rating,
  SUM(votes) as total_votes,
  ROUND(AVG(review_length), 2) as avg_review_length
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY movie_title
HAVING COUNT(*) >= 5  -- Only movies with at least 5 reviews
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 10;

-- ============================================================================
-- QUERY 2: RATING DISTRIBUTION ANALYSIS
-- ============================================================================
-- Shows the distribution of ratings across all categories
SELECT 
  rating_category,
  COUNT(*) as review_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage,
  AVG(review_length) as avg_review_length,
  MIN(rating) as min_rating_in_category,
  MAX(rating) as max_rating_in_category
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY rating_category
ORDER BY review_count DESC;

-- ============================================================================
-- QUERY 3: MOVIE STATISTICS BY RELEASE YEAR
-- ============================================================================
-- Analyzes movies by release year to find trends
SELECT 
  EXTRACT(YEAR FROM release_date) as release_year,
  COUNT(DISTINCT movie_id) as movie_count,
  COUNT(*) as total_reviews,
  AVG(rating) as avg_rating,
  MAX(rating) as max_rating,
  MIN(rating) as min_rating,
  SUM(votes) as total_votes
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY release_year
HAVING release_year IS NOT NULL
ORDER BY release_year DESC;

-- ============================================================================
-- QUERY 4: REVIEW QUALITY METRICS
-- ============================================================================
-- Analyzes the quality of reviews based on length and rating
SELECT 
  movie_title,
  AVG(review_length) as avg_review_length,
  MAX(review_length) as longest_review,
  MIN(review_length) as shortest_review,
  COUNT(*) as review_count,
  ROUND(STDDEV_POP(rating), 2) as rating_variance,
  AVG(rating) as avg_rating
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY movie_title
ORDER BY avg_review_length DESC
LIMIT 20;

-- ============================================================================
-- QUERY 5: MOVIES WITH MOST ENGAGEMENT (Votes)
-- ============================================================================
-- Shows movies that have received the most votes/engagement
SELECT 
  movie_title,
  SUM(votes) as total_votes,
  AVG(votes) as avg_votes_per_review,
  COUNT(*) as review_count,
  AVG(rating) as avg_rating,
  ROUND(SUM(votes) / COUNT(*), 2) as engagement_per_review
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY movie_title
HAVING COUNT(*) >= 3
ORDER BY total_votes DESC
LIMIT 15;

-- ============================================================================
-- QUERY 6: LOW RATED MOVIES (Below Average)
-- ============================================================================
-- Identifies movies with ratings below the overall average
WITH avg_rating_cte AS (
  SELECT AVG(rating) as overall_avg FROM `movie_reviews_db.cleaned_reviews`
)
SELECT 
  movie_title,
  AVG(rating) as avg_rating,
  COUNT(*) as review_count,
  SUM(votes) as total_votes,
  (SELECT overall_avg FROM avg_rating_cte) as overall_avg_rating
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY movie_title
HAVING AVG(rating) < (SELECT overall_avg FROM avg_rating_cte)
ORDER BY avg_rating ASC
LIMIT 10;

-- ============================================================================
-- QUERY 7: RATING CONSISTENCY ANALYSIS
-- ============================================================================
-- Shows movies with most consistent vs inconsistent ratings
SELECT 
  movie_title,
  AVG(rating) as avg_rating,
  STDDEV_POP(rating) as rating_std_dev,
  COUNT(*) as review_count,
  CASE 
    WHEN STDDEV_POP(rating) < 0.5 THEN 'Consistent'
    WHEN STDDEV_POP(rating) < 1.0 THEN 'Moderately Consistent'
    ELSE 'Inconsistent'
  END as consistency_level
FROM `movie_reviews_db.cleaned_reviews`
GROUP BY movie_title
HAVING COUNT(*) >= 5
ORDER BY rating_std_dev ASC;

-- ============================================================================
-- QUERY 8: MONTHLY REVIEW TRENDS
-- ============================================================================
-- Shows review submission trends over time
SELECT 
  DATE_TRUNC(processed_at, MONTH) as month,
  COUNT(*) as monthly_review_count,
  AVG(rating) as monthly_avg_rating,
  COUNT(DISTINCT movie_id) as unique_movies
FROM `movie_reviews_db.cleaned_reviews`
WHERE processed_at IS NOT NULL
GROUP BY month
ORDER BY month DESC;

-- ============================================================================
-- QUERY 9: TOP PERFORMING MOVIES WITH SAMPLE REVIEWS
-- ============================================================================
-- Gets top movies with sample review text
WITH ranked_movies AS (
  SELECT 
    movie_title,
    rating,
    review_text,
    AVG(rating) OVER (PARTITION BY movie_title) as avg_movie_rating,
    COUNT(*) OVER (PARTITION BY movie_title) as movie_review_count,
    ROW_NUMBER() OVER (PARTITION BY movie_title ORDER BY votes DESC) as review_rank
  FROM `movie_reviews_db.cleaned_reviews`
)
SELECT 
  movie_title,
  avg_movie_rating,
  movie_review_count,
  rating,
  review_text,
  review_rank
FROM ranked_movies
WHERE avg_movie_rating >= 8.0 
  AND movie_review_count >= 5
  AND review_rank <= 2
ORDER BY avg_movie_rating DESC, movie_title;

-- ============================================================================
-- QUERY 10: DATA QUALITY METRICS
-- ============================================================================
-- Shows data quality statistics across the dataset
SELECT 
  'Review Count' as metric, COUNT(*) as value FROM `movie_reviews_db.cleaned_reviews`
UNION ALL
SELECT 'Unique Movies', COUNT(DISTINCT movie_id) FROM `movie_reviews_db.cleaned_reviews`
UNION ALL
SELECT 'Average Rating', ROUND(AVG(rating), 2) FROM `movie_reviews_db.cleaned_reviews`
UNION ALL
SELECT 'Avg Review Length', ROUND(AVG(review_length), 0) FROM `movie_reviews_db.cleaned_reviews`
UNION ALL
SELECT 'Total Votes', SUM(votes) FROM `movie_reviews_db.cleaned_reviews`;
