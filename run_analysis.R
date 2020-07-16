#Install & load libraries
install.packages("dplyr")
install.packages("plyr")
library(dplyr)
library(plyr)


#Read in features and labels
wd1 <- list.files(pattern = "UCI HAR Dataset")
setwd(wd1)
features <- read.delim("features.txt", sep = " ", header = FALSE)
activity_labels <- read.delim("activity_labels.txt",sep = " ", header = FALSE)

#Read in train datasets
x_train <- read.delim("train/X_train.txt", sep = "", header = FALSE)
y_train <- read.delim("train/y_train.txt", header = FALSE)
subject_train <- read.delim("train/subject_train.txt", header = FALSE)

#Merge y_train with activity labels and set column names
train_merged <- join(y_train, activity_labels, by = "V1")
train_merged_colnames = c("activityLabelID","activityLabel")
colnames(train_merged) <- train_merged_colnames

#Set column names for subject_train
subject_train_colnames = c("subject")
colnames(subject_train) <- subject_train_colnames

#Set column names for x_train
train_colnames = c(features$V2)
colnames(x_train) <- train_colnames

#Bind merged y_train and activity labels dataframe "train_merged"
train <- cbind(train_merged,x_train)

#Bind all train dataframes
train <- cbind(subject_train, train)

#Read in test datasets
x_test <- read.delim("test/X_test.txt", sep = "", header = FALSE)
y_test <- read.delim("test/y_test.txt", header = FALSE)
subject_test <- read.delim("test/subject_test.txt", header = FALSE)

#Merge y_test with activity labels and set column names
test_merged <- join(y_test, activity_labels, by = "V1")
test_merged_colnames = c("activityLabelID","activityLabel")
colnames(test_merged) <- test_merged_colnames

#Set column names for subject_test
subject_test_colnames = c("subject")
colnames(subject_test) <- subject_test_colnames

#Set column names for x_test
test_colnames = c(features$V2)
colnames(x_test) <- test_colnames

#Bind merged y_test and activity labels dataframe "test_merged"
test <- cbind(test_merged,x_test)

#Bind all train dataframes
test <- cbind(subject_test, test)

#Bind test & train
single_dataset <- rbind(train, test)

#Column names strings
strings <- c("subject","activityLabelID","activityLabel","mean","std")

#Subset with mean & std
strings <- c("subject","testLabel","activityLabel","mean","std")
mean_std_only <- select(single_dataset, matches(strings))

#Subset and summarize means for each row
variable_avg <- mean_std_only %>% group_by(subject, activityLabelID,activityLabel) %>% summarize_all(list(mean))

#Write dataset to csv
write.csv(variable_avg, "tidy_data.csv", row.names = FALSE)