#!/usr/bin/python3
"""
A script to create the 'alx_book_store' database in a MySQL server.
"""

import mysql.connector
from mysql.connector import Error

def create_database():
    """Connects to MySQL server and creates the specified database."""
    conn = None
    cursor = None
    try:
        # --- Step 1: Establish a connection ---
        # NOTE: Replace 'your_user' and 'your_password' with your MySQL credentials.
        conn = mysql.connector.connect(
            host="localhost",
            user="your_user",        # Default is often 'root'
            password="your_password" # Your MySQL root password
        )
        cursor = conn.cursor()

        # --- Step 2: Execute the CREATE DATABASE command ---
        # Using 'IF NOT EXISTS' prevents an error if the database is already there.
        cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")

        print("Database 'alx_book_store' created successfully!")

    except Error as e:
        # Handle any errors that occur during the process
        print(f"Error: Failed to connect or create database: {e}")

    finally:
        # --- Step 3: Close the cursor and connection ---
        # It's important to close resources to free them up.
        if cursor is not None:
            cursor.close()
        if conn is not None and conn.is_connected():
            conn.close()

if __name__ == "__main__":
    create_database()
