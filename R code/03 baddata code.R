rm(list=ls())
setwd("C:/Users/Paul/Desktop/R course")
data <- read.delim("03 bad data fixed.txt")

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

###########################################
# Everything again, but without outlier

subset(data, Vision < 5)         # DT[Vision < 5,]
d_noro <- subset(data, Vision > 5)

# 2.
plot(y=d_noro$Vision, x=d_noro$Ages, ylim=c(0, 10))
# 3.
cor.test(d_noro$Vision, d_noro$Ages) # r= -0.7 (p<0.001)
# 4.
reg_noro <- lm(data    = d_noro,
               formula = Vision ~ Ages)
reg_noro # Vision = 11.7 - 0.10 * Ages     R²=0.46
# 5.
abline(reg_noro)
summary(reg_noro)

library(ggplot2)

ggplot(data=d_noro, aes(x=Ages, y=Vision)) +
  geom_point(color="red", size=3, shape=17) +
  ylab("Person's vision") +
  xlab("Person's age") +
  theme_minimal() +
  scale_y_continuous(limits=c(0,10), 
                     breaks=c(1,2,8,9)) +
  stat_smooth(method="lm", se=FALSE, color="green") +
  geom_text(aes(y=2, x=30, label="R² = 0.46"))




