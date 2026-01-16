-- Day 25

CREATE TABLE customers_d25 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers_d25 VALUES
(1, 'Aarav', 'India'),
(2, 'Liam', 'USA'),
(3, 'Sophia', 'UK'),
(4, 'Noah', 'Germany'),
(5, 'Emma', 'Canada');

CREATE TABLE orders_d25 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d25(cust_id)
);

INSERT INTO orders_d25 VALUES
(101, 1, '2023-01-10', 200),
(102, 1, '2023-02-15', 300),
(103, 2, '2023-01-05', 500),
(104, 3, '2023-03-01', 150),
(105, 4, '2023-01-20', 400),
(106, 4, '2023-03-10', 450);