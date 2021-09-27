###############################
# Processing Script 2 - ProcessingScriptIbisFieldData.R
#This processing script cleans and processes the IbisFieldDataOct19_2017 datasheet, which contains
#field data regarding the sampled ibis for Haemoproteus parasitemia

###############################Loading all required packages###########################
library(here) #to set paths
library(tidyverse) #all required data manipulation packages
library(xlsx) #to read in excel spreadsheets
library(lubridate) #to extract times from raw data
library(janitor) #to help clean up dates and tidy data

#--------------------------------------------------------------------------------------#

##################################Inputting Raw Data###################################
#Setting the path to the Ibis field data spreadsheet
data_locationIbisF <- here::here("data","raw_data","IbisFieldDataOct19_2017.xlsx")
#Loads the raw Ibis field data excel sheet
rdIbisField <- read.xlsx(data_locationIbisF, sheetName = "All capture data")

#--------------------------------------------------------------------------------------#

######################### #Cleaning the rdIbisField Data###############################

IbisField <- rename(rdIbisField, ID = ID..NSFSITE...) #renames the ID column

#Selecting the columns of interest to this analysis from the datasheet
IbisField <- select(IbisField,ID,Site.Name,Latitude,Longitude,Date,PCR.Sex,Age,Season,
                    Habitat.type,Ibis.number,Mass.bird..g.,Body.condition.score..1.5.,
                    Ectoparasite.score..1.5.,Culmen.length..mm.,Wing.chord.length..mm.,
                    Tarsus.length..mm.,Tarsus.width..mm.,Habituation.score.of.flock..1.5.)

#Renaming the columns of interest, also matching the other cleaned datasets
IbisField <- rename(IbisField,Site = Site.Name,Lat = Latitude,Long = Longitude,Sex = PCR.Sex,
                    HabType = Habitat.type,IbisNum = Ibis.number,BirdMassG = Mass.bird..g.,
                    BodyCondScore = Body.condition.score..1.5.,EctoParasitScore = Ectoparasite.score..1.5.,
                    CulmenLmm = Culmen.length..mm.,WingChordLmm = Wing.chord.length..mm.,
                    TarsusLmm = Tarsus.length..mm.,TarsusWmm = Tarsus.width..mm.,HabFlockScore = Habituation.score.of.flock..1.5.)

#This dataset has "-999" values which mean they are intentionally left blank,
#Birds with an ID number of "-999" represent sites that didn't catch any birds,
#but had weather data collected. This code deletes those observations.
IbisField <- IbisField[!(IbisField$ID == "-999"),]

####Site
#These site location abbreviations are the same across datasets
IbisField$Site[IbisField$Site == "Busch Wildlife Sanctuary"] <- "BWS"
IbisField$Site[IbisField$Site == "Cat House (Bonnie's, Richard Lane)"] <- "CAT"
IbisField$Site[IbisField$Site == "Dubois Park"] <- "DUP"
IbisField$Site[IbisField$Site == "DuBois Park"] <- "DUP"
IbisField$Site[IbisField$Site == "Dreher Park"] <- "DRP"
IbisField$Site[IbisField$Site == "Fisheating Creek"] <- "FC"
IbisField$Site[IbisField$Site == "Green Cay"] <- "GC"
IbisField$Site[IbisField$Site == "Gaines Park"] <- "GP"
IbisField$Site[IbisField$Site == "Indian Creek"] <- "ICP"
IbisField$Site[IbisField$Site == "Juno Beach"] <- "JB"
IbisField$Site[IbisField$Site == "Juno Beach "] <- "JB"
IbisField$Site[IbisField$Site == "J.W. Corbett Wildlife Management Area"] <- "JWC"
IbisField$Site[IbisField$Site == "Kitching Creek"] <- "KC"
IbisField$Site[IbisField$Site == "Lion Country Safari"] <- "LCS"
IbisField$Site[IbisField$Site == "Lake Worth"] <- "LW"
IbisField$Site[IbisField$Site == "Loxahatchee Slough"] <- "LOXS"
IbisField$Site[IbisField$Site == "Loxahatchee Wildlife Refuge"] <- "LOXWR"
IbisField$Site[IbisField$Site == "Loxahatchee/LILA Cell B2"] <- "LOXB2"
IbisField$Site[IbisField$Site == "Loxahatchee NE "] <- "LOXNE"
IbisField$Site[IbisField$Site == "Palm Beach Zoo"] <- "WPBZ"
IbisField$Site[IbisField$Site == "Royal Palm"] <- "RP"
IbisField$Site[IbisField$Site == "CROW Wildlife Rehabilitation Center"] <- "CROW"
IbisField$Site[IbisField$Site == "Solid Waste Authority"] <- "SWA"
IbisField$Site[IbisField$Site == "TetraTech"] <- "TT"

####Sex Column
#This replaces the -999 and FAIL values with NA. The IbisBlood datasheets carry more sex data for the birds
IbisField$Sex[IbisField$Sex == "FAIL"] <- NA

####Age Column
IbisField$Age[IbisField$Age == "Adult"] <- "A"
IbisField$Age[IbisField$Age == "3rd year"] <- "J"
IbisField$Age[IbisField$Age == "2nd year"] <- "J"
IbisField$Age[IbisField$Age == "1st year"] <- "J"
IbisField$Age[IbisField$Age == "NA"] <- NA
IbisField$Age[IbisField$Age == "Adult "] <- "A"
IbisField$Age[IbisField$Age == "2nd year "] <- "J"
IbisField$Age[IbisField$Age == "Juvenile"] <- "J"
IbisField$Age[IbisField$Age == "2nd Year"] <- "J"

#Replacing all -999 values in the dataset with NA
IbisField[IbisField == -999] <- NA

#Replacing NA text strings with regular NA values in multiple columns
IbisField$BodyCondScore[IbisField$BodyCondScore == "NA"] <- NA
IbisField$HabFlockScore[IbisField$HabFlockScore == "NA"] <- NA
IbisField$CulmenLmm[IbisField$CulmenLmm == "NA"] <- NA
IbisField$WingChordLmm[IbisField$WingChordLmm == "NA"] <- NA
IbisField$TarsusLmm[IbisField$TarsusLmm == "NA"] <- NA
IbisField$TarsusWmm[IbisField$TarsusWmm == "NA"] <- NA

#--------------------------------------------------------------------------------------#

###############################Saving the Cleaned Dataset###############################

save_data_location3 <- here::here("data", "processed_data", "processedIbisFielddata.rds")
saveRDS(IbisField, file = save_data_location3)

