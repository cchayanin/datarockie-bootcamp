CREATE TABLE IF NOT EXISTS "customer" (
  "id" int PRIMARY KEY,
  "firstname" text NOT NULL,
  "lastname" text NOT NULL,
  "address" text,
  "email" text,
  "phone" text
);

CREATE TABLE IF NOT EXISTS "menu_head" (
  "id" int PRIMARY KEY,
  "menu_name" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "menu_detail" (
  "id" int PRIMARY KEY,
  "size_dish" text NOT NULL,
  "price" real NOT NULL,
  "menu_id" int NOT NULL
);

CREATE TABLE IF NOT EXISTS "payment_type" (
  "id" int PRIMARY KEY,
  "payment" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "order_head" (
  "id" int PRIMARY KEY,
  "order_date" date NOT NULL,
  "customer_id" int NOT NULL,
  "payment_id" int NOT NULL
);

CREATE TABLE IF NOT EXISTS "order_detail" (
  "id" int PRIMARY KEY,
  "order_id" int NOT NULL,
  "menu_detail_id" int NOT NULL,
  "quantity" int NOT NULL
);

ALTER TABLE "menu_detail" ADD FOREIGN KEY ("menu_id") REFERENCES "menu_head" ("id");

ALTER TABLE "order_head" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("id");

ALTER TABLE "order_head" ADD FOREIGN KEY ("payment_id") REFERENCES "payment_type" ("id");

ALTER TABLE "order_detail" ADD FOREIGN KEY ("order_id") REFERENCES "order_head" ("id");

ALTER TABLE "order_detail" ADD FOREIGN KEY ("menu_detail_id") REFERENCES "menu_detail" ("id");

INSERT INTO customer(id, firstname, lastname, address, email, phone) VALUES
(1, 'Geri', 'Osbourn', '9253 Esch Point', 'gosbourn0@flickr.com', '556-895-1194'),
(2, 'Berky', 'Grigoriscu', '02856 Green Ridge Terrace', 'bgrigoriscu1@cnet.com', '731-939-2883'),
(3, 'Aharon', 'Morrid', '6 Pankratz Center', 'amorrid2@edublogs.org', '203-594-6860'),
(4, 'Corney', 'Easterfield', '82 Hoard Plaza', 'ceasterfield3@wisc.edu', '303-367-9251');


INSERT INTO menu_head(id, menu_name) VALUES
  (1,'Double Cheeseburger'),
  (2,'Kimchi Fried Rice'),
  (3,'Ramen'),
  (4,'Fried Chicken'),
  (5,'Spagetthi'),
  (6,'Pizza');
  
INSERT INTO menu_detail(id, size_dish, price, menu_id) VALUES
  (1, 'M', 100, 1),
  (2, 'L', 150, 1),
  (3, 'M', 120, 2),
  (4, 'L', 160, 2),
  (5, 'M', 90, 3),
  (6, 'L', 110, 4),
  (7, 'XL', 140, 4),
  (8, 'M', 120, 5),
  (9, 'L', 160, 5),
  (10, 'L', 160, 6),
  (11, 'XL', 200, 6);

INSERT INTO payment_type(id,payment) VALUES 
  (1,'Cash'),
  (2,'Credit/Debit');
  
INSERT INTO order_head(id, order_date, customer_id, payment_id) VALUES 
  (1, '2022-10-01', 1, 1),
  (2, '2022-10-01', 2, 1),
  (3, '2022-10-02', 3, 2),
  (4, '2022-10-02', 4, 1),
  (5, '2022-10-05', 4, 2),
  (6, '2022-10-05', 1, 1),
  (7, '2022-10-05', 3, 1),
  (8, '2022-10-06', 2, 2),
  (9, '2022-10-07', 3, 2),
  (10, '2022-10-07', 1, 1);
  
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
  
