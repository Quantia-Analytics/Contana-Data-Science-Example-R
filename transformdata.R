## The code in this file transforms the 
## dairy data set for time series regression
## Analysis.

## Set variable to TRUE of FALSE to define the 
## environment.
Azure = FALSE
if(Azure){
  ## Read the input data table into a data frame. 
  frame1 <- maml.mapInputPort(1)
  ## Source the .R file from the zip. 
  source("src/milkutilities.R")
} else {
  ## If in RStudio read the .csv file with read.csv function.
  dirName <- "C:/Users/Steve/Documents/AzureML/Data Sets/CA_Milk"
  fileName <- "cadairydata.csv"
  infile <- file.path(dirName, fileName)
  frame1 <- read.csv( infile, header = TRUE, stringsAsFactors = FALSE)
} 

## Ensure the month names are all trimmed 
## to three characters.
frame1$Month <- substr(frame1$Month, 1, 3)

## Create a new POSIXct column. 
frame1$dateTime <- to.POSIXct(frame1$Year, frame1$Month.Number)

## Add a columns with the polynomial values of Month.Number.
frame1$Month.Count  <- frame1$Month.Number + 
                    12 * (frame1$Year - 1995)
frame1$monthNumSqred <- frame1$Month.Count^2
frame1$monthNumCubed <- frame1$Month.Count^3

## If in Azure output the data frame.
if(Azure){
  maml.mapOutputPort('frame1')
} else {
  frame1$Month <- as.factor(frame1$Month)
}