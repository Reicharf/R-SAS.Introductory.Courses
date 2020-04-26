# Usual first lines of code for any project:
rm(list=ls()) # Clean up environment
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten") # Set working directory
library(data.table)
data <- fread("vision fixed (other) LM.txt") # Import file

# Start doing this assignment with your 
# knowledge/code from yesterday:
#  Focus on the columns: "Vision" and "Ages" 
#   1. Format them both as numeric
#   2. Plot them (y=Vision and x=Ages)
#   3. Get the correlation (r) and its p-value
#   4. Get the simple linear regression (y=a+bx)
#   5. Add the regression line to the plot

# 1.
data$Vision <- as.numeric(data$Vision)
data$Ages   <- as.numeric(data$Ages)
# 2.
plot(y=data$Vision, x=data$Ages, ylim=c(0, 10))
# 3.
cor.test(data$Vision, data$Ages) # r= -0.5 (p=0.007)
# 4.
reg <- lm(data    = data,
          formula = Vision ~ Ages)
reg # Vision = 11.1 - 0.09 * Ages     R²=0.22
# 5.
abline(reg)
summary(reg)

### Who is the outlier?
data[Vision < 5] # Rolando is the oulier!

### Create a subset of our data without Rolando
data.nr <- data[Vision > 5]          # Option 1
data.nr <- data[Person != "Rolando"] # Option 2

# Correlation without Rolando
cor.test(data.nr$Vision, data.nr$Ages) # r= -0.7 (p<0.0001)

# Regression without Rolando
reg.nr <- lm(data    = data.nr,
             formula = Vision ~ Ages)
reg.nr # Vision = 11.7 - 0.10 * Ages  
summary(reg.nr) # R² = 0.46

# Plot without Rolando
plot(y=data.nr$Vision, x=data.nr$Ages, 
     ylim=c(0, 10), xlim=c(0,100))
abline(reg.nr)

##########################################################
# Create plot with more options via ggplot() function

#install.packages("ggplot2")
library(ggplot2)

p <- ggplot(data=data.nr, aes(x=Ages, y=Vision))
p <- p + geom_point(color="purple", size=3, shape=17)
p <- p + ylab("Person's vision")
p <- p + xlab("Person's age")
p <- p + theme_minimal()
p <- p + scale_y_continuous(limits=c(0,10), breaks=c(1,2,8,9))
p <- p + stat_smooth(method="lm", se=FALSE, color="orange")
p <- p + geom_text(aes(y=2, x=40, label="R2 = 0.46"))

p # show plot 
