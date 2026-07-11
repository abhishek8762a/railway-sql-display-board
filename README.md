# Railway Station Display-Board System (SQL) 🚆

I was waiting at a railway station last week, just staring at the display board.
Trains coming, going, getting delayed, platforms changing every minute. And I
started wondering how this thing actually works behind the scenes.

So I tried building a small version of it in SQL. Nothing fancy — just enough
to understand it.

## The one idea I took away

When a train gets delayed, you don't go and update the board, the app and the
website separately. You keep the status in **one place**, and let all of them
read from it. Change it once, everything updates together.

That one table (`live_status`) is the single source of truth. That was the
whole lesson for me.

## The tables

- `stations` — list of stations (code, name, city, state)
- `train_master` — train details (number, name, source, destination)
- `train_schedule` — the planned timetable, each stop of each train
- `live_status` — live delays, status and platform (this is the important one)
- `platform_status` — which platform is busy right now

The display board is basically a JOIN across a few of these tables. No screen
keeps its own copy of the data.

## Files

- `schema.sql` — run this first, it builds the database + tables + data (MySQL)
- `queries.sql` — the display board query and the "update one row" demo
-  the raw data as CSV files if you want to import it somewhere else

## How to run

Open `schema.sql` in MySQL Workbench and hit run. It creates everything.
Then open `queries.sql` and run the queries one by one.

## The part I liked

Say Tamil Nadu Express is running late. I don't touch the whole database, I
just change one row:

```sql
UPDATE live_status
SET current_status = 'Delayed', delay_minutes = 60
WHERE train_id = (SELECT train_id FROM train_master WHERE train_number = '12621');
```

Run the display board query again and the delay is already there. One change,
and every screen reading that table is in sync.

## Then I got curious — how did this work before computers?

In my project I'm updating that row by hand. In the real system today, a GPS
device on every train sends its location every 30 seconds and a program updates
the row on its own.

And before GPS? A person in the control room updated a big paper chart by hand
as each station phoned in where the trains were. That chart was the single
source of truth back then.

Funny thing — the idea never really changed. Only who does the updating. A
station master became a GPS. A paper chart became a table.

---

Note: the data here is sample data I made up, using real Indian train and
station names, just to test the design.
