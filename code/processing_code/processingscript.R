###############################
# Processing Script


########Loading all required packages
library(here) #to set paths
library(tidyverse) #all required data manipulation packages
library(xlsx) #to read in excel spreadsheets
library(lubridate) #to extract times from raw data
library(janitor) #to help clean up dates and tidy data

########Inputting all the raw data into R
#Setting the path to the Ibis blood parasite spreadsheet
data_locationIbisB <- here::here("data","raw_data","Ibis_Blood_ParasiteData_2017.xlsx")
#Loads the raw Ibis blood data excel sheet from 2015-2017
rdIbisBlood15_17 <- read.xlsx(data_locationIbisB, sheetName = "2015-2017")
#Loads the raw Ibis blood data excel sheet from 2010-2014
rdIbisBlood10_14 <- read.xlsx(data_locationIbisB, sheetName = "2010-2014")
#Setting the path to the Ibis field data spreadsheet
data_locationIbisF <- here::here("data","raw_data","IbisFieldDataOct19_2017.xlsx")
#Loads the raw Ibis field data excel sheet
rdIbisField <- read.xlsx(data_locationIbisF, sheetName = "All capture data")
#Setting the path to the first Ibis supplemental excel sheet (Urban Gradients)
data_locationIbisUr <- here::here("data","raw_data","100IbisID_UrbanGradient.xlsx")
#Loads the raw Ibis Urban Gradient supplemental data sheet
UrbanIbis <- read.xlsx(data_locationIbisUr, sheetName = "Samples by Date")
#Setting the path to the second Ibis supplemental excel sheet (Salmonella)
data_locationIbisSal <- here::here("data","raw_data","SalmonellaFieldSerotypesAug27_2018.xlsx")
#Loads the raw Ibis Urban Gradient supplemental data sheet
SalIbis <- read.xlsx(data_locationIbisSal, sheetName = "ALL Positives")

########Tidying the rdIbisBlood10_14 data
IbisBlood10_14 <- rename(rdIbisBlood10_14, ID = X.) #renames the ID column

#Extracts just the columns of interest
IbisBlood10_14 <- select(IbisBlood10_14, ID, Site.ID, Date, PCR.sex, Age..adult.juvenile., 
                         Total.RBC, Haemoproteus.parasitemia.)

#Renames the columns of interest
IbisBlood10_14 <- rename(IbisBlood10_14, Site = Site.ID, Sex = PCR.sex, Age = Age..adult.juvenile.,
                         TotalRBC = Total.RBC, HaeParasit = Haemoproteus.parasitemia.)

#Change "adult" and "juvenile" in the Age column to "A" and "J"
IbisBlood10_14$Age[IbisBlood10_14$Age == "adult"] <- "A"
IbisBlood10_14$Age[IbisBlood10_14$Age == "Adult"] <- "A"
IbisBlood10_14$Age[IbisBlood10_14$Age == "juvenile"] <- "J"
IbisBlood10_14$Age[IbisBlood10_14$Age == "SA"] <- "A"
#Now the Ibises that had age recorded are referred to as "A" for adult or "J" for juvenile


#Changing the DIV/0 values in HaeParasit to NA and change the column to numerical values
IbisBlood10_14$HaeParasit <- as.numeric(IbisBlood10_14$HaeParasit)  # Divide-by-zero errors are now NA

#Reformatting the date values in the Date column
IbisBlood10_14$Date <- excel_numeric_to_date(IbisBlood10_14$Date)
#After this step, the values that just state the year are labelled with "1905", may need to go back or exclude from analysis

#Abbreviating the site names to make analysis easier
IbisBlood10_14$Site[IbisBlood10_14$Site == "Royal Palms"] <- "RP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Everglades"] <- "E"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Dreher Park"] <- "DP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Indian Creek"] <- "ICP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Indian Creek "] <- "ICP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Indian Creek Park"] <- "ICP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Juno Beach"] <- "JB"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Lion Country Safari"] <- "LCS"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Lake Worth"] <- "LW"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Prosperity Oaks"] <- "PO"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Promenade Plaza"] <- "PP"
IbisBlood10_14$Site[IbisBlood10_14$Site == "San Mateo"] <- "SM"
IbisBlood10_14$Site[IbisBlood10_14$Site == "Solid Waste Authority"] <- "SWA"
IbisBlood10_14$Site[IbisBlood10_14$Site == "West Palm Beach Zoo"] <- "WPBZ"


