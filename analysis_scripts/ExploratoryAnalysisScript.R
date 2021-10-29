###############################
# Exploratory Analysis Script
#
#this script loads the processed and cleaned data and performs an initial 
#exploratory analysis on the data. This script will also include a section on variates/covariates
#and what questions to answer. Will combine into an Rmarkdown document for better visuals.


###############################Loading all required packages###########################

library(here) #to set paths
library(tidyverse) #all required data manipulation packages
library(lubridate) #work with date/time data
#--------------------------------------------------------------------------------------#

###############################Loading all datasets####################################
#This code loads all of the processed and cleaned Ibis data

data_location1 <- here::here("processed_data","processedIbisBlood10_14.rds")
data_location2 <- here::here("processed_data","processedIbisBlood15_17.rds")
data_location3 <- here::here("processed_data","processedIbisFielddata.rds")
data_location4 <- here::here("processed_data","processedIbisUrban.rds")

IbisBlood10_14 <- readRDS(data_location1)
IbisBlood15_17 <- readRDS(data_location2)
IbisField <- readRDS(data_location3)
IbisUrban <- readRDS(data_location4)

#--------------------------------------------------------------------------------------#

###############################Completing Combination Data Frames#########################
#Outer joining IbisBlood10_14 and IbisBlood15_17, keeping all values of the 10_14 dataset
IbisBlood10_17 <- merge(IbisBlood10_14, IbisBlood15_17, by = c("ID", "Site", "Date", "Sex", "Age",
                                                              "TotalRBC", "HaeParasit"), all=TRUE)
#There is no overlap in the ID numbers between the two, so no recapture is assumed.

#This is a left join, this data frame below only contains birds that were in the IbisBlood10_17
#dataset (all with parasitemia data), with additional information added by the IbisField data. Ibis
#from the Field data that weren't tested for parasitemia or weren't included on Blood dataset
#are not included in this dataframe

#IbisBlood10_17(with Field)_(Parasitemia data)
IbisC <- left_join(IbisBlood10_17, IbisField, by = c("ID", "Site", "Date", "Sex", "Age", "Season", "HabType",
                                                         "IbisNum", "BirdMassG", "BodyCondScore", "EctoParasitScore",
                                                         "CulmenLmm", "WingChordLmm", "TarsusLmm", "TarsusWmm"))

#This section classifies the habitat type for the sites without a habitat type.
IbisC <- IbisC %>%
        mutate(HabType = ifelse(Site == "ICP", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "JB", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "RP", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "LCS", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "LW", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "SWA", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "E", "Natural", HabType)) %>%
        mutate(HabType = ifelse(Site == "WPBZ", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "PO", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "PP", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "DRP", "Urban", HabType)) %>%
        mutate(HabType = ifelse(Site == "SM", "Urban", HabType))
  
  
##This section is adding in the seasons for observations that have collection dates but no season.

#Creating intervals for adding seasons based on the date column
int1 <- interval(ymd("2012-12-01"), ymd("2012-12-31"))
int2 <- interval(ymd("2013-06-01"), ymd("2013-08-31"))
int3 <- interval(ymd("2013-12-01"), ymd("2013-12-31"))
int4 <- interval(ymd("2014-02-01"), ymd("2014-03-31"))

#Adding seasons to the ibis without them stated based on the date the sameple was collected
IbisC <- IbisC %>%
         mutate(Season = ifelse(Date %within% int1, "Fall 2012", Season)) %>%
         mutate(Season = ifelse(Date %within% int2, "Summer 2013", Season)) %>%
         mutate(Season = ifelse(Date %within% int3, "Fall 2013", Season)) %>%
         mutate(Season = ifelse(Date %within% int4, "Spring 2014", Season))


#Adding a column for HaeParasit Presence/Absence data
IbisC <- IbisC %>%
    mutate(HaeParasitPA = as.integer(HaeParasit > 0 & !is.na(HaeParasit)))

#Adding a column for transformed HaeParasit data on a logarithm base 10 scale,
#then removing the -Inf values due to there being no parasitemia in those birds. This column
#then only contains logarithm transformed parasitemia data for birds with a positive value
#of parasitemia.
IbisC <- IbisC %>%
    mutate(HaeParasitLog10 = log10(HaeParasit)) %>%
    mutate(HaeParasitLog10 = ifelse(HaeParasitLog10 == "-Inf", NA, HaeParasitLog10))

#Changing the BodyCondScore to an ordinal scale and rounding up two values in dataset
IbisC$BodyCondScore[IbisC$BodyCondScore == "2.5"] <- "3"
IbisC$BodyCondScore[IbisC$BodyCondScore == "1.5"] <- "2" 
IbisC <- IbisC %>%
      mutate(BodyCondScore = recode_factor(BodyCondScore, '1' = 'Emaciated',
                                           '2' = 'Underweight', '3' = 'Ideal',
                                           '4' = 'Overweight', '5' = 'Obese',
                                           .ordered = TRUE))
      
#Changing the class of some variables for analysis. From character to numeric.
C2N <- c(16,17,18,21,22,23,24)

