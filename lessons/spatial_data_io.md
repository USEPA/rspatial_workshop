

# Reading and Writing Raster and Vector Data
So, now that we have the base packages installed and loaded we can work on getting our data into and out of R.  While it is possible to store spatial data as R objects (e.g. via .Rda/Rdata files) that is probably not the best approach.  It is better to store spatial data in widely used files (e.g. shapefiles,.tiff, or geojson) or in spatial databases (e.g. file geodatabse or PostGIS) and then read that data into R for analysis then write the results back out to your file format of choice.  In this lesson we will explore several ways to read and write multiple vector and raster data types.

## Lesson Outline
- [Vector data: shapefiles](#vector-data-shapefiles)
- [Vector data: geojson](#vector-data-geojson)
- [Vector data: Other](#vector-data-other)
- [Raster data: GeoTIFF](#raster-data-geotiff)
- [Raster data: ASCII](#raster-data-arcinfo-ascii)
- [Writing rasters](#writing-rasters)
- [Geospatial data packages](#geospatial-data-packages)

## Lesson Exercises
- [Exercise 2.0](#exercise-20)
- [Exercise 2.1](#exercise-21)
- [Exercise 2.2](#exercise-22)

## Before we start: Workflow with RStudio
I am a bit of a stickler on workflow.  If you standardize that part of your analysis, then it frees up valuable brain cells for other more interesting tasks.  For the rest of the workshop our workflow will follow these rules:

- We will work in an RStudio Project
- Our data will be stored in the project in a `data` folder
- All of our analysis and examples will be scripted and live in a `scripts` folder
- We will manage our paths with the fantastic [`here` package](https://cran.r-project.org/package=here).
- This last one really isn't a part of the workflow, but it fit here.  The script I am working on will be updated and on the web at:
    - AM: <https://github.com/jhollist/rspatial_workshop_am/blob/master/scripts/workshop_code.R>.
    - PM: <https://github.com/jhollist/rspatial_workshop_pm/blob/master/scripts/workshop_code.R>

## Exercise 2.0
We will work through this together.

1. Create a new RStudio project and name it `rspatial_workshop_am` or `rspatial_workshop_pm` depending on the time!
2. In your project create a `data` folder.
3. In your project create a `scripts` folder.
4. Create a new script, save it to your `scripts` folder and call it `workshop_code.R`
5. In the `workshop_code.R` add the following and save:


```r
# Packages
library(here)
library(sf)
library(raster)
library(dplyr)
```

## Get the example data
For this workshop, I have collected several example datasets to use and have included them in this repository.  So, let's first grab the dataset.  It is stored as a zip file.  You can download it [directly from this link](https://github.com/usepa/rspatial_workshop/blob/master/data/data.zip?raw=true), or we could use R.  I prefer to use the `httr` package because base `download.file` can act funny on different platforms.  We will save it to our `data` folder. 


```r
library(httr)
url <- "https://github.com/usepa/rspatial_workshop/blob/master/data/data.zip?raw=true"
GET(url,write_disk(here("data/data.zip"),overwrite = TRUE))
```

Oh and while we are being a bit #rstats crazy...  Let unzip it with R too!


```r
unzip(here("data/data.zip"), exdir = here("data"), overwrite = TRUE)
```


## Vector data: shapefiles
For many, shapefiles are going to be the most common way to interact with spatial data.  With `sf`, reading in in shapefiles is straightforward via the `st_read()` function.


```r
dc_metro <- st_read(here("data/Metro_Lines.shp"))
```

```
## Reading layer `Metro_Lines' from data source `/var/host/media/removable/SD Card/rspatial_workshop/data/Metro_Lines.shp' using driver `ESRI Shapefile'
## Simple feature collection with 8 features and 4 fields
## geometry type:  MULTILINESTRING
## dimension:      XY
## bbox:           xmin: -77.08576 ymin: 38.83827 xmax: -76.91327 ymax: 38.97984
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
```

We will get more into working with `sf` object and visualizing spatial data later, but just to prove that this did something:


```r
dc_metro
```

```
## Simple feature collection with 8 features and 4 fields
## geometry type:  MULTILINESTRING
## dimension:      XY
## bbox:           xmin: -77.08576 ymin: 38.83827 xmax: -76.91327 ymax: 38.97984
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
##      GIS_ID            NAME                            WEB_URL OBJECTID
## 1 Metro_004             red http://wmata.com/rail/maps/map.cfm        1
## 2 Metro_005          yellow http://wmata.com/rail/maps/map.cfm        2
## 3 Metro_003          orange http://wmata.com/rail/maps/map.cfm        3
## 4 Metro_002           green http://wmata.com/rail/maps/map.cfm        4
## 5 Metro_002 yellow - rush + http://wmata.com/rail/maps/map.cfm        5
## 6 Metro_001            blue http://wmata.com/rail/maps/map.cfm        6
## 7 Metro_001 orange - rush + http://wmata.com/rail/maps/map.cfm        7
## 8 Metro_006          silver http://wmata.com/rail/maps/map.cfm        8
##                         geometry
## 1 MULTILINESTRING ((-77.02029...
## 2 MULTILINESTRING ((-77.04157...
## 3 MULTILINESTRING ((-77.06848...
## 4 MULTILINESTRING ((-76.98502...
## 5 MULTILINESTRING ((-76.98502...
## 6 MULTILINESTRING ((-77.06842...
## 7 MULTILINESTRING ((-76.95222...
## 8 MULTILINESTRING ((-77.04712...
```

```r
plot(dc_metro)
```

![plot of chunk metro_chk](figure/metro_chk-1.png)

The spatial data types that `sf` recognizes follow the general concept of points, lines and polygons.  You can see for this that the Metro Lines are read in as a MUTLILINESTRING.  Details on these are beyond what we can cover in this short workshop, but the `sf` documentation does a good job, in particular the [Simple Features in R vignette](https://r-spatial.github.io/sf/articles/sf1.html).

### Writing shapefiles

Writing shapefiles is just as easy as reading them, assuming you have an `sf` object to work with.  We will just show this using `st_write`.

Before we do this, we can prove that the shapefile doesn't exist.



```r
list.files(here("data"),"dc_metro")
```

```
## character(0)
```

Now to write the shapefile:


```r
st_write(dc_metro,here("data/dc_metro.shp"))
```

```
## Writing layer `dc_metro' to data source `/var/host/media/removable/SD Card/rspatial_workshop/data/dc_metro.shp' using driver `ESRI Shapefile'
## features:       8
## fields:         4
## geometry type:  Multi Line String
```

```r
#Is it there?
list.files(here("data"),"dc_metro")
```

```
## [1] "dc_metro.dbf" "dc_metro.prj" "dc_metro.shp" "dc_metro.shx"
```

## Vector data: geojson

Last vector example we will show is geojson.  For most desktop GIS users this will not be encountered too often, but as more and more GIS moves to the web, geojson will become increasingly common.  We will still rely on `st_read()` for the geojson.

### Reading in geojson

To read in with `rgdal` we use "dsn" and "layer" a bit differently.  The "dsn" is the name (and path) of the file, and "layer" is going to be set as "OGRGeoJSON". 


```r
dc_metro_sttn <- st_read(here("data/metrostations.geojson"))
```

```
## Reading layer `OGRGeoJSON' from data source `/var/host/media/removable/SD Card/rspatial_workshop/data/metrostations.geojson' using driver `GeoJSON'
## Simple feature collection with 40 features and 6 fields
## geometry type:  POINT
## dimension:      XY
## bbox:           xmin: -77.085 ymin: 38.84567 xmax: -76.93526 ymax: 38.97609
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
```

And to see that something is there...
 

```r
#Let's look at the first six lines
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

### Writing geojson

Just as with shapefiles, writing to a geojson file can be accomplished with `st_write()`.


```r
st_write(dc_metro_sttn,"data/stations.geojson")
```

## Vector data: Other

We have barely touched the surface on the types of vector data formats that can be read in via `st_read()`.  The full list is available via <http://www.gdal.org/ogr_formats.html>.  With the defaults we can read File Geodatabase, PostGIS, GeoPackage, Arc Export files ...

In short, if you have it, we can probably read it, but for todays short workshop that is a bit beyond the scope.

## Exercise 2.1
For this first exercise we will just focus on getting a shapefile read into R.  We will be using the sticky notes I handed out to let me know who needs help and who has finished the exercise.  Once everyone is done, we will move on.

1. Using `st_read()`, read in the US Census Tiger Line Files of the state boundaries (tl_2015_us_state).  Assign it to an object called `us_states`.
2. Once it is read in use `summary` to look at some of the basics and then plot the data. 

## Raster data: GeoTIFF
We will now use the `raster` packages `raster()` function to read in some raster files.  Our first examples will be GeoTIFF.

Using `raster()` is just as easy as `st_read()`


```r
dc_elev <- raster(here("data/dc_ned.tif"))
dc_elev
```

```
## class       : RasterLayer 
## dimensions  : 798, 921, 734958  (nrow, ncol, ncell)
## resolution  : 0.0002777778, 0.0002777778  (x, y)
## extent      : -77.15306, -76.89722, 38.77639, 38.99806  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0 
## data source : /var/host/media/removable/SD Card/rspatial_workshop/data/dc_ned.tif 
## names       : dc_ned 
## values      : -5.316066, 131.4813  (min, max)
```

```r
plot(dc_elev)
```

![plot of chunk raster](figure/raster-1.png)

One thing to note is that, by default, `raster` actually leaves the data on disk as opposed to pulling it all into memory (like most things do in R). This allows us to work with rasters that are significantly larger than are available memory.  Only downside is that if we want to use other R functions on really big rasters we might have some issues.  Anyway, `raster` is best available (and is pretty good) method for working with rasters in R.  That is changing as other options are in development, most notably [the `stars` package](https://github.com/r-spatial/stars).

## Writing rasters:
Writing out to a raster file is done with `writeRaster`.  It has three arguments, "x" which is the `raster` object, "filename" which is the output file, and "format" which is the output raster format.  In practice, you can usually get away with not specifying the format as `raster` will try to infer the file format from the file name.  If you want to see the possible formats you can use `writeFormats()`.

To write out to a GeoTIFF:


```r
writeRaster(dc_elev,"dc_elev_example.tif", overwrite = T)
```

## Exercise 2.2
For this exercise let's get some practice with reading in raster data using the `raster` function.

1. Read in "dc_nlcd.tif". Assign it to an object names `dc_nlcd`.
2. Plot the object to make sure everything is working well.


## Geospatial data packages
There are a few packages on CRAN that provide access to spatial data. While this isn't necessarily data I/O, it is somewhat related.  We won't go into details as the intreface and data types for these are unique to the packages and a bit different than the more generic approach we are working on here.  That being said, these are useful and you should be aware of them.

A couple of interesting examples.

- [`censusapi`](https://cran.r-project.org/package=censusapi): This package provides a wrapper the API provided by the US Census Bureau.  Anything that is made available from that (e.g. decennial, ACS, etc.) can be accessed from this package.
- [`tidycensus`](https://cran.r-project.org/package=tidycensus): Provides a user-friendly interface and data format for accessing Census data.
- [`elevatr`](https://cran.r-project.org/package=elevatr): (WARNING: Horn Tooting Ahead) This package wraps several elevation API's that return either point elevation data as and `sp` object (`sf` support to come soon-ish) or a `raster` DEM for a given area, usually specified by the bounding box of an input `sp` object (ditto `sf` support).

