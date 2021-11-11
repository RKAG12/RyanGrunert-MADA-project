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
library(vip) #For plotting decision tree model
library(rpart) #For plotting machine learning models
library(rpart.plot) #For plotting machine learning models
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

#####################################Cross Validation Preperation#####################################
###Cross-Validation Setup
#Splitting the data in an 80/20 proportion
data_split_log <- initial_split(IbisPAdf, 0.8)

#Creating the two data frames: Training data and test data
PATrainDF <- training(data_split_log) #Creating the training dataset
PATestDF <- testing(data_split_log) #Creating the testing dataset

#Resampling the data with 10-fold cross validation. Splits the training
#data into 10 samples to train the model
PAFolds <- vfold_cv(PATrainDF, v = 10, repeats = 5)

#####################################Null Model Setup################################################

#sets the basic linear model for training data
null_mod <- logistic_reg() %>% set_engine("glm") %>% set_mode("classification")

#recipe for the null model on training data
nullrecTrain <- recipe(HaeParasitPA ~ 1, data = PATrainDF)

#workflow for null model on training data
null_wf <- workflow() %>% add_model(null_mod) %>% add_recipe(nullrecTrain)

#fits the model to the training data
FitNullTrainMod <- fit_resamples(null_wf, resamples = PAFolds)

#Save the metrics from the null model
NullTrainMetrics <- collect_metrics(FitNullTrainMod)

#recipe for the null model on training data
nullrecTest <- recipe(HaeParasitPA ~ 1, data = PATestDF)

#workflow for null model on training data
null_wf2 <- workflow() %>% add_model(null_mod) %>% add_recipe(nullrecTest)

#fits the model to the training data
FitNullTestMod <- fit_resamples(null_wf2, resamples = PAFolds)

#Save the metrics from the null model
NullTestMetrics <- collect_metrics(FitNullTestMod)

saveRDS(FitNullTrainMod, file = "results/Models/NullTrainMod.Rda")
saveRDS(NullTrainMetrics, file = "results/Tables/NullTrainMetrics.Rda")

saveRDS(FitNullTestMod, file = "results/Models/NullTestMod.Rda")
saveRDS(NullTestMetrics, file = "results/Tables/NullTestMetrics.Rda")


##########################Univariate GLM classification models#######################################
#Binomial GLM classification model setup
log_mod1 <- logistic_reg() %>% set_engine("glm") %>% set_mode("classification")

######Model 1 - Age
#Recipe setup for model, Parasitemia P/A vs Age on training data
PA_rec1_glm <- recipe(HaeParasitPA ~ Age, data = PATrainDF)

#Workflow Setup 1
PA_wf1 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec1_glm)

###Fitting the Model
PA_fit1 <- PA_wf1 %>% fit_resamples(PAFolds)

Model1MetricsPA <- collect_metrics(PA_fit1)
#Accuracy = 0.545, roc_auc = 0.451

#Saving the results and table
saveRDS(PA_fit1, file = "results/Models/Model1PA.Rda")
saveRDS(Model1MetricsPA, file = "results/Tables/Model1MetricsPA.Rda")



######Model 2 - Sex
#Recipe setup for model, Parasitemia P/A vs Sex on training data
PA_rec2_glm <- recipe(HaeParasitPA ~ Sex, data = PATrainDF)

#Workflow Setup 1
PA_wf2 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec2_glm)

###Fitting the Model
PA_fit2 <- PA_wf2 %>% fit_resamples(PAFolds)

Model2MetricsPA <- collect_metrics(PA_fit2)
#Accuracy = 0.606, roc_auc = 0.534

#Saving the results and table
saveRDS(PA_fit2, file = "results/Models/Model2PA.Rda")
saveRDS(Model2MetricsPA, file = "results/Tables/Model2MetricsPA.Rda")



######Model 3
#Recipe setup for model, Parasitemia P/A vs Site on training data
PA_rec3_glm <- recipe(HaeParasitPA ~ Site, data = PATrainDF)

#Workflow Setup 1
PA_wf3 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec3_glm)

