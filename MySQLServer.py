import os

def check_script(file_path):
    # Check if the file exists and is not empty
    if not os.path.isfile(file_path) or os.path.getsize(file_path) == 0:
        print("File does not exist or is empty.")
        return

    with open(file_path, 'r') as file:
        content = file.read()

    # Check for the import statement for mysql.connector
    if 'import mysql.connector' not in content:
        print("The script does not contain the import statement for mysql.connector.")
    
    # Check for the CREATE DATABASE statement for alxbookstore
    if 'CREATE DATABASE alxbookstore' not in content:
        print("The script does not contain the CREATE DATABASE statement for alxbookstore.")
    
    # Check for the code to establish a connection to the MySQL server
    if 'mysql.connector.connect' not in content:
        print("The script does not contain the code to establish a connection to the MySQL server.")
    
    # Check for the code to handle exceptions
    if 'try:' not in content or 'except' not in content:
        print("The script does not contain the code to handle exceptions.")
    
    # Check if the student did not use the SELECT or SHOW statements
    if 'SELECT' in content or 'SHOW' in content:
        print("The script contains SELECT or SHOW statements.")

# Example usage
check_script('your_script.sql')
