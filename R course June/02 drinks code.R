rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
data <- read.delim("02 drinks.txt")

data$drinks <- as.numeric(data$drinks) # format column "drinks" as numeric
              #as.factor()

plot(x=data$Person, y=data$blood_alc)
plot(x=data$drinks, y=data$blood_alc)

# correlation
cor.test(data$drinks, data$blood_alc) # r = 0.96 (p-value < 0.001)

# simple linear regression
reg <- lm(data    = data,
          formula = blood_alc ~                drinks)
                  #     y     =   a   +   b  *   x
                  # blood_alc = 0.049 + 0.12 * drinks

reg          # get estimates for a & b
summary(reg) # get more info on regression results
abline(reg)  # add regression line to plot

# simple linear regression but without intercept
reg2 <- lm(data    = data,
           formula = blood_alc ~   0   +         drinks)
                   #     y     =            b  *   x
                   # blood_alc =   0   +  0.13 * drinks
reg2
abline(reg2)







