CREATE TABLE customer (
  id int PRIMARY KEY,
  firstname text NOT NULL,
  lastname text NOT NULL,
  address text,
  email text,
  phone text
);

INSERT INTO customer(id, firstname, lastname, address, email, phone) VALUES
(1, 'Geri', 'Osbourn', '9253 Esch Point', 'gosbourn0@flickr.com', '556-895-1194'),
(2, 'Berky', 'Grigoriscu', '02856 Green Ridge Terrace', 'bgrigoriscu1@cnet.com', '731-939-2883'),
(3, 'Aharon', 'Morrid', '6 Pankratz Center', 'amorrid2@edublogs.org', '203-594-6860'),
(4, 'Corney', 'Easterfield', '82 Hoard Plaza', 'ceasterfield3@wisc.edu', '303-367-9251');

CREATE TABLE menu_head (
  id int PRIMARY KEY,
  menu_name text NOT NULL
);

INSERT INTO menu_head(id, menu_name) VALUES
  (1,"Double Cheeseburger"),
  (2,"Kimchi Fried Rice"),
  (3,"Ramen"),
  (4,"Fried Chicken"),
  (5,"Spagetthi"),
  (6,"Pizza");

CREATE TABLE menu_detail (
  id int PRIMARY KEY,
  size_dish text NOT NULL,
  price real NOT NULL,
  menu_id int NOT NULL,

  FOREIGN KEY (menu_id) REFERENCES menu_head(id)
);

INSERT INTO menu_detail(id, size_dish, price, menu_id) VALUES
  (1, "M", 100, 1),
  (2, "L", 150, 1),
  (3, "M", 120, 2),
  (4, "L", 160, 2),
  (5, "M", 90, 3),
  (6, "L", 110, 4),
  (7, "XL", 140, 4),
  (8, "M", 120, 5),
  (9, "L", 160, 5),
  (10, "L", 160, 6),
  (11, "XL", 200, 6);

CREATE TABLE payment_type (
  id int PRIMARY KEY,
  payment text NOT NULL
);

INSERT INTO payment_type(id,payment) VALUES 
  (1,"Cash"),
  (2,"Credit/Debit");

CREATE TABLE order_head (
  id int PRIMARY KEY,
  order_date date NOT NULL,
  customer_id int,
  payment_id int,

  FOREIGN KEY (customer_id) REFERENCES customer(id),
  FOREIGN KEY (payment_id) REFERENCES payment_type(id)
);

INSERT INTO order_head(id, order_date, customer_id, payment_id) VALUES 
  (1, "2022-10-01", 1, 1),
  (2, "2022-10-01", 2, 1),
  (3, "2022-10-02", 3, 2),
  (4, "2022-10-02", 4, 1),
  (5, "2022-10-05", 4, 2),
  (6, "2022-10-05", 1, 1),
  (7, "2022-10-05", 3, 1),
  (8, "2022-10-06", 2, 2),
  (9, "2022-10-07", 3, 2),
  (10, "2022-10-07", 1, 1);

CREATE TABLE order_detail (
  id int PRIMARY KEY,
  order_id int NOT NULL,
  menu_detail_id int NOT NULL,
  quantity int NOT NULL,

  FOREIGN KEY (order_id) REFERENCES order_head(id),
  FOREIGN KEY (menu_detail_id) REFERENCES menu_detail(id)
);

INSERT INTO order_detail(id, order_id, menu_detail_id, quantity) VALUES 
  (1, 1, 1, 2),
  (2, 1, 3, 1),
  (3, 1, 5, 1),
  (4, 2, 5, 2),
  (5, 3, 4, 1),
  (6, 3, 6, 2),
  (7, 4, 11, 1),
  (8, 5, 9, 2),
  (9, 5, 2, 1),
  (10, 6, 7, 1),
  (11, 6, 9, 1),
  (12, 7, 2, 1),
  (13, 8, 8, 2),
  (14, 9, 8, 1),
  (15, 10, 1, 1),
  (16, 10, 3, 1),
  (17, 10, 5, 1);


.mode markdown
.header on

.shell printf '\n\n\e[1;31mSQL Query\e[0m'
.shell printf '\n\n\e[1;32mSummarize daily income\e[0m \n'

SELECT h.order_date
,sum(d.quantity * md.price) total_price
FROM order_head h
JOIN order_detail d on d.order_id = h.id
JOIN menu_detail md on md.id = d.menu_detail_id
GROUP BY h.order_date
ORDER BY h.order_date;
  
.shell printf '\n\n\e[1;32mSummarize total price each customer\e[0m \n'

SELECT c.firstname || " " ||c.lastname customer_name
,sum(d.quantity * md.price) total_price
FROM order_head h
JOIN order_detail d on d.order_id = h.id
JOIN menu_detail md on md.id = d.menu_detail_id
JOIN customer c on c.id = h.customer_id
GROUP BY c.firstname || c.lastname
ORDER BY sum(d.quantity * md.price) DESC;


.shell printf '\n\n\e[1;32mWhich method of payment generates the greatest income\e[0m \n'

SELECT p.payment
,sum(d.quantity * md.price) total_price
FROM order_head h
JOIN order_detail d on d.order_id = h.id
JOIN menu_detail md on md.id = d.menu_detail_id
JOIN payment_type p on p.id = h.payment_id
GROUP BY p.payment
ORDER BY sum(d.quantity * md.price) DESC;

.shell printf '\n\n\e[1;32mShow All order transactions\e[0m \n'

WITH menus AS (
  SELECT md.id
  ,mh.menu_name
  ,md.size_dish
  ,md.price
  FROM menu_head mh
  JOIN menu_detail md ON md.menu_id = mh.id
),
orders AS (
  SELECT oh.id 
  ,od.id detail_id
  ,oh.order_date
  ,oh.customer_id
  ,od.menu_detail_id
  ,od.quantity
  FROM order_head oh
  JOIN order_detail od ON od.order_id = oh.id
)
  
SELECT ord.id 
,ord.order_date 
,cus.firstname || " " || cus.lastname customer_name
,menu.menu_name
,menu.size_dish
,menu.price
,ord.quantity
,menu.price * ord.quantity total
FROM customer cus
JOIN orders ord ON ord.customer_id = cus.id
JOIN menus menu ON menu.id = ord.menu_detail_id;