##Code Book: Getting and Cleaning Data Project

##Description

Information about the script, variables, data and transformations

## Introduction

The script `run_analysis.R` performs the steps described in the course project's definition.

* First, clear the workspace and set the working directory
* Create new sub-directory for this project if not already exist and set this as the new working directory
* Download the zip file if it doesn't already exist
* Unzip the zip file in current working directory
* Read the text files using read.table()
* All the similar data is merged using the `rbind()` function. Similarly, we address those files having the same number of columns and referring to the same entities.
* Then, only those columns with the mean and standard deviation measures are taken from the whole dataset. Used `grep()` function call to achieve that.
* Next, subset the desired columns of the X data set.
* After extracting these columns, they are given the correct names, taken from `features.txt`.
* Once we get the column names, they are modified using multiple calls to 'gsub()' function to make it meaningful column names
* As activity data is addressed with values 1:6, we take the activity names and IDs from `activity_labels.txt` and they are substituted in the dataset.
* Given column names to activity and subject data sets
* Column bind the x, y and subject data using `cbind()'
* Finally, we generate a new dataset with all the average measures for each subject and activity type (30 subjects * 6 activities = 180 rows) using `plyr` library and `ddply()` function call.
* The output file is called `tidy_data.txt`, and uploaded to this repository.

## Variables

* `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test` contain the data from the downloaded files.
* `x_data`, `y_data` and `subject_data` merge the previous datasets to further analysis.
* `features` contains the correct names for the `x_data` dataset, which are applied to the column names stored in `mean_and_std_features`, a numeric vector used to extract the desired data. New `x_data_sel' dataset created with only desired columns.
* A similar approach is taken with activity names through the `activities` variable.
* `all_data` merges `x_data_sel`, `y_data` and `subject_data` in a big dataset.
* Finally, `avg_each_var` contains the relevant averages using `ddply()` from the plyr package (used `colMeans()` function call within the `ddply()` function call).
* `tidy_data.txt` is created in the current working directory using `write.table()` function call.