###Fitting the Model
PA_fit3 <- PA_wf3 %>% fit_resamples(PAFolds)

Model3MetricsPA <- collect_metrics(PA_fit3)
#Accuracy = 0.584, roc_auc = 0.594

#Saving the results and table
saveRDS(PA_fit3, file = "results/Models/Model3PA.Rda")
saveRDS(Model3MetricsPA, file = "results/Tables/Model3MetricsPA.Rda")



######Model 4
#Recipe setup for model, Parasitemia P/A vs Season on training data
PA_rec4_glm <- recipe(HaeParasitPA ~ Season, data = PATrainDF)

#Workflow Setup 1
PA_wf4 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec4_glm)

###Fitting the Model
PA_fit4 <- PA_wf4 %>% fit_resamples(PAFolds)
#####ERROR ON FOLD 4 AND 5

Model4MetricsPA <- collect_metrics(PA_fit4)
#Accuracy = 0.639, roc_auc = 0.656

#Saving the results and table
saveRDS(PA_fit4, file = "results/Models/Model4PA.Rda")
saveRDS(Model4MetricsPA, file = "results/Tables/Model4MetricsPA.Rda")



######Model 5
#Recipe setup for model, Parasitemia P/A vs Date on training data
PA_rec5_glm <- recipe(HaeParasitPA ~ Date, data = PATrainDF)

#Workflow Setup 1
PA_wf5 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec5_glm)

###Fitting the Model
PA_fit5 <- PA_wf5 %>% fit_resamples(PAFolds)

Model5MetricsPA <- collect_metrics(PA_fit5)
#Accuracy = 0.539, roc_auc = 0.549

#Saving the results and table
saveRDS(PA_fit5, file = "results/Models/Model5PA.Rda")
saveRDS(Model5MetricsPA, file = "results/Tables/Model5MetricsPA.Rda")



######Model 6
#Recipe setup for model, Parasitemia P/A vs HabType on training data
PA_rec6_glm <- recipe(HaeParasitPA ~ HabType, data = PATrainDF)

#Workflow Setup 1
PA_wf6 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec6_glm)

###Fitting the Model
PA_fit6 <- PA_wf6 %>% fit_resamples(PAFolds)

Model6MetricsPA <- collect_metrics(PA_fit6)
#Accuracy = 0.535, roc_auc = 0.476

#Saving the results and table
saveRDS(PA_fit6, file = "results/Models/Model6PA.Rda")
saveRDS(Model6MetricsPA, file = "results/Tables/Model6MetricsPA.Rda")


######Model 7
#Recipe setup for model, Parasitemia P/A vs BirdMassG on training data
PA_rec7_glm <- recipe(HaeParasitPA ~ BirdMassG, data = PATrainDF)

#Workflow Setup 1
PA_wf7 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec7_glm)

###Fitting the Model
PA_fit7 <- PA_wf7 %>% fit_resamples(PAFolds)

Model7MetricsPA <- collect_metrics(PA_fit7)
#Accuracy = 0.627, roc_auc = 0.511

#Saving the results and table
saveRDS(PA_fit7, file = "results/Models/Model7PA.Rda")
saveRDS(Model7MetricsPA, file = "results/Tables/Model7MetricsPA.Rda")




##########################Multivariate GLM regression models#############################

######Model 8
#Recipe setup for model, Parasitemia P/A vs Age and Sex on training data
PA_rec8_glm <- recipe(HaeParasitPA ~ Season + Date, data = PATrainDF)

#Workflow Setup 7
PA_wf8 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec8_glm)

###Fitting the Model
PA_fit8 <- PA_wf8 %>% fit_resamples(PAFolds)

Model8MetricsPA <- collect_metrics(PA_fit8)
#Accuracy = 0.624, roc_auc = 0.668

#Saving the results and table
saveRDS(PA_fit8, file = "results/Models/Model8PA.Rda")
saveRDS(Model8MetricsPA, file = "results/Tables/Model8MetricsPA.Rda")


