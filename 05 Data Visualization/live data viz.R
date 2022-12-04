#### Lubridate ####
library(tidyverse)
library(lubridate)

### conversion
d <- "2022-10-01"
class(d)

d <- as.Date(d)
class(d)

### get day, month, year
day(d)

month(d)

year(d)

## display name of month
month(d, label = TRUE)
month(d, label = TRUE, abbr = FALSE)


## locale months' name
month(d, label = TRUE, locale = "th_TH.utf8")
month(d, label = TRUE, abbr = FALSE, locale = "th_TH.utf8")


## day of week
wday(d)
wday(d, label = TRUE)
wday(d, label = TRUE, abbr = FALSE)


### Convert Different formats into date
d <- c("29 May, 2022",
       "09 Sep, 1988",
       "15 Aug, 2021")

d <- dmy(d)
class(d)

d <- c("May 29 2022",
       "Sep 09 1988",
       "Aug 12 2021")

d <- mdy(d)
class(d)


tribble( ~ id,  ~ date,
                 1, "2022/09/09",
                 2, "2021/05/31",
                 3, "2022/08/25")


df <- tribble(~ id,  ~ date,
              1, "2022/09/09",
              2, "2021/05/31",
              3, "2022/08/25")
DEFAULT_LC_TIME <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.utf8")
df |>
    mutate(
        date = ymd(date),
        day = day(date),
        month = month(date, label = TRUE),
        year = year(date),
        wday = wday(date, label = TRUE)
    )


#### ggplot => 2D Grammar of graphic ####
glimpse(mtcars)

### concept of ggplot
ggplot(data = mtcars,
       mapping = aes(x = mpg)) +
    geom_histogram()

ggplot(data = mtcars,
       mapping = aes(x = mpg)) +
    geom_density()


#### One Variable continuous ####
### Histogram
mtcars |>
    ggplot(aes(mpg)) +
    geom_histogram(bins = 10)


### Bolxplot
## five number summary
mtcars |>
    summarise(
        min_mpg = min(mpg),
        q1 = quantile(mpg, 0.25),
        q2 = quantile(mpg, 0.5),
        q3 = quantile(mpg, 0.75),
        max_mpg = max(mpg),
    )

mtcars |> 
    ggplot(aes(mpg)) +
    geom_boxplot()


#### One Variable discrete/factor ####
### glimpse
glimpse(mtcars)

### convert am to factor
m <- mtcars |> 
    tibble() |> 
    mutate(am = factor(
        am,
        levels = c(0, 1),
        labels = c("Auto", "Manual")
    ))

glimpse(m)

### Bar chart
m |> 
    ggplot(aes(am)) +
    geom_bar()

m |> 
    count(am)


m |> 
    count(am) |> 
    mutate(percent = n/sum(n))

#### Two Variables both continuous ####
m |>
    ggplot(aes(wt, mpg)) +
    geom_point()

m |>
    ggplot(aes(wt, mpg)) +
    geom_smooth(method = "lm")


m |>
    ggplot(aes(wt, mpg)) +
    geom_point() +
    geom_smooth(method = "lm")

#### Setting Chart ####
m |>
    ggplot(aes(wt, mpg)) +
    geom_point(
        color = "red",
        size = 5,
        alpha = 0.8,
        shape = "+"
    ) +
    geom_smooth(method = "lm",
                color = "black",
                fill = "gold")

#### Setting Mapping ####
m |>
    ggplot(aes(wt, mpg)) +
    geom_point(size = 5,
               alpha = 0.5,
               mapping = aes(color = am))

m |>
    ggplot(aes(wt, mpg, color = am)) +
    geom_point(size = 5,
               alpha = 0.5)

m <- m |> 
    mutate(cyl = factor(cyl))

m |>
    ggplot(aes(wt, mpg)) +
    geom_point(size = 5,
               alpha = 0.5,
               mapping = aes(color = cyl))

### create hp segment
m |>
    select(wt, mpg, hp) |>
    mutate(hp_segment = case_when(hp < 100 ~ "Low",
                                  hp < 200 ~ "Medium",
                                  TRUE ~ "High")) |>
    mutate(hp_segment = factor(
        hp_segment,
        labels = c("Low", "Medium", "High"),
        levels = c("Low", "Medium", "High"),
        ordered = TRUE
    )) |>
    ggplot(aes(wt, mpg, color = hp_segment)) +
    geom_point(size = 4 , alpha = 0.8) +
    scale_color_manual(values = c("red", "gold", "blue"))

#### Two Variables one discrete, one continuous
### boxplot
m |>
    ggplot(aes(am, mpg)) +
    geom_boxplot()

### violin
m |>
    ggplot(aes(am, mpg)) +
    geom_violin()


#### Diamonds data set ####
diamonds |>
    ggplot(aes(cut, fill = cut)) +
    geom_bar()

diamonds |>
    ggplot(aes(cut, fill = color)) +
    geom_bar() +
    theme_minimal()

### overplotting
diamonds |>
    ggplot(aes(carat, price)) +
    geom_point()


### sample
diamonds |>
    sample_n(5000) |>
    ggplot(aes(carat, price)) +
    geom_point()

## smooth
diamonds |>
    sample_n(5000) |>
    ggplot(aes(carat, price)) +
    geom_point() +
    geom_smooth()

## change smooth method to linear
diamonds |>
    sample_n(5000) |>
    ggplot(aes(carat, price)) +
    geom_point() +
    geom_smooth(method = "lm")

#### Labels ####
diamonds |>
    sample_n(1000) |>
    ggplot(aes(carat, price)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm") +
    theme_minimal() +
    labs(
        title = "Relationship between carat and price of diamonds",
        x = "Carat",
        y = "Price (USD)",
        subtitle = "Using ggplot to create this visualization",
        caption = "Source: ggplot package"
    )


#### Facet ####
### wrap
diamonds |>
    sample_n(1000) |>
    ggplot(aes(carat, price)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm") +
    theme_minimal() +
    facet_wrap( ~ cut, ncol = 2)


### grid
diamonds |>
    count(cut, color)

diamonds |>
    sample_n(5000) |>
    ggplot(aes(carat, price)) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "lm") +
    theme_minimal() +
    facet_grid(cut ~ color)

#### Color ####
colors()

### name
diamonds |>
    ggplot(aes(price)) +
    geom_histogram(fill = "salmon",
                   bins = 50) +
    theme_minimal()

### hex
diamonds |>
    ggplot(aes(price)) +
    geom_histogram(fill = "#14e38d",
                   bins = 50) +
    theme_minimal()

### color brewer
diamonds |>
    sample_n(1000) |>
    ggplot(aes(carat, price, color = cut)) +
    geom_point() +
    theme_minimal() +
    scale_color_brewer(palette = "BuPu")


#### ggthemes ####
# install.packages("ggthemes")
library(ggthemes)

diamonds |> 
    sample_n(1000) |> 
    ggplot(aes(carat,price,color=cut)) + 
    geom_point() +
    theme_excel_new()


diamonds |> 
    sample_n(1000) |> 
    ggplot(aes(carat,price,color=cut)) + 
    geom_point() +
    theme_economist()


#### Patchwork ####
p1 <- ggplot(mtcars, aes(hp)) + geom_histogram(bins = 10)
p2 <- ggplot(mtcars, aes(mpg)) + geom_density()
p3 <- ggplot(diamonds, aes(cut, fill = cut)) + geom_bar()

# install.packages("patchwork")
library(patchwork)

p1 + p2 + p3

(p1 + p2) / p3

p1 / (p2 + p3)

