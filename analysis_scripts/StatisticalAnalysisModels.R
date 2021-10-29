###############################################################################
# Statistical Analysis Script
#
#This script loads the processed data and runs the statistical analyses for the project.
#This includes creating and saving all models, figures, and tables associated with the analysis.

###############################Loading all required packages###########################
library(here) #to set paths
library(tidyverse) #all required data manipulation packages
library(lubridate) #work with date/time data
library(tidymodels) #to run the statistical analyses
library(ranger) #implementation of random forests

set.seed(144)
#--------------------------------------------------------------------------------------#

###########################Loading Data for Analysis##############################
data_location5 <- here::here("processed_data","CompleteIbisDataset.rds")

IbisC <- readRDS(data_location5)
#--------------------------------------------------------------------------------------#
############################################################################################################
################################Presence/Absence Data for Haemoproetus Parasitemia##########################
############################################################################################################

########This section is setting up models for categorical binomial presence absence data
#####Setting up Data Frame
#This extracts the columns we need for the analysis
IbisPAdf <- IbisC[c("HaeParasitPA", "Sex", "Age", "Site", "Season",
                    "BodyCondScore", "Date", "HabType", "BirdMassG")] #Extracts columns of interest

#Changing columns to factors for use in making models
IbisPAdf$HaeParasitPA <- as.factor(IbisPAdf$HaeParasitPA)
IbisPAdf$Sex <- as.factor(IbisPAdf$Sex)
IbisPAdf$Age <- as.factor(IbisPAdf$Age)
IbisPAdf$Site <- as.factor(IbisPAdf$Site)
IbisPAdf$Season <- as.factor(IbisPAdf$Season)
IbisPAdf$HabType <- as.factor(IbisPAdf$HabType)

#Changing date to numeric for the model
IbisPAdf$Date <- as.numeric(IbisPAdf$Date)

#Deleting sites that hinder the model, these sites have no presence of Haemoproteus #ERROR: factor Site has new levels CAT, E, SM, WPBZ
IbisPAdf <- subset(IbisPAdf, Site!="CAT" &
                     Site!="E" &
                     Site!="SM" &
                     Site!="WPBZ" )

#####################################Cross Validation and Model Preparation
###Cross-Validation Setup
#Splitting the data in an 80/20 proportion
data_split_log <- initial_split(IbisPAdf, 0.8)

#Creating the two data frames: Training data and test data
PATrainDF <- training(data_split_log) #Creating the training dataset
PATestDF <- testing(data_split_log) #Creating the testing dataset

#Resampling the data with 10-fold cross validation. Splits the training
#data into 10 samples to train the model
PAFolds <- vfold_cv(PATrainDF, v = 10)

#Binomial GLM model setup
log_mod1 <- logistic_reg() %>% set_engine("glm") %>% set_mode("classification") 

########################################Model Evaluation

###############ERROR: Still in progress of learning to fit the models to the test data.#################

##########################Univariate GLM classification models#######################################
######Model 1
#Recipe setup for model, Parasitemia P/A vs Habitat Type on training data
PA_rec1 <- recipe(HaeParasitPA ~ HabType, data = PATrainDF)

#Workflow Setup 1
PA_wf1 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec1)

###Fitting the Model
PA_fit1 <- PA_wf1 %>% fit_resamples(PAFolds)

Model1MetricsPA <- collect_metrics(PA_fit1)
#Accuracy = 0.545, roc_auc = 0.451

#Saving the results and table
saveRDS(PA_fit1, file = "results/Models/Model1PA.Rda")
saveRDS(Model1MetricsPA, file = "results/Tables/Model1MetricsPA.Rda")

######Model 2
#Recipe setup for model, Parasitemia P/A vs Sex on training data
PA_rec2 <- recipe(HaeParasitPA ~ Sex, data = PATrainDF)

#Workflow Setup 1
PA_wf2 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec2)

###Fitting the Model
PA_fit2 <- PA_wf2 %>% fit_resamples(PAFolds)

