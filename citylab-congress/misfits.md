# The Congressional Density Index's Misfits

CityLab’s new Congressional Density Index classifies every all 435 U.S.
congressional districts by their makeup of urban, suburban and rural
neighborhoods. It finds that districts fall into one of six categories:
purely rural and urban districts, two types of predominantly suburban
districts, and districts that are mixes of rural and suburban
neighborhoods and urban and suburban neighborhoods.

[Read more about the model, what it means for the 2018 election, and see
where your district
falls](https://www.citylab.com/equity/2018/10/midterm-election-data-suburban-voters/572137/).

The way the model classified districts was through "[fuzzy C-means clustering](https://en.wikipedia.org/wiki/Fuzzy_clustering#Fuzzy_C-means_clustering)," a type of machine learning in which an algorithm compares data points and groups them into categories with similar characteristics. In this case, the characteristics the C-means algorithm looked at were each district's percentage of very-low-density, low-density, medium-density and high-density neighborhoods. Districts with similar proportions of each tended to end up in the same category.

Overall, the model matches up well with common sense, and is pretty
confident about how it classifies most districts. The typical district
was about a 69% match with its assigned category.

For example, [Michigan’s 8th
District](https://en.wikipedia.org/wiki/Michigan%27s_8th_congressional_district),
which includes Detroit exurbs and part of Lansing, was classified as a
sparse suburban district because 20% of its residents live in
very-low-density neighborhoods, 43% in low-density neighborhoods, 33% in
medium-density neighborhoods and 3.5% in high-density neighborhoods.
That’s prety close to a typical sparse suburban district, which on
average have 12% in very-low-density neighborhoods, 42.5% in low-density
neighborhoods, 37% in medium-density neighborhoods and 8% in
high-density neighborhoods. MI-08 had a few more people in rural
neighborhoods and slightly fewer in urban neighborhoods than typical
sparse suvburban districts, but otherwise was a pretty good match.

Here’s a table showing the typical neighborhood makeup of each of the
six types of
districts:

<table class="table table-striped table-hover table-condensed table-bordered" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="border-bottom:hidden" colspan="1">

</th>

<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="4">

<div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">

Typical neighborhood composition

</div>

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

</tr>

<tr>

<td style="text-align:left;">

Low-density suburban

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

</tr>

<tr>

<td style="text-align:left;">

High-density suburban

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

</tr>

</tbody>

</table>

But with 435 districts, there were inevitably several districts that didn’t fit the trends. In part that reflects a limitation of C-means clustering: it doesn't know what the categories it looks at mean; they're just numbers in a database. So a district that contains unusual combinations of neighborhoods — big rural and urban populations in the same district, or lots of dense suburbs combined with lots of rural residents — it can get confused.

Here are nine congressional districts that fall in between:

### 1\. [Nevada’s Second District](https://en.wikipedia.org/wiki/Nevada%27s_2nd_congressional_district)

  - **How the model classified it:** Rural-suburban mix
  - **How closely it fit its cluster:** 33.3%
  - **What else it might have been:** Sparse suburban (28.4%), dense
    suburban (17.2%)
  - **Description:** This northern Nevada district includes Reno, Carson
    City, and lots of rural territory. Overall, significant shares of
    its population live in all four types of neighborhoods: 25.4% very
    low density, 26.9% low density, 29% medium density and 18.6% high
    density.
  - **Why it’s in-between:** Districts with 25% very low density and 27%
    low density are often rural-suburban. But rural-suburban districts
    usually have just 3.9% high-density neighborhoods. So NV-02’s dense
    urban share puts it closer to dense suburban districts (on average
    22.4% high density) — though those districts are only an average of
    5.2% rural. Sparse suburban districts could be a happy medium —
    they’re an average of 12.2% very-low-density and 8.3%
    high-density. Districts that have large amounts of people living in
    dense cities and in the countryside are pretty rare. Ultimately, the
    model thought NV-02 was closest to rural-suburban districts, but
    shift the demographics a little bit and it could have ended up
    differently.

### 2\. [California’s 26th District](https://en.wikipedia.org/wiki/California%27s_26th_congressional_district)

  - **How the model classified it:** Dense suburban
  - **How closely it fit its cluster:** 33.3%
  - **What else it might have been:** Urban-suburban mix (32.6%)
  - **Description:** Located just west of Los Angeles, this district has
    cities such as Oxnard and Ventura. About 33% of its population each
    live in high-density and medium-density neighborhoods; of the rest,
    about 10 percent live in very-low-density neighborhoods and 23.5
    percent in low-density neighborhoods.
  - **Why it’s in-between:** Typical dense suburban districts have
    around half their population living in medium-density neighborhoods,
    and around 22 percent living in high-density neighborhoods. CA-26 is
    far below on medium density, and a bit above on high-density.
    Urban-suburban mix districts are a good fit for its level of
    medium-density neighborhood (typical makeup: 34.5%), but far below
    its average of 50.8% high-density neighborhoods. This ended up as
    dense suburban by literally 0.01% — it doesn’t get closer than
    this\!

### 3\. [Colorado’s 2nd District](https://en.wikipedia.org/wiki/Colorado%27s_2nd_congressional_district)

  - **How the model classified it:** Sparse suburban
  - **How closely it fit its cluster:** 33.3%
  - **What else it might have been:** Rural-suburban mix (26.7%), dense
    suburban (22.3%)
  - **Description:** Colorado’s 2nd contains Boulder and resort towns
    like Vail. It’s about 24% very-low-density, 25% low-density, 36%
    medium-density and 14% high-density.
  - **Why it’s in-between:** Typical sparse suburban districts have
    about 12% very-low-density, 42.5% low-density, 37% medium-density,
    and 8.3% high-density neighborhoods. So CO-02 simultaneously has
    more residents of rural AND urban neighborhoods than typical
    districts of its type. This is common for our misfit districts,
    which often have sizable rural and urban populations in the same
    districts; normal districts tend not to have lots of both.
    Rural-suburban mix districts are a better fit for CO-02’s large
    rural population — but not for its health urban
population.

### 4\. [Maryland’s 6th District](https://en.wikipedia.org/wiki/Maryland%27s_6th_congressional_district)

  - **How the model classified it:** Sparse suburban
  - **How closely it fit its cluster:** 33.1%
  - **What else it might have been:** Dense suburban (25.2%),
    rural-suburban mix (20.2%)
  - **Description:** This district comprises Maryland’s panhandle. It’s
    19.5% very-low-density, 27% low-density, 31% medium-density, and 22%
    high-density.
  - **Why it’s in-between:** Like other misfit districts, this has a
    pretty even mix of neighborhood types. It’s got a lot more people
    living in dense urban neighborhoods than is typical for sparse
    suburban districts, but fewer people living in very-low-density
    neighborhoods than typical rural-suburban mix
districts.

### 5\. [Washington’s 3rd District](https://en.wikipedia.org/wiki/Washington%27s_3rd_congressional_district)

  - **How the model classified it:** Rural-suburban mix
  - **How closely it fit its cluster:** 32.9%
  - **What else it might have been:** Sparse suburban (26.8%)
  - **Description:** This southern Washington district has suburbs of
    Portland, Oregon, and Washington’s capital of Olympia, plus the land
    in between. It’s about 29% very-low-density, 23% low-density, 38%
    medium-density and 10% high-density.
  - **Why it’s in-between:** Washington’s 3rd District has lots of rural
    neighborhoods, but also lots of dense inner suburbs, leaving it in
    between two different
categories.

### 6\. [Connecticut’s 4th District](https://en.wikipedia.org/wiki/Connecticut's_4th_congressional_district)

  - **How the model classified it:** Sparse suburban
  - **How closely it fit its cluster:** 31.9%
  - **What else it might have been:** Dense suburban (22.9%)
  - **Description:** This is the Connecticut district closest to New
    York City, which means it’s got lots of suburbs: about 40 percent of
    its residents live in low-density neighborhoods and 26% in
    medium-density neighborhoods, while almost no one here is rural. It
    also includes Bridgeport and Stamford, and has around 32 percent of
    its residents in high-density neighborhoods.
  - **Why it’s in-between:** This is clearly a suburban district; the
    only question for the model is which type. Its heavy dose of
    low-density neighborhoods makes it a good fit for the sparse
    suburban category. But sparse suburban districts arely have urban
    cores like CT-04, which has nearly four times as many residents in
    dense neighborhoods as the typical sparse suburban district. So the
    model considered classifying it as dense suburban instead, but those
    districts usually have twice as many people in medium-density
    neighborhoods.

### 7\. [California’s 24th District](https://en.wikipedia.org/wiki/California%27s_24th_congressional_district)

  - **How the model classified it:** Sparse suburban
  - **How closely it fit its cluster:** 30.2%
  - **What else it might have been:** Dense suburban (25.6%),
    Rural-suburban mix (18.6%)
  - **Description:** This district runs along the Pacific Coast from the
    fringes of Greater Los Angeles (where it borders \#2, California’s
    26th District) to about halfway in between L.A. and the San
    Francisco Bay Area. It’s got very rural areas, dense urban areas and
    everywhere in between; its population is roughly evenly split
    between the four types of neighborhoods.
  - **Why it’s in-between:** Any district that has significant numbers
    of people living in both very-low-density neighborhoods and
    high-density neighborhoods is going to be hard for the model to
    classify — that’s just not very common. CA-24’s mix of low- and
    very-low-density neighborhoods put it in sparse suburban, but its
    denser areas gave it some similarities to dense suburban
districts.

### 8\. [California’s 3rd District](https://en.wikipedia.org/wiki/California%27s_3rd_congressional_district)

  - **How the model classified it:** Rural-suburban mix
  - **How closely it fit its cluster:** 30.0%
  - **What else it might have been:** Sparse suburban (25.0%)
  - **Description:** This district covers the area in between the Bay
    Area and Sacramento, and then stretches north through the Sacramento
    Valley. Its population lives in a nearly even mix of the four
    different types of neighborhoods.
  - **Why it’s in-between:** A pattern should be becoming clear:
    Districts with lots of people in all the different types of
    neighborhoods don’t fit the model well, because of how rare this is.
    Just 13 districts (3%) have 15% of their population each living in
    very-low-density and high-density neighborhoods, including five of
    the nine districts on this list. CA-03 is one of them, with bits of
    two major metro areas and vast stretches of farmland in a single
    district. There are 182 districts that are at least 25 percent
    very-low-density, with a typical high-density population share of
    1.7%. With 23.2% of its population living in high-density
    neighborhoods, CA-03 is the most urban of all these rural-heavy
    distircts. No wonder it falls in
between.

### 9\. [Texas’s 21st District](https://en.wikipedia.org/wiki/Texas%27s_21st_congressional_district)

  - **How the model classified it:** Dense suburban
  - **How closely it fit its cluster:** 26.1%
  - **What else it might have been:** Rural-suburban mix (25.9%), Sparse
    suburban (22.5%)
  - **Description:** Like California’s 3rd, Texas’s 21st District runs
    between two metros and then out into the hinterland. In this case,
    it has part of San Antonio and Austia, the area in between, and then
    six rural central Texas counties. The two urban areas mean it has
    36% of its population in medium-density neighborhoods and 17.5% in
    high-density neighborhoods; the rural counties mean it has another
    28% in very-low-density neighborhoods. The final 18% live in
    low-density suburbs and small towns.
  - **Why it’s in-between:** This is a total outlier, one that is about
    equally similar to not two but three different categories of
    districts. Its abundance of medium-density neighborhoods put it
    tentatively in the dense suburban category, but those districts have
    an average of 5.2% of their population in very-low-density
    neighborhoods, five times less than TX-21. Ultimately the
    Congressional Density Index sort of threw up its hands and threw a
    dart.