######Model 9
#Recipe setup for model, Parasitemia P/A vs Date and Site on training data
PA_rec9_glm <- recipe(HaeParasitPA ~ Date + Site, data = PATrainDF)

#Workflow Setup 8
PA_wf9 <- workflow() %>% add_model(log_mod1) %>% add_recipe(PA_rec9_glm)

###Fitting the Model
PA_fit9 <- PA_wf9 %>% fit_resamples(PAFolds)

Model9MetricsPA <- collect_metrics(PA_fit9)
#Accuracy = 0.590, roc_auc = 0.608

#Saving the results and table
saveRDS(PA_fit9, file = "results/Models/Model9PA.Rda")
saveRDS(Model9MetricsPA, file = "results/Tables/Model9MetricsPA.Rda")

#Main conclusion is that the date
#is most significant in predicting whether or not the ibis
#gets parasitemia. 

###################################Machine Learning Model Setup##########################
#Decision Tree Model Setup
dt_mod1 <- decision_tree(cost_complexity = tune(),tree_depth = tune()) %>% 
  set_engine("rpart") %>% 
  set_mode("classification")

#LASSO Model Setup
lasso_mod1 <- logistic_reg(penalty = tune(), mixture = 1) %>%
  set_engine("glmnet") %>% set_mode("classification")

#Random Forest Model Setup
rf_mod1 <- rand_forest(mtry = tune(), min_n = tune(), trees = 500) %>% 
                         set_engine("ranger", importance = "impurity") %>% 
                         set_mode("classification")

#Set Presence absence recipe setup for models. These impute the missing values
#using K nearest neighbors and then setup dummy predictors for all of the
#nominal predictors

#All predictors
PA_rec1 <- recipe(HaeParasitPA ~ ., data = PATrainDF) %>%
  step_impute_knn(all_predictors()) %>%
  step_dummy(all_nominal_predictors()) 

######################################ML Model Evaluation#################################

########################Decision Tree######################
#tuning grid specification
dt_grid <- grid_regular(cost_complexity(), tree_depth(), levels = 5)

#Workflow for the decision tree
dt_wf <- workflow() %>% add_model(dt_mod1) %>% add_recipe(PA_rec1)

#Tuning the model for the decision tree
dt_fit1 <- dt_wf %>% tune_grid(resamples = PAFolds, grid = dt_grid)

collect_metrics(dt_fit1)
dt_fit1 %>% autoplot()

#Choosing best model
best_dt <- dt_fit1 %>% select_best("roc_auc")

#Finalizing the workflow with best model
final_dt_wf <- dt_wf %>% finalize_workflow(best_dt)

#Fitting best model to training data
final_dt_fit <- final_dt_wf %>% last_fit(data_split_log)

ModelDTMetricsPA <- collect_metrics(final_dt_fit)

saveRDS(final_dt_fit, file = "results/Models/FinalDTFit.Rda")
saveRDS(ModelDTMetricsPA, file = "results/Tables/ModelDTMetrics.Rda")


#Diagnostic Plots
DTTree <- rpart.plot(extract_fit_parsnip(final_dt_fit)$fit)
saveRDS(DTTree, file = "results/Figures/DTTree.Rda")


ImpPlotDT <- final_dt_fit %>% extract_fit_parsnip() %>% vip()
saveRDS(ImpPlotDT, file = "results/Figures/ImpPlotDT.Rda")
###Based on this model, roc_auc is about 0.675 which is the same
#as the LASSO model.  Sample date seems to be the most
#important variable in the model. In the model, the first decision is whether
#or not the bird was sampled before or after Fall 2016. If the bird was sampled
#after, the tree predicts there was no parasitemia.



################################LASSO Model####################################
###Model 1 all predictors
#Set LASSO workflow
lasso_wf1 <- workflow() %>%
  add_model(lasso_mod1) %>%
  add_recipe(PA_rec1)

#LASSO tuning grid specification
lasso_grid1 <- tibble(penalty = 10^seq(-4, -1, length.out = 30))


