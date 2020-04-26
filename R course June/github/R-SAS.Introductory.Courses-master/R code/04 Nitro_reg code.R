rm(list=ls())
setwd("C:/Users/Paul/Desktop/R course")
dat <- read.delim2("03 Nitro_reg.txt")

# format columns
dat$block <- as.factor(dat$block)
dat$plot  <- as.factor(dat$plot)
dat$N     <- as.numeric(dat$N)

# plot data
plot(y=dat$yield, x=dat$N, col=dat$block)

# linear model: simple regression with block effect
lm(data    = dat,
   formula = yield ~             N + block)
           #   y   =  a   +    b*x + block_i
           # yield = 14.1 + 0.13*N + [0, -0.72, 2.38]

# linear model: polynomial reg. with block effect
mod <- lm(data    = dat,
   formula = yield ~             N +  I(N^2) + block)
           #   y   =  a   +    b*x +    c*x² + block_i
           # yield = 9.13 + 0.41*N -0.002*N² + [0, -0.72, 2.38]
           # yield = 9.68 + 0.41*N -0.002*N²

plot(mod)

### ggplot ###
ggplot(data=dat, aes(y=yield, x=N)) +
  geom_point() +
  stat_smooth(method="lm", se=FALSE,
              formula=y~poly(x,2))


