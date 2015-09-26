
## Gettng and Reading Data
##  Class Project
##  Sep 7 2015 - Oct 5 2015
##
## Problem Description (Tidy the data sets produced from monitoring activitities of subjects participating in an experiment)
##    1. Merges the training and the test data sets rom the files downloaded, to create one data set
##    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##    3. Uses descriptive activity names to name the activities in the data set
##    4. Appropriately labels the data set with descriptive variable names. 
##    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##
##
library(RCurl)
## Step 0 - download the files
  FileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  DownloadDir <- "./Data"
  DataSetZip <- "Dataset.zip"
  DestFile <- paste(DownloadDir, DataSetZip, sep = "/")
  
## the setInternet2 command is needed to overcome download.file issues on the Windows machine.
  setInternet2(use = TRUE)
  if (!file.exists(DataSetZip)) { download.file(FileURL, DestFile)}
  
##  Unzip the files if we haven't already done so
  setwd(DownloadDir)
  UnzippedDir <- "./UCI HAR Dataset"
  if (!file.exists(UnzippedDir)) { unzip(DataSetZip, exdir=".")}

## step 0 reading of all the relevant files - Training data #####
######
######
##  read the file X_train.txt using read.csv  (observations over period of time and using several frequencies)
##  read the file Y_train.txt using read.csv  Y_train.txt - Activities that produced the observations in the trainin set X_train.txt file
##  read the file subject_train.txt that has the corresponding entries for subject ids (range 1 :30) that performed the activities
##  Repeat the above sets for the "test" data set (observations, corresponding activities and subjects)
##  read the feature labels from the features.txt (this file has the 561 features for each observation data row)
##  
## Reading of the Training data set - the source data
## All these reads using read.csv we will use 
##    header = FALSE since there is no header
##    sep = = "" since we have white spaces between the values
##    stringsAsFactors = false - as we are reading text files
##
    setwd("./UCI HAR Dataset") ## set the working directory to the ./data/UCI HAR Dataset for all our file reading activities below
    TrainData <- read.csv("./train/X_train.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
    TrainDataActivity <- read.csv("./train/Y_train.txt", header = FALSE, stringsAsFactors = FALSE)
    TrainDataSubjects <- read.csv("./train/subject_train.txt", header = FALSE, stringsAsFactors = FALSE)
    nrow(TrainData)
    nrow(TrainDataActivity)
    nrow(TrainDataSubjects)
    table(TrainDataActivity)
    table(TrainDataSubjects)
  
## Validate the read with "nrow" call - Should be the same number as the observations in the X_train.txt
## We should see the activity labels bewtween 1 and 6, with 6 groups of data corresponding to 6 activities
## We should see the subjects index between 1 and 30, with 21 groups of data corresponding to
## 21 subjects picked random for the training set

## We will repeat the steps for the TEST data as well
## READ THE TEST DATA FILES as we did above fore the training set
  
    TestData <- read.csv("./test/X_test.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
    TestDataActivity <- read.csv("./test/Y_test.txt", header = FALSE, stringsAsFactors = FALSE)
    TestDataSubjects <- read.csv("./test/subject_test.txt", header = FALSE, stringsAsFactors = FALSE)  
    nrow(TestData)
    nrow(TestDataActivity)
    nrow(TestDataSubjects)
    table(TestDataActivity)
    table(TestDataSubjects)

##Change each of the 6 data frames to data table format
    library(dplyr)
    TrainData <- tbl_df(TrainData)
    TrainDataSubjects <- tbl_df(TrainDataSubjects)
    TrainDataActivity <- tbl_df(TrainDataActivity)
    TestData <- tbl_df(TestData)
    TestDataSubjects <- tbl_df(TestDataSubjects)
    TestDataActivity <- tbl_df(TestDataActivity)

##### STEP 1 - Merge the training and test data sets #####
#####
##### we will use rbind to merge the training and test sets (Measurements, Activity sequences, and Subjects who performed activities)
#####
 
    SubjectsMonitored <- rbind(TrainDataSubjects, TestDataSubjects)
    ActivitySequences <- rbind(TrainDataActivity, TestDataActivity)
    ActivityMeaasurements <- rbind(TrainData, TestData)
  
####  STEP2  - Extracting mean and standard deviation features from the observations tables for each subject and 
####  each repeated activtity
### 
###   We will will extract the mean and standard deviations  for the core set of observations explained in the 
###   features_info.txt file.
###   WE WILL NOT EXTRACT the measurments of the angle() functions that measure the angle between the mean vectors
###   We WILL NOT EXTRACT the Frequency Means that were used in Fourrier Transforms
### 
###   We will start with reading the features labels, clean the labels and then select the labels/column indices
###   for the mean and std measurements.
###
###   Read the file features.txt to extract raw labels - the file has 2 columns: the feature index and the feature label
###   Validate the structure and the # rows - there has to be 561 rows for the 561 features set measured/observed
###
    FeaturesLabels <- read.csv("features.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
    str(FeaturesLabels)

### Extract the row indices for the column names that matches mean() or std() in the Feature Labels
    MeanStdmatches <- grep("mean\\(\\)|std\\(\\)", FeaturesLabels[,2])
    MeanStdLabels <- FeaturesLabels[MeanStdmatches,][, 2]

###   STEP 2 continued - we will use the mean and standard deviations label indices to select columns from the merged data set 
###  Apply the "select" method and use the indices of the columns we derived from the feature labels data table
    MeanStdObservations <- select(ActivityMeaasurements, MeanStdmatches)
    str(MeanStdObservations)
    
##  Preparation of STEP 4 - preparing descriptive column names
### Cleaning of the feature labels to conform to R variable names; remove (, ); replace , - with "_"; 
##  Add descriptions time, frequency and acceleration in place "t" , "f" and "acc"
    MeanStdLabels <- gsub("\\(|\\)", "", MeanStdLabels)
    MeanStdLabels <- gsub("-", "_", MeanStdLabels)
    MeanStdLabels <- gsub("^t", "time", MeanStdLabels )
    MeanStdLabels <- gsub("^f", "frequency", MeanStdLabels)
    MeanStdLabels <- gsub("Acc", "Acceleration", MeanStdLabels)

##  STEP 3 - requires activity labels be applied instead of integers in the activity column
##
##
    ActivitySequences[ActivitySequences == 1] <- "WALKING" 
    ActivitySequences[ActivitySequences == 2] <- "WALKING_UPSTAIRS" 
    ActivitySequences[ActivitySequences == 3] <-"WALKING_DOWNSTAIRS"
    ActivitySequences[ActivitySequences == 4] <- "SITTING"
    ActivitySequences[ActivitySequences == 5] <- "STANDING"
    ActivitySequences[ActivitySequences == 6] <- "LAYING"
    
## STEP 4 of the assignment - now we apply the column names that we have processed in the Features Labels data table.
## we use the colnames function to do that
    colnames(MeanStdObservations) <- MeanStdLabels
    str(MeanStdObservations)


    colnames(SubjectsMonitored) <- c("SubjectId")
    colnames(ActivitySequences) <- c("Activity")
##  Now we combine the 3 data tables  - Subjects Monitored, Activity sequences measured and the Mean & SD observatoins
    CombinedData <- cbind(SubjectsMonitored, ActivitySequences, MeanStdObservations)

### STep 5 - tidy the data set
###   We need to group the data by subject, by activity for each subejct and the mean for each grouping
###   Tidy the data by grouping the data set by subject id and activity and the averaging (mean) of each variable within
##    these groups
###   Examine the structure of the Tidy data set
###   We should have 180 observations (30 subjects multiplied by 6 actitivies)
###   We will have 68 columns/variables (33 mean and 33 std columns) + subject, activity variables
    TidyData <- CombinedData %>% group_by(SubjectId, Activity) %>% summarize_each(funs(mean))
    str(TidyData)

##  Final Steps: Write the Tidy data set to a file using write.table command
##
    library(data.table)
    write.table(TidyData, "./TidyMeansData.txt", row.names = FALSE)
  
##  make sure we are able to read the data
    DT <- read.table("TidyMeansData.txt", header = TRUE)
    str(DT)
  