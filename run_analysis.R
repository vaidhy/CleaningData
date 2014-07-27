# Read the metadata
columnNames <- read.table("features.txt", header=F, strip.white=T)
activityLabels <- read.table("activity_labels.txt",  header=F, strip.white=T)

# Read training dataset
trainDataDF <- read.table("train/X_train.txt", header=F, strip.white=T)
trainActivityDF <- read.table("train/y_train.txt", header=F, strip.white=T)
trainSubjectDF <- read.table("train/subject_train.txt", header=F, strip.white=T)

# Set the column names
colnames(trainDataDF) <- columnNames$V2

# Add subject and activity
trainDataDF$Activity <- trainActivityDF$V1
trainDataDF$Subject <- trainSubjectDF$V1

# Read test dataset
testDataDF <- read.table("test/X_test.txt", header=F, strip.white=T)

testActivityDF <- read.table("test/y_test.txt", header=F, strip.white=T)
testSubjectDF <- read.table("test/subject_test.txt", header=F, strip.white=T)

# Set the column names
colnames(testDataDF) <- columnNames$V2

# Add subject and activity
testDataDF$Activity <- testActivityDF$V1
testDataDF$Subject <- testSubjectDF$V1

# Merge the datasets
requiredData <- rbind(testDataDF, trainDataDF)

# rm(trainDataDF, trainActivityDF, trainSubjectDF, testDataDF, testActivityDF, testSubjectDF)

# Get all required names. 
requiredFactors <- c("Activity", "Subject")

requiredCols <- vector()

# colDimension are columns that are given in X, Y and Z dimensions
rColDimensionT <- c("tBodyAcc", "tGravityAcc", "tBodyAccJerk", 
                     "tBodyGyro", "tBodyGyroJerk", "fBodyAcc", "fBodyAccJerk",
                     "fBodyGyro")

for (i in rColDimensionT) {
    for (j in c("-mean()-X","-mean()-Y","-mean()-Z","-std()-X","-std()-Y","-std()-Z")) {
        requiredCols <- append(requiredCols, paste0(i,j) )
    }
}

# Col are columns that do not have spatial dimensions
rColT <- c("tBodyAccMag", "tGravityAccMag", "tBodyAccJerkMag", 
                "tBodyGyroMag", "tBodyGyroJerkMag", "fBodyAccMag",
                "fBodyBodyAccJerkMag", "fBodyBodyGyroMag", "fBodyBodyGyroJerkMag")

for (i in rColT) {
    for (j in c("-mean()","-std()")) {
        requiredCols <- append(requiredCols, paste0(i,j) ) 
    }
}

# Let us clean up all the unrequired columns
for (i in colnames(requiredData)) {
    if (!(i %in% append(requiredCols, requiredFactors))) {
        requiredData[[i]] <- NULL
    }       
}

# Set the activity column names as factors with labels
requiredData$Activity <- factor(requiredData$Activity, labels = activityLabels$V2)

# Define Subjects as a factor
requiredData$Subject <- as.factor(requiredData$Subject)

# Create the tidy dataset and initialize it as a empty data frame
tidyData <- data.frame()
tidyData$Subject <- vector(mode="character", length = 0)
tidyData$Activity <- vector(mode="character", length = 0)

for (i in requiredCols) {
    tidyData[[i]] <- vector(mode="numeric", length = 0)
}

# Walk through the data by subject and activity and add to tidydata
i <- 1
for (subject in levels(requiredData$Subject)) {
    for (activity in levels(requiredData$Activity)) {
        resultList <- c(Subject=subject, Activity=activity)
        subsetDF <- requiredData[which(requiredData$Subject == subject & 
                                    requiredData$Activity == activity),]
        for (col in requiredCols) {
            resultList <- append(resultList, mean(subsetDF[[col]], na.rm=T))
        }
        tidyData[i,] <- resultList
        i <- i+1
    }
}

# Finally write the csv file
write.csv(tidyData, "tidydata.txt")