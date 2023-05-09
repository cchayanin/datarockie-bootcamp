# install.packages(c("dplyr","readr"))

# load package
library(dplyr)
library(readr)

#### read csv file ####
imdb <- read.csv("imdb.csv", stringsAsFactors = FALSE) # base r
imdb <- read_csv("imdb.csv") # readr package


### list file name in zip
unzip("imdb.zip", list = TRUE)

### unzip/extract file
unzip("imdb.zip")

### read csv without extract file
imdb <- read_csv(unz("imdb.zip", "imdb.csv"))

### read csv and extract file
imdb <- read_csv(unzip("imdb.zip", "imdb.csv"))

### review data structure
glimpse(imdb)


### print head and tail of data
## head
head(imdb) #default 6 rows
head(imdb, 10)

## tail
tail(imdb, 10)


#### Select Columns ####
### by column name
select(imdb, MOVIE_NAME, RATING)

### by column index
select(imdb, 1, 5)

### rename column
select(imdb, movie_name = MOVIE_NAME, released_year = YEAR)

#### pipe operator ####
imdb |>
    select(movie_name = MOVIE_NAME, released_year = YEAR) |>
    head(10)


#### Filter Data 1####
filter(imdb, SCORE >= 9.0)

### pipe operator
imdb |> filter(SCORE >= 9.0)

### transform column name to lowercase
names(imdb) <- tolower(names(imdb))

### use pipe to connect multiple step to transform
imdb |>
    select(movie_name, year, score) |>
    filter(score >= 9)

### filter multiple conditions

## and
imdb |>
    select(movie_name, year, score) |>
    filter(score >= 9 & year > 2000)

imdb |>
    select(movie_name, year, score) |>
    filter(score >= 9 , year > 2000)

## or
imdb |>
    select(movie_name, length, score) |>
    filter(score == 8.8 | score == 8.3)

## in can be use filter multiple value in same column
imdb |>
    select(movie_name, length, score) |>
    filter(score %in% c(8.3, 8.8))


#### Filter Data 2 ####
### filter string column
imdb |>
    select(movie_name, genre, rating) |>
    filter(rating == "R")

imdb |>
    select(movie_name, genre, rating) |>
    filter(genre == "Drama")

### filter string with grepl
imdb |>
    select(movie_name, genre, rating) |>
    filter(grepl("Drama", genre))

## grepl is case-sensitive
imdb |>
    select(movie_name) |>
    filter(grepl("king", movie_name))

# ignore.case turn grepl to case-insensitive
imdb |>
    select(movie_name) |>
    filter(grepl("king", movie_name, ignore.case = TRUE))


#### Create New Columns ####
### mutate
imdb |>
    select(movie_name, score, length) |>
    mutate(
        score_group = if_else(score >= 9, "High Rating", "Low Rating"),
        length_group = if_else(length >= 120, "Long Film", "Short Film")
    )

imdb |> 
    select(movie_name, score) |> 
    mutate(score_update = score + 0.1) |> 
    head(10)

### replace column with the same name
imdb |> 
    select(movie_name, score) |> 
    mutate(score = score + 0.1) |> 
    head(10)


#### Arrange Data ####
### arrange

## ascending
imdb |> 
    arrange(length) |> 
    head(10)

## descending
imdb |> 
    arrange(desc(length)) |> 
    head(10)

### multiple columns sorting
imdb |> 
    arrange(rating,desc(length))


#### Summary Statistics ####
imdb |>
    summarize(mean_length = mean(length),
              sum_length = sum(length),
              sd_length = sd(length),
              min_length = min(length),
              max_length = max(length),
              n = n())

### group by
imdb |>
    filter(rating != "") |>
    group_by(rating) |>
    summarize(
        mean_length = mean(length),
        sum_length = sum(length),
        sd_length = sd(length),
        min_length = min(length),
        max_length = max(length),
        n = n()
    )

#### Join Tables ####
favorite_films <- data.frame(id = c(5, 10, 25, 30, 98))

favorite_films |>
    inner_join(imdb, by = c("id" = "no"))

#### Write CSV File
### prep data to export
imdb_prep <- imdb |>
    select(movie_name, released_year = year, rating, length, score) |>
    filter(rating == "R", released_year > 2000)

### export
## base r
write.csv(imdb_prep,"imdb_prep.csv", row.names = FALSE)

## dplyr
write_csv(imdb_prep,"imdb_prep.csv")