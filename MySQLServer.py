import mysql.connector
from mysql.connector import errorcode

def create_database():
    """
    Connects to the MySQL server and creates the 'alx_book_store' database.
    """
    try:
        # Establish a connection to the MySQL server
        cnx = mysql.connector.connect(
            host="localhost",
            user="your_username",  # Replace with your MySQL username
            password="your_password"  # Replace with your MySQL password
        )
        cursor = cnx.cursor()

        db_name = "alx_book_store"

        # SQL statement to create the database if it doesn't exist
        # 'IF NOT EXISTS' prevents the script from failing if the database already exists
        sql_statement = f"CREATE DATABASE IF NOT EXISTS {db_name}"

        # Execute the SQL statement
        cursor.execute(sql_statement)
        print(f"Database '{db_name}' created successfully!")

    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(f"Error: {err}")
    finally:
        # Close the cursor and the connection
        if 'cnx' in locals() and cnx.is_connected():
            cursor.close()
            cnx.close()
            print("MySQL connection is closed.")

if __name__ == "__main__":
    create_database()
