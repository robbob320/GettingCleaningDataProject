Getting and Cleaning Data project -- COOKBOOK
The purpose of the project was to produce a tidy data set from the files provided. The commands which were used to produce the tidy set, as well as corresponding comments, are stored in "run_analysis.R" file.

Steps (atomic goals)

merge the training and the test sets to create one data set
extract only the measurements on the mean and standard deviation for each measurement.
use descriptive activity names to name the activities in the data set
appropriately label the data set with descriptive activity names.
create a second, independent tidy data set with the average of each variable for each activity and each subject.
Atomic goals - comments

Step 1

Downloading and unzipping appropriate files was performed from the level of R, using functions:

download.file
unzip
Subsequent components of the future dataset (that is: training and test x's, y's and subjects) were read using functions:

file.name (in order to produce path from a few parts, also containing blank spaces)
read.table (as the files were in .txt format)
One data frame was produced using functions:

cbind (adds columns to existing object - used for binding x variables with subject and activity)
rbind (adds rows to existing object - used for adding test data frame to the bottom of training data frame)
For the author, this step also involved naming columns with the names of features which were provided in a separate file. This was achieved using the following functions:

as.character (which changed the type of label from factor to string)
colnames (to add the desired attribute to data frame)
Step 2

Choosing only the variables which were means or standard deviations of some characteristics was performed by the following functions:

grepl (searching a pattern of characters in a string)
which (returning indices that meet some conditions)
The author also took into consideration columns labeled with meanFreq(), as the file 'features_info.txt' indicated that this is "weighted average of the frequency components to obtain a mean frequency", which simply means that this is also a summary statistics, but of a variable measuring some frequencies.

The resulting data set consists of 81 columns (79 variables plus columns indicating activity and subject).

Step 3 and step 4

Labeling the activities not with numbers, but descriptive names, consisted of two steps. First part was to read the file containing activity names, the second part - to convert variable "activity" to the factor and name the levels of activity with those names. This was achieved with functions:

file.path and read.table (as described above, in step 1)
factor(data, labels) (where data is the desired "activity" column and labels are names read from the file "activity_labels.txt")
Step 5

Creating the second table, with average of each variable for each activity and each subject, was achieved thanks to functions:

melt (creating a table with 813621 rows, each containing subject number, activity name - as we want to summarize data according to these columns - and variable name and its value)
dcast (creating data frame output with 180 rows - because of 30 subjects, each with 6 possible activity states, and 81 columns - 79 variables, subject number and activity name)
It is important to set the aggregation function as mean (in function dcast, argument fun.aggregate), as the default value is sum, which is not the desired summary function for this exercise.

The tidy dataset can be written to a separate .txt file using the following function:

write.table ("row.names" argument needs to be set as FALSE)
