-- Day 35

CREATE TABLE customers_d35 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d35 VALUES
(1, '2023-01-05'),
(2, '2023-01-20'),
(3, '2023-02-10'),
(4, '2023-02-25');

CREATE TABLE orders_d35 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d35(cust_id)
);

INSERT INTO orders_d35 VALUES
(201,1,'2023-01-10',200),
(202,1,'2023-02-12',250),
(203,1,'2023-03-15',150),
(204,2,'2023-01-25',300),
(205,2,'2023-02-28',100),
(206,3,'2023-02-15',400),
(207,3,'2023-03-20',50),
(208,4,'2023-02-28',500);