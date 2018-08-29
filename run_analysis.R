# getdata%2Fprojectfiles%2FUCI HAR Dataset
#  data in "UCI HAR Dataset" "UCI HAR Dataset/train" "UCI HAR Dataset/test" 
# library(reshape2)
#  #
# Read activity and features data description
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <-  as.character(features[,2])
#
# Extract  mesures: Mean and estándar deviation names
features_Ind1 <- grep("*-mean().", features[,2])
features_Ind2 <- grep("*-std()", features[,2])
features_Ind3 <- c(features_Ind1, features_Ind2)
features_Ind <- sort(features_Ind3)   # 79 features_nasme
features_names <- features[features_Ind,2]
# Improve descriptions 
features_names <- gsub("tBodyAcc", "TimeBodyAccelerometer", features_names)
features_names <- gsub("tBodyGyro", "TimeBodyGyroscope", features_names)
features_names <- gsub("tGravityAcc", "TimeGravityAccelerometer", features_names)
features_names <- gsub("fBodyAcc", "FrequencyBodyAccelerometer", features_names)
features_names <- gsub("fBodyGyro", "FrequencyBodyGyroscope", features_names)
features_names <- gsub("-mean()", "Mean", features_names)
features_names <- gsub("-std()", "Std", features_names)


# Read train  and merge train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_Ind]
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
S_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- cbind(S_train, Y_train, X_train)
# Read and merge test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_Ind]
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
S_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- cbind(S_test, Y_test, X_test)
#
#  merge training and test data
#
X_totdata <- rbind(X_train, X_test)
#
# Assign labels to dataset
colnames(X_totdata) <- c("subject", "activity", as.character(features_names))
# Convert activities and subjects in factors
#
X_totdata$activity <- factor(X_totdata$activity, levels = activity_labels[,1], labels = activity_labels[,2])
X_totdata$subject <- as.factor(X_totdata$subject)
# Reshaping data with melt
X_totdata.res <- melt(X_totdata, id = c("subject", "activity"))
# Cast reshaped data into data frame. It contains the average of each variable for each activity and subject
X_totdata.mean <- dcast(X_totdata.res, subject + activity ~ variable, mean)
# Write data set as a txt file
write.table(X_totdata.mean, file = "TidyDataSet3.txt", row.names=FALSE, quote = FALSE)
