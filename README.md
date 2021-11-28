# Overview

This is Ryan Grunert's data analysis repository for the Haemoproteus parasitemia in wild American Ibis dataset.

# Pre-requisites

This data analysis project uses R, Rmarkdown (and variants, e.g. bookdown), Github and a reference manager that can handle bibtex. It is also assumed that you have a word processor installed (e.g. MS Word or [LibreOffice](https://www.libreoffice.org/)). You need that software stack to successfully recreate the entire analysis.

# Main Directory Structure

* All data is located in the 'raw_data' and 'processed_data' folders.
* All code is located in the 'processing_script' and 'analysis_scripts' folders.
* All results (figures, tables, computed values) are located in the `results` folder and subfolders.
* All products (manuscripts, supplementary files) are located in the  `products` subfolders. The references used in the manuscript and the metadata are located here as well.
* See the various `readme.md` files in those folders for some more information.

# Content 

The 'raw_data' folder contains the raw datasets for the analysis. None of these should be altered in any way. 

The 'processed_data' folder contains all of the processed data created from the 'processing_script' folder. These should not be altered in any way.

To recreate the analysis, the processing script should be run first, and then the analysis scripts.

The 'processing_script' folder contains two files; the main Processing Script and a readme. To recreate the data processing for later analysis, run the code on the processing script from beginning to end without alteration of the original code. It will load the unprocessed datasets, clean them, and save the processed datasets in the 'processed_data' folder.

The 'analysis_scripts' folder contains three files, the main script for exploratory data analysis, the main script for statistical analyses, and the readme. The exploratory analysis script will load the processed dataset and create and save figures and tables that explore the data. These saved tables and figures can all be viewed in the 'results' folder, 'supplemental_materials' folder, and within the script. The statistical analysis script will load the processed data and create various tables, figures, and models (saving them to the results folder and supplemental_materials folder as well). 

NOTE: The statistical analysis script will take about 20-30 minutes to completely run all of the models.

The 'results' folder contains 3 subfolders, 'Figures', 'Models', and 'Tables'. These contains saved Rda and JPEG files from the analysis scripts.

The 'products' folder currently contains the references, metadata for every dataset, and 'manuscript' folder. The primary report is written in Rmarkdown. Inside the 'manuscript' folder, there is the main .Rmd manuscript file that can be used to recreate all the analyses if one wanted. Included there is also a word output for the .Rmd file.
	
The 'supplemental_materials' folder contains all of the models, figures, and tables that were included in the main manuscript file. It also contains an .Rmd file that will discuss the other excluded figures and models from the exploratory analysis and statistical analysis. 

# Getting started

This is a Github repository. [The best way to get to download it is here](https://github.com/RKAG12/RyanGrunert-MADA-project)

To start, open the processing_scripts and run all of them in order according to the order specified in the README. Then run the code in the analysis_scripts.

You can also open the 'Manuscript.Rmd' file to read the main findings of the analysis.


