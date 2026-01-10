-- Day 19

CREATE TABLE customers_d19 (
  cust_id INT PRIMARY KEY,
  signup_date DATE,
  channel VARCHAR(20)
);

INSERT INTO customers_d19 VALUES
(1,'2024-01-05','Organic'),
(2,'2024-01-20','Paid'),
(3,'2024-02-10','Referral'),
(4,'2024-03-01','Organic'),
(5,'2024-03-15','Paid');

CREATE TABLE orders_d19 (
  order_id INT,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  FOREIGN KEY (cust_id) REFERENCES customers_d19(cust_id)
);

INSERT INTO orders_d19 VALUES
(1,1,'2024-01-10',1000),
(2,1,'2024-02-12',1500),
(3,1,'2024-03-15',2000),
(4,2,'2024-01-25',3000),
(5,3,'2024-02-15',1200),
(6,3,'2024-03-20',1800),
(7,4,'2024-03-18',900),
(8,5,'2024-03-25',2500);