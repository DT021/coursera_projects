##############################################################################
# Load libraries
####################

library("tidyverse")
library("data.table")


##############################################################################
# Loading the data
####################

# Get file size, convert to kB
file.size("household_power_consumption.txt")/1000

# Check available system memory (in kB), command only works on Windows
if(.Platform$OS.type == "windows") 
  system('wmic OS get FreePhysicalMemory /Value')

# Looks like I have more than enough memory to load
df <- fread("household_power_consumption.txt", na.strings="NA")

# Filter dates I'm using
df %>%
  filter(Date == '1/2/2007' | Date == '2/2/2007') %>%
  mutate(Global_active_power = as.numeric(Global_active_power)) -> df


##############################################################################
# Plot 1
####################

# Set graphics device as png with 480x480 size
png('plot1.png', width = 480, height = 480, units = "px")

# Histogram with title
hist(df$Global_active_power, 
     col = "red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# Turn off graphics device
dev.off()