from datetime import datetime, timedelta
import pandas as pd
from airflow import DAG
from airflow.operators.python import PythonOperator
from sqlalchemy import create_engine

# Konfigurasi Koneksi ke Database PostgreSQL Docker
DB_CONN_STR = "postgresql+psycopg2://dw_user:dw_password@postgres_dw:5432/order_management_dw"

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2026, 5, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def load_csv_to_postgres(file_name, table_name):
    """Fungsi untuk membaca CSV dan memasukkannya ke PostgreSQL"""
    # Jalur file di dalam container Docker Airflow
    file_path = f"/opt/airflow/project_folder/raw_data/smoke/{file_name}"
    
    print(f"Membaca file: {file_path}")
    df = pd.read_csv(file_path)
    
    engine = create_engine(DB_CONN_STR)
    # Memasukkan data ke skema 'public' (Raw Layer)
    df.to_sql(table_name, engine, if_exists='replace', index=False, schema='public')
    print(f"Sukses memindahkan {len(df)} baris ke tabel {table_name}!")

with DAG(
    dag_id='order_management_etl',
    default_args=default_args,
    schedule_interval=None,  # Dijalankan manual lewat tombol play
    catchup=False,
    tags=['dwbi', 'commerce'],
) as dag:

    tables_to_load = {
        'categories.csv': 'raw_categories',
        'cities.csv': 'raw_cities',
        'customer_profile_events.csv': 'raw_customer_profile_events',
        'order_items.csv': 'raw_order_items',
        'order_status_events.csv': 'raw_order_status_events',
        'orders.csv': 'raw_orders',
        'payment_methods.csv': 'raw_payment_methods'
    }

    # Membuat task Airflow secara otomatis berurutan
    for csv_file, table_name in tables_to_load.items():
        task_id = f"load_{table_name}"
        
        PythonOperator(
            task_id=task_id,
            python_callable=load_csv_to_postgres,
            op_kwargs={'file_name': csv_file, 'table_name': table_name},
        )
