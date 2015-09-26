# GettingCleaningDataProject
# Course Date: Sep 7 2015 

 
#  Problem Description:
  Tidy the data sets produced from monitoring activitities of subjects participating in an experiment).

  Project description:
    1. Merges the training and the test data sets rom the files downloaded, to create one data set
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
#   STEP  0:
    Download the data using the R package to a directory called "./Data" assuming the directory already exists.
    unzip the files to the "./Data" directory

    Unzipped data has the following core files
    Traiing set data under the sub directory "/train"
    Test set data under the sub directory "/test"
    Traing and test data sets has the following files:
      X_train.txt, X_test.txt   
      - respective training and test set observations for a sequence of activities measured over time and for various frequencies.
      Y_train.txt and Y_test.txt 
      - respective training and test set activities that produced the observations in the training & test set files
      subject_train.text and subject_test.act 
      - training and test set subjects that participated in the activities
      Features.info has the information on the experiment observations, computed variables and the features.txt has the features list that were observed

#   STEP 0 Continued - reading of all the relevant files - Training data 


    Read the file X_train.txt using read.csv  (observations over period of time and using several frequencies)
    Read the file Y_train.txt using read.csv  Y_train.txt - Activities that produced the observations in the training and test sets
    Read the file subject_train.txt that has the corresponding entries for subject ids (range 1 :30) that performed the activities
    Repeat the above sets for the "test" data set (observations, corresponding activities and subjects)
    Read the feature labels from the features.txt (this file has the 561 features for each observation data row)
  
  Reading of the Training data set - the source data
  All these reads using read.csv we will use 
    header = FALSE since there is no header
    sep = = "" since we have white spaces between the values
    stringsAsFactors = false - as we are reading text files

#   STEP 0 - Validation of training and test sets
    Validate the read with "nrow" call - Should be the same number as the observations in the X_train.txt 
    We should see the activity labels bewtween 1 and 6, with 6 groups of data corresponding to 6 activities
    We should see the subjects index between 1 and 30, with 21 groups of data corresponding to
    21 subjects picked random for the training set and 9 subjects  in the test set
    
#  STEP 1 - Merge the training and test data sets 

    We will use rbind to merge the training and test sets (Measurements, Activity sequences, and Subjects who performed activities)
    At this point we still have 3 data sets but the training and test sets are merged for each of these 3 data sets.

#   STEP2  - Extracting mean and standard deviation features from the observations tables 
    
    We will extract the mean and standard deviations  for the core set of observations explained in the 
    features_info.txt file.
    WE WILL NOT EXTRACT the measurments of the angle() functions that measure the angle between the mean vectors
    We WILL NOT EXTRACT the Frequency Means that were used in Fourrier Transforms
 
    We will start with reading the features labels, clean the labels and then select the labels/column indices
    for the mean and std measurements.

    Read the file features.txt to extract raw labels using read.csv function
    - the file has 2 columns: the feature index and the feature label
    Validate the structure and the  rows - there should be 561 rows for the 561 features set measured/observed
   
    Extract the row indices for the column names that matches mean() or std() in the Feature Labels using the grep function
    Apply the "select" method and use the indices of the columns we derived from the feature labels data table
   
#  STEP 3 - requires activity labels be applied instead of integers in the activity column
  
    We will do straight forward data table manipulations to replace the numerals with descriptive activity label strings lke "
      "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
  
#  STEP 4:  Assigning meaniningful column names and creating one single combined data set
    Preparing the column names - 
    Cleaning of the feature labels to conform to R variable names; remove (, ); replace , - with "_"; 
    Add descriptions time, frequency and acceleration in place of labels that start with "t" and "f" 
    Replace the "acc" substring with "Acceleration". 
    
    Using colnames() function assign the colnames to the Subjects, Activities and Mean & Standard deviation observations
    
    Combine the 3 data sets to form a single combined data set.
    
    VALIDATION: validate the structure and should have - 10299 obs. of  68 variables with all descriptive column names
    
#  STEP 5:   Creation of a second, independent tidy data set with the average of each variable for each activity and each subject
  
    We need to group the data by subject, by activity for each subejct and the mean for each grouping.
    Tidy the data by grouping the data set by subject id and activity and the averaging (mean) of each variable within
    these groups using the dplyr functions group_by and summarize_each with function(means)
      
      VALIDATION: validate the resulting Tidy Data structure - 
          We should have 180 observations (30 subjects multiplied by 6 actitivies)
          We should have 68 columns/variables (33 mean and 33 std columns) + subject, activity variables
#  OUTPUT
    Output the resulting Tidy Data (tbl_df) structure using the write.table with row_names = FALSE
    VALIDATION - read the output file using read.table with header = TRUE
    Ensure that we have 180 observations and 68 variables.

