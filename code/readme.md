The R scripts in this folder are the code that produce both the processed data and analyses. In order
to fully reproduce the analysis, the R files in processing_code should be ran first and then the R files
in analysis_code. Below details the order in which to run the files in each folder.

1. processing_code:
	1. ProcessingScriptIbisBloodData.R
	2. ProcessingScriptIbisFieldData.R
	3. ProcessingScriptIbisUrban.R

2. analysis_code:
	1. ExploratoryAnalysisScript.R
	

The code in the processing_code directory will load all the raw datasets from the raw_data directory,
clean and process them, then save the processed datasets in the processed_data directory.

The code in the analysis_code directory will load processed datasets from the processed_data directory in order to perform the analyses.