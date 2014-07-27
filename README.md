Cleaning Samsung UCI Data
=========================

Goal
----

The goal of the exercise is to clean up the Samsung UCI data to enable futher analysis.

Data Format
-----------

The Samsung UCI data has be split into a training and a test set. In each set, there is a raw file containing training data where each observation has 561 variables. Each observation is tied to a subject and an activity which are given in two separate files. 

The variable names are described in features.txt. The descriptive names for the activities are given in activity_labels.txt. 

Script Explanation
------------------

We read all the 8 files in the following order.

### Reading the metadata

1. Read the variables names from features.txt. The actual names for features will be in the column V2.
2. Read the descriptive activities from activity_lables.txt. The activity lables will be in the column V2.

### Reading the training dataset

1. Read the X_train.txt which contains all the observations for the training data as trainDataDF.
2. Read the y_train.txt which contains the activity numbers.
3. Read the subject_train.txt which contains the subjects for whom each of the observation has been taken.
4. Set the column names for trainDataDF from the variables read in metadata.
5. Merge the activity data into the trainDataDF as column = Activity
6. Merge the subject data into the trainDataDF as column = Subject

### Reading the test dataset

1. Read the X_test.txt which contains all the observations for the test data as testDataDF.
2. Read the y_test.txt which contains the activity numbers.
3. Read the subject_test.txt which contains the subjects for whom each of the observation has been taken.
4. Set the column names for testDataDF from the variables read in metadata.
5. Merge the activity data into the testDataDF as column = Activity
6. Merge the subject data into the testDataDF as column = Subject

### Merging the datasets

Merge the test and training datasets into a common dataset called requiredData. We can optionally save the space by removing all the test and training datasets from memory.

### Set the right factors

We define subject and activity as factors. While defining activity as factors, we can use the lables read from activity_lables.txt to set the right descriptive labels.

### Identify the required columns

We need to to only keep variables that indicate the mean and standard deviations. Looking through the features, we notice that there are two kinds of means and standard deviations - ones with spatial dimension and ones without. We use that to programatically generate the list of variables we want to keep. We also identify Subject and Activity as two variables that we want to retain.

### Removing unwanted data

We loop through all the columns in the requiredData and remove all the columns whose names are not identified as required columns. We will end up with 68 columns from the original 563 columns of data.

### Computing the average

We will create a dataframe called tidyData in which we will store the average computed. We create a nested loop with the outer loop around the subject as factor and inner loop around activity as the factor. We subset the requiredData based on these loops. For each dataframe subset, we compute the mean for each of the columns present. As we compute the means, we will add it to a list for now. Once we have gone through all the columns, we will add the list to tidyData. Once all the loops are complete, tidyData will have averages for the variables by subject and activity.

### Writing the file

Finally, tidyData can be written out using write.csv into a file called tidyData.txt.




