-- Day 16

CREATE TABLE customers_d16 (
  cust_id INT PRIMARY KEY,
  signup_date DATE,
  channel VARCHAR(20)
);

INSERT INTO customers_d16 VALUES
(1,'2025-01-05','Ads'),
(2,'2025-01-10','Organic'),
(3,'2025-02-01','Referral'),
(4,'2025-02-05','Ads'),
(5,'2025-03-01','Organic');

CREATE TABLE orders_d16 (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  status VARCHAR(20),
  FOREIGN KEY (cust_id) REFERENCES customers_d16(cust_id)
);

INSERT INTO orders_d16 VALUES
(101,1,'2025-01-10',1200,'completed'),
(102,1,'2025-02-15',1500,'completed'),
(103,1,'2025-03-20',1800,'completed'),
(104,2,'2025-01-20',800,'completed'),
(105,2,'2025-01-28',900,'completed'),
(106,3,'2025-02-10',2000,'completed'),
(107,3,'2025-03-05',2200,'completed'),
(108,4,'2025-02-18',700,'completed'),
(109,5,'2025-03-10',3000,'completed');