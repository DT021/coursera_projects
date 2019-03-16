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
# convert date and time to as.POSIXct object
df %>%
  filter(Date == '1/2/2007' | Date == '2/2/2007') %>%
  mutate(Datetime = as.POSIXct(strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")),
         Global_active_power = as.numeric(Global_active_power)) -> df


##############################################################################
# Plot 3
####################

# Set graphics device as png with 480x480 size
png('plot3.png', width = 480, height = 480, units = "px")

# Plot for Sub_metering_1
with(df, plot(Datetime, Sub_metering_1, type = "l", 
              ylab = "Energy sub metering", xlab = ""))

# Add Sub_metering_2
with(df, lines(Sub_metering_2 ~ Datetime, col = "red", type = "l"))

# Add Sub_metering_3
with(df, lines(Sub_metering_3 ~ Datetime, col = "blue", type = "l"))

# Add legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1)


# Turn off graphics device
dev.off()

