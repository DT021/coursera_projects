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

# Get total (sum) emissions by year, filter by fips 24510 or 06037
# code for region name
NEI %>%
  filter(SCC %in% SCCs_to_keep$SCC, 
         fips == "24510" | fips == "06037") %>%
  mutate(Region = ifelse(fips == "06037", "Los Angeles", "Baltimore")) %>%
  group_by(year, Region) %>%
  summarize(Emissions = sum(Emissions)) -> data


###############################################################################
# Transform data
# One of the challenges here is that emissions are so different between the
# two regions, so we want to first "normalize" the data so comparisons are
# easier to understand. I will transform Emissions to % change from the previous 
# year. This allows us to compare relative change.

# Read more about % change here:
# https://en.wikipedia.org/wiki/Relative_change_and_difference#Percentage_change

data %>%
  group_by(Region) %>%
  mutate(
    # First I'll create a "lag variable" equal to previous year
    Emissions_previous = lag(Emissions, n = 1, default = NA),
    # Then I'll subtract current from previous to get raw change
    Emissions_change = ifelse(is.na(Emissions_previous), 0, Emissions - Emissions_previous),
    # Then I'll calculate percentage change
    Emissions_pct_change = Emissions_change / Emissions
    ) -> data


###############################################################################
# Generate plot

# Generate a scatter plot with smooth fit line
plot <- ggplot(data, aes(x = year, y = Emissions_pct_change, fill = Region)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) + # Bar plot
  scale_x_discrete(name = "Year", limits = data$year) + # Manual x-axis ticks
  scale_y_continuous(name = "Percent Change in Emissions\n(Lower is Better)", # Y-axis title
                     labels = scales::percent_format(accuracy = 1)) + # Y-axis % format
  ggtitle("Percent Change in PM2.5 Vehicle Emissions\nby Year and Region") # Title


###############################################################################
# Save plot

ggsave("plot6.png")


###############################################################################
# Cleanup

# Remove temporary data and plot from memory
rm(data)
rm(plot)