#Fitting the LASSO model to training data
lasso_fit1 <- lasso_wf1 %>%
  tune_grid(resamples = PAFolds, grid = lasso_grid1,
            control = control_grid(verbose = FALSE, save_pred = TRUE),
            metrics = metric_set(roc_auc))

collect_metrics(lasso_fit1)

top_lasso <- lasso_fit1 %>%
  show_best("roc_auc", n = 1) %>%
  arrange(penalty)
top_lasso

lasso_fig <- lasso_fit1 %>% autoplot()
#Not terrible, but ROC_AUC is 0.674

saveRDS(lasso_fit1, file = "results/Models/LASSOmod.Rda")
saveRDS(top_lasso, file = "results/Tables/ModelLASSOMetrics.Rda")
saveRDS(lasso_fig, file = "results/Figures/LASSOFig.Rda")


#################################Random Forest#################################

#Set Random Forest Workflow
rf_wf1 <- workflow() %>%
  add_model(rf_mod1) %>%
  add_recipe(PA_rec1)

#Tuning model and running it
rf_fit1 <- rf_wf1 %>%
            tune_grid(resamples = PAFolds, grid = 25,
                      control_grid(save_pred = TRUE),
                      metrics = metric_set(roc_auc))
collect_metrics(rf_fit1)
rf_fit1 %>% show_best(metric = "roc_auc")
autoplot(rf_fit1)
#Best model has an roc_auc of 0.712

#Picking best random forest model and fitting it to training data
top_rf_model <- rf_fit1 %>% select_best(metric = "roc_auc")
final_rf_wf <- rf_wf1 %>% finalize_workflow(top_rf_model)
final_rf_fit <- final_rf_wf %>% last_fit(data_split_log)

saveRDS(final_rf_fit, file = "results/Models/RFFit.Rda")

#Getting the best values from the random forest model and null model
best_rf <- show_best(rf_fit1, n = 1)
best_null <- show_best(FitNullTrainMod)

#Comparing the best values from the best random forest model and null model
rfvsnull <- bind_rows(best_rf, best_null)
rfvsnull
#The random forest model seems to perform the best out of all the models with an roc_auc of 0.719

###Diagnostic plots for random forest model

ImpPlotRF <- final_rf_fit %>%
  extract_fit_parsnip() %>%
  vip::vip()

saveRDS(ImpPlotRF, file = "results/Figures/ImpPlotRF.Rda")
#Date and Bird Mass in grams are the variables with the most importance. Bird mass had a relatively high
#accuracy compared to other univariate models at 0.627, but low roc_auc at 0.511


#Getting the predictions and residuals

rf_residpredict <- final_rf_fit %>%
  augment(new_data = PATrainDF) %>%
  select(.pred_1, HaeParasitPA)

#Plot for Predicted vs Observed Values
rf_predobs_plot <- ggplot(rf_residpredict, aes(x = HaeParasitPA, y = .pred_1)) +
  geom_point() +
  xlab("Observed Values") + ylab("Predicted Values") +
  ggtitle("Predicted vs. Observed Values for Random Forest Model")
rf_predobs_plot

##############################Fitting Random Forest to Test Data########################################
set.seed(144)
Test_rf_fit <- final_rf_wf %>% last_fit(data_split_log)

saveRDS(Test_rf_fit, file = "results/Models/TestRFFit.Rda")

TestMetrics <- Test_rf_fit %>% collect_metrics()
#accuracy - 0.715, roc_auc - 0.725. Best so far. 

saveRDS(TestMetrics, file = "results/Tables/TestRFMetrics.Rda")

RFImpPlotTest <- Test_rf_fit %>% 
  pluck(".workflow", 1) %>%   
  extract_fit_parsnip() %>% 
  vip()

saveRDS(RFImpPlotTest, file = "results/Figures/RFImpPlotTest.Rda")
#Date and mass of the bird in grams are the most important variables in the workflow

ROC_Test_RF <- Test_rf_fit %>% 
  collect_predictions() %>% 
  roc_curve(HaeParasitPA, .pred_0) %>% 
  autoplot()
saveRDS(ROC_Test_RF, file = "results/Figures/RF_Test_ROCPlot.Rda")





