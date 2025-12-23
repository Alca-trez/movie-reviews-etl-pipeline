import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from google.cloud import bigquery
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'service_account.json'

def visualize_top_movies(df):
    """Create bar chart for top rated movies"""
    fig, ax = plt.subplots(figsize=(12, 6))
    ax.bar(df['movie_title'], df['avg_rating'], color='steelblue')
    ax.set_title('Top Rated Movies', fontsize=16, fontweight='bold')
    ax.set_xlabel('Movie Title', fontsize=12)
    ax.set_ylabel('Average Rating', fontsize=12)
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig('output/top_movies.png', dpi=300)
    print("Saved: output/top_movies.png")
    plt.close()

def visualize_rating_distribution(df):
    """Create pie chart for rating distribution"""
    fig, ax = plt.subplots(figsize=(10, 8))
    ax.pie(df['cnt'], labels=df['rating_category'], autopct='%1.1f%%', startangle=90)
    ax.set_title('Rating Distribution', fontsize=16, fontweight='bold')
    plt.tight_layout()
    plt.savefig('output/distribution.png', dpi=300)
    print("Saved: output/distribution.png")
    plt.close()

def visualize_reviews_heatmap(df):
    """Create heatmap for review patterns"""
    fig, ax = plt.subplots(figsize=(12, 8))
    sns.heatmap(df.corr(), annot=True, cmap='coolwarm', ax=ax)
    ax.set_title('Feature Correlation Matrix', fontsize=16, fontweight='bold')
    plt.tight_layout()
    plt.savefig('output/correlation_heatmap.png', dpi=300)
    print("Saved: output/correlation_heatmap.png")
    plt.close()

def visualize(project_id='YOUR_PROJECT_ID'):
    """Main visualization function"""
    client = bigquery.Client(project=project_id)
    
    # Query 1: Top rated movies
    query1 = """SELECT movie_title, AVG(rating) as avg_rating 
               FROM `YOUR_PROJECT_ID.movie_reviews_db.cleaned_reviews` 
               GROUP BY movie_title ORDER BY avg_rating DESC LIMIT 10"""
    df1 = client.query(query1).to_pandas()
    visualize_top_movies(df1)
    
    # Query 2: Rating distribution
    query2 = """SELECT rating_category, COUNT(*) as cnt 
               FROM `YOUR_PROJECT_ID.movie_reviews_db.cleaned_reviews` 
               GROUP BY rating_category"""
    df2 = client.query(query2).to_pandas()
    visualize_rating_distribution(df2)
    
    print("All visualizations created successfully!")

if __name__ == "__main__":
    print("Creating visualizations...")
    visualize()
    print("Done!")
