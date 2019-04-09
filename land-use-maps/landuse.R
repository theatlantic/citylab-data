library(tidyverse)
library(scales)
library(stringr)
library(raster)
library(rgdal)
library(magick)
library(sp)

## Helper function for below
add_magick <- function(p) {
	pg <- ggplotGrob(p)
	pg$layout$l[[which(pg$layout$name == "title")]] <- 2
	pg$layout$l[[which(pg$layout$name == "subtitle")]] <- 2
	plot <- tempfile()
	ggsave(pg, filename = plot, device = "png", width = 10, height = 7)
	image_read(plot) %>% image_scale("2000x1400") %>% image_border(color = "white", "15x")}

## Download data
download.file("http://ecotope.org/files/anthromes/v2/data/anthromes/anthromes_2_GeoTIFF.zip", "anthromes_2_GeoTIFF.zip")
unzip("anthromes_2_GeoTIFF.zip", exdir = "geotiffs") # Unzip into a folder called "geotiffs"

## Compile and clean the downloaded data
files <- paste0("geotiffs/", c("1700/anthro2_a1700.tif", "1800/anthro2_a1800.tif", "1900/anthro2_a1900.tif", "2000/anthro2_a2000.tif")) # Store the filepaths of our downloaded data as a vector
landusedata <- files %>% # Take those filepaths
	map(raster) %>% # Load each of them in as a raster image with "purrr::map"
	# Convert to a data frame
	map(as, "SpatialPixelsDataFrame") %>% 
	map(as.data.frame) %>%
	map(~ set_names(.x, "value", "x", "y")) %>% # Set column names
	# Simplify the classification structure to a few discrete categories
	map(~ mutate(.x, landuse = case_when(value %in% c(11, 12) ~ "Urban",
										 value %in% c(21:24) ~ "Villages",
										 value %in% c(31:34) ~ "Cropland",
										 value %in% c(41:43) ~ "Rangeland",
										 value %in% c(51:54) ~ "Woodland",
										 value %in% c(61, 62) ~ "Wild") %>%
				 	# Put the categories in the order we'll want
				 	as.factor() %>% fct_relevel("Urban", "Villages", "Cropland", "Rangeland", "Woodland", "Wild"))) %>%
	map(~ filter(.x, !is.na(landuse)))

## Create an animation of land use changes worldwide

for(i in 1:4) { # Loop through our four images
	p <- ggplot(landusedata[[i]]) + # Creating for each one a ggplot image
		geom_tile(aes(x = x, y = y, fill = landuse)) + # Using the land use categories we created as the fill
		scale_fill_manual(values = c("#FF404E", "#FFBCBA", "#94E0A8", "#FFEE7D", "#109B54", "#F9D9BD")) + # Assign colors
		# Customize theme elements
		theme(axis.text = element_blank(), # Remove axis text
			  axis.line = element_blank(), # Remove the axis line from the default CityLab theme
			  axis.title = element_blank(), # Remove axis titles
			  axis.ticks = element_blank(), # Remove axis ticks
			  plot.title = element_text(size = 32), # Increase title size
			  panel.grid = element_blank(), # Remove grey background
			  legend.position = "bottom", # Position legend at bottom
			  panel.background = element_blank())	+ # Remove gridlines
		# Apply labels
		labs(title = paste0("Land use in ", i * 100 + 1600), # Dynamic title based on the year of the image we're showing
			 caption = "Source: ecotope.org (David H. Montgomery/CityLab)", # Caption
			 fill = "") # Hide label for legend
	p1 <- add_magick(p) # Convert to a magick image using our helper function
	# Create an object, `landusemaps`, that's a vector of all four ggplot images
	if(exists("landusemaps")) { landusemaps <- append(landusemaps, p1)} else { landusemaps <- append(c(), p1)}
}
a <- image_animate(landusemaps, fps = 1) # Animate the images at 1 frame per second
image_write(a, "landuse.gif") # Save to disk
rm(landusemaps) # Delete the `landusemaps` object so it doesn't cause problems if we run this gain

