
###############################################################################
#### Step 0
# Load libraries and data
####

# Load tidyverse library
library("tidyverse")

# Download data zip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "data.zip", "curl")

# Unzip
unzip("data.zip")



###############################################################################
#### Step 1
# INSTRUCTIONS: Merge the training and the test sets to create one data set
####

# Measurements
measurements <- data.frame(fread("UCI HAR Dataset/test/X_test.txt")) %>%
  bind_rows(data.frame(fread("UCI HAR Dataset/train/X_train.txt")))

# Subject IDs
subjs <- data.frame(fread("UCI HAR Dataset/test/subject_test.txt")) %>%
  bind_rows(data.frame(fread("UCI HAR Dataset/train/subject_train.txt"))) %>%
  rename(subject = V1)

# Activity IDs
activity <- data.frame(fread("UCI HAR Dataset/test/y_test.txt")) %>%
  bind_rows(data.frame(fread("UCI HAR Dataset/train/y_train.txt"))) %>%
  rename(activity = V1)

# Bind the columns together
tidy1 <- subjs %>% 
  bind_cols(activity) %>%
  bind_cols(measurements)



###############################################################################
#### Step 2
# INSTRUCTIONS: Extracts only the measurements on the mean and 
# standard deviation for each measurement
####

# Generate a list of features to keep (mean or std, but not meanFreq)
features <- data.frame(fread("UCI HAR Dataset/features.txt"))
features_to_keep <- features %>% 
  filter((grepl("mean", V2) | grepl("std", V2)) & !grepl("meanFreq", V2)) %>%
  mutate(col_ids = paste0("V", V1)) # Column identifier to use later

# Keep only subject, activity, and mean or std features
tidy1 <- tidy1[, c("subject", "activity", features_to_keep$col_ids)]



###############################################################################
#### Step 3
# INSTRUCTIONS: Uses descriptive activity names to name the activities 
# in the data set
####

# Read activity metadata file
activity_names <- data.frame(fread("UCI HAR Dataset/activity_labels.txt")) %>%
  rename(activity = V1, activity_name = V2)

# Left join with tidy1
tidy1 <- tidy1 %>%
  left_join(activity_names, by="activity")

# Reorder columns so that subject, activity, activity_name are first 
tidy1 <- tidy1 %>%
  select(1, 2, length(colnames(tidy1)), 3:length(colnames(tidy1))-1)



###############################################################################
#### Step 4
# INSTRUCTIONS: Appropriately labels the data set with descriptive 
# variable names
####

features_to_keep <- features_to_keep %>%
  mutate(col_names = gsub("\\(\\)", "", V2), # Remove "()" from name
         col_names = gsub("-", "_", col_names)) # Replace "-" with "_" for consistency

# Descriptive names are given by "col_names" in features_to_keep
old_names <- colnames(tidy1)
setnames(tidy1, old_names, c("subject", "activity", 
                            "activityname", features_to_keep$col_names))



###############################################################################
#### Step 5
# INSTRUCTIONS: From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for 
# each activity and each subject

tidy2 <- tidy1 %>% 
  group_by(subject, activity) %>%
  summarise_if(is_numeric, mean) %>%
  left_join(activity_names, by="activity")

# Reorder columns
tidy2 <- tidy2 %>%
  select(1, 2, length(colnames(tidy2)), 3:length(colnames(tidy2))-1)



###############################################################################
#### Step 6
# INSTRUCTIONS: Write to file

write.table(tidy2, file="output.txt", row.name=FALSE)
