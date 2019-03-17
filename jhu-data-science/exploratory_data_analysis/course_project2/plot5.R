###############################################################################
# Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


###############################################################################
# Load libraries
library("tidyverse")
library("ggplot2")


###############################################################################
# Question 5
# How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?

# Get all motor vehicle sources using EI.Sector
# looking at the data, there are different ways I could have filtered it.
# A very literal interpretation of the question might lead us to filter by
# "Motor Vehicles" in SCC.Level.Three, but for this there is no data in
# Baltimore, and it seems to be missing a lot of other vehicle-related
# emissions. Instead I will use the "Mobile - On-Road" stem in EI.Sector.


###############################################################################
# Wrangle data

SCC %>% 
  filter(grepl("Mobile - On-Road", EI.Sector)) %>% 
  select(SCC) -> SCCs_to_keep

# Get total (sum) emissions by year, filter by fips 24510
NEI %>%
  filter(SCC %in% SCCs_to_keep$SCC, fips == "24510") %>%
  group_by(year) %>%
  summarize(Emissions = sum(Emissions)) -> data


###############################################################################
# Generate plot

# Generate a scatter plot with smooth fit line
plot <- ggplot(data, aes(x = year, y = Emissions)) +
  geom_point(size = 4) + # Points
  geom_smooth(aes(color = "Spline")) + # Spline
  geom_smooth(method="lm", aes(color = "Linear Fit"),
              se = F, linetype = 2, size = .5) + # Linear fit
  scale_colour_discrete(name = "Line Type", 
                        breaks = c("Spline", "Linear Fit")) + # Legend
  scale_x_discrete(name = "Year", limits = data$year) + # Manual x-axis ticks
  ggtitle("PM2.5 Vehicle Emissions by Year in Baltimore") # Title


###############################################################################
# Save plot

ggsave("plot5.png")


###############################################################################
# Cleanup

# Remove temporary data and plot from memory
rm(data)
rm(plot)
