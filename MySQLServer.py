import mysql.connector
from mysql.connector import Error

def create_database():
    try:
        # Connect to MySQL server
        connection = mysql.connector.connect(
            host='localhost',  # Change to your MySQL server's host if needed
            user='root',       # Change to your MySQL username
            password='password'  # Change to your MySQL password
        )

        # Check if the connection was successful
        if connection.is_connected():
            print("Successfully connected to MySQL server")

            # Create a cursor object to execute SQL queries
            cursor = connection.cursor()

            # SQL query to create database if it does not exist
            cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")

            # Commit the changes
            connection.commit()

            print("Database 'alx_book_store' created successfully!")

    except Error as e:
        print(f"Error: {e}")
    finally:
        if connection.is_connected():
            # Close the cursor and connection
            cursor.close()
            connection.close()
            print("MySQL connection is closed")

if __name__ == "__main__":
    create_database()
