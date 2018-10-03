library(tidyverse)
library(scales)
library(sf)
library(stringr)
library(readxl)

## Load in data on Census tracts that are split between multiple congressional districts
# This data comes from the Missouri Census Data Center's MABLE/Geocorr14: http://mcdc.missouri.edu/websas/geocorr14.html
split_tracts <- read_csv("data/split_tracts.csv", skip = 2, 
						 col_names = c("county", "tract", "state", "cd114", "stab", "cntyname", "pop14", 
						 			  "afact")) %>% 
	mutate(GEOID = paste0(county, tract) %>% str_remove_all("\\."), # Format tract numbers by removing periods
		   CD = paste0(stab, "-", cd114) %>% str_replace_all("-00", "-AL")) %>% # Get district names in proper format
	select(GEOID, stab, CD, afact) %>%  # Select key rows
	mutate(col = "split_tracts") %>% # Label these so I can swap out PA tracts later
	# Load in data on PA's tract/district relations, which are wrong in the above data.
	bind_rows(read_csv("data/pa_tracts.csv", col_types = cols(GEOID = "c")) %>% # Load PA's data
			  	as_data_frame() %>%
			  	mutate(col = "pa", # Mark this so I can replace the original PA data
			  		   stab = "PA") %>% # Format the state column of PA data like the national file
			  	select(GEOID, stab, CD = Code, afact, col)) %>%
	filter(!(col == "split_tracts" & stab == "PA")) %>% # Remove the original file's PA data
	select(-stab, -col)

## Load Census tract data and do a bunch of processing
census_tracts <- st_read("shapefiles", "tracts", quiet = TRUE) %>% # Read a shapefile of tract boundaries
	distinct() %>% # Filter out duplicate rows
	left_join(split_tracts, by = "GEOID") %>% # Join with our data on split tracts from above
    left_join(read_csv("data/tract_demog.csv"), by = "GEOID") %>% # Load a spreadsheet with demographic data for tracts
	# Load a spreadsheet for connecting state names, abbreviations and FIPs codes
	left_join(read_csv("data/statefips.csv", col_names = c("Name", "STATEFP", "State", "Region"), skip = 1) %>% 
			  	select(STATEFP, State, Region), 
			  by = "STATEFP") %>%
	# Calculate the area of each tract and add it as a column in the database
	bind_cols(st_area(.) %>% 
			  	as_data_frame() %>% 
			  	set_names("area") %>% 
			  	# Remove the square meters unit label the function adds and convert area from sq meters to sq miles
			  	mutate(area = str_remove_all(area, " m^2") %>% as.numeric() / 2.59e+6)) %>%
	# Calculate our density data for each tract.
	# This is the key step
	mutate(density = households/area, # Compute households per square mile
		   # Classify each district based on its density
		   type = case_when(
		   	density < 102 ~ "Very low density",
		   	density < 800 ~ "Low density",
		   	density < 2213 ~ "Medium density",
		   	density >= 2213 ~ "High density",
		   	TRUE ~ "NA"),
		   # For split tracts, `afact` represents the percentage of its land area in each district
		   # I don't know what afact means; I preserved the term used by MABLE/Geocorr14
		   # Here I calculate weighted population by multiplying population by `afact`
		   weighted_pop = pop * afact)


