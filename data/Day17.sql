-- Day 17

CREATE TABLE customers_d17 (
  cust_id INT PRIMARY KEY,
  signup_date DATE,
  channel VARCHAR(20)
);

INSERT INTO customers_d17 VALUES
(1,'2024-01-05','Organic'),
(2,'2024-01-10','Ads'),
(3,'2024-02-01','Referral'),
(4,'2024-02-15','Organic'),
(5,'2024-03-01','Ads'),
(6,'2024-03-05','Referral');

CREATE TABLE orders_d17 (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  status VARCHAR(20),
  FOREIGN KEY (cust_id) REFERENCES customers_d17(cust_id)
);

INSERT INTO orders_d17 VALUES
(101,1,'2024-01-10',1200,'completed'),
(102,1,'2024-02-12',1500,'completed'),
(103,1,'2024-04-01',1800,'completed'),
(104,2,'2024-01-20',900,'completed'),
(105,3,'2024-02-05',2000,'completed'),
(106,3,'2024-03-10',2200,'completed'),
(107,4,'2024-02-20',1100,'completed'),
(108,5,'2024-03-10',3000,'completed'),
(109,5,'2024-05-01',3200,'completed'),
(110,6,'2024-03-15',1400,'completed');