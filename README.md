---
title: "README"
output: html_document
---



##1) Merges the training and the test sets to create one data set.

###reading train data
tr - train data

```r
tr <- read.table("UCI HAR Dataset/train/X_train.txt")
```

###reading test data
te - test data

```r
te <- read.table("UCI HAR Dataset/test/X_test.txt")
```

###merging train and test
t - the merged data (currently contains all columns)

```r
t <- rbind(tr,te)
```

##2) Extracts only the measurements on the mean and standard deviation for each measurement. 

###reading column name
tl - column names

```r
tl <- read.table("UCI HAR Dataset/features.txt")
```

###selecting the mean() and std() columns
fm - the row number of the mean columns
fs - the row number of the std columns

```r
fm <- grep("mean()",tl$V2,fixed = T)
fs <- grep("std()",tl$V2,fixed = T)
```

###selecting only the columns where the column numbers are identical with the two arrays of the previous step
t - the merged data (it contains now only the mean and standard deviations columns)

```r
t <- t[,c(fm,fs)]
```

##3) Uses descriptive activity names to name the activities in the data set
###read train activity file
trac - train activity file

```r
trac <- read.table("UCI HAR Dataset/train/y_train.txt")
```

###read test activity file
teac - test activity file

```r
teac <- read.table("UCI HAR Dataset/test/y_test.txt")
```

###adding the two activity dataset together
tac - the train and test activity files together

```r
tac <- rbind(trac,teac)
names(tac) <- "act_code"
```

###binding the activity dataset with the dataset from step 2
t1 - the dataset including the activity codes

```r
t1 <- cbind(tac,t)
```

###reading the activity label file
acl - activity label file

```r
acl <- read.table("UCI HAR Dataset/activity_labels.txt")
names(acl) <- c("act_code","activity")
```

###merging the activity label data and the dataset based on the activity code
tm - the dataset including the activity codes and activity names

```r
tm <- merge(t1,acl,by.x = "act_code", by.y="act_code")
```

###rearranging the columns

```r
tm <- tm[,c(1,68,2:67)]
```

##4) Appropriately labels the data set with descriptive variable names. 
###selecting the relevant column names from the column names data (tl)
tl1 - column names including only the mean and standard deviations attributes

```r
tl1 <- tl[c(fm,fs),]
tmname <- as.character(tl1$V2)
names(tm) <- c("act_code","activity", tmname)
```

##5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###reading the subject files: train and test
trs - train subject file
tes - test subject file

```r
trs <- read.table("UCI HAR Dataset/train/subject_train.txt")
tes <- read.table("UCI HAR Dataset/test/subject_test.txt")
```

###binding the train and test subject files
ts - the total subject file (train and test together)

```r
ts <- rbind(trs,tes)
```

###binding the subject data with the dataset
tms - the dataset including the activity codes, activity names and the subject codes

```r
tms <- cbind(ts,tm)
names(tms) <- c("subject","act_code","activity", tmname)
```

###loading the reshape2 package

```r
library(reshape2)
```

```
## Warning: package 'reshape2' was built under R version 3.0.3
```

###selecting the column names of the measure variables

```r
meas <- names(tms[,4:69])
```

###melting the file
tmsmelt - the melt version of the dataset (subject, activity code and activity name as IDs and the mean and std variables as measure variables)

```r
tmsmelt <- melt(tms,id=c("subject","act_code","activity"),measure.vars = meas)
```

###casting the melted files by the subject and the activity category
tmscast - the tidy data with the average of each variable for each activity and each subject

```r
tmscast <- dcast(tmsmelt, subject + activity ~ variable, mean)
```

###creating the txt file
write.table(tmscast,"ActivityTidy.txt",row.name=F)