## Take all our Census tract data, from above, and summarize it by congressional district
district_summary <- census_tracts %>% 
	as_data_frame() %>%
	# Remove any tracts that weren't categorized because they're in US territories, not states
	filter(type != "NA") %>% 
	# For each congressional district, sum up the total population in each type of tract
	group_by(CD, Region, type) %>%
	summarize(pop = sum(weighted_pop, na.rm = TRUE)) %>%
	# Calculate the percentage of each congressional district's population in each type of tract
	group_by(CD) %>%
	mutate(pct = pop/sum(pop, na.rm = TRUE)) %>%
	select(-pop) %>% # Remove raw population as no longer necessary
	spread(type, pct, fill = 0) %>% # Spread the population percentage data into columns
	select(CD, `Very low density`, `Low density`, `Medium density`, `High density`) %>% # Reorder columns
	# Join data on current occupants of each seat
	left_join(read_excel("housemembers.xlsx") %>% 
			  	separate(`State/District`, c("State", "District"), sep = 2) %>%
			  	mutate(District = ifelse(District == "00", "AL", District),
			  		   CD = paste0(State, "-", District)) %>%
			  	select(CD, Party),
			  by = "CD") %>%
	# Load in data on presidential election results in district, from Daily Kos data
	left_join(results <- read_csv("data/Daily Kos Elections results CD.csv", 
								  col_types = "cc_dddddd", # Select and format certain columns
								  col_names = c("CD", "Incumbent", "Clinton16", "Trump16", "Obama12", "Romney12", "Obama08", "McCain08"), skip = 2) %>% 
			  	mutate_if(~ any(is.numeric(.x)),~.x/100), by = "CD") %>% # Convert percentages to decimal format
	# Load in data on 2016 congressional results by district
	left_join(read_excel("federalelections2016.xlsx", sheet = 13) %>%
			  	filter(!is.na(`GENERAL VOTES`), is.na(`TOTAL VOTES`), !str_detect(D, "UNEXPIRED")) %>%
			  	mutate(CD = paste0(`STATE ABBREVIATION`, "-", D)) %>%
			  	select(CD, PARTY, `GENERAL %`) %>%
			  	mutate(PARTY = PARTY %>% str_trim() %>% str_replace_all("DFL", "D") %>% as_factor() %>% fct_other(keep = c("D", "R")), 
			  		   CD = str_replace_all(CD, "-00", "-AL") %>% str_remove_all(" - FULL TERM")) %>%
			  	group_by(CD, PARTY) %>%  #CA-17
			  	summarize(`GENERAL %` = sum(`GENERAL %`)) %>%
			  	spread(PARTY, `GENERAL %`, fill = 0) %>%
			  	set_names(c("CD", "cong_R16", "cong_D16", "cong_Other16")), 
			  by = "CD") %>%
	# Load in data on Cook Political Report race ratings
	left_join(read_csv("data/cook.csv") %>%
			  	mutate(PVI = case_when(str_detect(PVI, "D") ~ str_remove(PVI, "D+") %>% as.numeric() * -1,
			  						   str_detect(PVI, "R") ~ str_remove(PVI, "R+") %>% as.numeric(),
			  						   str_detect(PVI, "EVEN") ~ 0)) %>% 
			  	select(-Incumbent), by = "CD") %>%
	# Calculate competitive races: Any race that's not "Safe"
	mutate(is_competitive_cook = case_when(
		cook_score %in% c(-2, 0, 2) ~ 1,
		TRUE ~ 0
	)) %>% 
	# Add in FiveThirtyEight's election predictions
	left_join(read_csv("data/house_district_forecast.csv") %>%
			  	# Identify the states with a single House district and add that as a column
			  	left_join(read_csv("data/house_district_forecast.csv") %>% 
			  			  	group_by(state) %>% 
			  			  	summarize(max_dist = max(district)) %>% 
			  			  	mutate(max_dist = ifelse(max_dist == 1, 1, 0)), by = "state") %>%
			  	# Get congressional district names into a standardized format
			  	mutate(CD = paste0(state, "-", sprintf("%02d", district)), # Add leading 0s to one-digit numbers
			  		   CD = case_when(max_dist == 1 ~ str_replace(CD, "-01", "-AL"), 
			  		   			   TRUE ~ CD)) %>% # Designate statewide districts "AL" instead of "01" or "00"
			  	filter(model == "classic", party %in% c("D", "R")) %>% # Use 538's "classic" model
			  	select(CD, party, win_probability) %>%
			  	# Some races, such as in California, feature multiple candidates of the same party.
			  	# Here I sum those up to reflect the chances each party will win, rather than particular candidates
			  	# If a race has two Democrats and no one else, then Democrats have a 100% chance of winning
			  	group_by(CD, party) %>%
			  	summarize(win_probability = sum(win_probability)) %>% 
			  	spread(party, win_probability, fill = 0) %>%
			  	select(CD, D538 = D),
			  by = "CD") %>% 
	# Decide which races count as competitive.
	mutate(is_competitive538 = case_when(
		D538 >= 1/4 & D538 <= 3/4 ~ 1, # Competitive if the leading party has less than a 75% chance to win
		# Or if the leading party has >75% of winning, but is not the incumbent party
		D538 >= 3/4 & Party == "R" ~ 1,
		D538 <= 1/4 & Party == "D" ~ 1,
		TRUE ~ 0
	)) %>%
	filter(!is.na(Party)) # Remove some extraneous rows that worked their way in to our dataset
write_csv(district_summary, "data/district_summary.csv")