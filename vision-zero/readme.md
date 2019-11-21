## Vision Zero fatality data

As part of its story, ["Are These Cities Any Closer to Eliminating Traffic Deaths?"](https://www.citylab.com/transportation/2019/11/vision-zero-data-traffic-deaths-pedestrians-cyclist-safety/601831/), CityLab collected data on traffic crashes for five major U.S. cities that have embraced a "Vision Zero" goal of eliminating fatalities and injuries from traffic crashes: New York City, Los Angeles, Chicago, San Francisco, and Washington, D.C.

This data came from two places for each city. All the Vision Zero cities publish bulk data containing details on every single crash in their boundaries, usually derived from police department databases, which is an incredible wealth of information. However, this data is often uncleaned and contains inaccuracies. So all the cities also publish their own official data counting fatalities and injuries from crashes. This tends to be more accurate, but doesn't allow delving into the data with the same degree of granularity.

Attached is [`vision-zero-fatalities-type.csv`](https://github.com/theatlantic/citylab-data/blob/master/vision-zero/vision-zero-fatalities-type.csv), which represents CityLab's compilation of summary-level traffic fatality data from the five cities over the past seven to nine years. (Data on non-fatality crashes is only in the bulk data.)

The data is structured in "tall" format, with one row for each piece of data. The columns represent:

- `city`: The city in question
- `year`: The year that a particular point of data is from
- `type`: The type of fatality — usually Pedestrians, Bicyclists and Motorists (including both drivers and passengers), but occasionally including other categories some cities track independently such as Motorcyclists
- `fatalities`: The number of fatalities in that `city`, `year` and `type`
- `pop`: The city's Census-reported population in that `year`
- `fatalities_percap`: The number of fatalities in that `city`, `year` and `type` per 100,000 residents of the city, to enable rough comparisons between cities of different sizes
- `vz_date`: The year and month that each city enacted Vision Zero. (The date format also encodes a day value, the first of the month, but this does not reflect the precise day Vision Zero was adopted.)
- `vz_year`: The year each city enacted Vision Zero

This summary-level data was obtained directly from each city's Vision Zero office or other relevant agency.

## Bulk data

For people interested in accessing the bulk data for any or all cities, which contains data on fatality, injury and non-injury crashes, here is how to access the data. Note that these datasets tend to be very large, containing hundred of thousands or millions of rows, which can cause issues both for downloading and for opening them in conventional spreadsheet applications. CityLab analyzed them using command line tools in the R language.

- **New York:** [Motor Vehicle Collisions - Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95) via NYC Open Data.
- **Chicago:** [Traffic Crashes - Crashes](https://data.cityofchicago.org/Transportation/Traffic-Crashes-Crashes/85ca-t3if) via Chicago Data Portal. See also separate spreadsheets with data about [People](https://data.cityofchicago.org/Transportation/Traffic-Crashes-People/u6pd-qa9d) and [Vehicles](https://data.cityofchicago.org/d/68nd-jvt3) involved in crashes. Note that Chicago's bulk open data only dates back to Sept. 2017 on a citywide basis. 
- **Los Angeles** and **San Francisco:** Bulk data on these cities, along with all other California cities, was obtained from the California Highway Patrol's Statewide Integrated Traffic Records System (SWITRS). This data can be accessed with a free account [here](http://iswitrs.chp.ca.gov/Reports/jsp/CollisionReports.jsp).
- **Washington, D.C.:** [Crashes in DC](https://opendata.dc.gov/datasets/crashes-in-dc) via Open Data DC.