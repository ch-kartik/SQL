-- Day 14 

CREATE TABLE orders_d14 (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  status VARCHAR(20)
);

INSERT INTO orders_d14 VALUES
(1,101,'2025-01-05',1200,'completed'),
(2,101,'2025-02-10',1800,'completed'),
(3,101,'2025-03-15',2000,'completed'),
(4,102,'2025-01-12',3000,'completed'),
(5,103,'2025-02-01',900,'completed'),
(6,103,'2025-02-20',1100,'completed'),
(7,104,'2025-01-25',1500,'completed'),
(8,104,'2025-03-10',1500,'completed'),
(9,105,'2025-03-05',4000,'completed');