Model2MetricsPA <- collect_metrics(PA_fit2)
#Accuracy = 0.613, roc_auc = 0.525

#Saving the results and table
saveRDS(PA_fit2, file = "results/Models/Model2PA.Rda")
saveRDS(Model2MetricsPA, file = "results/Tables/Model2MetricsPA.Rda")

######Model 3
#Recipe setup for model, Parasitemia P/A vs Age on training data
PA_rec3 <- recipe(HaeParasitPA ~ Age, data = PATrainDF)

#Workflow Setup 1
PA_wf3 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec3)

###Fitting the Model
PA_fit3 <- PA_wf3 %>% fit_resamples(PAFolds)

Model3MetricsPA <- collect_metrics(PA_fit3)
#Accuracy = 0.595, roc_auc = 0.473

#Saving the results and table
saveRDS(PA_fit3, file = "results/Models/Model3PA.Rda")
saveRDS(Model3MetricsPA, file = "results/Tables/Model3MetricsPA.Rda")

######Model 4
#Recipe setup for model, Parasitemia P/A vs Site on training data
PA_rec4 <- recipe(HaeParasitPA ~ Site, data = PATrainDF)

#Workflow Setup 1
PA_wf4 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec4)

###Fitting the Model
PA_fit4 <- PA_wf4 %>% fit_resamples(PAFolds)
#####ERROR ON FOLD 4 AND 5

Model4MetricsPA <- collect_metrics(PA_fit4)
#Accuracy = 0.563, roc_auc = 0.564

#Saving the results and table
saveRDS(PA_fit4, file = "results/Models/Model4PA.Rda")
saveRDS(Model4MetricsPA, file = "results/Tables/Model4MetricsPA.Rda")
######Model 5
#Recipe setup for model, Parasitemia P/A vs Date on training data
PA_rec5 <- recipe(HaeParasitPA ~ Date, data = PATrainDF)

#Workflow Setup 1
PA_wf5 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec5)

###Fitting the Model
PA_fit5 <- PA_wf5 %>% fit_resamples(PAFolds)

Model5MetricsPA <- collect_metrics(PA_fit5)
#Accuracy = 0.545, roc_auc = 0.546

#Saving the results and table
saveRDS(PA_fit5, file = "results/Models/Model5PA.Rda")
saveRDS(Model5MetricsPA, file = "results/Tables/Model5MetricsPA.Rda")
######Model 6
#Recipe setup for model, Parasitemia P/A vs Date on training data
PA_rec6 <- recipe(HaeParasitPA ~ Season, data = PATrainDF)

#Workflow Setup 1
PA_wf6 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec6)

###Fitting the Model
PA_fit6 <- PA_wf6 %>% fit_resamples(PAFolds)

Model6MetricsPA <- collect_metrics(PA_fit6)
#Accuracy = 0.643, roc_auc = 0.676

#Saving the results and table
saveRDS(PA_fit6, file = "results/Models/Model6PA.Rda")
saveRDS(Model6MetricsPA, file = "results/Tables/Model6MetricsPA.Rda")
#############Multivariate GLM regression models###########
######Model 7
#Recipe setup for model, Parasitemia P/A vs Age and Sex on training data
PA_rec7 <- recipe(HaeParasitPA ~ Age + Sex, data = PATrainDF)

#Workflow Setup 7
PA_wf7 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec7)

###Fitting the Model
PA_fit7 <- PA_wf7 %>% fit_resamples(PAFolds)

Model7MetricsPA <- collect_metrics(PA_fit7)
#Accuracy = 0.662, roc_auc = 0.548

#Saving the results and table
saveRDS(PA_fit7, file = "results/Models/Model7PA.Rda")
saveRDS(Model7MetricsPA, file = "results/Tables/Model7MetricsPA.Rda")
######Model 8
#Recipe setup for model, Parasitemia P/A vs Season and Date on training data
PA_rec8 <- recipe(HaeParasitPA ~ Season + Date, data = PATrainDF)

#Workflow Setup 8
PA_wf8 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec8)