## Create a map zoomed in on Europe

landuse_europe <- files %>% # Start as before
	map(raster) %>%
	map(~crop(.x, extent(-12, 40, 35, 65))) %>% # Crop based on latitude and longitude
	# Continue as before
	map(as, "SpatialPixelsDataFrame") %>% 
	map(as.data.frame) %>%
	map(~ set_names(.x, "value", "x", "y")) %>%
	map(~ mutate(.x, landuse = case_when(value %in% c(11, 12) ~ "Urban",
										 value %in% c(21:24) ~ "Villages",
										 value %in% c(31:34) ~ "Cropland",
										 value %in% c(41:43) ~ "Rangeland",
										 value %in% c(51:54) ~ "Woodland",
										 value %in% c(61, 62) ~ "Wild") %>%
				 	as.factor() %>% fct_relevel("Urban", "Villages", "Cropland", "Rangeland", "Woodland", "Wild"))) %>%
	map(~ filter(.x, !is.na(landuse)))

# Use the same process as above to create the animations
for(i in 1:4) {
	p <- ggplot(landuse_europe[[i]]) +
		geom_tile(aes(x = x, y = y, fill = landuse)) +
		scale_fill_manual(values = c("#FF404E", "#FFBCBA", "#94E0A8", "#FFEE7D", "#109B54", "#F9D9BD")) +
		theme(axis.text = element_blank(), # Remove axis text
			  axis.line = element_blank(), # Remove the axis line from the default CityLab theme
			  axis.title = element_blank(), # Remove axis titles
			  axis.ticks = element_blank(), # Remove axis ticks
			  plot.title = element_text(size = 32), # Increase title size
			  panel.grid = element_blank(), # Remove grey background
			  legend.position = "bottom", # Position legend at bottom
			  panel.background = element_blank())	+ # Remove gridlines
		labs(title = paste0("European land use in ", i * 100 + 1600),
			 caption = "Source: ecotope.org (David H. Montgomery/CityLab)",
			 fill = "")
	p1 <- add_magick(p)
	if(exists("europe_map")) { europe_map <- append(europe_map, p1)} else { europe_map <- append(c(), p1)}
}
b <- image_animate(europe_map, fps = 1)
image_write(b, "landuse_europe.gif")
rm(europe_map)

## Do the same, but just for urban land use

for(i in 1:4) {
	p <- ggplot(landusedata[[i]], aes(x = x, y = y)) +
		geom_tile(fill = "grey90") +
		geom_tile(data = landusedata[[i]] %>% 
				  	filter(landuse %in% c("Urban", "Villages")), # The only change: this filter, showing only two landuse levels
				  aes(fill = landuse)) +
		scale_fill_manual(values = c("#FF404E", "#FFBCBA", "#94E0A8", "#FFEE7D", "#109B54", "#F9D9BD")) +
		theme(axis.text = element_blank(), # Remove axis text
			  axis.line = element_blank(), # Remove the axis line from the default CityLab theme
			  axis.title = element_blank(), # Remove axis titles
			  axis.ticks = element_blank(), # Remove axis ticks
			  plot.title = element_text(size = 32), # Increase title size
			  panel.grid = element_blank(), # Remove grey background
			  legend.position = "bottom", # Position legend at bottom
			  panel.background = element_blank())	+ # Remove gridlines
		labs(title = paste0("Urban areas in ", i * 100 + 1600),
			 caption = "Source: ecotope.org (David H. Montgomery/CityLab)",
			 fill = "")
	p1 <- add_magick(p)
	if(exists("landusemaps")) { landusemaps <- append(landusemaps, p1)} else { landusemaps <- append(c(), p1)}
}
c <- image_animate(landusemaps, fps = 1)
image_write(c, "landuse_urban.gif")
rm(landusemaps)