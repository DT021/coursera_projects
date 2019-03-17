###############################################################################
# Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


###############################################################################
# Load libraries
library("tidyverse")
library("ggplot2")


###############################################################################
# Question 4
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# So, this question is kind of ambiguous. Does "Across the United States" mean
# I should collapse all the regions into 1, or look at each region separately?
# I assumed the first, because there are 3263 unique FIPS codes and we are not
# given data to convert FIPS codes to larger regions


###############################################################################
# Wrangle data

# Get all coal sources from SCC using EI Sector
SCC %>% 
  filter(grepl("Coal", EI.Sector)) %>% 
  select(SCC) -> SCCs_to_keep

# Get total (sum) emissions by year
NEI %>%
  filter(SCC %in% SCCs_to_keep$SCC) %>%
  group_by(year) %>%
  summarize(Emissions = sum(Emissions)) -> data


###############################################################################
# Generate plot

# Generate a scatter plot with linear fit line
plot <- ggplot(data, aes(x = year, y = Emissions)) +
  geom_point(size = 4) + # Points
  geom_smooth(aes(color = "Spline")) + # Spline
  geom_smooth(method="lm", aes(color = "Linear Fit"),
              se = F, linetype = 2, size = .5) + # Linear fit
  scale_colour_discrete(name = "Line Type", 
                        breaks = c("Spline", "Linear Fit")) + # Legend
  scale_x_discrete(name = "Year", limits = data$year) + # Manual x-axis ticks
  ggtitle("PM2.5 Coal Emissions by Year") # Title


###############################################################################
# Save plot

ggsave("plot4.png")


###############################################################################
# Cleanup

# Remove temporary data and plot from memory
rm(data)
rm(plot)
