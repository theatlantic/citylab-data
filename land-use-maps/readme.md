## Animated land use maps

CityLab used R code to create animated maps showing changes in world land use from 1700 to 2000, using data from [ecotope.org](http://ecotope.org). The maps, and insight from Prof. Erle Ellis, who led the team that created the data, were featured in the CityLab article, "[How 300 Years of Urbanization and Farming Transformed the Planet](https://www.citylab.com/environment/2019/01/farming-climate-change-land-use-urbanization-over-time-map/579724/)."

The script [`landuse.R`](https://github.com/theatlantic/citylab-data/blob/master/land-use-maps/landuse.R) will recreate those animations (minus a few elements of CityLab's private `ggplot` theme) in their entirety, including downloading and processing the data.

The results, contained in the [`GIFs`](https://github.com/theatlantic/citylab-data/blob/master/land-use-maps/GIFs/) folder of this repository, should look something like this: 

![](https://github.com/theatlantic/citylab-data/blob/master/land-use-maps/GIFs/landuse.gif)