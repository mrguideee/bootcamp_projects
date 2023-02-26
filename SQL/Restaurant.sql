-- Restaurant Owner (Focus On Wine)
-- 5 Tables
-- 1 Fact, 4 Dimension
-- search google how to add foreign key
-- write SQL 5 queries analyze data
-- 1 SubQuery and WITH

-- sqlite command
.mode markdown
.header ON

CREATE TABLE customer (
  	customer_id INT UNIQUE PRIMARY KEY,
  	name TEXT,
  	nationality TEXT,	
  	member TEXT
);

INSERT INTO customer VALUES
(1,'John ','USA','yes'),
(2,'Joseph','USA','yes'),
(3,'Leon','France','yes'),
(4,'Neo','Itlay','no'),
(5,'Alan','Itlaly','no'),
(6,'Percival','Australia','yes'),
(7,'Aqua','Thailand','no'),
(8,'Rimura','Japan','yes');

CREATE TABlE wine (
  	wine_id	INT UNIQUE PRIMARY KEY,
  	name TEXT,
  	Price REAL,
  	winetype_id INT,
    foreign key (winetype_id) references winetype(winetype_id)
  );
  
INSERT INTO wine VALUES
(1,'Airén',29,2),
(2,'Tempranillo',40,2),
(3,'Hermann',129,1),
(4,'Milahue',90,1),
(5,'Ramnista',30,2);

CREATE TABLE staff (
  staff_id INT UNIQUE PRIMARY KEY,
  name TEXT,
  Position TEXT
  );
  
INSERT INTO staff VALUES
(1,'Dear','Owner'),
(2,'Chi','Manager'),
(3,'Pae','Staff'),
(4,'Petch','Staff'),
(5,	'Fluke','Staff');

CREATE TABLE winetype (
  winetype_id INT PRIMARY KEY,
  name TEXT
);

INSERT INTO winetype VALUES
  (1,'Old World'),
  (2,'New World');

CREATE TABLE orders (
  	orders_id INT UNIQUE PRIMARY KEY,
  	order_date DATE,
  	wine_id INT,
  	customer_id INT,
  	staff_id INT,
    FOREIGN KEY (wine_id) REFERENCES wine(wine_id),
    FOREIGN KEY (customer_id) REFERENCES customer(wine_id)
  );
  
INSERT INTO orders VALUES
(1,'2022-06-12',3,3,4),
(2,'2022-06-12',1,1,4),
(3,'2022-06-12',5,6,4),
(4,'2022-06-14',3,8,4),
(5,'2022-06-14',1,2,5),
(6,'2022-06-14',1,3,3),
(7,'2022-06-15',2,1,5),
(8,'2022-06-15',4,6,4),
(9,'2022-06-16',5,5,4),
(10,'2022-06-17',2,8,5);

-- อยากรู้ว่าไวน์ประเภท New World ยอดขายเท่าไหร่
-- #1.Query / with
WITH wine_new_world AS(
  SELECT 
	a.name AS wine_type,
    b.price AS wine_price,
    c.orders_id
FROM winetype A
JOIN wine b ON a.winetype_id = b.winetype_id
JOIN orders c ON b.wine_id = c.wine_id
WHERE wine_type = 'New World'
)

SELECT 
	SUM(wine_price) AS 'Total Sale From Wine New World Type'
FROM wine_new_world;

--- อยากรู้ว่าชาติไหนซื้อไวน์เยอะที่สุด
-- #2
SELECT
customer_nation AS Nation,
COUNT(*) AS 'Buy Count'
FROM (
  SELECT 
	a.nationality AS customer_Nation
FROM customer a 
JOIN orders b ON a.customer_id = b.customer_id
) as sub
GROUP BY Nation
ORDER BY COUNT(*) DESC;

-- อยากรู้ว่าพนักงานคนไหนปิดยอดขายได้มากที่สุด
-- #3
SELECT
	name,
	SUM(price) AS Total_Sale
FROM 
(
  SELECT
	a.name,
  b.orders_id,
  c.price
FROM staff a
JOIN orders b ON a.staff_id = b.staff_id
JOIN wine c ON c.wine_id = b.wine_id
)
GROUP BY name
ORDER BY Total_Sale DESC;

-- อยากรู้ว่าวันไหนยอดขายดีที่สุด
-- #4
SELECT
	order_date,
	SUM(price) AS Price
FROM
(SELECT
	b.order_date,
	a.Price
FROM wine a 
JOIN orders b ON a.wine_id = b.wine_id)
GROUP BY order_date
ORDER BY Price DESC;

-- ระหว่าง Wine New World กับ Old World อันไหนขายออกบ่อยที่สุด
-- #5
SELECT
	name AS wine_type,
    COUNT(*) AS buy_count
FROM
(SELECT 
	a.name,
  c.orders_id
From winetype a
JOIN wine b ON a.winetype_id = b.winetype_id
JOIN orders c ON b.wine_id = c.wine_id)
GROUP BY name
ORDER BY buy_count DESC;
