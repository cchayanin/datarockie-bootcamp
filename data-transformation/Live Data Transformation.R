# install.packages(c("tidyverse", "glue", "sqldf", "jsonlite", "RSQLite", "rvest"))

#### Glue ####
library(glue)
my_name <- "Toy"
my_fav_food <- "Hamburger"

text <-
  glue("Hello my name is {my_name}, my favorite food is {my_fav_food}!")

library(tidyverse)
#### data transformation 101
### package dplyr
## data() - built-in data frame
## select, filter, mutate, arrange, summarize
mtcars |>
  rownames_to_column() |>
  rename(model = rowname) |>
  tibble()

### Preview Data frame
head(mtcars)
tail(mtcars)
glimpse(mtcars)
str(mtcars)


### Pipe Operator %>%
head(mtcars)

mtcars %>%
  head() %>%
  summarize(mean(mpg))

### Native Pipe |> requires R 4.1+
mtcars |>
  head()


### Summary
mtcars |>
  summary()


#### Prep Data ####
df <- mtcars |>
  rownames_to_column() |>
  tibble()


### select/rename ####
## by column name
df |>
  select(mpg, hp, wt, am)

## by position
df |>
  select(1:3, 5)

## mix column and position
df |>
  select(1:3, 5, am)

## select as alias name
df |>
  select(milePerGallon = mpg,
         horsePower = hp,
         weight = wt)

## rename
df <- df |>
  rename(model = rowname)


## select column starts_with
df |>
  select(starts_with("a"), 1:3)

## select column ends_with
df |>
  select(ends_with("p"))

## select column contains
df |>
  select(contains("a"))


### Filter ####
result <- df |>
  select(model, mpg, wt, hp, am) |>
  filter(mpg > 30)

## write csv
write_csv(result, "result.csv")

## filter and
df |>
  select(model, mpg, wt, hp, am) |>
  filter(mpg < 30, hp > 150)

df |>
  select(model, mpg, wt, hp, am) |>
  filter(mpg < 30 & hp > 150)

## filter or
df |>
  select(model, mpg, wt, hp, am) |>
  filter(mpg < 30 | hp > 150)


## filter between
df |>
  select(model, mpg, wt, hp, am) |>
  filter(mpg >= 20, mpg <= 30)

df |>
  select(model, mpg, wt, hp, am) |>
  filter(between(mpg, 20, 30))

# distinct
df |>
  distinct(gear)

## filter in
df |>
  select(model, gear) |>
  filter(gear %in% c(3, 5))

## filter equal ,not equal
mtcars_tibble |>
  select(model, gear) |>
  filter(gear == 5)

mtcars_tibble |>
  select(model, gear) |>
  filter(gear != 5)

## filter regexp
df |>
  filter(grepl("^[MF]", model)) |>
  select(model, mpg, hp, wt)

df |>
  slice(grep("^[MF]", model)) |>
  select(model, mpg, hp, wt)


#### Mutate ####
df_transform <- df |>
  select(model, mpg, hp) |>
  mutate(
    hp_double = hp * 2,
    hp_squre = hp ** 2,
    hp_log = log(hp),
    name = "R Language"
  )

### new column
df |>
  select(model, am) |>
  mutate(am_label = if_else(am == 0, "Auto", "Manual"))

### replace column
df |>
  select(model, am) |>
  mutate(am = if_else(am == 0, "Auto", "Manual"))

### replace with factor
df <- df |>
  mutate(am = factor(if_else(am == 0, "Auto", "Manual")))

df <- df |>
  mutate(vs = factor(if_else(vs == 0, "V-Shaped", "Straight")))

### case-when
df_mpg <- df |>
  select(model, mpg) |>
  mutate(mpg_group = case_when(mpg <= 15 ~ "low",
                               mpg <= 25 ~ "medium",
                               mpg > 25 ~ "high",
                               TRUE ~ "other"))
## define rows to show Tibble
print(df_mpg, n = 25)


#### Handle NA ####
### Why handle NA
x <- c(10, 15, 20, NA, 100)
## ถ้ามี NA ในข้อมูลจะไม่สามารถหาผลลัพธ์ได้เลย
## ค่าที่ได้จะออกมาเป็น NA
sum(x)
mean(x)

## na.rm remove NA value from data
sum(x, na.rm = TRUE)

### check NA
is.na(x)

## subset is not NA
x[!is.na(x)]

## manual assign NA
df[5, "disp"] <- NA #360
df[6, 5] <- NA #105

## write function to check NA
check_na <- function(col) {
  sum(is.na(col))
}

apply(df, MARGIN = 2, check_na)

## anonymous function
apply(df, MARGIN = 2, function(col)
  sum(is.na(col)))

## replace missing values
# mean imputation
avg_disp <- mean(df$disp, na.rm = TRUE)

df |>
  mutate(disp = replace_na(disp, avg_disp),
         hp = replace_na(hp, median(hp, na.rm = TRUE)))

### built-in data frame msleep
apply(msleep, MARGIN = 2, function(col)
  sum(is.na(col)))

## filter is not NA
msleep |>
  select(name, genus, vore) |>
  filter(!is.na(vore))

### sqldf manipulate df by sql
library(sqldf)
sqldf("SELECT name, genus, vore
      FROM msleep
      WHERE vore is not null
      LIMIT 10")

### check each row in data frame complete
## complete row
sum(complete.cases(msleep))

## not complete row
nrow(msleep) - sum(complete.cases(msleep))

### drop every rows with missing value
msleep_clean <- drop_na(msleep)


#### Arrange ####
### descending
df |>
  select(model, mpg, hp, wt) |>
  arrange(desc(mpg)) |>
  head(5)

### ascending
df |>
  select(model, mpg, hp, wt) |>
  arrange(mpg) |>
  head(5)

### multiple sorting
df |>
  select(model, mpg, hp, wt, am) |>
  arrange(am, desc(mpg)) |>
  print(n = 32)

#### Summarize ####
df |>
  summarize(
    avg_mpg = mean(mpg),
    sd_mpg = sd(mpg),
    sum_mpg = sum(mpg),
    n = n()
  )

### group by
df |>
  group_by(am) |>
  summarize(
    avg_mpg = mean(mpg),
    sd_mpg = sd(mpg),
    sum_mpg = sum(mpg),
    n = n()
  )

df |>
  group_by(am, vs) |>
  summarize(
    avg_mpg = mean(mpg),
    sd_mpg = sd(mpg),
    sum_mpg = sum(mpg),
    n = n()
  ) |>
  ungroup()

#### nycflight13 ####
library(nycflights13)

### glimpse
glimpse(flights)

### filter September 9
flights |>
  filter(month == 9, day == 9)

### count
flights |>
  count(month)

## Which carrier had most flights in May 2013
flights |>
  filter(month == 5) |>
  count(carrier) |>
  arrange(desc(n)) |>
  left_join(airlines, by = "carrier") |>
  head(5)

#### library tidyr ####
### tidyr is a collection of tidyverse

## read data
wp <- read_csv("worldphone.csv")

## transform wide to long
# old method
wp |>
  gather(N.Amer:Mid.Amer,
         key = "region",
         value = "sales")

# new method
long_wp <- wp |>
  pivot_longer(-Year,
               names_to = "region",
               values_to = "sales")

## convert to wide format
long_wp |>
  pivot_wider(names_from = "region",
              values_from = "sales")


#### JSON ####
library(jsonlite)

### read json
employee_list <- fromJSON("employees_for_R.json")

### convert to data frame
emp_df <- data.frame(employee_list)

### convert df to json
toJSON(emp_df)
