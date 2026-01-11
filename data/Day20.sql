-- Day 20 

CREATE TABLE customers_d20 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    country VARCHAR(30),
    signup_date DATE
);

INSERT INTO customers_d20 VALUES
(1, 'Aarav', 'India', '2024-01-10'),
(2, 'Emily', 'USA', '2024-01-15'),
(3, 'Liam', 'UK', '2024-02-01'),
(4, 'Sophia', 'Germany', '2024-02-05'),
(5, 'Noah', 'India', '2024-02-20'),
(6, 'Olivia', 'USA', '2024-03-01');

CREATE TABLE orders_d20 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    FOREIGN KEY (cust_id) REFERENCES customers_d20(cust_id)
);

INSERT INTO orders_d20 VALUES
(101, 1, '2024-02-01', 120.00),
(102, 1, '2024-02-10', 80.00),
(103, 2, '2024-02-05', 300.00),
(104, 2, '2024-03-01', 250.00),
(105, 2, '2024-03-15', 450.00),
(106, 3, '2024-02-20', 90.00),
(107, 4, '2024-03-05', 500.00),
(108, 4, '2024-03-18', 700.00),
(109, 5, '2024-03-22', 60.00),
(110, 6, '2024-03-25', 1000.00);