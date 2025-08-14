-- Script to print the full description of the books table from alx_book_store database
-- Using INFORMATION_SCHEMA to get table structure without DESCRIBE or EXPLAIN

SELECT 
    COLUMN_NAME AS 'Field',
    COLUMN_TYPE AS 'Type',
    IS_NULLABLE AS 'Null',
    COLUMN_KEY AS 'Key',
    COLUMN_DEFAULT AS 'Default',
    EXTRA AS 'Extra'
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_SCHEMA = 'alx_book_store' 
    AND TABLE_NAME = 'books'
ORDER BY 
    ORDINAL_POSITION;