IbisC[ , C2N] <- apply(IbisC[ , C2N], 2,
                       function(x) as.numeric(as.character(x)))

##############################Saving the Complete Dataset#########################

save_data_location <- here::here("processed_data", "CompleteIbisDataset.rds")

saveRDS(IbisC, file = save_data_location)

###############################Exploratory Tables#################################
IbisC %>%
count(Sex, wt = HaeParasitPA)

IbisC %>%
  count(Age, wt = HaeParasitPA)

IbisC %>%
  count(Age, Sex, wt = HaeParasitPA)

IbisC %>%
  count(Site, wt = HaeParasitPA)

IbisC %>%
  count(Season, wt = HaeParasitPA)

IbisC %>%
  count(BodyCondScore, Age, wt = HaeParasitPA)

################################Exploratory Graphs#####################################
########Plot 1
ExpFigure1 <-ggplot(IbisC) +
  geom_point(aes(x = Date, y = HaeParasitLog10, color = HabType)) +
  ggtitle("Haemoproteus parasitemia from sampled infected Ibises from 2010-2017 by habitat type") +
  xlab("Date") +
  ylab("Haemoproteus Parasitemia (Log base 10)") +
  scale_color_discrete("Habitat Type", na.translate = F) +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10))

Figure_file1 <- here("results", "Figures", "ExpFigure1.png")
ggsave(filename = Figure_file1,plot = ExpFigure1)

#########Plot 2: Violin plot of haemoproteus parasitemia vs adult and juvenile

ExpFigure2 <- IbisC %>%
  drop_na(Age) %>%
  ggplot() +
  geom_violin(aes(x = Age, y = HaeParasit)) +
  ggtitle("Haemoproteus parasitemia from adult and juvenile sampled Ibises") +
  xlab("Age") +
  ylab("Haemoproteus Parasitemia") +
  scale_y_continuous(limits = c(0, 0.1)) +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10))

Figure_file2 <- here("results", "Figures", "ExpFigure2.png")
ggsave(filename = Figure_file2, plot = ExpFigure2)

#########Plot 3: Boxplot of haemoproteus parasitemia vs sex

ExpFigure3 <- IbisC %>%
  drop_na(Sex) %>%
  ggplot() +
  geom_boxplot(aes(x = Sex, y = HaeParasit)) +
  scale_y_continuous(limits = c(0, 0.5)) +
  ggtitle("Haemoproteus parasitemia from sampled Ibises by sex") +
  xlab("Sex") +
  ylab("Haemoproteus Parasitemia") +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10))

Figure_file3 <- here("results", "Figures", "ExpFigure3.png")
ggsave(filename = Figure_file3, plot = ExpFigure3)

##########Plot 4: Scatterplot of haemoproteus parasitemia vs bird weight with sex
ExpFigure4 <- IbisC %>%
  drop_na(BirdMassG, Sex) %>%
  ggplot() +
  geom_point(aes(x = BirdMassG, y = HaeParasitLog10, color = Sex)) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_continuous(limits = c(130, 1240)) +
  ggtitle("Haemoproteus parasitemia by total female and male Ibis mass") +
  xlab("Total mass of Ibis (g)") +
  ylab("Haemoproteus Parasitemia (Log base 10)") +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10))

Figure_file4 <- here("results", "Figures", "ExpFigure4.png")
ggsave(filename = Figure_file4, plot = ExpFigure4)

##########Plot 5: Scatterplot of haemoproteus parasitemia vs bird weight with body condition score

ExpFigure5 <- IbisC %>%
  drop_na(BirdMassG, BodyCondScore, Sex) %>%
  ggplot() +
  geom_point(aes(x = BirdMassG, y = HaeParasitLog10, color = BodyCondScore)) +
  facet_wrap(~ Sex) +
  ggtitle("Haemoproteus parasitemia by female and male Ibis mass and body condition score") +
  xlab("Total mass of Ibis (g)") +
  ylab("Haemoproteus Parasitemia (Log base 10)") +
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10)) +
  scale_x_continuous(limits = c(130, 1240)) +
  scale_color_discrete("Body Condition", na.translate = F)

Figure_file5 <- here("results", "Figures", "ExpFigure5.png")
ggsave(filename = Figure_file5, plot = ExpFigure5)

###########Plot 6: Scatterplot of haemoptroteus parasitemia vs sample site and habitat type
ExpFigure6 <- IbisC %>%
  drop_na(HabType, Site) %>%
  ggplot() +
  geom_point(aes(x = Site, y = log10(HaeParasit), color = HabType)) +
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        legend.title = element_text(size = 10)) +
  ggtitle("Haemoproteus parasitemia by sample site and habitat type") +
  xlab("Sample Site") +
  ylab("Haemoproteus Parasitemia (Log base 10)") +
  scale_color_discrete("Habitat Type", na.translate = F) 

Figure_file6 <- here("results", "Figures", "ExpFigure6.png")
ggsave(filename = Figure_file6, plot = ExpFigure6)





