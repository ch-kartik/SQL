-- Day 29

CREATE TABLE customers_d29 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50)
);

INSERT INTO customers_d29 VALUES
(1, 'Aarav'),
(2, 'Neha'),
(3, 'Rohan'),
(4, 'Priya');

CREATE TABLE orders_d29 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d29(cust_id)
);

INSERT INTO orders_d29 VALUES
(101, 1, '2023-01-10', 500),
(102, 1, '2023-02-15', 700),
(103, 1, '2023-03-10', 600),
(104, 2, '2023-01-05', 300),
(105, 3, '2023-02-20', 400),
(106, 3, '2023-03-18', 450),
(107, 4, '2023-01-25', 800);