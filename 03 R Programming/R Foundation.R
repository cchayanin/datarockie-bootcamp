#### R Foundation #
### Variables ####

# assign
income <- 45000
expense <- 26000
saving <- income - expense

# remove
rm(income)
rm(expense)
rm(saving)


### Data types ####
## numeric
class(100)

## character
class("Hello World")

## logical
class(TRUE)

## factor
# nominal factor
animal <- c("cat", "dog", "hippo", "cat", "dog")
animal <- as.factor(animal)
class(animal)
# ordinal factor(sort)
performance <-
    c("Poor", "Average", "Good", "Good", "Poor", "Average", "Good")
performance <- factor(performance,
                      levels = c("Poor", "Average", "Good"),
                      ordered = TRUE)


### Data structure ####
## Vector
friends <- c("toy", "ink", "aan", "top", "wan")
length(friends)

# subset by position
friends[1]
friends[2]
friends[3]

friends[1:3]
friends[4:5]

friends[c(1, 3, 5)]
friends[c(5, 2, 4)]

## Matrix
matrix(1:25, ncol = 5)
m <- matrix(1:10, ncol = 2, byrow = TRUE)

nrow(m)
ncol(m)

m * 2

m1 <- matrix(c(1,5,3,6),ncol=2)
m2 <- matrix(c(2,4,5,5),ncol=2)

# element-wise computation
m1 + m2
m1 * m2

# matrix multiplication .dot notation
m1 %*% m2


## Dataframe ####
friends <- c("toy", "ink", "aan", "top", "wan")
ages <- c(33, 30, 34, 28, 25)
movie_lover <- c(TRUE, TRUE, FALSE, T, F)
jobs <- as.factor(c("data", "data", "digital", "digital", "phd"))
handsome_degree <- factor(
    c("low", "medium", "high", "high", "high"),
    levels = c("low", "medium", "high"),
    ordered = TRUE
)

friends_df <- data.frame(friend_id = 1:5,
                         friends,
                         ages,
                         movie_lover,
                         jobs,
                         handsome_degree)
class(df)

# Write csv file
write.csv(df, "friends.csv",
          row.names = FALSE)

# Read csv file
df <- read.csv("friends.csv")

# Read csv from internet
url <-
    "https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv"

mtcars_df <- read.csv(url)

# Dataframe subset
friends_df[1:3, ] # row 1:3, all column
friends_df[4:5, ] # row 4:5, all column

friends_df[1:3, 1:3] # row 1:3, column 1:3
friends_df[1:3, 4:5] # row 1:3, column 4:5

friends_df[, c(2, 4, 5)] # all row, column 2,4,5

friends_df[friends_df$ages < 30] # row age < 30, all column
friends_df[friends_df$ages < 30, c(2, 4, 5)] # row age < 30, column 2,4,5

friends_df[friends_df$movie_lover, ] # movie_lover true, all column

friends_df[friends_df$jobs != "digital", ] # job not digital, all column

friends_df[friends_df$job %in% c("data", "digital"),]

friends_df[, c("friends", "ages", "movie_lover")]

cond1 <- friends_df$job == "data"
cond2 <- friends_df$movie_lover
friends_df[cond1 & cond2,]
friends_df[cond1 | cond2,]

# Aggregate
ages <- friends_df$ages
mean(ages)
sum(ages)
median(ages)
min(ages)
max(ages)
sd(ages)
var(ages)

# create new column
friends_df$segment <- ifelse(friends_df$ages >= 30, "Old", "Young")

table(friends_df$segment) # frequency table
table(friends_df$job)

ncol(friends_df)
nrow(friends_df)

# proportion
table(friends_df$segment) / nrow(friends_df)

summary(friends_df)
str(friends_df)

friends_df$jobs <- factor(friends_df$jobs)
friends_df$segment <- factor(friends_df$segment)

summary(friends_df)
str(friends_df)


# drop column
friends_subset <- friends_df[, 1:5]

friends_df$handsome_degree <- NULL

str(friends_df)


## List
john <- list(
    fullname = "John Davis",
    age = 25,
    city = "London",
    email = "john.davis@gmail.com"
)
marry <- list(
    fullname = "Marry Anne",
    age = 22,
    city = "Liverpool",
    email = "marry.anne@gmail.com"
)
kevin <- list(
    fullname = "Kevin Herst",
    age = 25,
    city = "USA",
    email = "kevin.h@gmail.com",
    movies = c("Batman","Dark Knight")
)

# nested list
customers <- list(john=john,marry=marry,kevin=kevin)
customers
customers$john
customers$john$fullname
customers$john$age

customers[["kevin"]]
customers[["kevin"]][["email"]]


### Control Flow ####
## if, for, while

## if
score <- 85
if (score >= 80) {
    print("Passed")
} else {
    print("Failed")
}

if (score >= 90) {
    print("A")
} else if (score >= 80) {
    print("B")
} else if (score >= 70) {
    print("C")
} else{
    print("D")
}

# ifelse vectorization in r
ifelse(scores >= 80, "Passed", "Failed")


## for loop
for (i in 1:10) {
    print(i)
}

scores <- c(95, 50, 88, 72, 75)
for (score in scores) {
    if (score >= 90) {
        print("A")
    } else if (score >= 80) {
        print("B")
    } else if (score >= 70) {
        print("C")
    } else{
        print("D")
    }
}


## while loop
count <- 0
while (count < 10) {
    print("hello")
    count <- count + 1
}


### Functions ####
greeting <- function() {
    print("Hello")
}

my_sum <- function(a, b) {
    # return(a + b)
    a + b # R function's final line of code will automatically return
}

my_sum2 <- function(a, b)
    a + b # {} can be omitted if function has only one statement


## Control Flow in Function
grading <- function(score) {
    if (score >= 90) {
        return("A")
    } else if (score >= 80) {
        return("B")
    } else if (score >= 70) {
        return("C")
    } else{
        return("D")
    }
}

scores <- c(95, 50, 88, 72, 75)
for (score in scores) {
    print(grading(score))
}


# guess animal name ####
guess_animal_game <- function(animal) {
    while (TRUE) {
        guess_animal <- readline("Guess animal: ")
        
        if (animal == guess_animal) {
            print("Congratulation! your guess is correct!")
            break
        } else {
            print("Your guess is incorrect. Please try again.")
        }
    }
}

guess_animal_game("hippo")


# username passord login ####
login_fn <- function() {
    attempt <- 3
    
    username <- "user1234"
    password <- "1234"
    
    count <- 1
    while (count <= attempt) {
        # get input from user
        user_input <- readline("Username: ")
        password_input <- readline("Password: ")
        
        # check username, password
        if (username == user_input & password == password_input) {
            print("Thank you! you have succesfully login.")
            break
            
        } else {
            print("Sorry, please tye again.")
        }
        count <- count + 1
    }
}

login_fn()


### Regular Expression ####
# built-in data set state.name

grep("^S", state.name) # grep return index
state.name[grep("^S", state.name)]
state.name[grep("^s", state.name, ignore.case = TRUE)]
state.name[grep("^[ABS]",
                state.name,
                ignore.case = TRUE)] # return value by subset

grep("^[abs]",
     state.name,
     ignore.case = TRUE,
     value = TRUE) # return value

grepl("^[ABS]", state.name) # grepl return logical
x <- grepl("^[ABS]", state.name)
sum(x)

# replace
gsub("South","Dragon", state.name)

