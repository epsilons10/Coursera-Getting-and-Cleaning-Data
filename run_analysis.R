###########################################################################################

## Coursera Getting and Cleaning Data Course Project
## Author: Sandeep Agarwal
## Date: Dec 12, 2016

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
#    & rename the column names
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names 
# 5. From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject 
###########################################################################################

# Clean up workspace
rm(list=ls())

# Set working directory to existing directory
setwd("/DataScience/R")

# Create new working directory for this project
if (!file.exists("./c3project")) {dir.create("./c3project")}

# set working directory (especially created for course 3 Getting & Cleaning Data Project)
setwd("/DataScience/R/c3project")

# Download the zip file if it doesn't exist already
filename <- "dataset.zip"
if (!file.exists(filename)){
     fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(fileurl, filename, method="curl")
}  

# unzip the zip file in current working directory if not done so already
if (!file.exists("UCI HAR Dataset")) {unzip(filename)}

# Step 1: Merges the training and the test sets to create one data set
######################################################################
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge both train & test data sets for x & y
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
#         & rename the column names
######################################################################

features <- read.table("UCI HAR Dataset/features.txt")

# get columns with match for -mean() or -std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data_sel <- x_data[, mean_and_std_features]

# fix the column names of x data with the names from variables in features
names(x_data_sel) <- features[mean_and_std_features, 2]

# modify the column names using gsub function call
# removing parentheses ()
names(x_data_sel) <- gsub("\\()", "", names(x_data_sel))
# string ending in -std will be renamed that part to StdDev
names(x_data_sel) <- gsub("-std$", "StdDev", names(x_data_sel))
# -mean to Mean
names(x_data_sel) <- gsub("-mean", "Mean", names(x_data_sel))
# starting with "t" to time
names(x_data_sel) <- gsub("^t", "time", names(x_data_sel))
# sstarting with "f" to frequency
names(x_data_sel) <- gsub("^f", "frequency", names(x_data_sel))
# BodyBody to Body
names(x_data_sel) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", names(x_data_sel))
# Gyro to Gyroscope
names(x_data_sel) <- gsub("[Gg]yro", "Gyroscope", names(x_data_sel))
# Acc to Accelerometer
names(x_data_sel) <- gsub("Acc", "Accelerometer", names(x_data_sel))
# -std to Std
names(x_data_sel) <- gsub("-std", "Std", names(x_data_sel))

# Step 3: Use descriptive activity names to name the activities in the data set
######################################################################

activities <- read.table("UCI HAR Dataset/activity_labels.txt")


# update y data with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# fix the column name for y data
names(y_data) <- "activity"

# Step 4: Appropriately labels the data set with descriptive variable names
######################################################################

# fix the column name for subject data
names(subject_data) <- "subject"

# Step 5: From the data set in step 4, creates a second, independent tidy data 
#         set with the average of each variable for each activity and each subject
######################################################################

# combined the data together in a single data set
all_data <- cbind(x_data_sel, y_data, subject_data)

# install the package "plyr" if not already installed
# load the "plyr library
library(plyr)

# use ddply to split data frame, apply function, and return results in a data frame
# calculate average (mean) of each variable for each activity and each subject.
avg_each_var <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

# write this data in a text file as a tidy data set
write.table(avg_each_var, "tidy_data.txt", row.name = FALSE, quote = FALSE)

############# End of Script #############
