## The code in this file creates a training data set
## for building a time series regression model. 

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

## Eliminate the last one year (12 months) of 
## the dairy data frame, using the date time column. 
frame2 <- frame1[frame1$dateTime < "2013-01-01", ]

## Make sure the 

## If in Azure output the data frame.
if(Azure) maml.mapOutputPort('frame2')
