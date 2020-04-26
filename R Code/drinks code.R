# Usual first lines of code for any project:
rm(list=ls()) # Clean up environment
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten") # Set working directory
library(data.table)
dataset <- fread("drinks (other) LM.txt") # Import file

# correct formatting for columns
dataset$Person <- as.factor(dataset$Person)
dataset$drinks <- as.numeric(dataset$drinks)

library(data.table)
DT <- data.table(dataset) # data.table format for advantageous functions
DT[, max(drinks), by=Person] # look at maximum number of drinks per person

# plot data for first impression
plot(x=DT$Person, y=DT$blood_alc) # factor  - numeric : boxplot
plot(x=DT$drinks, y=DT$blood_alc) # numeric - numeric : scatter plot

# correlation
cor(DT$drinks, DT$blood_alc) # only returns the correlation estimate
cor.test(DT$drinks, DT$blood_alc) # also returns e.g. p-value
# r = 0.956 (p<0.0001)

# simple linear regression
reg <- lm(data    = DT,
          formula = blood_alc ~               drinks)
#    y      = a    + b    *   x
# blood_alc = 0.05 + 0.12 * drinks
reg # this object contains all results of fitting the regression
summary(reg) # show more of the results contained in the object
abline(reg)  # add regression line to plot

# simple linear regression without intercept
reg.noint <- lm(data    = DT,
                formula = blood_alc ~ 0 +        drinks)
#    y      = 0 + b    *   x
# blood_alc = 0 + 0.13 * drinks
reg.noint
summary(reg.noint)
abline(reg.noint)

#####################################################
# more plotting options with default plot() function
# old
plot(x=DT$drinks, y=DT$blood_alc)
# new
plot(x=DT$drinks, y=DT$blood_alc, xlim = c(0,10), ylim = c(0, 2))
abline(reg.noint)
