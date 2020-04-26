3+2 # this is how you add 3 and 2

### variables
a <- 5
b <- 2*6
a <- 7
a + b

### basic functions
pi
log(a)
sqrt(a+b)

# Names and order of function arguments
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
setwd("C:/Users/Paul/Desktop/R course")
data <- read.delim("01 testfile.txt")

# format Species column as factor
data$Species <- as.factor(data$Species)

mean(data$Weight)

library(data.table)
DT <- data.table(data)

# mean overall weight
DT[, mean(Weight)]
# mean weight per species
DT[, mean(Weight), by=Species]
# mean weight per species for observations with Count>100
DT[Count > 100, mean(Weight), by=Species]

DT[Count > 100, .(mean_w = mean(Weight),
                  mean_c = mean(Count)), by=Species]



