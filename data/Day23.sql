-- Day 23 

CREATE TABLE funnel_events_d23 (
    user_id INT,
    event_date DATE,
    event_type VARCHAR(50)
);

INSERT INTO funnel_events_d23 VALUES
(1, '2025-01-01', 'visit'),
(1, '2025-01-01', 'signup'),
(1, '2025-01-02', 'trial'),
(1, '2025-01-05', 'purchase'),
(2, '2025-01-01', 'visit'),
(2, '2025-01-02', 'signup'),
(3, '2025-01-02', 'visit'),
(4, '2025-01-03', 'visit'),
(4, '2025-01-03', 'signup'),
(4, '2025-01-04', 'trial'),
(5, '2025-01-04', 'visit'),
(5, '2025-01-05', 'signup'),
(5, '2025-01-06', 'trial'),
(5, '2025-01-07', 'purchase');
