-- Day - 9

CREATE TABLE customers_d9 (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(50),
  signup_date DATE
);

INSERT INTO customers_d9 VALUES
(1, 'Amit', '2024-01-10'),
(2, 'Riya', '2024-01-15'),
(3, 'John', '2024-02-01'),
(4, 'Sara', '2024-02-10');

CREATE TABLE orders_d9 (
  order_id INT,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  status VARCHAR(20),
  FOREIGN KEY (cust_id) REFERENCES customers_d9(cust_id)
);

INSERT INTO orders_d9 VALUES
(101, 1, '2024-02-01', 3000, 'completed'),
(102, 1, '2024-02-10', 4000, 'completed'),
(103, 2, '2024-02-15', 12000, 'completed'),
(104, 3, '2024-02-20', 2000, 'cancelled'),
(105, 3, '2024-02-25', 3000, 'completed');
