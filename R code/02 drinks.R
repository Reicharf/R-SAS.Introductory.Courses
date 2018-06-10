# Do this after break:
# 1. File > New File > R Script
# 2. Set working directory
# 3. Import drinks file into object "dataset"
# 4. Think about whether columns are formatted correctly

rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
dataset <- read.delim("02 drinks.txt")

# correct formatting for columns
dataset$Person <- as.factor(dataset$Person)
dataset$drinks <- as.numeric(dataset$drinks)

library(data.table)
DT <- data.table(dataset) # data.table format for advantageous functions
DT[, max(drinks), by=Person] # maximum number of drinks per person

# plot data for first impression
plot(x=DT$Person, y=DT$blood_alc) # factor  - numeric : boxplot
plot(x=DT$drinks, y=DT$blood_alc) # numeric - numeric : scatter plot

# correlation
cor.test(DT$drinks, DT$blood_alc)
 # r = 0.956 (p<0.0001)

# simple linear regression
reg <- lm(data    = DT,
          formula = blood_alc ~               drinks)
                  #    y      = a    + b    *   x
                  # blood_alc = 0.05 + 0.12 * drinks
reg
summary(reg) # get more than default
abline(reg)  # add regression line to plot

# simple linear regression without intercept
reg2 <- lm(data    = DT,
           formula = blood_alc ~ 0 +        drinks)
                   #    y      = 0 + b    *   x
                   # blood_alc = 0 + 0.13 * drinks
reg2
summary(reg2)
abline(reg2)

#####################################################
# more plotting options with default plot() function
# old
plot(x=DT$drinks, y=DT$blood_alc)
# new
plot(x=DT$drinks, y=DT$blood_alc, xlim = c(0,10), ylim = c(0, 2))
abline(reg2)
