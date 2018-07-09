Two R scripts that will acquire, analyze and visualize data on air pollution picked up by the Purple Air network of sensors around the Fourth of July, 2017. 

These scripts were used to produce the CityLab story, [The Spike in Air Pollution From July 4 Fireworks, Visualized](https://www.citylab.com/environment/2018/07/the-spike-in-air-pollution-from-july-4-fireworks-visualized/564368/).

Contained in this folder are:

- `fireworks_scrape.R`: A script that will, somewhat laboriously, download data from hundreds of air pollution sensors
- `fireworks_viz.R`: A script that will analyze the data produced by `fireworks_scrape.R` and produce charts like the below. Note that this chart is not an exact copy of the charts included in CityLab's article, because those use a private CityLab `ggplot` theme for styling.

![](https://raw.githubusercontent.com/theatlantic/citylab-data/master/images/fireworks_themeless.png?token=AMX5y-61xlFnhUgN0t-kJEMQPspEpH7fks5bTOi0wA%3D%3D)

- `tz-list.csv`: A spreadsheet of data on each time zone. Including this is a little shortcut for adjusting our sensors from UTC to local times
