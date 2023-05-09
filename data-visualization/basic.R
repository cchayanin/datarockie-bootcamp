#### Basic Plot ####

### mtcars dataset

### Histogram
hist(mtcars$mpg)
hist(mtcars$hp)

## Analyzing horse power
mean(mtcars$hp)
median(mtcars$hp)

str(mtcars)

mtcars$am <- factor(mtcars$am,
                    levels = c(0, 1),
                    labels = c("Auto", "Manual"))

str(mtcars)

### Bar Plot
barplot(table(mtcars$am))


### Box Plot
boxplot(mtcars$hp)

## five num
fivenum(mtcars$hp)

min(mtcars$hp)
quantile(mtcars$hp, probs = c(.25, .5, .75))
max(mtcars$hp)

## whisker calculation
Q3 <- quantile(mtcars$hp, probs = .75)
Q1 <- quantile(mtcars$hp, probs = .25)
IQR_hp <- Q3 - Q1


Q3 + 1.5 * IQR_hp
Q1 - 1.5 * IQR_hp

## flag outlier
boxplot.stats(mtcars$hp, coef = 1.5)

## filter out outliers
hp_no_out <- mtcars$hp[mtcars$hp < 335]

## box plot no outlier
boxplot(hp_no_out)

## Boxplot 2 Variables
# Qualitative × Quantitative
boxplot(mpg ~ am, data = mtcars)


boxplot(mpg ~ am,
        data = mtcars,
        col = c("gold", "salmon"))

### Scatter Plot
## Quantitative × Quantitative
plot(mtcars$hp, mtcars$mpg)


plot(mtcars$hp, mtcars$mpg, pch = 17, col = "blue")
cor(mtcars$hp, mtcars$mpg)

lm(mpg ~ hp, data = mtcars)

## labels
plot(
    mtcars$hp,
    mtcars$mpg,
    pch = 17,
    col = "blue",
    main = "Scatter Plot",
    xlab = "Horse Power",
    ylab = "Miles Per Gallon"
)