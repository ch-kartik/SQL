-- Day 41

CREATE TABLE customers_d41 (
  cust_id INT PRIMARY KEY,
  signup_date DATE,
  country VARCHAR(20)
);

INSERT INTO customers_d41 VALUES
(1, '2022-12-15', 'India'),
(2, '2022-11-10', 'India'),
(3, '2023-01-05', 'USA'),
(4, '2023-02-20', 'UK');

CREATE TABLE subscriptions_d41 (
  subs_id INT PRIMARY KEY,
  cust_id INT,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (cust_id) REFERENCES customers_d41(cust_id)
);

INSERT INTO subscriptions_d41 VALUES
(101, 1, '2023-01-01', NULL),
(102, 2, '2023-01-01', '2023-03-15'),
(103, 3, '2023-02-01', NULL),
(104, 4, '2023-03-01', NULL);

CREATE TABLE payments_d41 (
  payment_id INT PRIMARY KEY,
  cust_id INT,
  payment_date DATE,
  amount INT,
  FOREIGN KEY (cust_id) REFERENCES customers_d41(cust_id)
);

INSERT INTO payments_d41 VALUES
(1, 1, '2023-01-05', 100),
(2, 1, '2023-02-05', 150),
(3, 1, '2023-03-05', 120),
(4, 2, '2023-01-05', 200),
(5, 2, '2023-02-05', 180),
(6, 3, '2023-02-10', 300),
(7, 3, '2023-03-10', 300),
(8, 4, '2023-03-15', 250);
