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

## Make a histogram of the residuals
p1 <- ggplot(frame1, aes(lm1Resid)) +
  geom_histogram(binwidth = 0.05) +
  xlab("Residual") + ylab("Count") +
  ggtitle("Histogram with bin width = 0.05")
  theme(text = element_text(size=20))

p2 <- ggplot(frame1, aes(lm1Resid)) +
  geom_histogram(binwidth = 0.01) +
  xlab("Residual") + ylab("Count") +
  ggtitle("Histogram with bin width = 0.01")
theme(text = element_text(size=20))

multiplot(p1, p2, cols = 2)


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
