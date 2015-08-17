# This file contains code to score the regression
## model. 

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
  ## The dataset data frame is immutable, so
  ## make a copy we can work with and make sure
  ## the data-time column is the correct type.
  scores <- dataset
  scores$dateTime <- to.POSIXct(dataset$Year,
                                 dataset$Month.Number)
} else{
  scores <- frame1
}


## Compute the predicted values from the model
## as the score lables.
if(Azure){
  scores <- predict(model, newdata = scores)
} else {
  scores$ScoredLabels <- predict(model, newdata = scores)
}

