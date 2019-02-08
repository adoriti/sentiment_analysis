# -----------------  Code Summary --------------------------
#
#  Sentiment analysis
#  Developer: Afroditi Doriti
#  Version: 1
#  last Version:  08/01/2019
#  Function: Sentiment analysis of phone reviews
#  Related scripts:
#  Reviewer:
#  date of review:
#
#  source of the data:
#
#-------------------Outputs---------------------------------
#
#

# Load packages ----
library("doParallel")
library("tidyverse")
library("plotly")
library("corrplot")

# Set up doParallel ----
# Find how many cores are on your machine
detectCores() # Result = Typically 4 to 6

# Create Cluster with desired number of cores. Don't use them all! Your computer is running other processes.
cl <- makeCluster(2)

# Register Cluster
registerDoParallel(cl)

# Confirm how many cores are now "assigned" to R and RStudio
getDoParWorkers() # Result 2

# Set wd and load files ----
setwd("C:\\Users\\ASUS\\Documents\\Ubiqum\\Big Data AWS")
iphone_file <- "iphone_smallmatrix_labeled_8d.csv"

# read file for iphone
iphone <- read.csv(iphone_file)

# check structure of the dataframe and reviews for iphone characteristics
str(iphone)
summary(iphone)
plot_ly(iphone, x = ~ iphonesentiment, type = 'histogram')
plot_ly(iphone, x = ~ iphonecampos, type = "histogram")
plot_ly(iphone, x = ~ iphonecamneg, type = "histogram")

# check for missing values
any(is.na(iphone)) # Gives FALSE

# increase the max print limit
options(max.print=1000000)

# check for correlations
correlations <- cor(iphone)
correlations
corrplot(correlations)

# sort correlations
correlations[lower.tri(correlations,diag=TRUE)]=NA  #Prepare to drop duplicates and meaningless information
correlations <- as.data.frame(as.table(correlations))  #Turn into a 3-column table
correlations <- na.omit(correlations)  #Get rid of the junk we flagged above
correlations <- correlations[order(-abs(correlations$Freq)),]    #Sort by highest correlation (whether +ve or -ve)
head(correlations, 50)

# Stop doParallel ----
# Stop Cluster. After performing your tasks, stop your cluster.
stopCluster(cl)