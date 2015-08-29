## This file contains R code for an initial visualization
## of the California milk production data. 

## Set variable to TRUE of FALSE to define the 
## environment.
Azure = FALSE
if(Azure){
  ## Read the input data table into a data frame. 
  frame1 <- maml.mapInputPort(1)
  ## Source the .R file from the zip. 
  source("src/milkutilities.R")
  ## Ensure the dataTime column is preserved
  frame1$dateTime <- to.POSIXct(frame1$Year, frame1$Month.Number)
}

## Compute a linear model of the trend
## and add the predicted values to the data frame.
lm1 <- lm(Milk.Prod ~ dateTime + monthNumCubed, data = frame1)
frame1$lm1Pred <- predict(lm1, newdata = frame1)


## Plot the actual and predicted values of 
## milk production.
library(ggplot2)
plot.milk <- function(data){
  ggplot(data, aes(dateTime, Milk.Prod)) +
    geom_line() +
    geom_line(aes(dateTime, lm1Pred), color = "red") +
    xlab("Date") + ylab("Log CA milk production") +
    ggtitle("Time series plots of milk produciton and trend") +
    theme(text = element_text(size=20))
}

plot.milk(frame1)

## Make the time series plot of the residuals
library(dplyr)
#frame1 <- frame1 %>% mutate(lm1Resid = Milk.Prod - lm1Pred)
frame1$lm1Resid  <- frame1$Milk.Prod - frame1$lm1Pred

ggplot(frame1, aes(dateTime, lm1Resid)) + geom_line()+
  theme(text = element_text(size=20)) +
  ylab("Residual") + xlab("Date") + 
  ggtitle("Linear model residuals vs date")

## Look at the month to month variation in the 
## residuals with a box plot. Need to make Month 
## an ordered factor to make this work.
frame1$Month <- order.month(frame1$Month)

plot.milk.box <- function(data){
  ggplot(data, aes(factor(Month), lm1Resid)) +
    geom_boxplot() +
    ylab("Residual") + xlab("Month") +
    ggtitle("Linear model residuals by month") +
    theme(text = element_text(size=20))
}

plot.milk.box(frame1)
