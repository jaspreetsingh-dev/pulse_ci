import sqlite3
import datetime
import os

DB_PATH = os.getenv("DB_PATH", "data/results.db")
def init_db():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS results ("
    "id INTEGER PRIMARY KEY,"
    "repo_url TEXT," 
    "score INTEGER," 
    "timestamp TEXT,"
    "commit_message TEXT,"
    "passed_checks INTEGER)")
    conn.commit()
    conn.close()

def save_result(repo_url, score, commit_message, passed_checks):
    timestamp = datetime.datetime.now().isoformat()
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO results (repo_url, score, timestamp, commit_message, passed_checks) VALUES (?, ?, ?, ?, ?)",
    (repo_url, score, timestamp, commit_message, passed_checks))
    conn.commit()
    conn.close()

def get_results():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM results")
    rows = cursor.fetchall()
    conn.close()
    return rows