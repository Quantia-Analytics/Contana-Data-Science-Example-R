## The code in this file evaluates the performance
## of the linear regression time series model. 

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
  ## Put the score (last column) in the data frame
  ## in ScoredLables
  inFrame$ScoredLables <- inFrame[, ncol(inFrame)]
} else {
  frame1 <- scores
}


## Plot the actual and predicted values of 
## milk production.
library(ggplot2)
plot.milk <- function(data){
  ggplot(data, aes(dateTime, Milk.Prod)) +
    geom_line() +
    geom_line(aes(dateTime, ScoredLables), color = "red") +
    xlab("Date") + ylab("Log CA milk production") +
    ggtitle("Time series plots of milk produciton and prediction") +
    theme(text = element_text(size=20))
}

plot.milk(frame1)

## Compute the residuals and make a time series plot.
frame1$lmResid  <- frame1$Milk.Prod - frame1$ScoredLables

ggplot(frame1, aes(dateTime, lmResid)) + 
  geom_point(color = "blue", alpha = 0.3, size =4) +
  theme(text = element_text(size=20)) +
  ylab("Residual") + xlab("Date") + 
  ggtitle("Linear model residuals vs date")

## Look at the month to month variation in the 
## residuals with a plot. Need to make Month 
## an ordered factor for this work.
frame1$Month <- order.month(frame1$Month)

plot.milk.box <- function(data){
  ggplot(data, aes(factor(Month), lmResid)) +
    geom_boxplot() +
    ylab("Residual") + xlab("Month") +
    ggtitle("Linear model residuals by month") +
    theme(text = element_text(size=20))
}

plot.milk.box(frame1)


## Quantile-quantile normal plot of the residuals.
qqnorm(frame1$lmResid)

## Histogram of the residuals
ggplot(frame1, aes(x = lmResid)) + 
  geom_histogram(binwidth = 0.02) +
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
  rmsOverall = rmse(frame1$lmResid[1:216]),
  rmsEvaluate = rmse(frame1$lmResid[217:228]))

## If in Azure output the data frame.
if(Azure) maml.mapOutputPort('outFrame')