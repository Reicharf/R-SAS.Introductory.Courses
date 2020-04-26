2+2 # add two plus two

# variables
a <- 3
myfirstvariable <- 300*2
a + myfirstvariable

# basic functions etc.
pi
log(a)
sqrt(a + myfirstvariable)

# multiple arguments in functions
rep(3,4)
rep(4,3)

seq(2, 8, 2)
seq(2, 2, 8)
seq(from=2, to=8, by=2) # if arguments are adressed explicitly,
seq(from=2, by=2 ,to=8) # you can change their order

# vectors
c <- seq(from=2, to=8, by=2)
d <- c(1, 4, 6)
d[1:2]
e <- c("red", "blue", "green", "a")
e[3:4]

sqrt(c)
mean(c)
min(c)

################################################################
# Data management in R
rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
data <- read.delim("01 testfile.txt")

data$Weight       # values in column "Weight" of dataset "data"
mean(data$Weight) # take mean of -"-

data[2, 3] # single cell of a dataset (2nd row, 3rd column)

# these all do the same thing: all values of 2nd column = Weight column
data[ , 2]
data[ , "Weight"]
data$Weight

str(data)
data2 <- as.data.table(data) # copy of data, but in better data.table format
str(data2)

data2[ , mean(Weight)]              # also mean of weights
data2[ , mean(Weight), by=Species]  # mean of weights per species
data2[Count < 100, mean(Weight), by=Species] #..but only for Count<100 values

data2[Count < 100, .(mean_w = mean(Weight),
                     mean_c = mean(Count)), by=Species]