###Fitting the Model
PA_fit8 <- PA_wf8 %>% fit_resamples(PAFolds)

Model8MetricsPA <- collect_metrics(PA_fit8)
#Accuracy = 0.648, roc_auc = 0.689

#Saving the results and table
saveRDS(PA_fit8, file = "results/Models/Model8PA.Rda")
saveRDS(Model8MetricsPA, file = "results/Tables/Model8MetricsPA.Rda")

############################################################################################################
################################Continuous Data for Haemoproetus Parasitemia on a Log Scale 10##############
############################################################################################################
#This section is setting up Linear models for continuous haemoproteus parasitemia data
IbisHaeDF <- IbisC[c("HaeParasitLog10", "Sex", "Age", "Site", "Season",
                     "BodyCondScore", "Date", "HabType", "BirdMassG")]

#Drops the NA rows with no parasitemia data
IbisHaeDF <- IbisHaeDF %>%
  drop_na(HaeParasitLog10)

#Changing character columns to factors
IbisHaeDF$Sex <- as.factor(IbisHaeDF$Sex)
IbisHaeDF$Age <- as.factor(IbisHaeDF$Age)
IbisHaeDF$Site <- as.factor(IbisHaeDF$Site)
IbisHaeDF$Season <- as.factor(IbisHaeDF$Season)
IbisHaeDF$HabType <- as.factor(IbisHaeDF$HabType)

#Changing date to numeric
IbisHaeDF$Date <- as.numeric(IbisHaeDF$Date)

#Splitting the data in an 80/20 proportion
data_split_lin <- initial_split(IbisHaeDF, 0.8)

#Creating the two data frames: Training data and test data
HaeTrainDF <- training(data_split_lin) #Creating the training dataset
HaeTestDF <- testing(data_split_lin) #Creating the testing dataset

#Resampling the data with 10-fold cross validation. Splits the training
#data into 10 samples to train the model
HaeFolds <- vfold_cv(HaeTrainDF, v = 10)

#Building the random forest model
HaeForest <- rand_forest(trees = 100,
                         mode = "regression") %>%
                          set_engine("ranger")

#Building the linear model
lm_mod1 <- linear_reg() %>% set_engine("lm") %>% set_mode("regression")

########################Random Forest Model##########################
#Creating the recipe of all predictors vs HaeParasit. This also imputes
#missing data in the other columns in order to run the analyses using
#K nearest neighbors
HaeRec_rf <- recipe(HaeParasitLog10 ~ ., data = HaeTrainDF) %>%
  step_impute_knn(all_predictors()) %>%
  prep(stringsAsFactors = TRUE) 

#Setting the workflow
Haewf_rf <- workflow() %>%
  add_model(HaeForest) %>%
  add_recipe(HaeRec_rf)

#Fitting the model on the training data
HaeMod_rs_rf <- fit_resamples(Haewf_rf,
                                  resamples = HaeFolds,
                                  control = control_resamples(save_pred = TRUE))

RandomForestMetrics <- collect_metrics(HaeMod_rs_rf)
#rmse = 0.568, rsq = 0.238

#Saving the results and table
saveRDS(HaeMod_rs_rf, file = "results/Models/RandomForest1.Rda")
saveRDS(RandomForestMetrics, file = "results/Tables/RandomForestMetrics.Rda")
########################Linear Models#################################
#Setting the recipe
Hae_Rec1 <- recipe(HaeParasitLog10 ~ HabType, data = HaeTrainDF) 

#Setting the workflow
Hae_wf1 <- workflow() %>% add_model(lm_mod1) %>% add_recipe(Hae_Rec1)

#Fitting the model
Hae_fit1 <- Hae_wf1 %>% fit_resamples(HaeFolds)

#Saving the metrics
LinMetrics1 <- collect_metrics(Hae_fit1)

#Saving the results and table
saveRDS(Hae_fit1, file = "results/Models/Model9Lin.Rda")
saveRDS(LinMetrics1, file = "results/Tables/LinMetrics1.Rda")
