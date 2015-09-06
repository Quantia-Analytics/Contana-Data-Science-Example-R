# Cortana Analytics Conference Data Science Tutorial Example:   
## Forecasting with Azure ML and R


## Overview

This repository contains R code for a Microsoft Azure Machine Learning experiment used for the Data Science Example at the 2015 Cortana Analytics Conference. The experiment is in the [Microsoft Azure ML gallery](https://gallery.azureml.net/Experiment/e616740e68c647ba9bbefa663d037df5). 

The Azure ML experiment illustrates the basics of building and evaluating a regression forecasting machine learning model, using Azure Machine Learning and R. The goal of this experiment is to forecast the monthly milk production for the State of California. 

## Data

The data are contained in a .csv file. These data are derived from dairy production information published by the United States Department of Agriculture. The data set contains a  time series of dairy production data for several products, along with milk fat pricing, for 128 months.

## Code organization

The Azure ML experiment contains R code running in three Execute R Script modules. 

The milkutilities.R file contains utility functions used in the Execute R Script modules. 

Two columns containing the square and cube of the month count are computed in an Execute R Script module with the code in the transform.R file. These new features are used in a polynomial regression of the time series trend.  

The code milkvisualize.R file generates graphics for the visualization and exploration of the data set. Specifically, one can see that the time series has a strong trend. Further, these data exhibit a significant seasonal (monthly) variation. 

The splitdata.R file contains final bit of data munging code. This code divides the data into training and test sets. The last 12 months of milk production data are held back to test the forecasting power of our model. Note, the Split module would not work in this case, since it randomly samples the data.

The lmevaluate.R file contains code to compute summary statistics and visualize the model scoring (prediction) results.This information is used to evaluate model performance. 

The milklm.R and lmscore.R files contain code to compute an R linear model and predictions (scores) for that model. This code is used for testing in RStudio and to explore feature selection.  


