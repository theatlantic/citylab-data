Methodology
================

#### By David H. Montgomery

CityLab has unveiled a new model for understanding congressional districts in terms of density, the CityLab Congressional Density Index (CDI). This model classifies every congressional district by the density of its neighborhoods using a machine-learning algorithm.

I wrote about the takeaway from the model with Richard Florida [here](https://www.citylab.com/equity/2018/10/midterm-election-data-suburban-voters/572137/), including graphics and an interactive. 

This article explains how we calculated the model. You can download our classification for each congressional district [here](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/citylab_cdi.csv) (plus the [column layout](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/cdi_columns.md)), and download the R code used to calculate the model [here](https://github.com/theatlantic/citylab-data/tree/master/citylab-congress).

The premise: start with Census tracts
-------------------------------------

One simple way to categorize districts by density is to just calculate each district's overall density — total people or households divided by total area. We decided not not follow that route because many districts contain a wide variety of neighborhoods. A single district might contain both high-rise condos and rolling fields. Instead, we decided to start at the neighborhood level, using the U.S. Census's tracts — the smallest geographic level for which demographic data is available.

We classified each tract based on the number of households per square mile, based on previous research:

-   Tracts with fewer than 102 households per square mile were classified as "very low density." This was based on [research by Jed Kolko](https://fivethirtyeight.com/features/how-suburban-are-big-american-cities/), which found that 102 households per square mile in a ZIP code was the cutoff at which people were likely to describe their neighborhoods as "rural."
-   Tracts with more than 2,213 households per square mile were classified as "high density," again based on Kolko's findings that people living in neighborhoods above that density tended to describe them as "urban."
-   The people in neighborhoods in between tended to describe where they live as "suburban." But that's a huge category with an estimated 182 million Americans, or 57 percent of the population. We added an additional dividing line at 800 households per square mile. Tracts below that level was classified as "low density"; above that level, tracts were "medium density."

The four categories all have significant shares of the American population, with the "low" and "medium" density tracts somewhat more common than the "high" and "very low" neighborhoods:

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Type of Tract
</th>
<th style="text-align:left;">
Estimated Population
</th>
<th style="text-align:left;">
Percentage of Country
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Very low density
</td>
<td style="text-align:left;">
71,182,763
</td>
<td style="text-align:left;">
22.35%
</td>
</tr>
<tr>
<td style="text-align:left;">
Low density
</td>
<td style="text-align:left;">
89,918,057
</td>
<td style="text-align:left;">
28.24%
</td>
</tr>
<tr>
<td style="text-align:left;">
Medium density
</td>
<td style="text-align:left;">
91,897,589
</td>
<td style="text-align:left;">
28.86%
</td>
</tr>
<tr>
<td style="text-align:left;">
High density
</td>
<td style="text-align:left;">
65,425,961
</td>
<td style="text-align:left;">
20.55%
</td>
</tr>
</tbody>
</table>

Dealing with split tracts
-------------------------

Though most Census tracts are located within a single congressional district, around 5,000 of the country's more than 72,000 tracts are substantially split between two or more different districts. We used [a file](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/split_tracts.csv) from the Missouri Census Data Center's [MABLE/Geocorr14 tool](http://mcdc.missouri.edu/websas/geocorr14.html) that calculated the percentage of each tract's land area within each congressional district. Later on in the process, we multiply the tract's total population by this percent to calculate a rough estimate of the number of people in each congressional district by tract.

There was one problem with the MABLE/Geocorr14 database: it was based on congressional districts as drawn earlier in the decade. As such, it didn't account for the new congressional district boundaries in effect for 2018 in Pennsylvania. We used a custom R script to calculate similar percentages for the split tracts in Pennsylvania.

Aggregating to congressional districts
--------------------------------------

At this point, we've categorized every Census tract by density, and have assigned each tract (or part of tract) to a congressional district, along with an estimate of the population living in each tract (or part of tract). The next step was simple: sum up this population by congressional district.

Now for each district, we had an estimate of the total number of people (and share of total population) living in each type of neighborhood. For example, Wisconsin's 1st District, currently held by House Speaker Paul Ryan, is 21.6 percent "very low density," 40.7 percent "low density," 28.1 percent "medium density" and 9.6 percent "high density."

Clustering
----------

We then plugged this density breakdown of each of the country's 435 congressional districts into a machine-learning algorithm called "[fuzzy c-means clustering](https://en.wikipedia.org/wiki/Fuzzy_clustering#Fuzzy_C-means_clustering)." Put simply, this groups a dataset into a certain number of clusters. Each cluster's data will tend to be more similar to each other than to members of different clusters. Running this algorithm immediately produced sensible results: Districts we knew to be rural tended to be clustered together, and similarly with districts we knew to be urban or suburban.

After experimenting with different numbers of clusters, we settled on six, because six clusters fit well with understandings of density and demographics as well with trends in politics. This is what a typical example of each cluster looked like in its neighborhood makeup:

<table class="table table-striped table-hover table-condensed table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="4">
Neighborhood composition

</th>
<th style="border-bottom:hidden" colspan="1">
</th>
</tr>
<tr>
<th style="text-align:left;">
Cluster
</th>
<th style="text-align:left;">
Very low density
</th>
<th style="text-align:left;">
Low density
</th>
<th style="text-align:left;">
Medium density
</th>
<th style="text-align:left;">
High density
</th>
<th style="text-align:right;">
Number of Districts
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Pure rural
</td>
<td style="text-align:left;">
58.7%
</td>
<td style="text-align:left;">
29.3%
</td>
<td style="text-align:left;">
10.6%
</td>
<td style="text-align:left;">
1.4%
</td>
<td style="text-align:right;">
70
</td>
</tr>
<tr>
<td style="text-align:left;">
Rural-suburban
</td>
<td style="text-align:left;">
36.6%
</td>
<td style="text-align:left;">
37.4%
</td>
<td style="text-align:left;">
22.1%
</td>
<td style="text-align:left;">
3.9%
</td>
<td style="text-align:right;">
114
</td>
</tr>
<tr>
<td style="text-align:left;">
Sparse suburban
</td>
<td style="text-align:left;">
12.2%
</td>
<td style="text-align:left;">
42.5%
</td>
<td style="text-align:left;">
37.0%
</td>
<td style="text-align:left;">
8.3%
</td>
<td style="text-align:right;">
86
</td>
</tr>
<tr>
<td style="text-align:left;">
Dense suburban
</td>
<td style="text-align:left;">
5.2%
</td>
<td style="text-align:left;">
21.0%
</td>
<td style="text-align:left;">
51.4%
</td>
<td style="text-align:left;">
22.4%
</td>
<td style="text-align:right;">
83
</td>
</tr>
<tr>
<td style="text-align:left;">
Urban-suburban
</td>
<td style="text-align:left;">
2.6%
</td>
<td style="text-align:left;">
12.1%
</td>
<td style="text-align:left;">
34.5%
</td>
<td style="text-align:left;">
50.8%
</td>
<td style="text-align:right;">
48
</td>
</tr>
<tr>
<td style="text-align:left;">
Pure urban
</td>
<td style="text-align:left;">
0.3%
</td>
<td style="text-align:left;">
1.8%
</td>
<td style="text-align:left;">
8.0%
</td>
<td style="text-align:left;">
90.0%
</td>
<td style="text-align:right;">
34
</td>
</tr>
</tbody>
</table>
Because it's "fuzzy," the algorithm tells us how confident it is that a given district belongs in its category. Many are clear and decisive. For example, Nebraska's 3rd District has a 97.5 percent resemblance to the "pure rural" cluster, while Illinois' 4th District had a 99.8 percent resemblance to "pure urban."

Others were more ambiguous. Minnesota's 3rd District, for example, was categorized as "sparse suburban," but it had only a 52.5 percent resemblance. It also had a 26.5 percent resemblance to "dense suburban," plus minor odds for other district types. That's because Minnesota's 3rd District's abundance of medium-density neighborhoods matched other "dense suburban" districts — but its small share of high-density neighborhoods and moderate share of low-density neighborhoods were closer to "sparse suburban" districts.

Running the c-means clustering algorithm over and over again produced slightly different results for some districts on the edge between two different clusters. But the big picture was remarkably consistent.

We've chosen to report each district as belonging to a single category, as sorted by the c-means algorithm. But our [full data](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/clustered_districts.csv) contains each district's resemblance scores for each cluster, for those who want to be more attuned to uncertainty. (Reference the [column layout](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/cdi_columns.md) as a guide.)

Political analysis
------------------

With every district now classified according to its density, we brought in data from a variety of sources about the politics of each seat: which party currently occupies it, the share of the vote that [presidential](https://docs.google.com/spreadsheets/d/1zLNAuRqPauss00HDz4XbTH2HqsCzMe0pR8QmD1K8jk8/edit#gid=0) and [congressional candidates](https://transition.fec.gov/pubrec/fe2016/federalelections2016.xlsx) have received in that district, and how the election forecasters at [FiveThirtyEight](https://projects.fivethirtyeight.com/2018-midterm-election-forecast/house/?ex_cid=rrpromo) and the [Cook Political Report](https://www.cookpolitical.com) rate the race's chances in the 2018 general election.

This enabled us to identify the thrust of [our main story introducing the model](https://www.citylab.com/equity/2018/10/midterm-election-data-suburban-voters/572137): that Republican-held seats in predominantly suburban districts are disproportionately competitive this year.

But we also believe there are other insights that can be drawn from this way of looking at congressional districts. Some of those we hope to write ourselves over the next month here at CityLab. But we also hope other people will find this a useful tool for their own analyses. So take a look at the [full data](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/citylab_cdi.csv) and [code](https://github.com/theatlantic/citylab-data/tree/master/citylab-congress)! If you have any questions, [email me](mailto:dmontgomery@citylab.com) or reach out [on Twitter](twitter.com/dhmontgomery).

The cartogram tiles used in [our visualization](https://cdn.theatlantic.com/assets/media/img/posts/2018/10/cdi_tilegram_01-4/205b52768.png) were designed by Daniel Donner for Daily Kos Elections, and are used under a Creative Commons Attribution 4.0 International License. They can be downloaded [here](https://docs.google.com/spreadsheets/d/1LrBXlqrtSZwyYOkpEEXFwQggvtR0bHHTxs9kq4kjOjw/edit#gid=1250379179).