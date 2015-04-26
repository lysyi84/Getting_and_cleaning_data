features=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/features.txt"))
activity_labels=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/activity_labels.txt"))

x_train=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/train/X_train.txt"))
y_train=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/train/y_train.txt"))
subject_train=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/train/subject_train.txt"))

x_test=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/test/X_test.txt"))
y_test=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/test/y_test.txt"))
subject_test=read.table(unzip("getdata-projectfiles-UCI HAR Dataset.zip","UCI HAR Dataset/test/subject_test.txt"))

colnames(x_train)=features$V2
colnames(y_train)="activity"
colnames(subject_train)="subject"
d_train=cbind(x_train,y_train,subject_train)

colnames(x_test)=features$V2
colnames(y_test)="activity"
colnames(subject_test)="subject"
d_test=cbind(x_test,y_test,subject_test)

library(data.table)
D=data.table(rbind(d_train,d_test))

col_numbers=grep("-mean\\(|-std\\(",colnames(D))
D1=subset(D,select=col_numbers)
D2=subset(D,select=c("activity","subject"))
D3=aggregate(D1,by=list(D2$subject,D2$activity),FUN=mean)
names(D3)[1]="subject"
names(D3)[2]="activity"

D3$activity=activity_labels$V2[match(D3$activity,activity_labels$V1)]
write.table(D3,"means.txt",row.name=FALSE)
