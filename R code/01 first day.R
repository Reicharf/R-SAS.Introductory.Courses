3+2 # this is how you write a comment

### variables
a <- 5
b <- 2*6
a <- 7
a + b

### basic functions
pi
log(2) # the function "log" takes the logarithm of any number
sqrt(a+b) #you can e.g. add a+b even inside a function


# Names and order of function arguments
# Some functions require multiple arguments. You can explicitly
# address them with their names (e.g. "from=") or leave the name
# out - IF you provide the arguments in the default order:
seq(from=2, to=8, by=0.5) # works
seq(2, 8, 0.5)            # works
seq(2, 0.5, 8)            # does not work
seq(from=2, by=0.5, to=8) # works

### vectors
x <- c(1, 4, 5)
y <- c("red", "blue")

sqrt(x)
mean(x)
min(x)
max(x)

################
# Handling Data
################
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets") # set your working directory
data <- read.delim("01 testfile.txt") # import txt file

# format Species column as factor
data$Species <- as.factor(data$Species)

mean(data$Weight)

library(data.table) 
# data.table is an optional additional package which lets you
# do multiple convenient things with your data. 
DT <- data.table(data) # transform standard data to data.table format

# mean overall weight
DT[, mean(Weight)]
# mean weight per species
DT[, mean(Weight), by=Species]
# mean weight per species for observations with Count>100
DT[Count > 100, mean(Weight), by=Species]

DT[Count > 100, .(mean_w = mean(Weight),
                  mean_c = mean(Count)), by=Species]