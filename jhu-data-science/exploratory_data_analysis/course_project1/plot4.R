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
# Plot 4
####################

# Set graphics device as png with 480x480 size
png('plot4.png', width = 480, height = 480, units = "px")

# Set 2x2 grid for our 4 plots
par(mfrow = c(2, 2))

######
# Plot 1 -- Top-left corner
with(df, plot(Datetime, Global_active_power, type = "n", 
              ylab = "Global Active Power", xlab = ""))

# Add spline
with(df, lines(spline(Global_active_power ~ Datetime)))


######
# Plot 2 -- Top-right corner
with(df, plot(Datetime, Voltage, type = "n", 
              ylab = "Voltage", xlab = "datetime"))

# Add spline
with(df, lines(spline(Voltage ~ Datetime)))


######
# Plot 3 -- Bottom-left corner
with(df, plot(Datetime, Sub_metering_1, type = "n", 
              ylab = "Energy sub metering", xlab = ""))

# Add spline for Sub_metering_1
with(df, lines(spline(Sub_metering_1 ~ Datetime), col = "black"))

# Sub_metering_2
with(df, lines(spline(Sub_metering_2 ~ Datetime), col = "red"))

# Sub_metering_3
with(df, lines(spline(Sub_metering_3 ~ Datetime), col = "blue"))

# Add legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1, bty = "n")


######
# Plot 4 -- Bottom-right corner
with(df, plot(Datetime, Global_reactive_power, type = "n", 
              xlab = "datetime"))

# Add spline
with(df, lines(spline(Global_reactive_power ~ Datetime)))



# Turn off graphics device
dev.off()

