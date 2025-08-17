import mysql.connector
from mysql.connector import Error

def create_database():
    try:
        # Connect to MySQL server
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='your_password'  # Replace with your actual password
        )

        if connection.is_connected():
            cursor = connection.cursor()
            # Create the database if it doesn't exist
            cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store")
            print("Database 'alx_book_store' created successfully!")

    except mysql.connector.Error as err:
        print(f"Error: Could not connect to MySQL server.\n{err}")

    finally:
        # Close cursor and connection if they were opened
        try:
            if cursor:
                cursor.close()
        except NameError:
            pass
        try:
            if connection and connection.is_connected():
                connection.close()
        except NameError:
            pass

if __name__ == "__main__":
    create_database()
