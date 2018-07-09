# This is a script to load, clean and visualize data about July 4 fireworks-related pollution
# The steps in this script will only work if fireworks_scrape.R has previously been run
# This code was written by David H. Montgomery for CityLab and is available under the MIT License

# Load packages
library(tidyverse)
library(scales)
library(stringr)
library(lubridate)

# If you haven't run fireworks_scrape.R, you must run it first. This will take a while:
# source("fireworks_scrape.R") 

# Load in our data from the hundreds of CSVs we scraped previously

# Create a helper function for the import
# This is basically read_csv, but it skips any tables that don't have three columns
# We need this in order to use purrr to import these columns even if the scraping didn't work perfectly
read_csv_and_filter <- function(filename, ncol = 3, ...) {
    table <- read_csv(filename, ...)
    if (ncol(table) == ncol) {
        return(table)
    } else {
        return(data.frame("created_at" = character(), "entry_id" = character(), "field2" = numeric()))
    }
}

# Load load up a table of time zone references to adjust from UTC
timezones <- read_csv("jsondump.csv") %>% 
    left_join(read_csv("us_timezone_reference.csv")) %>%
    select(THINGSPEAK_PRIMARY_ID, tzid, diff) %>% # Select only the columns we need
    mutate(THINGSPEAK_PRIMARY_ID = as.character(THINGSPEAK_PRIMARY_ID)) # Convert ID numbers to character

# Store our file names in both short and long formats
files <- dir("csvs", full.names = TRUE)
short_files <- dir("csvs") %>% str_remove_all(".csv")

# Load in all the CSVs we scraped, combine them into a dataframe, and clean and format
july4 <- map2(files, # Take our list of filenames as '.x'
              short_files, # And our list of short filenames as '.y'
              # And map our custom function over them, reading the data in, omitting some empty CSVs
              ~read_csv_and_filter(.x, col_types = "ccn") %>% 
                  mutate(sensor = .y)) %>% # Before we join them, label each one with a unique ID number
    reduce(bind_rows) %>% # Combine all these spreadsheets into a single dataframe
    # Join with our time zone data
    left_join(timezones, by = c("sensor" = "THINGSPEAK_PRIMARY_ID")) %>%
    # Convert our timestamps into datetime format, and adjust for time zones
    mutate(created_at = as_datetime(created_at) + (diff * 60 * 60)) %>% # R tracks time in seconds, so we multiply
    mutate(created_at = round_date(created_at, unit = "minute")) %>% # Round off times to the nearest minute
    group_by(created_at) %>% # Group by minutes
    summarize(field2 = mean(field2)) # For each minute, calculate the average pollution reading of every sensor

# Graph it!
# This won't look exactly like CityLab's version because we have a private custom ggplot theme
ggplot(july4, aes(x = created_at, y = field2)) + # Plot the time on the x-axis and the pollution on the y
    geom_point(size = .2) + # Make this a point graph, and shrink the points because we'll have so many
    scale_x_datetime(date_breaks = "1 day", date_labels = "%b %d") + # Format the x-axis as days
    scale_y_continuous(expand = expand_scale(mult = c(0, .1))) + # Remove extra space above x-axis 
    expand_limits(y= 0) + # Start the y-axis at 0
    {if(exists("theme_citylab")) theme_citylab()} + # Add CityLab's ggplot theme if it exists; otherwise move on
    # If CityLab's ggplot theme exists, re-add the vertical gridlines it normally removes
    {if(exists("theme_citylab")) theme(panel.grid.major.x = element_line(), panel.grid.minor.x = element_line())} +
    # Label the plot
    labs(title = "Air Pollution Spikes During July 4 Fireworks", 
         caption = "Source: CityLab analysis of 2017 PurpleAir sensor data (David H. Montgomery/CityLab)", 
         y = expression(AVERAGE~FINE~PARTICULATE~MATTER~LEVELS~(μg/m^3)), # Use expression() to get a superscript
         x = "DATE AND TIME OF READING")

# Graph a zoomed-in version; see above graph for additional comments
ggplot(data = july4 %>% filter(created_at >= as_datetime("2017-07-04 12:00:00")), # Filter the data by date
       aes(x = created_at, y = field2)) +
    geom_point(size = .2) +
    scale_x_datetime(date_labels = "%b %d, %I %p", date_minor_breaks = "1 hour") +
    {if(exists("theme_citylab")) theme_citylab()} +
    {if(exists("theme_citylab")) theme(panel.grid.major.x = element_line(), panel.grid.minor.x = element_line())} +
    theme(panel.grid.major.x = element_line(), panel.grid.minor.x = element_line()) +
    labs(title = "Fireworks Air Pollution Peaks Around 10 p.m.", 
         caption = "Source: CityLab analysis of 2017 PurpleAir sensor data (David H. Montgomery/CityLab)", 
         y = expression(AVERAGE~FINE~PARTICULATE~MATTER~LEVELS~(μg/m^3)), 
         x = "DATE AND TIME OF READING")