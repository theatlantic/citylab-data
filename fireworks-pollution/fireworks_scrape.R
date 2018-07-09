# This is a script to download data from Purple Air's network of air sensors about July 4 fireworks-related pollution
# Specifically, it will scrape a list of Purple Air's sensors, then download data from US-based sensors for a week around the Fourth of July, 2017
# A separate script, fireworks_viz.R, will analyze and visualize the data acquired in this script
# Some steps in this script will take some time to run
# This code was written by David H. Montgomery for CityLab and is available under the MIT License

# Load packages
library(tidyverse)
library(scales)
library(stringr)
library(lubridate)
library(rvest)
library(rjson)
library(jsonlite)
library(RCurl)
library(rgdal)

# Scrape the HTML table from purpleair.com/sensorlist
sensor_table <- "https://www.purpleair.com/sensorlist" %>% # Take the URL
    read_html() %>% # Read it as HTML
    html_nodes(xpath = '//*[@id="thelist"]/font/table') %>% # Extract just the table from the page
    html_table() %>% # Read as a table
    `[[`(1) %>% # Convert the table into a data frame format
    # Filter and clean the scraped table
    filter(X3 != "") %>% # Remove duplicate sensors that lack data in the third column
    select(-X1) %>% # Drop an empty column
    # Parse out the dates in the third column
    separate(X2, into = "name", sep = "Real ", extra = "drop") %>%
    separate(X3, into = c("created", "rest"), sep = "LastSeen: ", extra = "merge") %>%
    separate(rest, into = "last_seen", sep = "Age: ", extra = "drop") %>%
    select(-X4, -X5) %>% # Drop unneeded columns
    # Convert our created and last_seen columns to dates
    mutate(created = str_remove_all(created, "Created: ") %>% as_datetime(),
           last_seen = as_datetime(last_seen)) %>%
    # Scrape the HTML map URLs and add it to our data frame
    bind_cols("https://www.purpleair.com/sensorlist" %>%
                  read_html() %>%
                  html_nodes(xpath = '//*[@id="thelist"]/font/table') %>%
                  html_nodes("td") %>% 
                  html_nodes("a") %>% 
                  html_attr("href") %>% 
                  as_data_frame()) %>%
    # Parse out latitude and longitude from the URL
    separate(value, into = c("lat", "rest"), sep = "&", extra = "merge") %>%
    separate(rest, "lon", sep = "&", extra = "drop") %>%
    mutate(lat = str_remove_all(lat, "/map\\?lat=") %>% as.numeric(),
           lon = str_remove_all(lon, "lng=") %>% as.numeric()) %>%
    filter(lon < -67 & lat < 49.3457868 & lat > 24.7433195) # Filter out sensors outside of the US (a little superfluous given a future step; feel free to delete this line)

# Filter out sensors that weren't active over July 4, 2017.
id2017 <- filter(sensor_table, created < as_datetime("2017-07-04"), last_seen > as_datetime("2017-07-04"))

# Scrape a full readout of sensor data from Purple Air's JSON stream
jsondump <- fromJSON(getURL("https://www.purpleair.com/json"))$results %>% # Get the JSON
    filter(Label %in% id2017$name) # Filter to just the sensors we want, from id2017

# Add time zone data and filter out some Canadian sensors
# Download a shapefile of time zone boundaries
download.file("https://github.com/evansiroky/timezone-boundary-builder/releases/download/2018d/timezones.shapefile.zip", "timezones.shapefile.zip") 
unzip("timezones.shapefile.zip") # Unzip
timezones_shp <- readOGR("dist", "combined-shapefile") # Load the shapefile into R 
unlink("timezones.shapefile.zip") # Remove the .zip file
unlink("dist", recursive = TRUE) # Remove the shapefile

sensor_points <- jsondump # Create a copy of jsondump for plotting our sensor points
coordinates(sensor_points) <- ~Lon + Lat # Convert our lat/lon coordinates into a GIS object
proj4string(sensor_points) <- proj4string(timezones_shp) # Match up projection systems

jsondump <- jsondump %>% # Take our list of sensors
    # Calculate which time zone each sensor point lies in, and merge this with our list of sensors
    bind_cols(over(sensor_points, timezones_shp)) %>% 
    # Filter to just US time zones
    filter(tzid %in% c("America/Anchorage", "America/Boise", "America/Chicago", "America/Denver", "America/Detroit", "America/Indiana/Indianapolis", "America/Indiana/Knox", "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City", "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Indianapolis", "America/Juneau", "America/Kentucky/Louisville", "America/Kentucky/Monticello", "America/Knox_IN", "America/Los_Angeles", "America/Louisville", "America/Menominee", "America/New_York", "America/Nome", "America/North_Dakota/Beulah", "America/North_Dakota/Center", "America/North_Dakota/New_Salem", "America/Phoenix", "America/Puerto_Rico"))

# Scrape the actual data using ThingSpeak's API

# First, create our list of scraping URLs
api_key <- "" # Insert your ThingSpeak API Read key here
urls <- data.frame( # Create a table with all the URLs in it
    url = paste0("https://api.thingspeak.com/channels/", # Paste the base URL
                 unique(jsondump$THINGSPEAK_PRIMARY_ID), # Plus the unique ID from another table
                 # Plus the rest of the URL with my key and the start and end dates of the data I want
                 "/fields/2.csv?api_key=", # This scrapes just field number two rather than all the data
                 api_key,
                 "&start=2017-06-29%2000:00:00&end=2017-07-06%2000:00:00"),
    id = as.character(unique(jsondump$THINGSPEAK_PRIMARY_ID))) # Also store those unique IDs in another column

# Now, scrape the data
# (This will take a while)
if(!dir.exists("csvs")) {dir.create("csvs") } # Create a folder to hold the CSVs, if it doesn't already exist
for(i in 1:nrow(urls)) { # Loop through the table we just created, row by row
    if(getURL(urls$url[i]) != "-1") { # Check to see if calling the URL results in an error.
        write_csv( # If not, for each URL, create a CSV file on my computer
            read_csv(getURL(urls$url[i])), # Containing the spreadsheet I get from visiting each URL
            paste0("csvs/", urls$id[i], ".csv")) # With the ID number as the document's name
    }
}

# Save everything we've acquired as CSVs, so we don't have to do this again
write_csv(sensor_table, "sensor_table.csv")
write_csv(jsondump, "jsondump.csv")
write_csv(id2017, "id2017.csv")

# See fireworks_viz.R for how to analyze and visualize this data