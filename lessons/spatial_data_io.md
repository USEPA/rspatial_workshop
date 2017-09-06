
```
## Error in FUN(X[[i]], ...): there is no package called 'sp'
```

```
## Error in eval(expr, envir, enclos): object 'opts_chunk' not found
```

# Reading and Writing Raster and Vector Data
So, now that we have the base packages installed and loaded we can work on getting our data into and out of R.  While it is possible to store spatial data as R objects (e.g. via .Rda/Rdata files) that is probably not the best approach.  It is better to store spatial data in widely used files (e.g. shapefiles,.tiff, or geojson) or in spatial databases (e.g. file geodatabse or PostGIS) and then read that data into R for analysis then write the results back out to your file format of choice.  In this lesson we will explore several ways to read and write multiple vector and raster data types.

## Lesson Outline
- [Vector data: shapefiles](#vector-data-shapefiles)
- [Vector data: file geodatabase](#vector-data-file-geodatabase])
- [Vector data: geojson](#vector-data-geojson)
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
- This last one really isn't a part of the workflow, but it fit here.  The script I am working on will be updated and on the web.  Jeff will provide link.

## Exercise 2.0
We will work through this together.

1. Create a new RStudio project and name it `rspatial_workshop_am` or `rspatial_workshop_pm`.
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
For this workshop, I have collected several example datasets to use and have included them in this repository.  So, let's first grab the dataset.  It is stored as a zip file.  You can download it [directly from this link](https://github.com/usepa/rspatial_workshop/blob/master/data/data.zip?raw=true), or we could use R.  I prefer to use the `httr` package because base `download.file` can act funny on different platforms.


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
For many, shapefiles are going to be the most common way to interact with spatial data.  In R, there are many ways to read in shapefiles.  We are going to focus on using `rgdal` because it is flexible and provides a common interface to multiple file types.  But to be fair, I'll also quickly show a another option from `maptools`.

### Reading in Shapfiles
To read in a shapefile using `rgdal`, we want to use the `readOGR` function.  This function is the primary way to interact with vector data using `rgdal`.  There are many arguments to this function, but the two you need are the "dsn" and "layer".  For a shapefile the "dsn" is the path (in our case probably "data") and the "layer" is the name of the shapefile without any extension.  The function call to read the DC Metro shapefile from our example data looks like: 


```r
dc_metro <- readOGR("data","Metro_Lines")
```

```
## Error in readOGR("data", "Metro_Lines"): could not find function "readOGR"
```

We will get more into working with `sp` object and visualizing spatial data later, but just to prove that this did something:


```r
summary(dc_metro)
```

```
## Error in summary(dc_metro): object 'dc_metro' not found
```

```r
plot(dc_metro)
```

```
## Error in plot(dc_metro): object 'dc_metro' not found
```

As I mentioned earlier, there are other ways to read in shapefiles.  For example:


```r
dc_metro_mt<-maptools::readShapeLines("data/Metro_Lines")
```

```
## Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]): there is no package called 'sp'
```

```r
summary(dc_metro_mt)
```

```
## Error in summary(dc_metro_mt): object 'dc_metro_mt' not found
```
 
Couple of notes on this  First the `maptools` functions require that you know your geometry type, whereas, `readOGR` will get that from the data.  I did test to see if the the `maptools::readShapeLines` was any quicker than `rgdal::readOGR` and in my huge sample of one, it was. Lastly, `readShapeLines` is a one-trick pony.  It reads in shapefiles and that is it.  As we will see, `readOGR` works across a range of vector data types and thus, is what I would recommend for most vector data I/O tasks.

### Writing shapefiles

Writing shapefiles is just as easy as reading them, assuming you have an `sp` object to work with.  We will just show this using `writeOGR`.

Before we do this, we can prove that the shapefile doesn't exist.



```r
list.files("data","dc_metro")
```

```
## character(0)
```

Now to write the shapefile:


```r
writeOGR(dc_metro,"data","dc_metro",driver="ESRI Shapefile")
```

```
## Error in writeOGR(dc_metro, "data", "dc_metro", driver = "ESRI Shapefile"): could not find function "writeOGR"
```

```r
#Is it there?
list.files("data","dc_metro")
```

```
## character(0)
```

So same "dsn" and "layer" arguments as before.  Only difference is that the first argument is the `sp` object you want to write out to a shapefile.  

## Vector data: file geodatabase
A recent addition to the GDAL world is the ability to read ESRI File Geodatabases.  This is easy to access on windows as the latest version of GDAL is wrapped up as part of the `rgdal` install and thus you get access to the appropriate drivers.  This is a bit more challenging on Linux (even more so on the antiquated RHEL 6 that is EPAs approved OS) as you need to have GDAL 1.11.x +.  In any event, if you use file geodatabases, you can read those directly into R with readOGR. Difference here is the "dsn" is the name of the file geodatabase (with path info if needed), and the "layer" is the feature class.


```r
#List feature classes
ogrListLayers("data/spx.gdb")
```

```
## Error in ogrListLayers("data/spx.gdb"): could not find function "ogrListLayers"
```

```r
examp_fgdb <- readOGR(dsn = "data/spx.gdb", layer="polygons5")
```

```
## Error in readOGR(dsn = "data/spx.gdb", layer = "polygons5"): could not find function "readOGR"
```

And to be sure it worked:


```r
summary(examp_fgdb)
```

```
## Error in summary(examp_fgdb): object 'examp_fgdb' not found
```

```r
plot(examp_fgdb)
```

```
## Error in plot(examp_fgdb): object 'examp_fgdb' not found
```

Writing to a file geodatabase from R is not yet possible.

## Vector data: geojson

Last vector example we will show is geojson.  For most desktop GIS users this will not be encountered too often, but as more and more GIS moves to the web, geojson will become increasingly common.  We will still rely on `readOGR` for the geojson.

### Reading in geojson

To read in with `rgdal` we use "dsn" and "layer" a bit differently.  The "dsn" is the name (and path) of the file, and "layer" is going to be set as "OGRGeoJSON". 


```r
dc_metro_sttn <- readOGR("data/metrostations.geojson", "OGRGeoJSON")
```

```
## Error in readOGR("data/metrostations.geojson", "OGRGeoJSON"): could not find function "readOGR"
```

And to see that something is there...
 

```r
#Let's use the defualt print method 
dc_metro_sttn
```

```
## Error in eval(expr, envir, enclos): object 'dc_metro_sttn' not found
```

```r
#And add a few more things to our plot
plot(dc_metro)
```

```
## Error in plot(dc_metro): object 'dc_metro' not found
```

```r
plot(dc_metro_sttn, col = "red", add=TRUE)
```

```
## Error in plot(dc_metro_sttn, col = "red", add = TRUE): object 'dc_metro_sttn' not found
```

### Writing geojson

Just as with shapefiles, writing to a geojson file can be accomplished with `writeOGR`.


```r
writeOGR(dc_metro_sttn,dsn="stations.gejson",layer="dc_metro_sttn",driver="GeoJSON")
```

Lastly, if you commonly work with geojson files, there is the `geojsonio` package from [rOpenSci](https://ropensci.org/) that provides a number of tools for reading, writing, and converting geojson files.  It is certainly worth exploring as it provides additional functionality beyond the `rgdal` toolset.

## Exercise 2.1
For this first exercise we will just focus on getting a shapefile read into R.  We will be using the sticky notes I handed out to let me know who needs help and who has finished the exercise.  Once everyone is done, we will move on.

1. Using `rgdal::readOGR` to read in the US Census Tiger Line Files of the state boundaries (tl_2015_us_state).  Assign it to an object called `us_states`.
2. Once it is read in use `summary` to look at some of the basics and then plot the data. 

## Raster data: GeoTIFF
We will just show a couple of examples as reading in rasters is a bit more straightforward than vector.  Our first examples will be GeoTIFF.

I will show one example with `rgdal`, but then we are going to switch to using `raster` for the remainder of the examples.  We'll see why pretty quickly with this example.

The `rgdal` function for reading in rasters is `readGDAL`.  For rasters, it essentially has a single argument we need to worry about, "fname" which is the filename.


```r
dc_elev_gdal <- readGDAL("data/dc_ned.tif")
```

```
## Error in readGDAL("data/dc_ned.tif"): could not find function "readGDAL"
```

```r
raster::print(dc_elev_gdal) #using the raster print method
```

```
## Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]): there is no package called 'sp'
```

Using `raster` is just as easy


```r
dc_elev <- raster("data/dc_ned.tif")
```

```
## Error in raster("data/dc_ned.tif"): could not find function "raster"
```

```r
dc_elev
```

```
## Error in eval(expr, envir, enclos): object 'dc_elev' not found
```

So it wasn't too obvious, but if we look closer ...


```r
system.time(readGDAL("data/dc_ned.tif"))
```

```
## Error in readGDAL("data/dc_ned.tif"): could not find function "readGDAL"
```

```
## Timing stopped at: 0 0 0
```

```r
system.time(raster("data/dc_ned.tif"))
```

```
## Error in raster("data/dc_ned.tif"): could not find function "raster"
```

```
## Timing stopped at: 0 0 0
```

The speed here is due to the fact that `raster` actually leaves the data on disk as opposed to pulling it all into memory.  Some operations will actually be faster on the `SpatialGrid` objects, but with bigger rasters reading in can be a challenge.  In addition, a lot of the typical raster operations come from the `raster` package and, in my opinion, it is just a bit easier to work with `raster` objects as opposed to `sp` for this.  Lastly, it is what I prefer, so there's that.  We will stick with `raster` for the rest of the workshop.


## Writing rasters:
Writing out to a raster file is done with `writeRaster`.  It has three arguments, "x" which is the `raster` object, "filename" which is the output file, and "format" which is the output raster format.  In practice, you can usually get away with not specifying the format as `raster` will try to infer the file format from the file name.  If you want to see the possible formats you can use `writeFormats()`.

To write out to a GeoTIFF:


```r
writeRaster(dc_elev,"dc_elev_example.tif", overwrite = T)
```

```
## Error in writeRaster(dc_elev, "dc_elev_example.tif", overwrite = T): could not find function "writeRaster"
```

## Exercise 2.2
For this exercise let's get some practice with reading in raster data using the `raster` function.

1. Read in "dc_nlcd.tif". Assign it to an object names `dc_nlcd`.
2. Plot the object to make sure everything is working well.


## Geospatial data packages
There are a few packages on CRAN that provide access to spatial data. While this isn't necessarily data I/O, it is somewhat related.  We won't go into details as the intreface and data types for these are unique to the packages and a bit different than the more generic approach we are working on here.  That being said, these are useful and you should be aware of them.

A couple of interesting examples.

- `maps`: This has been around for a while and is still actively maintained so it's a good first place to look for spatial data. Contains mostly boundary datasets (e.g. counties) and has both US and international data. 
- `USCensus2010`:  Provides access to census data directly in R.  I haven't dug into this one much, so can't say too much.  There is also a package for the 2000 census. 

