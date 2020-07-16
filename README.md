==================================================================
Getting and Cleaning Data Course Project
run_analysis.R Read Me


The script leverages the following files from the UCI HAR Dataset:
==================================================================
-	'features.txt': List of all features.

-	'activity_labels.txt': Links the class labels with their activity name.

-	'train/X_train.txt': Training set.

-	'train/y_train.txt': Training labels.

-	'test/X_test.txt': Test set.

-	'test/y_test.txt': Test labels.

-	'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

-	'train/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.



Detailed Script Description
==================================================================
# Commented lines describe sripted process step by step


#Step 1 Install & load libraries
install.packages("dplyr")
install.packages("plyr")
library(dplyr)
library(plyr)

#Step 2 Set working directory to UCI HAR Dataset and read in features.txt and acvitity_labels.txt by " " delimiter without headers
wd1 <- list.files(pattern = "HAR")
setwd(wd1)
features <- read.delim("features.txt", sep = " ", header = FALSE)
activity_labels <- read.delim("activity_labels.txt",sep = " ", header = FALSE)

#Step 3 Read in train datasets by "" delimiter without headers
x_train <- read.delim("train/X_train.txt", sep = "", header = FALSE)
y_train <- read.delim("train/y_train.txt", header = FALSE)
subject_train <- read.delim("train/subject_train.txt", header = FALSE)

#Step 4 Join y_train with activity_labels by V1, the activity ID column in both dataframes and set column names
train_merged <- join(y_train, activity_labels, by = "V1")

#Step 5 Create a list of appropriate column headers for 'train_merged", and apply
train_merged_colnames = c("activityLabelID","activityLabel")
colnames(train_merged) <- train_merged_colnames

#Step 6 Create string for column header of subject_train and apply
subject_train_colnames = c("subject")
colnames(subject_train) <- subject_train_colnames

#Step 7 Create a list of appropriate column headers for x_train based on 'features' and apply
train_colnames = c(features$V2)
colnames(x_train) <- train_colnames

#Step 8 Bind joined y_train and activity labels dataframe ('train_merged') with x_train
train <- cbind(train_merged,x_train)

#Step 9 Bind all train into a singular train dataframe
train <- cbind(subject_train, train)

#Step 10 Read in test datasets by "" delimiter without headers
x_test <- read.delim("test/X_test.txt", sep = "", header = FALSE)
y_test <- read.delim("test/y_test.txt", header = FALSE)
subject_test <- read.delim("test/subject_test.txt", header = FALSE)

#Step 11 Join y_test with activity_labels by V1
test_merged <- join(y_test, activity_labels, by = "V1")

#Step 12 Create a list of appropriate column headers for 'test_merged", and apply
test_merged_colnames = c("activityLabelID","activityLabel")
colnames(test_merged) <- test_merged_colnames

#Step 13 Create string for column header of subject_train and apply
subject_test_colnames = c("subject")
colnames(subject_test) <- subject_test_colnames

#Step 14 Create a list of appropriate column headers for x_test based on 'features' and apply
test_colnames = c(features$V2)
colnames(x_test) <- test_colnames

#Step 15 Bind joined y_test and activity_labels dataframe ('test_merged') with x_test
test <- cbind(test_merged,x_test)

#Step 16 Bind all test dataframes into a singular test dataframe
test <- cbind(subject_test, test)

#Step 17 Bind test & train dataframes into a singluar tidy dataset 
single_dataset <- rbind(train, test)

#Step 18 Create a variable 'strings' to hold the strings for subset of column names from 'single_dataset' to take mean & std measurments only
strings <- c("subject","activityLabelID","activityLabel","mean","std")

#Step 19 Pass the strings to match only on specified column names to create subset of data for mean & std measurments only with subject and activity fields
mean_std_only <- select(single_dataset, matches(strings))

#Step 20 Subset and summarize means for each row and subject
variable_avg <- mean_std_only %>% group_by(subject, activityLabelID,activityLabel) %>% summarize_all(list(mean))

#Step 21 Write secondary independent tidy dataset with the average of each variable for each activity and each subject to csv.
write.table(variable_avg, "tidy_data.txt", row.names = FALSE)
