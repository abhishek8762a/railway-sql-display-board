-- ============================================================
--  RAILWAY DISPLAY-BOARD SYSTEM  --  MySQL (with foreign keys)
--  Poori file ek baar mein run karo.
-- ============================================================

CREATE DATABASE IF NOT EXISTS railway_system;
USE railway_system;

-- purani tables hata do (ulte order mein - child pehle)
DROP TABLE IF EXISTS platform_status;
DROP TABLE IF EXISTS live_status;
DROP TABLE IF EXISTS train_schedule;
DROP TABLE IF EXISTS train_master;
DROP TABLE IF EXISTS stations;

-- 1) STATIONS  (sabse pehle - ye kisi ko point nahi karti)
CREATE TABLE stations (
    station_id    INT PRIMARY KEY,
    station_code  VARCHAR(10) NOT NULL,
    station_name  VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    state         VARCHAR(50)
);

-- 2) TRAIN_MASTER  (stations ko point karti hai)
CREATE TABLE train_master (
    train_id          INT PRIMARY KEY,
    train_number      VARCHAR(10) NOT NULL,
    train_name        VARCHAR(100) NOT NULL,
    source_station_id INT,
    dest_station_id   INT,
    FOREIGN KEY (source_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (dest_station_id)   REFERENCES stations(station_id)
);

-- 3) TRAIN_SCHEDULE  (train_master + stations dono ko point karti hai)
CREATE TABLE train_schedule (
    schedule_id    INT PRIMARY KEY,
    train_id       INT,
    station_id     INT,
    stop_number    INT,
    arrival_time   VARCHAR(10),
    departure_time VARCHAR(10),
    day_number     INT,
    distance_km    INT,
    FOREIGN KEY (train_id)   REFERENCES train_master(train_id),
    FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

-- 4) LIVE_STATUS  (single source of truth)
CREATE TABLE live_status (
    live_id           INT PRIMARY KEY,
    train_id          INT,
    journey_date      VARCHAR(12),
    current_status    VARCHAR(30),
    delay_minutes     INT,
    expected_platform VARCHAR(10),
    last_updated      VARCHAR(30),
    FOREIGN KEY (train_id) REFERENCES train_master(train_id)
);

-- 5) PLATFORM_STATUS
CREATE TABLE platform_status (
    platform_id          INT PRIMARY KEY,
    station_id           INT,
    platform_number      INT,
    is_occupied          INT,
    occupied_by_train_id INT,
    occupied_till        VARCHAR(30),
    FOREIGN KEY (station_id)           REFERENCES stations(station_id),
    FOREIGN KEY (occupied_by_train_id) REFERENCES train_master(train_id)
);

-- ============================================================
--  DATA  (isi order mein daalo - parent pehle, child baad me)
-- ============================================================

INSERT INTO stations VALUES
(1,'NDLS','New Delhi','Delhi','Delhi'),
(2,'BCT','Mumbai Central','Mumbai','Maharashtra'),
(3,'HWH','Howrah Junction','Kolkata','West Bengal'),
(4,'MAS','Chennai Central','Chennai','Tamil Nadu'),
(5,'SBC','KSR Bengaluru','Bengaluru','Karnataka'),
(6,'JP','Jaipur Junction','Jaipur','Rajasthan'),
(7,'CNB','Kanpur Central','Kanpur','Uttar Pradesh'),
(8,'BPL','Bhopal Junction','Bhopal','Madhya Pradesh'),
(9,'NGP','Nagpur Junction','Nagpur','Maharashtra'),
(10,'ADI','Ahmedabad Junction','Ahmedabad','Gujarat'),
(11,'PNBE','Patna Junction','Patna','Bihar'),
(12,'LKO','Lucknow Charbagh','Lucknow','Uttar Pradesh');

INSERT INTO train_master VALUES
(1,'12951','Mumbai Rajdhani Express',1,2),
(2,'12301','Howrah Rajdhani Express',1,3),
(3,'12621','Tamil Nadu Express',1,4),
(4,'12627','Karnataka Express',1,5),
(5,'12958','Ahmedabad Rajdhani Express',1,10),
(6,'12309','Rajendra Nagar Rajdhani',1,11),
(7,'12002','Bhopal Shatabdi Express',1,8),
(8,'12004','Lucknow Shatabdi Express',1,12),
(9,'12956','Jaipur Rajdhani Express',1,6),
(10,'12034','Kanpur Shatabdi Express',1,7),
(11,'12809','Howrah Mumbai Mail',3,2),
(12,'12290','Mumbai Nagpur Express',2,9),
(13,'12615','Grand Trunk Express',1,4),
(14,'12139','Sewagram Express',9,2),
(15,'12471','Swaraj Express',2,1);

INSERT INTO train_schedule VALUES
(1,1,1,1,'-','16:25',1,0),
(2,1,6,2,'20:05','20:10',1,308),
(3,1,10,3,'05:30','05:40',2,1200),
(4,1,2,4,'08:15','-',2,1384),
(5,2,1,1,'-','16:50',1,0),
(6,2,7,2,'22:05','22:10',1,440),
(7,2,11,3,'04:00','04:10',2,999),
(8,2,3,4,'09:55','-',2,1451),
(9,3,1,1,'-','22:30',1,0),
(10,3,8,2,'07:10','07:15',2,707),
(11,3,9,3,'11:45','11:55',2,1092),
(12,3,4,4,'07:40','-',3,2175),
(13,7,1,1,'-','06:00',1,0),
(14,7,7,2,'10:15','10:17',1,440),
(15,7,8,3,'13:35','-',1,707),
(16,9,1,1,'-','19:55',1,0),
(17,9,6,2,'00:10','-',2,308),
(18,10,1,1,'-','06:10',1,0),
(19,10,7,2,'10:55','-',1,440);

INSERT INTO live_status VALUES
(1,1,'2026-07-10','On Time',0,'5','2026-07-10 15:40'),
(2,2,'2026-07-10','Delayed',20,'9','2026-07-10 15:41'),
(3,3,'2026-07-10','Delayed',45,'12','2026-07-10 15:39'),
(4,7,'2026-07-10','On Time',0,'1','2026-07-10 15:42'),
(5,9,'2026-07-10','Platform Change',0,'3','2026-07-10 15:38'),
(6,10,'2026-07-10','Departed',5,'2','2026-07-10 06:15');

INSERT INTO platform_status VALUES
(1,1,1,1,7,'2026-07-10 06:00'),
(2,1,2,0,NULL,NULL),
(3,1,3,1,9,'2026-07-10 20:00'),
(4,1,5,1,1,'2026-07-10 16:25'),
(5,1,9,1,2,'2026-07-10 17:10'),
(6,1,12,1,3,'2026-07-10 22:30'),
(7,1,6,0,NULL,NULL),
(8,1,7,0,NULL,NULL);
