import os
import datetime
import psycopg
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = os.getenv("DB_PORT", "5432")


def get_connection():
    return psycopg.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        port=DB_PORT
    )


def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS results (
            id SERIAL PRIMARY KEY,
            repo_url TEXT,
            score INTEGER,
            timestamp TIMESTAMP,
            commit_message TEXT,
            passed_checks INTEGER
        )
    """)

    conn.commit()
    conn.close()


def save_result(repo_url, score, commit_message, passed_checks):
    timestamp = datetime.datetime.now()

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO results (
            repo_url,
            score,
            timestamp,
            commit_message,
            passed_checks
        )
        VALUES (%s, %s, %s, %s, %s)
    """, (
        repo_url,
        score,
        timestamp,
        commit_message,
        passed_checks
    ))

    conn.commit()
    conn.close()


def get_results():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT *
        FROM results
        ORDER BY id DESC
    """)

    rows = cursor.fetchall()

    conn.close()

    return rows