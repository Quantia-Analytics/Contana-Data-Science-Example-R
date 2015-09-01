## This file contains code to evaluate the performance
## of the time series regression on California milk
## production 

Azure = FALSE
if(Azure){
  ## Read the input data table into a data frame. 
  frame3 <- maml.mapInputPort(1)
  ## Source the .R file from the zip. 
  source("src/milkutilities.R")
  ## Ensure the dataTime column is preserved
  frame3$dateTime <- to.POSIXct(frame3$Year, frame3$Month.Number)
} else{
  frame3 <- scores
}


## Plot the actual and predicted values of 
## milk production.
library(ggplot2)
plot.milk <- function(data){
  ggplot(data, aes(dateTime, Milk.Prod)) +
    geom_line() +
    geom_line(aes(dateTime, ScoredLabels), color = "red") +
    xlab("Date") + ylab("Log CA milk production") +
    ggtitle("Time series plots of milk produciton and trend") +
    theme(text = element_text(size=20))
}

plot.milk(frame3)

## Make the time series plot of the residuals
library(dplyr)
frame3$Resid  <- frame3$Milk.Prod - frame3$ScoredLabels

ggplot(frame3, aes(dateTime, Resid)) + geom_point()+
  theme(text = element_text(size=20)) +
  ylab("Residual") + xlab("Date") + 
  ggtitle("Linear model residuals vs date")

## Look at the month to month variation in the 
## residuals with a box plot. Need to make Month 
## an ordered factor to make this work.
frame3$Month <- order.month(frame3$Month)

plot.milk.box <- function(data){
  ggplot(data, aes(factor(Month), Resid)) +
    geom_boxplot() +
    ylab("Residual") + xlab("Month") +
    ggtitle("Linear model residuals by month") +
    theme(text = element_text(size=20))
}

plot.milk.box(frame3)

## Quantile-quantile normal plot of the residuals.
qqnorm(frame3$Resid)

## Histogram of the residuals
ggplot(frame3, aes(x = Resid)) + 
  geom_histogram(binwidth = 0.02, alpha = 0.5) +
  ggtitle("Histogram of linear model residuals") +
  xlab("Linear model residuals") +
  theme(text = element_text(size=20))

## Compute the RMSE values of the residuals
## for both the overall and evaluation 
## parts of the dataset. 
rmse <- function(x){
  sqrt(sum(x^2)/length(x))
} 

outFrame <- data.frame( 
  rmsOverall = rmse(frame3$Resid[1:216]),
  rmsEvaluate = rmse(frame3$Resid[217:228]))

## If in Azure output the data frame.
if(Azure) maml.mapOutputPort('outFrame')
