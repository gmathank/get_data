library(plyr)
library(reshape2)

test = read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
label_test = read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
subject_test = read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")

train = read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
label_train = read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
subject_train = read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

featnames = read.table(".\\UCI HAR Dataset\\features.txt")
activity_labels = read.table(".\\UCI HAR Dataset\\activity_labels.txt")

# merge train and test datasets
df = rbind(train, test)
# rename the feature names
colnames(df) <- featnames[,2]

# find features related to mean and std dev
idx = grepl('mean',colnames(df)) | grepl('std',colnames(df))
df = df[,idx]

df2 = cbind(rbind(label_train, label_test), rbind(subject_train,subject_test))
colnames(df2) = c("activity_label","subject")
df2$activity_label = as.factor(df2$activity_label)
df2$subject = as.factor(df2$subject)

# rename activity label from numeric to activity name
df2$activity_label = mapvalues(df2$activity_label, from = levels(factor(activity_labels$V1)), to = levels(factor(activity_labels$V2)))

df = cbind(df,df2)

df3 = ddply(df,c("activity_label","subject"), numcolwise(mean))
    
write.table(df3, "tidy_data.txt", row.name=FALSE)
