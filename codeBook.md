codeBook
=========

* Original data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

* Original data explanation can be found in http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

* For this exercise we will use the X-measurements obtained in the original experiment (discarding thus all inertial values) 
*We keep all X-measurements where means or standard deviations were performed as a last step, i.e, those whose names end with either mean() or std(). Note also that features' names have slightly changed and all '-' in the names have been replaced by '_' characters.

* test and train sets have been concatenated to obtain a table with all experiments in both sets.

* The variable activities, that was codified using an external table, has been de-codified and full names appear.

* The tidy dataset (written by the script in a new file called tidy.txt) contains the averages of each column for each subject and activity.

