The R scripts in this folder are the code that produce both the processed data and analyses. In order
to fully reproduce the analysis, the R files in processing_code should be ran first and then the R files
in analysis_code. Below details the order in which to run the files in each folder.

The code in the 'ExploratoryAnalysisScript.R' file will load the processed data from the 'processed_data' folder and conduct an exploratory analysis. This will create various tables and figures that will all be saved in the results folder and supplemental data folder. 

The code in the 'StatisticalAnalysisModels.R' file will load the processed data from the 'processed_data' folder and conduct all of the statistical analyses on the data. The resulting tables, figures, and models will all be saved in the results folder, and the supplemental data folder.