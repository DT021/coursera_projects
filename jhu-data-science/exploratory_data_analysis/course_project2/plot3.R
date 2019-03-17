###############################################################################
# Read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


###############################################################################
# Load libraries
library("tidyverse")
library("ggplot2")


###############################################################################
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in 
# emissions from 1999–2008 for Baltimore City? Which have seen increases in 
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.


###############################################################################
# Wrangle data

# Get total (sum) emissions by year and type, filtered on fips 24510
NEI %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarize(Emissions = sum(Emissions)) -> data


###############################################################################
# Generate plot

# Generate a scatter plot with linear fit line
# faceted by type, with some theming to make it more readable
plot <- ggplot(data, aes(x = year, y = Emissions)) +
  geom_point() +
  facet_grid(. ~ type) + 
  geom_smooth(method="lm", se = F) + 
  scale_x_discrete(name = "Year", limits = data$year) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle("PM2.5 Emissions in Baltimore by Year and Type")


###############################################################################
# Save plot

ggsave("plot3.png")


###############################################################################
# Cleanup

# Remove temporary data and plot from memory
rm(data)
rm(plot)
