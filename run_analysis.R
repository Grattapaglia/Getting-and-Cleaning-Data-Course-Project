# Reads and binds train data sets:

train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_y, train_x)

# Reads and binds test data sets:

test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_y, test_x)

# Merges the train and test data sets:

data <- rbind(train, test)

# Reads activity labels and features and turns their second column into characters

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels$V2 <- as.character(activity_labels$V2)

features <- read.table("UCI HAR Dataset/features.txt")
features$V2 <- as.character(features$V2)

# Names the columns of the merged data

colnames(data) <- c("subject", "activity", features$V2)

# Search for matches on mean and standard deviation 

mean_and_std_colnumbers <- grep(".*mean.*|.*std.*", colnames(data))

# Extract the columns from data that match the words mean and std

data_final <- data[,c(1, 2, mean_and_std_colnumbers)]

# Replace the numbers of the activity column with their respective labels

data_final$activity <- factor(data_final$activity, levels = activity_labels$V1, labels = activity_labels$V2)

# Opens package and melt objects

library(reshape2)

data_final <- melt(data_final, id = c("subject", "activity"))

# Casts the data set

data_tidy <- dcast(data_final, subject + activity ~ variable, mean)

# Exports data set to working directory

write.table(data_tidy, "data_tidy.txt", row.names = F)
