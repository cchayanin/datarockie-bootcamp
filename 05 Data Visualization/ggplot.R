library(tidyverse)

#### Concept ####
### Data + Mapping
ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +

### Geometry
ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +
    geom_point()

### More Geometry
ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +
    geom_point() +
    geom_smooth()

ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +
    geom_point() +
    geom_smooth() +
    geom_rug()

### Customize Plot
ggplot(mtcars, aes(hp, mpg)) +
    geom_point(size = 3 ,
               col = "blue",
               alpha = 0.2)


#### Histogram ####
ggplot(mtcars, aes(hp)) +
    geom_histogram(bins = 10, fill = "red", alpha = 0.5)

#### Base Plot ####
base_plot <- ggplot(mtcars, aes(hp))

base_plot + geom_histogram(bins = 10)
base_plot + geom_density()
base_plot + geom_boxplot()


#### Diamonds Data set ####
diamonds

#### Boxplot by groups
diamonds |> 
    count(cut)

ggplot(diamonds,aes(cut,fill=color)) +
    geom_bar(position = "dodge")

ggplot(diamonds,aes(cut,fill=color)) +
    geom_bar(position = "fill")


#### Scatter Plot ####
ggplot(diamonds,aes(carat,price)) +
    geom_point()

### reduce size
set.seed(24)
ggplot(sample_n(diamonds, 5000), aes(carat, price)) +
    geom_point()


#### Facet
set.seed(24)
small_diamonds <- sample_n(diamonds, 5000)
ggplot(small_diamonds, aes(carat, price)) +
    geom_point() +
    geom_smooth(method = "lm", col = "red") +
    facet_wrap(~ color, ncol = 2)


#### Theme
ggplot(small_diamonds, aes(carat, price)) +
    geom_point() +
    geom_smooth(method = "lm", col = "red") +
    facet_wrap( ~ color, ncol = 2) +
    theme_minimal()


#### Labels
ggplot(small_diamonds, aes(carat, price, col = cut)) +
    geom_point(size = 3 , alpha = 0.2) +
    geom_smooth(method = "lm", col = "red") +
    facet_wrap(~ color, ncol = 2) +
    theme_minimal()
