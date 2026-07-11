-- ============================================================
--  EXAMPLE QUERIES  (run after schema.sql)
-- ============================================================
USE railway_system;

-- Q1) THE DISPLAY BOARD at New Delhi.
--     The board, app and website all run a query like this
--     against the SAME tables. Nobody keeps their own copy.
SELECT t.train_number       AS 'Train No',
       t.train_name         AS 'Train',
       s.station_name       AS 'Destination',
       sc.departure_time    AS 'Departure',
       ls.current_status    AS 'Status',
       ls.delay_minutes     AS 'Delay (min)',
       ls.expected_platform AS 'Platform'
FROM train_schedule sc
JOIN train_master   t  ON t.train_id   = sc.train_id
JOIN stations       s  ON s.station_id = t.dest_station_id
LEFT JOIN live_status ls ON ls.train_id = sc.train_id
WHERE sc.station_id = 1          -- New Delhi
  AND sc.departure_time <> '-'   -- trains that depart from here
ORDER BY sc.departure_time;


-- Q2) THE KEY IDEA — one train gets delayed.
--     Update ONE row in the source of truth (live_status).
--     Re-run Q1 and the whole board reflects it.
UPDATE live_status
SET current_status = 'Delayed', delay_minutes = 60
WHERE train_id = (SELECT train_id FROM train_master WHERE train_number = '12621');


-- Q3) Which platforms are free right now at New Delhi?
SELECT platform_number,
       CASE WHEN is_occupied = 1 THEN 'Occupied' ELSE 'Free' END AS status
FROM platform_status
WHERE station_id = 1
ORDER BY platform_number;


-- Q4) Only the delayed trains (what an alerts job would read).
SELECT t.train_number, t.train_name, ls.delay_minutes, ls.expected_platform
FROM live_status ls
JOIN train_master t ON t.train_id = ls.train_id
WHERE ls.current_status = 'Delayed'
ORDER BY ls.delay_minutes DESC;
