require(plyr)

# 1. Merges the training and the test sets to create one data set.

train <- read.table("Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("Getting and Cleaning Data/UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("Getting and Cleaning Data/UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

mergedData <- rbind(train,test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 2.1 Load Label Data
activityLabels <- read.table("Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt"
                             ,col.names = c("ActivityId", "Activity"))
features <- read.table("Getting and Cleaning Data/UCI HAR Dataset/features.txt"
                       ,colClasses = c("character"))

# 2.2 Label columns
labels <- rbind(c(0, "Subject"),c(0, "ActivityId"),features)[,2]
colnames(mergedData) <- labels

# 2.3 Select specified columns
mergedDataWithMeanAndStd <- mergedData[,grepl("mean|std|Subject|ActivityId", names(mergedData))]


# 3. Uses descriptive activity names to name the activities in the data set
mergedDataWithMeanAndStd <- join(activityLabels,mergedDataWithMeanAndStd,by = "ActivityId", match = "first")

# 4. Appropriately labels the data set with descriptive variable names. 

# 4.1 Remove parentheses
names(mergedDataWithMeanAndStd) <- gsub('\\(|\\)',"",names(mergedDataWithMeanAndStd), perl = TRUE)
# 4.2 Make syntactically valid names 
names(mergedDataWithMeanAndStd) <- make.names(names(mergedDataWithMeanAndStd))
# 4.3 Make clearer names
names(mergedDataWithMeanAndStd) <- gsub('Acc',"Acceleration",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('GyroJerk',"AngularAcceleration",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('Gyro',"AngularSpeed",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('Mag',"Magnitude",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('^t',"TimeDomain.",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('^f',"FrequencyDomain.",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('\\.mean',".Mean",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('\\.std',".StandardDeviation",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('Freq\\.',"Frequency.",names(mergedDataWithMeanAndStd))
names(mergedDataWithMeanAndStd) <- gsub('Freq$',"Frequency",names(mergedDataWithMeanAndStd))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyDataSet = ddply(mergedDataWithMeanAndStd, c("Subject","Activity"), numcolwise(mean))
write.table(tidyDataSet, file = "Getting and Cleaning Data/tidyDataSet.txt")