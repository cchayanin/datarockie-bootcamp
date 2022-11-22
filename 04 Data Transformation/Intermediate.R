# install.packages("tidyverse")


library(tidyverse)

#### Tibble ####
## data frame
(df <- data.frame(id = 1:3, name = c("toy", "jisoo", "lisa")))

## tibble
(df_tibble <- tibble(id = 1:3, name = c("toy", "jisoo", "lisa")))

### convert dataframe to tibble
mtcars_tibble <- tibble(rownames_to_column(mtcars))


#### Sample Data ####
### sample_n
sample_n(mtcars, size = 5)

### sample_frac
sample_frac(mtcars, size = 0.20) # 20%

### replace option to repeat sample data
sample_frac(mtcars, size = 0.50, replace = TRUE)

### set.seed
set.seed(42) # set for lock result in random
sample_n(mtcars, size = 5)
sample_frac(mtcars, size = 0.20)


#### Slice ####
mtcars |>
    slice(1:5)

mtcars |>
    slice(6:10)

mtcars |>
    slice(c(1, 3, 5))

mtcars |> 
    slice(sample(nrow(mtcars),10))
