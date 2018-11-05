## CityLab Congressional Density Index, 2010 Districts

This folder contains a variant of the Congressional Density Index for districts as they existed in 2010, before redistricting. 

Read more about what this data shows about America's political geography in this CityLab article.

The spreadsheet `2010_districts.csv` contains each pre-2010 congressional district, its classification, and other data. Below is a map showing those districts, with those gained by Republicans in the 2010 election highlighted:

![CityLab CDI 2010 map with GOP pickups](https://raw.githubusercontent.com/theatlantic/citylab-data/master/citylab-congress/2010-districts/map.png)

Here is a guide to the column layout of `2010_districts.csv`:

- `CD`: Congressional District, with "AL" for at-large districts
- `Cluster`: The CityLab CDI class for each district, such as "pure urban"
- `Very low density`: Percentage of each district's 2010 population living in Census tracts with fewer than 102 households per square mile
- `Low density`: Population share in tracts with between 102 and 799 households per square mile
- `Medium density`: Population share in tracts with between 800 and 2,213 households per square mile
- `High density`: Population share in tracts with more than 2,213 households per square mile
- `obama08` through `bush00`: Vote share for various major-party presidential candidates in each district in given years
- `cong_D10` and `cong_R10`: Vote share in each district for Republican and Democratic presidential candidates in the 2010 general elections
- `incumbent2010`: The party of the incumbent representative at the time of the 2010 elections
- `Incumbent`: The name of the 2010 incumbent representative
- `winner2010`: The party of the candidate who won that district in the 2010 elections
- `cong_D08` and `cong_R08`: Vote share in each district for Republican and Democratic presidential candidates in the 2008 general elections
