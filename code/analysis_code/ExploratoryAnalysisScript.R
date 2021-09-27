###############################
# Exploratory Analysis Script
#
#this script loads the processed and cleaned data and performs an intitial 
#exploratory analysis on the data. This script will also include a section on variates/covariates
#and what questions to answer. Will combine into an Rmarkdown document for better visuals


###############################Loading all required packages###########################

library(here) #to set paths
library(tidyverse) #all required data manipulation packages

#--------------------------------------------------------------------------------------#

###############################Loading all datasets####################################
#This code loads all of the processed and cleaned Ibis data

data_location1 <- here::here("data","processed_data","processedIbisBlood10_14.rds")
data_location2 <- here::here("data","processed_data","processedIbisBlood15_17.rds")
data_location3 <- here::here("data","processed_data","processedIbisFielddata.rds")
data_location4 <- here::here("data","processed_data","processedIbisUrban.rds")

IbisBlood10_14 <- readRDS(data_location1)
IbisBlood15_17 <- readRDS(data_location2)
IbisField <- readRDS(data_location3)
IbisUrban <- readRDS(data_location4)

#--------------------------------------------------------------------------------------#

####Variates/Covariates



















