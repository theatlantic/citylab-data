## Column layout for CityLab CDI

The full results of the CityLab Congressional Density Index are contained in the spreadsheet [`citylab_cdi_extended.csv`](https://github.com/theatlantic/citylab-data/blob/master/citylab-congress/citylab_cdi.csv). Here is a schematic for the columns in that spreadsheet:

- `CD`: The name of the congressional district, in the form of each state's two-letter abbreviation, a dash, and the two-digit number of the district. Statewide at-large districts are referred to as `-AL` (not `-00` or `-01`, as some use).
- `Cluster`: The CDI classification based on the district's makeup of neighborhoods.
- `Very low density`: The percentage of that district's population living in "very low density" neighborhoods with fewer than 102 households per square mile.
- `Low density`: The percentage of that district's population living in "low density" neighborhoods with between 102 and 799 households per square mile.
- `Medium density`: The percentage of that district's population living in "medium density" neighborhoods with between 800 and 2,213 households per square mile.
- `High density`: The percentage of that district's population living in "high density" neighborhoods with more than 2,213 households per square mile.
- `Pre-2018 incumbent`: The occupant of the seat as of October 2018.
- `Pre-2018 party`: The political party of the occupant of the seat as of October 2018.
- `2018 winner party`: The political party of the candidate who won this seat in 2018.
- `Clinton16`: The percent of the vote received in the 2016 presidential election by Democratic candidate Hillary Clinton.
- `Trump16`: The percent of the vote received in the 2016 presidential election by Republican candidate Donald Trump.
- `Obama12`: The percent of the vote received in the 2012 presidential election by Democratic candidate Barack Obama.
- `Romney12`: The percent of the vote received in the 2012 presidential election by Republican candidate Mitt Romney.
- `Obama08`: The percent of the vote received in the 2008 presidential election by Democratic candidate Barack Obama. This is the vote share in the 2018 boundaries of the district, not the boundaries that existed in 2008.
- `McCain08`: The percent of the vote received in the 2008 presidential election by Republican candidate John McCain. This is the vote share in the 2018 boundaries of the district, not the boundaries that existed in 2008.
- `cong_R16`: The percent of the vote received in the 2016 general election by Republican candidates for the U.S. House.
- `cong_D16`: The percent of the vote received in the 2016 general election by Democratic candidates for U.S. House.
- `cong_Other16`: The percent of the vote received in the 2016 general election by non-major-party candidates for U.S. House.
- `PVI`: The district's rating on the [Cook Partisan Voting Index](https://en.wikipedia.org/wiki/Cook_Partisan_Voting_Index).
- `cook_score`: The district's rating for the 2018 election, as of Oct. 3, 2018, by the Cook Political Report. "3" represents "Safe Republican," 2 "Likely Republican", 1 "Lean Republican", 0 "Tossup", -1 "Lean Democrat", -2 "Likely Democrat" and -3 "Safe Democrat".
- `is_competitive_cook`: A calculated binary about whether the race is competitive according to Cook's ratings. Races are competitive if they're not considered "Safe", or if they are considered safe but the safe candidate is from a different party than the current occupant of the seat.
- `D538`: The odds that a Democratic candidate will win the seat, as estimated by [FiveThirtyEight's "classic" model](https://projects.fivethirtyeight.com/2018-midterm-election-forecast/house/?ex_cid=rrpromo) on Oct. 3, 2018.
- `is_competitive538`: A calculated binary about whether the race is competitive according to FiveThirtyEight's model. A race is competitive if no party has more than a 75 percent chance of winning the seat, or if a party has a greater than 75 percent chance of winning a seat currently held by the other party.
- `Pure rural` through `Pure urban`: The final six columns represent the fuzzy c-means algorithm's weighting of each district into the six clusters. A higher number means it has more in common with that cluster.
