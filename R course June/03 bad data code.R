rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
dt <- read.delim2("03 bad data fixed.txt")

dt$Ages   <- as.numeric(dt$Ages)
dt$Vision <- as.numeric(dt$Vision)

# Practice: 
#   1. Plot them (y=Vision and x=Ages)
#   2. Get the correlation (r) and its p-value
#   3. Get the simple linear regression (y=a+bx)
#   4. Add the regression line to the plot

plot(y=dt$Vision, x=dt$Ages, ylim=c(0, 10))
cor.test(dt$Vision, dt$Ages) # r= -0.5 (p=0.007)
reg <- lm(data    = dt,
          formula = Vision ~ Ages)
reg # Vision = 11.1 - 0.09 * Ages 
abline(reg)
summary(reg) # R² = 0.247 = 24.7 %

# Investigate the outlier
library(data.table)      # activate data.table package
dt2 <- as.data.table(dt) # create dt in better data.table format

dt2[Vision < 4] # It's Rolando

#################################################################
# correlation and regression again but without Rolando

# Eliminate the outlier
dt.nr <- dt2[Vision > 4]

cor.test(dt.nr$Vision, dt.nr$Ages) # r= -0.7 (p<0.0001)

reg.nr <- lm(data    = dt.nr,
             formula = Vision ~ Ages)
reg.nr # Vision = 11.7 - 0.10 * Ages 
summary(reg.nr) # R² = 0.485 = 48.5 %

plot(y=dt.nr$Vision, x=dt.nr$Ages, ylim=c(0, 10))
abline(reg.nr)

################################################################
# Create a graph using ggplot2
library(ggplot2) # or klick on box next to package

p <- ggplot(data=dt, aes(x=Ages, y=Vision))
p <- p + geom_point(size=8, shape=17, colour="red")
p <- p + theme_bw()
p <- p + ylab("Person's vision") + xlab("Person's age")
p <- p + scale_y_continuous(limits=c(0,10), 
                            breaks=c(1,2,8,9))
p <- p + stat_smooth(method="lm", se=FALSE, color="blue", size=2)
p <- p + geom_text(aes(y=4, x=30, label="R² = 0.24"))
p


