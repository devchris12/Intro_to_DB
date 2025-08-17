# MySQLServer.py
import mysql.connector
import os

# Check if the file exists and is not empty
def check_file_exists_and_not_empty(file_path):
    if os.path.exists(file_path):
        if os.path.getsize(file_path) > 0:
            print(f"File {file_path} exists and is not empty.")
        else:
            print(f"File {file_path} exists but is empty.")
            return False
    else:
        print(f"File {file_path} does not exist.")
        return False
    return True

# Create database and handle exceptions
def create_database():
    try:
        # Establish connection to MySQL server
        connection = mysql.connector.connect(
            host="localhost",  # Your MySQL host (localhost in this case)
            user="root",       # Your MySQL username
            password="password" # Your MySQL password
        )

        cursor = connection.cursor()

        # Check if the database already exists
        cursor.execute("SHOW DATABASES LIKE 'alx_book_store'")
        result = cursor.fetchone()

        if result:
            print("Database 'alx_book_store' already exists.")
        else:
            # Create the database if it doesn't exist
            cursor.execute("CREATE DATABASE alx_book_store")
            print("Database 'alx_book_store' created successfully!")

        # Close the cursor and connection
        cursor.close()
        connection.close()

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return False
    return True

# Run checks and actions
if __name__ == "__main__":
    # Check if the file task_4.sql exists and is not empty
    file_path = "task_4.sql"
    if check_file_exists_and_not_empty(file_path):
        # Create the database if it doesn't exist
        create_database()
    else:
        print("Please ensure the file exists and is not empty.")
