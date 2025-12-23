# Movie Reviews ETL Pipeline

[![Python 3.8+](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A complete end-to-end **ETL (Extract, Transform, Load) pipeline** for processing and analyzing movie review data. This project demonstrates practical data engineering skills using Python, Pandas, PySpark, BigQuery, and data visualization techniques.

## Project Overview

This ETL pipeline extracts movie review data, applies comprehensive data quality transformations, and loads it into Google BigQuery for analytics. The project showcases real-world data engineering practices including error handling, data validation, and scalable processing.

### Key Features

- **Data Extraction**: Robust extraction from multiple data sources
- **Data Transformation**: Advanced transformation logic using PySpark for handling duplicates and outliers
- **Data Loading**: Efficient loading to Google BigQuery for cloud-based analytics
- **Data Validation**: Comprehensive error handling and quality assurance framework
- **Data Visualization**: Professional dashboards and insights using Matplotlib and Seaborn
- **Version Control**: Complete Git workflow with clean code practices

## Technologies Used

| Component | Technology |
|-----------|------------|
| **Language** | Python 3.8+ |
| **Data Processing** | Pandas, PySpark, NumPy |
| **Cloud Platform** | Google Cloud Platform (GCP) |
| **Data Warehouse** | BigQuery |
| **Visualization** | Matplotlib, Seaborn |
| **Version Control** | Git, GitHub |
| **Notebook** | Jupyter |

## Project Structure

```
movie-reviews-etl-pipeline/
├── README.md                 # Project documentation
├── requirements.txt          # Python dependencies
├── data/                     # Data storage directory
├── src/                      # Source code directory
│   ├── extract.py           # Data extraction module
│   ├── transform.py         # Data transformation module
│   ├── load.py              # Data loading module
│   └── visualize.py         # Visualization module
├── output/                  # Output directory for visualizations
├── sql/                     # SQL queries for BigQuery
│   └── 01_create_tables.sql # Table creation script
└── venv/                    # Virtual environment
```

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/movie-reviews-etl-pipeline.git
cd movie-reviews-etl-pipeline
```

### 2. Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Google Cloud Setup

- Create a GCP project
- Enable BigQuery API
- Create a service account and download `service_account.json`
- Place the JSON file in the project root

## Usage

### Running the Complete Pipeline

```bash
# Step 1: Extract data
python src/extract.py

# Step 2: Transform data
python src/transform.py

# Step 3: Load to BigQuery
# Run SQL queries in BigQuery console:
sql/01_create_tables.sql

# Step 4: Create visualizations
python src/visualize.py
```

### Individual Module Usage

Each module can be used independently:

```python
from src.extract import DataExtractor
from src.transform import DataTransformer

# Extract data
extractor = DataExtractor()
data = extractor.extract_from_source()

# Transform data
transformer = DataTransformer()
cleaned_data = transformer.clean_and_validate(data)
```

## Configuration

Edit `config.py` to customize:

```python
GCP_PROJECT_ID = "your-project-id"
BIGQUERY_DATASET = "movie_reviews_db"
DATA_SOURCE = "data/raw_reviews.csv"
OUTPUT_DIR = "output/"
```

## Data Pipeline Details

### Step 1: Data Extraction

- Reads movie review data from configured sources
- Implements error handling for missing/invalid records
- Supports multiple data formats (CSV, JSON, BigQuery)

### Step 2: Data Transformation

- **Deduplication**: Removes duplicate records
- **Outlier Detection**: Identifies and handles anomalous data
- **Data Validation**: Ensures data quality and consistency
- **Feature Engineering**: Creates derived features for analysis

**Technologies**: PySpark DataFrame operations, pandas transformations

### Step 3: Data Loading

- Loads processed data to BigQuery tables
- Maintains data integrity and referential constraints
- Supports incremental loads and full refreshes

### Step 4: Analytics & Visualization

- Generates insights from processed data
- Creates professional visualizations (charts, graphs, dashboards)
- Produces analytical reports

## Key Metrics & Outcomes

- ✅ **Data Quality**: Comprehensive validation framework ensuring data accuracy
- ✅ **Scalability**: Handles large datasets using distributed computing (PySpark)
- ✅ **Reliability**: Robust error handling and logging throughout pipeline
- ✅ **Performance**: Optimized queries and efficient data transformations

## Code Examples

### Extract Data

```python
import pandas as pd
from google.cloud import bigquery

client = bigquery.Client(project='YOUR_PROJECT_ID')
df = pd.DataFrame({
    'movie_id': [1, 2, 3],
    'movie_title': ['Inception', 'Dark Knight', 'Interstellar'],
    'rating': [8.8, 9.0, 8.6]
})
```

### Transform Data with PySpark

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, count

spark = SparkSession.builder.appName("MovieETL").getOrCreate()
df = spark.read.csv('data/reviews.csv', header=True)

# Remove duplicates
df_unique = df.dropDuplicates()

# Handle outliers
df_clean = df_unique.filter((col('rating') > 0) & (col('rating') <= 10))
```

### Create Visualizations

```python
import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv('data/processed_reviews.csv')

plt.figure(figsize=(10, 6))
plt.bar(df['movie_title'], df['avg_rating'], color='steelblue')
plt.title('Top Rated Movies')
plt.xlabel('Movie')
plt.ylabel('Average Rating')
plt.savefig('output/top_movies.png')
plt.show()
```

## Performance Optimization

- **Spark Partitioning**: Data partitioned by date for faster queries
- **Batch Processing**: Efficient batch operations instead of row-by-row processing
- **Query Optimization**: BigQuery queries optimized with proper indexing
- **Memory Management**: Efficient memory usage through lazy evaluation

## Testing

```bash
# Run unit tests
python -m pytest tests/

# Run with coverage
pytest --cov=src/ tests/
```

## Troubleshooting

### Authentication Error
```
If you get authentication errors with BigQuery:
1. Verify service_account.json is in the correct location
2. Check GCP_PROJECT_ID in config.py
3. Ensure BigQuery API is enabled
```

### Memory Issues with Large Datasets
```
If processing large datasets:
1. Use PySpark instead of Pandas for better scalability
2. Increase partition count in Spark jobs
3. Optimize DataFrame operations (filter before join)
```

## Best Practices Implemented

- ✅ Clear separation of concerns (extract, transform, load)
- ✅ Error handling and logging
- ✅ Data validation at each stage
- ✅ Documentation and code comments
- ✅ Version control with meaningful commits
- ✅ Scalable architecture for production use

## Future Enhancements

- [ ] Add machine learning models for prediction
- [ ] Implement real-time data streaming with Pub/Sub
- [ ] Add data quality metrics and SLA monitoring
- [ ] Create web dashboard for visualization
- [ ] Implement CI/CD pipeline with Cloud Build
- [ ] Add cost optimization features

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Abhishek Verma**
- Email: abhishekverma705@gmail.com
- LinkedIn: [linkedin.com/in/abhishek-verma16](https://linkedin.com/in/abhishek-verma16)
- GitHub: [github.com/Alca-trez](https://github.com/Alca-trez)

## Acknowledgments

- Google Cloud Platform documentation
- Apache Spark community
- Data engineering best practices

---

**Made with ❤️ by Abhishek Verma**
