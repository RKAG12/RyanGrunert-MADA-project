###################
#Processing Script 3 - 100IbisID_UrbanGradient
#This script loads and cleans the Urbanization dataset for the Ibis parasitemia data.

###############################Loading all required packages###########################
library(here) #to set paths
library(tidyverse) #all required data manipulation packages
library(xlsx) #to read in excel spreadsheets
library(lubridate) #to extract times from raw data
library(janitor) #to help clean up dates and tidy data

#--------------------------------------------------------------------------------------#

##################################Inputting Raw Data###################################
#Setting the path to the first Ibis supplemental excel sheet (Urban Gradients)
data_locationIbisUr <- here::here("data","raw_data","100IbisID_UrbanGradient.xlsx")
#Loads the raw Ibis Urban Gradient supplemental data sheet
rdUrbanIbis <- read.xlsx(data_locationIbisUr, sheetName = "Samples by Date")

#--------------------------------------------------------------------------------------#

##############################Cleaning the rdUrbanIbis data###########################
#Selects only the columns of interest in the dataset
IbisUrban <- select(rdUrbanIbis, Name:Serotype)

#Renames the columns of interest
IbisUrban <- rename(IbisUrban,ID = Name,Date = Collection.Date,HgPPM = mg.kg.Hg..PPM.,
                    Site = Site.Name,UrbanPercent = Site...Urbanized)

#Change the site names to their abbreviations
IbisUrban$Site[IbisUrban$Site == "Juno Beach"] <- "JB"
IbisUrban$Site[IbisUrban$Site == "Indian Creek"] <- "ICP"
IbisUrban$Site[IbisUrban$Site == "Dubois Park"] <- "DUP"
IbisUrban$Site[IbisUrban$Site == "Dreher Park"] <- "DRP"
IbisUrban$Site[IbisUrban$Site == "Lion Country Safari"] <- "LCS"
IbisUrban$Site[IbisUrban$Site == "Loxahatchee Wildlife Refuge"] <- "LOXWR"
IbisUrban$Site[IbisUrban$Site == "Solid Waste Authority "] <- "SWA"
IbisUrban$Site[IbisUrban$Site == "Gaines Park"] <- "GP"
IbisUrban$Site[IbisUrban$Site == "Kitching Creek"] <- "KC"
IbisUrban$Site[IbisUrban$Site == "Kitching Creek "] <- "KC"
IbisUrban$Site[IbisUrban$Site == "Loxahatchee NE"] <- "LOXNE"
IbisUrban$Site[IbisUrban$Site == "TetraTech"] <- "TT"
IbisUrban$Site[IbisUrban$Site == "Loxahatchee NE "] <- "LOXNE"
IbisUrban$Site[IbisUrban$Site == "Green Cay"] <- "GC"
IbisUrban$Site[IbisUrban$Site == "J.W. Corbett Wildlife Management Area"] <- "JWC"
IbisUrban$Site[IbisUrban$Site == "Loxahatchee Slough"] <- "LOXS"
IbisUrban$Site[IbisUrban$Site == "Lake Worth"] <- "LW"

#--------------------------------------------------------------------------------------#

################################Saving the UrbanIbis Data#############################
#Saving the Ibis Blood 15-17 dataset as an RDS in the processed data folder
save_data_location3 <- here::here("data", "processed_data", "processedIbisUrban.rds")
saveRDS(IbisUrban, file = save_data_location3)

#--------------------------------------------------------------------------------------#







