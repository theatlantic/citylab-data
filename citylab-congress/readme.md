## CityLab Congressional Density Index

[CityLab](http://citylab.com) has classified every U.S. congressional district based on the density of the hundreds of neighborhoods that make up each one. 

We're releasing the full results — and the code used to produce the Congressional Density Index — to the public. The code is released under the [MIT License](https://github.com/theatlantic/citylab-data/blob/master/LICENSE), and the data under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>. You're free to use and modify this work, provided you attribute the CityLab Congressional Density Index, and maintain a similar license on your use of the CDI. 

To learn more about the CDI, read our [methodology](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/methodology.md). You can also read the CityLab article by David Montgomery and Richard Florida introducing the preliminary findings: that Republican-held suburban seats are in particular danger in the 2018 congressional elections.

This repository contains all the code and data you need to reproduce our work. Of particular note:

- `citylab_cdi.csv` contain the most recent classifications of each district 
- `district_class.R` is an R script that will calculate the neighborhood density makeup of each congressional district. (It relies on a variety of spreadsheets in the `data` folder, so you'll want to preserve the folder structure of this repository if you download and run it.)
- `cluster_analysis.R` is an R script that takes the output of `district_class.R` and performs a c-means clustering algorithm on it, grouping districts into distinct categories based on their neighborhood makeup.
- The `shapefiles` folder contains a shapefile with every Census tract in the United States (not counting territories). This is necessary for `district_class.R` to run (so preserve folder structure), but might also be useful for other analyses!

The CityLab Congressional Density Index was developed by David H. Montgomery for [CityLab](http://citylab.com).

If you have any suggestions, or find any bugs, please [contact me](mailto:dmontgomery@citylab.com) or file a pull request. 