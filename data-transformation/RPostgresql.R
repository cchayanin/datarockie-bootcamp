#### RPostgreSQL ####
### install.packages("RPostgreSQL")
library(tidyverse)
library(RPostgreSQL)

### create connection
conn <- dbConnect(
    PostgreSQL(),
    host = "host",
    dbname = "dbname",
    port = portno,
    user = "user",
    password = "password"
)

### list Table
dbListTables(conn)

### create dataframe
students <- data.frame(id = 1:5,
                       student_name = c("Lisa", "Jisoo", "Rose", "Jenny", "Milli"))

### create table from dataframe
dbWriteTable(conn, "students", students, row.names = FALSE)
dbListTables(conn)


### get data from students table
student_df <- dbGetQuery(conn, "SELECT * FROM students")

### delete table
dbRemoveTable(conn, "students")
dbListTables(conn)

### close connection
dbDisconnect(conn)


### create connection by get values from .Renviron ####
Renviron_file <- "./.Renviron"
readRenviron(Renviron_file)
conn <- dbConnect(
    PostgreSQL(),
    host = Sys.getenv("host"),
    dbname = Sys.getenv("dbname"),
    port = Sys.getenv("port"),
    user = Sys.getenv("dbname"),
    password = Sys.getenv("password")
)

### create table from sql
sql <- read_file("restaurant.sql")
dbSendQuery(conn, sql)
dbListTables(conn)

### get data from students table
ct_df <- dbGetQuery(conn, "SELECT * FROM customer")
mh_df <- dbGetQuery(conn, "SELECT * FROM menu_head")
md_df <- dbGetQuery(conn, "SELECT * FROM menu_detail")
pt_df <- dbGetQuery(conn, "SELECT * FROM payment_type")
oh_df <- dbGetQuery(conn, "SELECT * FROM order_head")
od_df <- dbGetQuery(conn, "SELECT * FROM order_detail")

### Query from HW-SQL
## Summarize daily income
oh_df |>
    left_join(od_df, by = c("id" = "order_id")) |>
    left_join(md_df, by = c("menu_detail_id" = "id")) |>
    group_by(order_date) |>
    summarize(total_price = sum(quantity * price))

## Summarize total price each customer
oh_df |>
    left_join(od_df, by = c("id" = "order_id")) |>
    left_join(md_df, by = c("menu_detail_id" = "id")) |>
    left_join(ct_df, by = c("customer_id" = "id")) |>
    mutate(customer_name = paste(firstname, lastname),
           total_price = quantity * price) |>
    group_by(customer_name) |>
    summarise(total_price = sum(total_price)) |>
    arrange(desc(total_price))

## Which method of payment generates the greatest income
oh_df |>
    left_join(od_df, by = c("id" = "order_id")) |>
    left_join(md_df, by = c("menu_detail_id" = "id")) |>
    left_join(pt_df, by = c("payment_id" = "id")) |>
    mutate(total_price = quantity * price) |>
    group_by(payment) |>
    summarise(total_price = sum(total_price)) |>
    arrange(desc(total_price))

## Show All order transactions
menu_df <- mh_df |>
    left_join(md_df, by = c("id" = "menu_id")) |>
    select(id = id.y, menu_name, size_dish, price)

order_df <- oh_df |>
    left_join(od_df, by = c("id" = "order_id"))

ct_df |>
    left_join(order_df, by = c("id" = "customer_id")) |>
    left_join(menu_df, by = c("menu_detail_id" = "id")) |>
    mutate(customer_name = paste(firstname, lastname),
           total_price = price * quantity)

dbRemoveTable(conn, "order_detail")
dbRemoveTable(conn, "order_head")
dbRemoveTable(conn, "payment_type")
dbRemoveTable(conn, "customer")
dbRemoveTable(conn, "menu_detail")
dbRemoveTable(conn, "menu_head")

dbListTables(conn)

dbDisconnect(conn)
