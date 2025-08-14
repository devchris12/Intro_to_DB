#!/usr/bin/env python3
"""
MySQLServer.py - ALX Book Store Database Creation Script

This script creates the 'alx_book_store' database in MySQL server.
It handles connection errors gracefully and ensures proper database management.

Requirements:
- mysql-connector-python package
- MySQL server running
- Proper MySQL credentials

Author: ALX Student
Date: 2024
"""

import mysql.connector
from mysql.connector import Error
import sys


def create_database():
    """
    Creates the alx_book_store database in MySQL server.
    
    Returns:
        bool: True if database creation is successful, False otherwise
    """
    connection = None
    cursor = None
    
    try:
        # Database connection parameters
        # Note: Update these credentials according to your MySQL setup
        connection_config = {
            'host': 'localhost',
            'user': 'root',          # Update with your MySQL username
            'password': '',          # Update with your MySQL password
            'port': 3306,           # Default MySQL port
            'autocommit': True      # Enable autocommit for DDL statements
        }
        
        print("Attempting to connect to MySQL server...")
        
        # Establish connection to MySQL server
        connection = mysql.connector.connect(**connection_config)
        
        if connection.is_connected():
            print("Successfully connected to MySQL server!")
            
            # Create cursor object
            cursor = connection.cursor()
            
            # SQL command to create database if it doesn't exist
            create_db_query = "CREATE DATABASE IF NOT EXISTS alx_book_store"
            
            # Execute the database creation command
            cursor.execute(create_db_query)
            
            print("Database 'alx_book_store' created successfully!")
            return True
            
    except Error as e:
        # Handle MySQL connection and execution errors
        error_code = e.errno if hasattr(e, 'errno') else 'Unknown'
        error_msg = str(e)
        
        print(f"Error connecting to MySQL server:")
        print(f"Error Code: {error_code}")
        print(f"Error Message: {error_msg}")
        
        # Specific error handling for common issues
        if "Access denied" in error_msg:
            print("Please check your username and password.")
        elif "Can't connect to MySQL server" in error_msg:
            print("Please ensure MySQL server is running and accessible.")
        elif "Unknown database" in error_msg:
            print("Database connection issue occurred.")
        
        return False
        
    except Exception as e:
        # Handle any other unexpected errors
        print(f"An unexpected error occurred: {str(e)}")
        return False
        
    finally:
        # Ensure proper cleanup of database resources
        try:
            if cursor:
                cursor.close()
                print("Database cursor closed.")
                
            if connection and connection.is_connected():
                connection.close()
                print("MySQL connection closed.")
                
        except Error as cleanup_error:
            print(f"Error during cleanup: {str(cleanup_error)}")


def verify_mysql_connector():
    """
    Verifies that mysql-connector-python is properly installed.
    
    Returns:
        bool: True if package is available, False otherwise
    """
    try:
        import mysql.connector
        print(f"MySQL Connector version: {mysql.connector.__version__}")
        return True
    except ImportError:
        print("Error: mysql-connector-python package is not installed.")
        print("Please install it using: pip install mysql-connector-python")
        return False


def main():
    """
    Main function that orchestrates the database creation process.
    """
    print("=" * 60)
    print("ALX Book Store Database Creation Script")
    print("=" * 60)
    
    # Verify MySQL connector is available
    if not verify_mysql_connector():
        sys.exit(1)
    
    # Attempt to create the database
    success = create_database()
    
    print("=" * 60)
    if success:
        print("Script execution completed successfully!")
        print("Database 'alx_book_store' is ready for use.")
        sys.exit(0)
    else:
        print("Script execution failed!")
        print("Please check the error messages above and try again.")
        sys.exit(1)


if __name__ == "__main__":
    main()