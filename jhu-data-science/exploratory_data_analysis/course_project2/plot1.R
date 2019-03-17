###############################################################################
# Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


###############################################################################
# Load libraries
library("tidyverse")
library("ggplot2")


###############################################################################
# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.


###############################################################################
# Wrangle data

# Get total (sum) emissions by year
NEI %>%
  group_by(year) %>%
  summarize(Emissions = sum(Emissions)) -> data


###############################################################################
# Set graphics device

png('plot1.png')


###############################################################################
# Generate plot

# Line
plot(data, xaxt="n", type="l",
     main = "PM2.5 Emissions by Year",  xlab = "Year",  ylab = "Emissions",
     lwd = 1)

# Add points
points(data, lwd = 1, cex = 2)

# Add x-axis labels
with(data, axis(1, at = c(data$year)))

# Add linear fit line
with(data, abline(lm(Emissions ~ year), col = "red", lty = "dashed"))

# Add legend
legend("topright", legend = c("Spline", "Linear Fit"),
       col = c("black", "red"), lty = 1:2)


###############################################################################
# Save plot (turn device off) and cleanup

# Turn off graphics device
dev.off()

# Remove temporary data from memory
rm(data)