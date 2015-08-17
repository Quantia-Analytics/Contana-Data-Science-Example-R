## This file contains regression models
## for the analysis of the California 
## milk production data. 

to.POSIXct <- function(year, monthNumber){
  ## Function to create a POSIXct time series 
  ## object from a year.month format
  
  ## Create a charcter vector from the numeric input
  dateStr <- paste(as.character(year), "-",
                   as.character(monthNumber), "-",
                   "01", sep = "")
  
  as.POSIXct( strptime(dateStr, "%Y-%m-%d"))
}

Azure = FALSE
if(Azure){
  dataset$dateTime <- to.POSIXct(dataset$Year,
                                 dataset$Month.Number)
} else{
  dataset <- frame2
}

## Compute a linear model prune the features using
## stepwise regression.
lm <- lm(Milk.Prod ~ dateTime + Month +
             monthNumSqred + monthNumCubed - 1, 
         data = dataset)

library(MASS)
model <- stepAIC(lm, direction = "back")
