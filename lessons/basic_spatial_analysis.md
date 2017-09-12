

# Basic GIS Analysis with R
We now have the required packages installed and know how to read data into R. Our next step is to start doing some GIS analysis with R. Throughout the course of this lesson will show how to do some basic manipulation of the `raster` and `sf` objects and then show a few examples of relatively straightforward analyses.  We will only be scratching the surface here, but hopefully this will provide a starting point for more work doing spatial analysis in R.  ***Note:*** *Much of this lesson assumes familiarity with R and working with data frames.*

## Lesson Outline
- [Explore and manipulate](#explore-and-manipulate)
- [Projections](#projections)
- [Brief introduction to rgeos](#brief-introduction-to-rgeos)
- [Working with rasters](#working-with-rasters)

## Lesson Exercises
- [Exercise 3.1](#exercise-31)
- [Exercise 3.2](#exercise-32)
- [Exercise 3.3](#exercise-33)

## Explore and manipulate
The greatest thing about the `sf` objects is that the tricks you know for working with data frames will also work. This is becuase `sf` objects are data frames that hold the geographic information in a special list-column.  In addition to being data frames, `sf` was designed to work with the [`tidyverse`](https://tidyverse.org) and are organized as [tidy data.](http://vita.had.co.nz/papers/tidy-data.html)  This allows us to subset our spatial data, summarize data, etc. using the tools in the `tidyverse`, most notabley `dplyr`.  If you haven't worked with spatial data in R the "old way", then you can't fully appreciate how much this should:

![](https://media.giphy.com/media/3o7TKSjRrfIPjeiVyM/giphy.gif)

Suffice it to say, it is really cool!

Let's start working through some examples using the two Metro datasets.


```
## Reading layer `Metro_Lines' from data source `C:\data\rspatial_workshop\data\Metro_Lines.shp' using driver `ESRI Shapefile'
## Simple feature collection with 8 features and 4 fields
## geometry type:  MULTILINESTRING
## dimension:      XY
## bbox:           xmin: -77.08576 ymin: 38.83827 xmax: -76.91327 ymax: 38.97984
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
```

```
## Reading layer `Metro_Stations_District' from data source `C:\data\rspatial_workshop\data\metrostations.geojson' using driver `GeoJSON'
## Simple feature collection with 40 features and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -77.085 ymin: 38.84567 xmax: -76.93526 ymax: 38.97609
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
```

We've already seen how to use the default print statements to look at the basics


```r
dc_metro
dc_metro_sttn
```

We can get more info on the data with are usuall data frame tools:


```r
head(dc_metro_sttn)
```

```
## Simple feature collection with 6 features and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -77.03255 ymin: 38.89098 xmax: -76.93837 ymax: 38.97609
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##   OBJECTID   GIS_ID                 NAME
## 1        1 mstn_007     Columbia Heights
## 2        2 mstn_020 Georgia Ave Petworth
## 3        3 mstn_034               Takoma
## 4        4 mstn_004        Brookland-CUA
## 5        5 mstn_017          Fort Totten
## 6        6 mstn_003         Benning Road
##                                                  WEB_URL
## 1 http://wmata.com/rail/station_detail.cfm?station_id=75
## 2 http://wmata.com/rail/station_detail.cfm?station_id=76
## 3 http://wmata.com/rail/station_detail.cfm?station_id=29
## 4 http://wmata.com/rail/station_detail.cfm?station_id=27
## 5 http://wmata.com/rail/station_detail.cfm?station_id=28
## 6 http://wmata.com/rail/station_detail.cfm?station_id=90
##                   LINE                ADDRESS
## 1        green, yellow    3030 14TH STREET NW
## 2        green, yellow 3700 GEORGIA AVENUE NW
## 3                  red    327 CEDAR STREET NW
## 4                  red 801 MICHIGAN AVENUE NE
## 5   red, green, yellow 550 GALLOWAY STREET NE
## 6 blue, orange, silver   4500 BENNING ROAD NE
##                         geometry
## 1 POINT (-77.0325544130882 38...
## 2 POINT (-77.0234631972137 38...
## 3 POINT (-77.0181789925646 38...
## 4 POINT (-76.9945365689642 38...
## 5 POINT (-77.002205364201 38....
## 6 POINT (-76.9383671319143 38...
```

```r
summary(dc_metro_sttn)
```

```
##     OBJECTID        GIS_ID              NAME             WEB_URL         
##  Min.   : 1.00   Length:40          Length:40          Length:40         
##  1st Qu.:10.75   Class :character   Class :character   Class :character  
##  Median :20.50   Mode  :character   Mode  :character   Mode  :character  
##  Mean   :20.50                                                           
##  3rd Qu.:30.25                                                           
##  Max.   :40.00                                                           
##      LINE             ADDRESS                   geometry 
##  Length:40          Length:40          POINT        :40  
##  Class :character   Class :character   epsg:4326    : 0  
##  Mode  :character   Mode  :character   +proj=long...: 0  
##                                                          
##                                                          
## 
```

```r
names(dc_metro_sttn)
```

```
## [1] "OBJECTID" "GIS_ID"   "NAME"     "WEB_URL"  "LINE"     "ADDRESS" 
## [7] "geometry"
```

```r
#Look at individual columns
dc_metro_sttn$NAME
```

```
##  [1] "Columbia Heights"                            
##  [2] "Georgia Ave Petworth"                        
##  [3] "Takoma"                                      
##  [4] "Brookland-CUA"                               
##  [5] "Fort Totten"                                 
##  [6] "Benning Road"                                
##  [7] "Deanwood"                                    
##  [8] "NoMa - Gallaudet U"                          
##  [9] "Tenleytown-AU"                               
## [10] "Friendship Heights"                          
## [11] "Foggy Bottom-GWU"                            
## [12] "Farragut West"                               
## [13] "Farragut North"                              
## [14] "Dupont Circle"                               
## [15] "Woodley Park-Zoo Adams Morgan"               
## [16] "LEnfant Plaza"                               
## [17] "Smithsonian"                                 
## [18] "Federal Triangle"                            
## [19] "Archives-Navy Meml"                          
## [20] "Waterfront"                                  
## [21] "Navy Yard - Ballpark"                        
## [22] "Federal Center SW"                           
## [23] "Judiciary Sq"                                
## [24] "Capitol South"                               
## [25] "McPherson Sq"                                
## [26] "Metro Center"                                
## [27] "Gallery Pl-Chinatown"                        
## [28] "Mt Vernon Sq - 7th St Convention Center"     
## [29] "U St/African-Amer Civil War Memorial/Cardozo"
## [30] "Shaw-Howard Univ"                            
## [31] "Union Station"                               
## [32] "Congress Heights"                            
## [33] "Anacostia"                                   
## [34] "Eastern Market"                              
## [35] "Potomac Ave"                                 
## [36] "Stadium Armory"                              
## [37] "Rhode Island Ave"                            
## [38] "Minnesota Ave"                               
## [39] "Van Ness-UDC"                                
## [40] "Cleveland Park"
```

Now for the fun part.  If you use base R mostly, then you can use indexing/subsetting tools you already know to pull out individual features based on the data stored in the `sf` objects.  For instance:


```r
#select with base indexing
est_mrkt <- dc_metro_sttn[dc_metro_sttn$NAME == "Eastern Market",]
est_mrkt
```

```
## Simple feature collection with 1 feature and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -76.996 ymin: 38.88463 xmax: -76.996 ymax: 38.88463
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##    OBJECTID   GIS_ID           NAME
## 34       34 mstn_011 Eastern Market
##                                                   WEB_URL
## 34 http://wmata.com/rail/station_detail.cfm?station_id=60
##                    LINE                    ADDRESS
## 34 blue, orange, silver 701 PENNSYLVANIA AVENUE SE
##                          geometry
## 34 POINT (-76.996003408071 38....
```

```r
#select with subset (plus a Lil Rhody Shout Out!)
ri <- subset(dc_metro_sttn,NAME == "Rhode Island Ave")
ri
```

```
## Simple feature collection with 1 feature and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -76.99594 ymin: 38.92107 xmax: -76.99594 ymax: 38.92107
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##    OBJECTID   GIS_ID             NAME
## 37       37 mstn_030 Rhode Island Ave
##                                                   WEB_URL LINE
## 37 http://wmata.com/rail/station_detail.cfm?station_id=26  red
##                       ADDRESS                       geometry
## 37 919 RHODE ISLAND AVENUE NE POINT (-76.9959392002222 38...
```

This is cool, but even better is our ability to use `dplyr` for this type of work.

 

```r
# Need to add dplyr
library(dplyr)

# Let's get just the Red Line Stations
red_line_sttn <- dc_metro_sttn %>%
  filter(grepl("red",LINE))
red_line_sttn
```

```
## Simple feature collection with 16 features and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -77.085 ymin: 38.8961 xmax: -76.99454 ymax: 38.97609
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##    OBJECTID   GIS_ID                          NAME
## 1         3 mstn_034                        Takoma
## 2         4 mstn_004                 Brookland-CUA
## 3         5 mstn_017                   Fort Totten
## 4         8 mstn_028            NoMa - Gallaudet U
## 5         9 mstn_035                 Tenleytown-AU
## 6        10 mstn_018            Friendship Heights
## 7        13 mstn_012                Farragut North
## 8        14 mstn_010                 Dupont Circle
## 9        15 mstn_040 Woodley Park-Zoo Adams Morgan
## 10       23 mstn_021                  Judiciary Sq
## 11       26 mstn_024                  Metro Center
## 12       27 mstn_019          Gallery Pl-Chinatown
## 13       31 mstn_037                 Union Station
## 14       37 mstn_030              Rhode Island Ave
## 15       39 mstn_038                  Van Ness-UDC
## 16       40 mstn_006                Cleveland Park
##                                                    WEB_URL
## 1   http://wmata.com/rail/station_detail.cfm?station_id=29
## 2   http://wmata.com/rail/station_detail.cfm?station_id=27
## 3   http://wmata.com/rail/station_detail.cfm?station_id=28
## 4  http://wmata.com/rail/station_detail.cfm?station_id=108
## 5   http://wmata.com/rail/station_detail.cfm?station_id=10
## 6   http://wmata.com/rail/station_detail.cfm?station_id=11
## 7    http://wmata.com/rail/station_detail.cfm?station_id=4
## 8    http://wmata.com/rail/station_detail.cfm?station_id=6
## 9    http://wmata.com/rail/station_detail.cfm?station_id=7
## 10  http://wmata.com/rail/station_detail.cfm?station_id=23
## 11   http://wmata.com/rail/station_detail.cfm?station_id=1
## 12  http://wmata.com/rail/station_detail.cfm?station_id=21
## 13  http://wmata.com/rail/station_detail.cfm?station_id=25
## 14  http://wmata.com/rail/station_detail.cfm?station_id=26
## 15   http://wmata.com/rail/station_detail.cfm?station_id=9
## 16   http://wmata.com/rail/station_detail.cfm?station_id=8
##                         LINE                    ADDRESS
## 1                        red        327 CEDAR STREET NW
## 2                        red     801 MICHIGAN AVENUE NE
## 3         red, green, yellow     550 GALLOWAY STREET NE
## 4                        red      200 FLORIDA AVENUE NE
## 5                        red   4501 WISCONSIN AVENUE NW
## 6                        red   5337 WISCONSIN AVENUE NW
## 7                        red 1001 CONNECTICUT AVENUE NW
## 8                        red        1525 20TH STREET NW
## 9                        red        2700 24TH STREET NW
## 10                       red            450 F STREET NW
## 11 red, blue, orange, silver         607 13TH STREET NW
## 12        red, green, yellow            630 H STREET NW
## 13                       red          701 1ST STREET NE
## 14                       red 919 RHODE ISLAND AVENUE NE
## 15                       red 4200 CONNECTICUT AVENUE NW
## 16                       red 3599 CONNECTICUT AVENUE NW
##                          geometry
## 1  POINT (-77.0181789925646 38...
## 2  POINT (-76.9945365689642 38...
## 3  POINT (-77.002205364201 38....
## 4  POINT (-77.0030227321829 38...
## 5  POINT (-77.0795896368441 38...
## 6  POINT (-77.084998118688 38....
## 7  POINT (-77.0397031233431 38...
## 8  POINT (-77.0434166573705 38...
## 9  POINT (-77.0524203221932 38...
## 10 POINT (-77.0166412451066 38...
## 11 POINT (-77.0280802893592 38...
## 12 POINT (-77.0219176806835 38...
## 13 POINT (-77.0074165779102 38...
## 14 POINT (-76.9959392002222 38...
## 15 POINT (-77.0629884863183 38...
## 16 POINT (-77.0580448228721 38...
```

Let's add some data. I found some ridership data for the different stations and summarized that, by station, into "station_rides.csv".  Let's pull that in, and add it to `dc_metro_sttn`. 


```r
# Read in ridership data
station_rides <- read.csv(here("data/station_rides.csv"), stringsAsFactors = FALSE)

# Now a typical dplyr workflow
dc_metro_sttn <- dc_metro_sttn %>%
  left_join(station_rides,by = c("NAME" = "Ent.Station"))
```

So, now we can use these values to filter our dataset, perhaps to just the stations with average ridership greater than 10000.


```r
busy_sttn <- dc_metro_sttn %>%
  filter(avg_wkday > 10000) %>%
  select(name = NAME, line = LINE, ridership = avg_wkday)
busy_sttn
```

```
## Simple feature collection with 7 features and 3 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -77.04342 ymin: 38.88803 xmax: -77.00742 ymax: 38.92785
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##               name                      line ridership
## 1 Columbia Heights             green, yellow   12608.3
## 2    Farragut West      blue, orange, silver   22365.4
## 3   Farragut North                       red   26012.4
## 4    Dupont Circle                       red   18291.8
## 5      Smithsonian      blue, orange, silver   11671.6
## 6     Metro Center red, blue, orange, silver   28199.5
## 7    Union Station                       red   32611.1
##                         geometry
## 1 POINT (-77.0325544130882 38...
## 2 POINT (-77.0406977114452 38...
## 3 POINT (-77.0397031233431 38...
## 4 POINT (-77.0434166573705 38...
## 5 POINT (-77.0280685258322 38...
## 6 POINT (-77.0280802893592 38...
## 7 POINT (-77.0074165779102 38...
```

Lastly, we can do some aggregation with `dplyr`.  Say we wanted to estimate total average weekly riders on the different line/line combinations.


```r
dc_metro_stn_summ <- dc_metro_sttn %>%
  group_by(LINE) %>%
  summarize(total_week_avg_ridership = sum(avg_wkday, na.rm = TRUE)) %>%
  arrange(desc(total_week_avg_ridership))
dc_metro_stn_summ
```

```
## Simple feature collection with 9 features and 2 fields
## geometry type:  GEOMETRY
## dimension:      XY
## bbox:           xmin: -77.085 ymin: 38.84567 xmax: -76.93526 ymax: 38.97609
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
## # A tibble: 9 x 3
##                            LINE total_week_avg_ridership          geometry
##                           <chr>                    <dbl>  <simple_feature>
## 1                           red                 110820.9 <MULTIPOINT (...>
## 2          blue, orange, silver                  61476.3 <MULTIPOINT (...>
## 3     red, blue, orange, silver                  28199.5 <POINT (-77.0...>
## 4                         green                  14708.6 <MULTIPOINT (...>
## 5                 green, yellow                  12608.3 <MULTIPOINT (...>
## 6            red, green, yellow                   7442.0 <MULTIPOINT (...>
## 7          orange, blue, silver                   6352.1 <POINT (-77.0...>
## 8                        orange                   1761.2 <MULTIPOINT (...>
## 9 grn, yllw, orange, blue, slvr                      0.0 <POINT (-77.0...>
```

Key thing to point out here is that not only have we aggregated and summarized the numeric values, but the spatial data has been aggregated into a MULTIPOINT object as well.  This works equally as well for lines and polygons (whoa!)

We have just scratched the surface on the spatial data manipulation with `sf` and `dplyr` but suffice it to say, anything you can imagine doing in your desktop GIS, we can also easily (and in many cases), more quickly do that with a reproducible R script.

## Projections
Although many GIS provide project-on-the-fly (jwh editorial: WORST THING EVER), R does not.  To get our maps to work and analysis to be correct, we need to know how to modify the projections of our data so that they match up.  A description of projections is way beyond the scope of this workshop, but these links provide some good background info and details:

- [USGS](http://egsc.usgs.gov/isb//pubs/MapProjections/projections.html)
- [NCEAS](https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf)

And for more on projecting there's some good info in the [rOpenSci draft spatial data viz Task View](https://github.com/ropensci/maptools#projecting-data)

For our purposes we will be using `st_transform()` to reproject data.  We need to supply two arguments, "x", the object we are transforming, and either an [EPSG code](http://www.epsg-registry.org/) or a character with a [Proj.4](https://trac.osgeo.org/proj/) string.  We will assume that we have good data read into R and that the original projection is already defined.  This is the case with all of the example data.  Be careful using data that do not have a coordinate reference system defined!

For our examples, we will be using [Proj.4](https://trac.osgeo.org/proj/) strings.  We can get the Proj.4 strings from other datasets, or specify them from scratch.  To get them from scratch, the easiest thing to do is search at [spatialreference.org](http://spatialreference.org/).  You can either search there, or just use Google.  For instance, if we want the [ESRI Albers Equal Area projection as Proj.4](www.google.com/search?q=ESRI Albers Equal Area projection as Proj.4) gets it as the first result.  Just select the [Proj4](http://spatialreference.org/ref/esri/usa-contiguous-albers-equal-area-conic/proj4/) link from the list.

We can pull them from existing `sf` objects like:


```r
st_crs(dc_metro)$proj4string
```

```
## [1] "+proj=longlat +datum=WGS84 +no_defs"
```

So, let's reproject our data using the Albers projection stored in the `dc_nlcd` raster.  It is a `raster` object and not `sf` so it needs to be accessed with `proj4string()`


```r
esri_alb_p4 <- projection(dc_nlcd) 
```

```
## Error in methods::extends(class(x), "BasicRaster"): object 'dc_nlcd' not found
```

```r
dc_metro_alb <- st_transform(dc_metro,esri_alb_p4)
```

```
## Error in make_crs(crs): object 'esri_alb_p4' not found
```

```r
plot(st_geometry(dc_metro_alb))
```

```
## Error in st_geometry(dc_metro_alb): object 'dc_metro_alb' not found
```

Luckily, it is pretty common to have several datasets with one of which in the projections you want to use.  We can then just pull the Proj4 string from that.


```r
dc_metro_sttn_alb <- st_transform(dc_metro_sttn,
                                  st_crs(dc_metro_alb)$proj4string) 
```

```
## Error in st_crs(dc_metro_alb): object 'dc_metro_alb' not found
```

Projecting rasters is a bit different.  We will use `raster::projectRaster` to accomplish this.   


```r
dc_elev_alb <- projectRaster(dc_elev,crs=st_crs(dc_metro_alb)$proj4string)
```

```
## Error in st_crs(dc_metro_alb): object 'dc_metro_alb' not found
```

## Exercise 3.1
In this first exercise we will work on manipulating the Tiger Lines file of the states that we pulled in as part of lesson 2 and assigned to `us_states`.

1. Using `filter()` from `dplyr`, filter out the DC boundary and assign it to an object named `dc_bnd`.
2. Re-project `dc_bnd` to match the projection of `dc_metro_alb` (created in examples above).  Assign this to an object named `dc_bnd_alb`.

## Brief introduction to geospatial analyis with GEOS

In this section we are going to start working with many of the "typical" GIS type analyses, specifically buffers and a few overlays. We will use only tools from `sf` for this.  These tools use the [GEOS](https://trac.osgeo.org/geos) libraries that are installed with `sf` (if you are using Windows)

Let's start with a buffer. We will use the albers projected stations for these examples


```r
sttn_buff_500 <- st_buffer(dc_metro_sttn_alb,dist = 500)
```

```
## Error in st_buffer(dc_metro_sttn_alb, dist = 500): object 'dc_metro_sttn_alb' not found
```

```r
plot(st_geometry(sttn_buff_500))
```

```
## Error in st_geometry(sttn_buff_500): object 'sttn_buff_500' not found
```

We get a 500 meter circle around each of the stations.  

Let's say we wanted land area that was 100 to 500 meters away from a Metro Station.  We used combine buffer, union, and difference to do this. 


```r
# Get 100 meters out
# st_union merges into one.
sttn_buff_100 <- st_buffer(dc_metro_sttn_alb,dist = 100) %>%
  st_union() 
```

```
## Error in st_buffer(dc_metro_sttn_alb, dist = 100): object 'dc_metro_sttn_alb' not found
```

```r
sttn_buff_500 <- st_buffer(dc_metro_sttn_alb, dist = 500) %>%
  st_union()
```

```
## Error in st_buffer(dc_metro_sttn_alb, dist = 500): object 'dc_metro_sttn_alb' not found
```

```r
sttn_100_to_500 <- st_difference(sttn_buff_500, sttn_buff_100)
```

```
## Error in st_difference(sttn_buff_500, sttn_buff_100): object 'sttn_buff_500' not found
```

```r
plot(sttn_100_to_500)
```

```
## Error in plot(sttn_100_to_500): object 'sttn_100_to_500' not found
```

Lastly, let's pull out some of the basic geographic info on our datasets using `st_area` and `st_length`. Let's get the area and perimeter of the all the land 100 to 500 meters from a metro station


```r
st_area(sttn_100_to_500)
```

```
## Error in st_crs(x): object 'sttn_100_to_500' not found
```

```r
st_length(sttn_100_to_500)
```

```
## Error in st_geometry(x): object 'sttn_100_to_500' not found
```

Again, this is a very, very small portion of the GISy things you can do with `sf` but hopefully is enough to get you started.

## Exercise 3.2
We will work with the re-projected `dc_bnd_prj` lets set this up for some further analysis.

1. Buffer the DC boundary by 1000 meters. Save it to dc_bnd_1000
2. Assign an object that represents only the area 1000 meters outside of DC (hint: `st_difference()`).
3. Determine the area of both the DC boundary as well as just the surrounding 1000 meters.

## Working with rasters
Let's move on to rasters.  We will be doing mostly work with base R to summarize information stored in rasters and use our vector datasets (will require some gymnastics since `sf` is newer than `raster`) to interact with those rasters and then we will show a few functions from `raster`.

We've already seen how to get some of the basic info of a raster.  To re-hash:


```r
dc_elev
```

```
## class       : RasterLayer 
## dimensions  : 798, 921, 734958  (nrow, ncol, ncell)
## resolution  : 0.0002777778, 0.0002777778  (x, y)
## extent      : -77.15306, -76.89722, 38.77639, 38.99806  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0 
## data source : C:\data\rspatial_workshop\data\dc_ned.tif 
## names       : dc_ned 
## values      : -5.316066, 131.4813  (min, max)
```

This gives us the basics.  There are many options for looking at the values stored in the raster.  I usually default to `values` which returns the values as a vector which we can then use in R functions.

For instance, mean elevation in `dc_elev` could be calculated with 


```r
mean(values(dc_elev),na.omit=TRUE)
```

```
## [1] 48.76833
```

If our raster contains categorical data (e.g. LULC), we can work with that too.  We don't have a ready example so lets use another `raster` function to reclassify our elevation data and then look at some summary stats of that.


```r
#reclass elevation into H, M, L
elev_summ <- summary(values(dc_elev))
#this is the format for the look up table expected by reclassify
rcl <- matrix(c(-Inf,elev_summ[2],1,
                elev_summ[2],elev_summ[5],2,
                elev_summ[5],Inf,3),
              nrow=3,byrow=T)
dc_elev_class <- reclassify(dc_elev,rcl)
dc_elev_class
```

```
## class       : RasterLayer 
## dimensions  : 798, 921, 734958  (nrow, ncol, ncell)
## resolution  : 0.0002777778, 0.0002777778  (x, y)
## extent      : -77.15306, -76.89722, 38.77639, 38.99806  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : 1, 3  (min, max)
```

So now we have categorical data, we can do cross-tabs on the values and calculate percent in each category.


```r
elev_class_perc <- table(values(dc_elev_class))/
  length(values(dc_elev_class))
elev_class_perc
```

```
## 
##         1         2         3 
## 0.2500007 0.4999986 0.2500007
```

The last task we will show is using vector to data to clip out our raster data.  We can do this with crop and mask.  We do the crop first as it will subset our raster based on the extent.  In most cases this is a significantly smaller area than the full raster dataset and speeds up the subsequent mask. We will do this with the projected versions.

As I mentioned above, to get this to work we will need to do some extra work becuase `raster` doesn't now what an `sf` object is.  Luckily, there are tools in `sf` for us to convert from `sf` to `sp`, specifically `as()`  


```r
dc_elev_crop <- crop(dc_elev_alb,as(sttn_buff_500,"Spatial"))
```

```
## Error in crop(dc_elev_alb, as(sttn_buff_500, "Spatial")): object 'dc_elev_alb' not found
```

```r
plot(dc_elev_crop)
```

```
## Error in plot(dc_elev_crop): object 'dc_elev_crop' not found
```

```r
plot(sttn_buff_500,add=T)
```

```
## Error in plot(sttn_buff_500, add = T): object 'sttn_buff_500' not found
```

So, with this limited to just the extent of our dataset we can now clip out the values for each of the circles with.


```r
dc_elev_sttns <- mask(dc_elev_crop,as(sttn_buff_500, "Spatial"))
```

```
## Error in mask(dc_elev_crop, as(sttn_buff_500, "Spatial")): object 'dc_elev_crop' not found
```

```r
plot(dc_elev_sttns)
```

```
## Error in plot(dc_elev_sttns): object 'dc_elev_sttns' not found
```

```r
plot(sttn_buff_500,add=T,border="red",lwd=2)
```

```
## Error in plot(sttn_buff_500, add = T, border = "red", lwd = 2): object 'sttn_buff_500' not found
```

That gives us just the elevation within 500 meters of the Metro stations.  Probably not really interesting information, but we have it!  It might be more interesting to get the average elevation of each metro station.  Our workflow would be different as we would need to look at this on a per-station basis.  Might require a loop or a different approach all together.  Certainly possible, but beyond what we have time for today.

## Exercise 3.3
Let's combine all of this together and calculate some landcover summary statistics

1. Clip out the NLCD from within the DC boundaries.
2. Clip out the NLCD from the surrounding 1000 meters.
3. Summarize the land use/land cover statistics and report percent of each landcover type both within the DC boundary and within the surrounding 1000 meters.



