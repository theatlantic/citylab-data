library(tidyverse)
library(e1071)

set.seed(2018) # Set a fixed random number seed for reproducibility
district_summary <- read_csv("data/district_summary.csv") # Load the district_summary.csv file
# This can be created by the district_class.R script if you don't have it

## Run a fuzzy c-means analysis on each congressional district
cmeans6 <- cmeans(district_summary %>% select(2:5) %>% as.matrix(), # Select just the population percentage columns
				  6, # Divide the districts into six clusters
				  iter.max = 1000) # Run it a ton of times, if necessary

## Sometimes the c-means analysis changes up the order of the numbers it assigns to each cluster
## We can standardize that here

cluster_names <- cmeans6$centers %>% 
	as_data_frame() %>% 
	rownames_to_column(var = "cluster_number") %>%
	arrange(`High density`) %>%
	mutate(Cluster = c("Pure rural", "Rural-suburban mix", "Sparse suburban", "Dense suburban", "Urban-suburban mix", "Pure urban")) %>%
	select(cluster_number, Cluster) %>%
	arrange(cluster_number)

## Add our clusters to our list of congressional districts
districts6 <- bind_cols(district_summary, cmeans6$cluster %>% as.character() %>% 
					 	as_data_frame() %>% 
					 	set_names("cluster_number"),
						# Add in columns listing how closely each district matched each cluster
					 as_data_frame(cmeans6$membership) %>% 
							set_names(cluster_names$Cluster) %>% # Name the columns from cluster_names
							select("Pure rural", "Rural-suburban mix", "Sparse suburban", "Dense suburban", "Urban-suburban mix", "Pure urban") # Put our columns in the correct order
						) %>%
	left_join(cluster_names, by = "cluster_number") %>%
	select(CD, Cluster, everything(), -cluster_number) %>%
	filter(!is.na(CD)) %>%
	mutate(Cluster = as.factor(Cluster) %>% fct_relevel("Pure rural", "Rural-suburban mix", "Sparse suburban", "Dense suburban", "Urban-suburban mix", "Pure urban"))
write_csv(districts6, "citylab_cdi.csv")

