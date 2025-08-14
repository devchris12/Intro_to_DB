-- =============================================
-- ALX Book Store Database Schema
-- =============================================

-- Create the database
CREATE DATABASE IF NOT EXISTS alx_book_store;
USE alx_book_store;

-- =============================================
-- Table: Authors
-- Stores information about book authors
-- =============================================
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(215) NOT NULL
);

-- =============================================
-- Table: Customers  
-- Stores information about bookstore customers
-- =============================================
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(215) NOT NULL,
    email VARCHAR(215) UNIQUE NOT NULL,
    address TEXT
);

-- =============================================
-- Table: Books
-- Stores information about books available in the bookstore
-- =============================================
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(130) NOT NULL,
    author_id INT NOT NULL,
    price DOUBLE NOT NULL CHECK (price >= 0),
    publication_date DATE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =============================================
-- Table: Orders
-- Stores information about orders placed by customers
-- =============================================
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =============================================
-- Table: Order_Details
-- Stores information about books included in each order
-- =============================================
CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity DOUBLE NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY unique_order_book (order_id, book_id)
);

-- =============================================
-- Sample Data Insertion
-- =============================================

-- Insert sample authors
INSERT INTO Authors (author_name) VALUES 
('J.K. Rowling'),
('Stephen King'),
('Agatha Christie'),
('George Orwell'),
('Jane Austen'),
('Mark Twain'),
('Ernest Hemingway'),
('Maya Angelou'),
('Toni Morrison'),
('Gabriel García Márquez');

-- Insert sample customers
INSERT INTO Customers (customer_name, email, address) VALUES 
('Alice Johnson', 'alice.johnson@email.com', '123 Main Street, New York, NY 10001'),
('Bob Smith', 'bob.smith@email.com', '456 Oak Avenue, Los Angeles, CA 90210'),
('Carol Davis', 'carol.davis@email.com', '789 Pine Road, Chicago, IL 60601'),
('David Wilson', 'david.wilson@email.com', '321 Elm Street, Houston, TX 77001'),
('Eva Brown', 'eva.brown@email.com', '654 Maple Lane, Phoenix, AZ 85001');

-- Insert sample books
INSERT INTO Books (title, author_id, price, publication_date) VALUES 
('Harry Potter and the Philosopher''s Stone', 1, 25.99, '1997-06-26'),
('Harry Potter and the Chamber of Secrets', 1, 27.99, '1998-07-02'),
('The Shining', 2, 22.50, '1977-01-28'),
('It', 2, 24.99, '1986-09-15'),
('Murder on the Orient Express', 3, 18.99, '1934-01-01'),
('And Then There Were None', 3, 19.99, '1939-11-06'),
('1984', 4, 21.50, '1949-06-08'),
('Animal Farm', 4, 16.99, '1945-08-17'),
('Pride and Prejudice', 5, 15.99, '1813-01-28'),
('Sense and Sensibility', 5, 17.50, '1811-10-30'),
('The Adventures of Tom Sawyer', 6, 14.99, '1876-12-01'),
('The Old Man and the Sea', 7, 13.99, '1952-09-01'),
('I Know Why the Caged Bird Sings', 8, 16.50, '1969-01-01'),
('Beloved', 9, 23.99, '1987-09-02'),
('One Hundred Years of Solitude', 10, 26.99, '1967-06-05');

-- Insert sample orders
INSERT INTO Orders (customer_id, order_date) VALUES 
(1, '2024-01-15'),
(2, '2024-01-16'),
(3, '2024-01-17'),
(1, '2024-01-20'),
(4, '2024-01-22'),
(5, '2024-01-25'),
(2, '2024-02-01'),
(3, '2024-02-03');

-- Insert sample order details
INSERT INTO Order_Details (order_id, book_id, quantity) VALUES 
-- Order 1 (Alice's first order)
(1, 1, 2),
(1, 7, 1),
-- Order 2 (Bob's first order)
(2, 3, 1),
(2, 5, 2),
(2, 9, 1),
-- Order 3 (Carol's first order)  
(3, 2, 1),
(3, 4, 1),
-- Order 4 (Alice's second order)
(4, 10, 3),
(4, 12, 1),
-- Order 5 (David's order)
(5, 6, 2),
(5, 8, 1),
(5, 11, 1),
-- Order 6 (Eva's order)
(6, 13, 1),
(6, 14, 1),
(6, 15, 2),
-- Order 7 (Bob's second order)
(7, 1, 1),
(7, 9, 1),
-- Order 8 (Carol's second order)
(8, 7, 2),
(8, 12, 1);

-- =============================================
-- Useful Views for Common Queries
-- =============================================

-- View: Complete book information with author names
CREATE VIEW BookDetails AS
SELECT 
    b.book_id,
    b.title,
    a.author_name,
    b.price,
    b.publication_date
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

-- View: Order summary with customer information
CREATE VIEW OrderSummary AS
SELECT 
    o.order_id,
    c.customer_name,
    c.email,
    o.order_date,
    COUNT(od.book_id) AS total_books,
    SUM(od.quantity * b.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Books b ON od.book_id = b.book_id
GROUP BY o.order_id, c.customer_name, c.email, o.order_date;

-- =============================================
-- Indexes for Better Performance
-- =============================================

-- Index on Books title for search functionality
CREATE INDEX idx_book_title ON Books(title);

-- Index on Customers email for login functionality
CREATE INDEX idx_customer_email ON Customers(email);

-- Index on Orders order_date for date-based queries
CREATE INDEX idx_order_date ON Orders(order_date);

-- =============================================
-- Sample Queries to Test the Database
-- =============================================

-- Query 1: Find all books by a specific author
-- SELECT * FROM BookDetails WHERE author_name = 'J.K. Rowling';

-- Query 2: Get order summary for all orders
-- SELECT * FROM OrderSummary ORDER BY order_date DESC;

-- Query 3: Find the most popular books (by quantity sold)
-- SELECT 
--     b.title, 
--     a.author_name, 
--     SUM(od.quantity) AS total_sold
-- FROM Order_Details od
-- JOIN Books b ON od.book_id = b.book_id
-- JOIN Authors a ON b.author_id = a.author_id
-- GROUP BY b.book_id, b.title, a.author_name
-- ORDER BY total_sold DESC;

-- Query 4: Find customers who have placed multiple orders
-- SELECT 
--     c.customer_name, 
--     c.email, 
--     COUNT(o.order_id) AS order_count
-- FROM Customers c
-- JOIN Orders o ON c.customer_id = o.customer_id
-- GROUP BY c.customer_id, c.customer_name, c.email
-- HAVING order_count > 1;

-- =============================================
-- Database Schema Complete!
-- =============================================
