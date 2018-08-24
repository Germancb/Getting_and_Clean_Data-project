# Getting_and_Clean_Data-project
# The purpose of this project is to demostrate my ability to collect, work with, and clean data set
# getdata%2Fprojectfiles%2FUCI HAR Dataset
#  data in "UCI HAR Dataset" "UCI HAR Dataset/train/"   "UCI HAR Dataset/test/"
> library(reshape2)
#
# Read activity and features data description <- gola features and features2 activity_labels and activity_labels2
> activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
> activity_labels2 <- as.character(activity_labels[,2])
> features <- read.table("UCI HAR Dataset/features.txt")
> features2 <-  as.character(features[,2])
#
# Extract  mesures: Mean and estándar deviation names goals: features_Ind (Indices) features_names
> features_Ind1 <- grep("*-mean().", features2)
#
> features_Ind2 <- grep("*-std()", features2)
#
> features_Ind3 <- c(features_Ind1, features_Ind2)
#
> features_Ind <- sort(features_Ind3)   
> features_names <- features[features_Ind,2]

# Read train  and merge train data. goal: X_train> X_train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_Ind]

> Y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
> S_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
> X_train <- cbind(X_train, Y_train, S_Train)
# Read and merge test data. Goal X_test
> X_test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_Ind]
> Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
> S_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
> X_test <- cbind(X_test, Y_test, S_test)
#
#  merge training and test data. goal: X_totdata
#
> X_totdata <- rbind(X_train, X_test)
#
# Assign labels to dataset X_totdata
> colnames(X_totdata) <- c("subject", "activity", features_names)
#
# Convert activities and subjects in factors
#
> X_totdata$activity <- factor(X_totdata$activity, levels = activity_labels[,1], labels = activity_labels2)
> X_totdata$subject <- as.factor(X_totdata$subject)
# 
# Reshaping data with melt: goal: X_totdata.res
> X_totdata.res <- melt(X_totdata, id = c("subject", "activity"))
# Cast reshaped data into data frame. It contains the average of each variable for each activity and subject X_totdata.mean
> X_totdata.mean <- dcast(X_totdata.res, subject + activity ~ variable, mean)
# Write data set as a txt file
> write.table(X_totdata.mean, file = "TidyDatapgcd.txt", row.names=FALSE, quote = FALSE)
