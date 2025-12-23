import pandas as pd
from google.cloud import bigquery
import os
from datetime import datetime

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'service_account.json'

def create_sample_data():
    """Create sample movie review data"""
    data = {
        'movie_id': [1, 2, 3, 4, 5],
        'movie_title': ['Inception', 'Dark Knight', 'Interstellar', 'Avatar', 'Titanic'],
        'rating': [8.8, 9.0, 8.6, 7.8, 7.3],
        'review_text': ['Amazing', 'Great', 'Mind-bending', 'Stunning', 'Epic'],
        'release_date': ['2010-07-16', '2008-07-18', '2014-11-07', '2009-12-18', '1997-12-19'],
        'votes': [2500000, 2600000, 1900000, 2300000, 1300000]
    }
    df = pd.DataFrame(data)
    return df

def extract_from_csv(filepath):
    """Extract data from CSV file"""
    try:
        df = pd.read_csv(filepath)
        print(f"Extracted {len(df)} records from {filepath}")
        return df
    except Exception as e:
        print(f"Error reading CSV: {e}")
        return None

def extract_from_bigquery(project_id, query):
    """Extract data from BigQuery"""
    client = bigquery.Client(project=project_id)
    try:
        df = client.query(query).to_pandas()
        print(f"Extracted {len(df)} records from BigQuery")
        return df
    except Exception as e:
        print(f"Error querying BigQuery: {e}")
        return None

if __name__ == "__main__":
    # Create sample data
    df = create_sample_data()
    print("Sample data created:")
    print(df.head())
    
    # Save to CSV
    df.to_csv('data/raw_reviews.csv', index=False)
    print("\nData saved to data/raw_reviews.csv")
