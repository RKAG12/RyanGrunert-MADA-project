# Overview

Part 2 of the project is located in the Manuscript.rmd file.

This is Ryan Grunert's class project repository. 

# Pre-requisites

This data analysis project uses R, Rmarkdown (and variants, e.g. bookdown), Github and a reference manager that can handle bibtex. It is also assumed that you have a word processor installed (e.g. MS Word or [LibreOffice](https://www.libreoffice.org/)). You need that software stack to make use of this template.

# Main Directory Structure

* All data is located in the subfolders inside the `data` folder.
* All code is located in the `code` folder and subfolders.
* All results (figures, tables, computed values) are located in the `results` folder and subfolders.
* All products (manuscripts, supplementary files) are located in the  `products` subfolders.
* See the various `readme.md` files in those folders for some more information.

# Content 

The 'code' folder contains two subfolders: 'processing_code' and 'analysis_code'
 	- 'processing_code' contains 3 R scripts that load the raw datasets, performs all the cleaning needed, and saves the results in the 'processed_data' folder.
	- 'analysis_code' contains 1 R script currently, that loads the processed datasets and performs an Exploratory Analysis. Afterwards it saves the results and figures into the ExploratoryAnalysis folder in the results folder.
	
The 'data' folder contains two subfolders: 'raw_data' and 'processed_data'
	- 'raw_data' contains the raw datasets used for the analysis. These should not be edited in any way.
	- 'processed_data' contains the processed datasets that were created as a result of the processing_code scripts, and were saved as .RDS files.

The 'results' folder currently only contains one folder, 'ExploratoryAnalysis'. This contains the figures created as a result of the Exploratory Analysis script.

The 'products' folder currently contains the references, metadata for every dataset, and 'manuscript' folder. The primary report is written in Rmarkdown. Inside the 'manuscript' folder, there is the main .Rmd manuscript file that can be used to recreate all the analyses if one wanted. Included there is also an html and word output for the .Rmd file.
	
# Getting started

This is a Github repository. [The best way to get to download it is here](https://github.com/RKAG12/RyanGrunert-MADA-project)

To start, open the processing_scripts and run all of them in order according to the order specified in the README. Then run the analysis_scripts.

You can also open the 'Manuscript.Rmd' file and complete the entire analysis there as well. Either method will work, but if you are going to use both, clear the R environment before you do so.


