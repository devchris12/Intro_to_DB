-- This script prints the full description of the table 'books' from the specified database.
-- It retrieves information from the INFORMATION_SCHEMA.COLUMNS table.

SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_DEFAULT,
    EXTRA
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'alx_book_store' AND TABLE_NAME = 'Books';
