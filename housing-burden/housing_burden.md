## CityLab housing burden data

The zipped file `housing_burden_tracts.geojson` contains a GIS file of every US Census tract, along with data about severe housing burden (the percent of households spending more than 50% of household income on rent or mortgage) in each tract.

The data was used in the CityLab article, "[The Neighborhoods Where Housing Costs Devour Budgets](https://www.citylab.com/equity/2019/04/affordable-housing-map-monthly-rent-home-mortgage-budget/586330/)."

![](https://cdn.theatlantic.com/assets/media/img/posts/2019/04/housing_burden_tracts_all_map-4/bd9f5dae2.png)

This data derives from the U.S. Census's American Community Survey, which as a survey has a margin of error. At the tract level these margins can be somewhat high, so we would advise caution in treating any particular tract's numbers, or comparison between any two tracts' numbers, as significant. Some tracts have no data listed in the file because due to margin of error their calculated housing burden was below 0% or above 100%. 

The data was downloaded from the National Historical Geographic Information System, and is reshared here with permission. Please see [NHGIS's terms of use](https://www.nhgis.org/research/citation).

Preferred citation:

> Steven Manson, Jonathan Schroeder, David Van Riper, and Steven Ruggles. [IPUMS National Historical Geographic Information System: Version 13.0](http://doi.org/10.18128/D050.V13.0) [Database]. Minneapolis: University of Minnesota. 2018.

Below is a record schema for `housing_burden_tracts.geojson`. All data is from the 2013-2017 American Community Survey: 

- `STATEFP`: The FIPS code for a tract's state
- `COUNTYFP`: The FIPS code for a tract's county
- `TRACTCE`: The FIPS code for a given tract
- `AFFGEOID`: A long-form Census unique identifier for each tract
- `GEOID`: A short-form Census unique identifier for each tract
- `ALAND`: The land area of each tract, in square meters
- `AWATER`: The water area of each tract, in square meters
- `pop`: The population of each tract
- `median_income`: The median income of each tract, in dollars
- `med_homecost`: The median monthly housing cost of each tract, in dollars
- `pct_own`: Percent of residents who own their own home
- `pct_rent`: Percent of residents who rent their home
- `housing_50pct`: Estimated number of households spending more than 50% of their income on housing costs
- `housing_total`: Estimated total number of households
- `housing_na`: Estimated number of households with no data on housing costs. Note that this is usually a significant percentage of homes — an average of more than 50%.
- `housing_pct_missing`: Percent of homes missing data on housing burden.
- `housing_burdened`: Percent of homes for which data is available who spend more than 50% of household income on housing. Calculated by `housing_50pct / (housing_total - housing_na)`. 
- `burden_10k`: Percent of homes earning less than $10,000/year who are severely housing burdened (spend more than 50% of their income on housing)
- `burden_20k`: Percent of homes earning between $10K and $20K who are severely housing burdened
- `burden_35k`: Percent of homes earning between $20K and $35K who are severely housing burdened
- `burden_50k`: Percent of homes earning between $35K and $50K who are severely housing burdened
- `burden_75k`: Percent of homes earning between $50K and $75K who are severely housing burdened
- `burden_100k`: Percent of homes earning between $75K and $100K who are severely housing burdened
- `burden_100plus`: Percent of homes earning more than $100,000 who are severely housing burdened