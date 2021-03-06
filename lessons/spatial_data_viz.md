



```
## Reading layer `Metro_Lines' from data source `/var/host/media/removable/SD Card/rspatial_workshop/data/Metro_Lines.shp' using driver `ESRI Shapefile'
## Simple feature collection with 8 features and 4 fields
## geometry type:  MULTILINESTRING
## dimension:      XY
## bbox:           xmin: -77.08576 ymin: 38.83827 xmax: -76.91327 ymax: 38.97984
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
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

# Visualizing Spatial Data in R
Visualizing spatial data in interactive and static forms is one of the defining characteristics of GIS.  With interactive visualization and analysis, R, has not been quite up to the standards of a stand-alone GIS like QGIS or ArcGIS. Static visualization (e.g. maps) in R are, in my opinion, on par with anything you can create with a dedicated GIS.  A few (now somewhat dated) examples of maps built with R show this:

- [London Bike Hires](http://spatialanalysis.co.uk/wp-content/uploads/2012/02/bike_ggplot.png)
- [Facebook Users](http://paulbutler.org/archives/visualizing-facebook-friends/facebook_map.png)

For quick simple static visualization we can use the base plotting functions that `sf` and `raster` provide.  For maps with a bit more cartographic flair we can use `ggplot2`.  We will show examples of both of these.  

For interactive visualization of spatial data, the bread and butter of GIS, we will use the `mapview` package which provides an easy way to visualize `sf` (and `sp`) objects using Leaflet javascript libraries.

## Lesson Outline
- [Visualizing spatial data with `sf` and `raster`](#visualizing-spatial-data-with-sf-and-raster)
- [Mapping with javascript: `mapview`](#mapping-with-javascript-mapview)

## Lesson Exercises
- [Exercise 4.1](#exercise-41)
- [Exercise 4.2](#exercise-42)

## Visualizing spatial data with `sf` and `raster`

The default plotting tools from `sf` and `raster` are good enough for most of your needs and we have already seen these functions in action.  We will show these again.

To create a plot of a single layer


```r
plot(st_geometry(dc_metro))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

```r
#Play with symbology
plot(st_geometry(dc_metro), col="red", lwd = 3)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)

```r
#Use data to color
plot(st_geometry(dc_metro), col=factor(dc_metro$NAME), lwd=dc_metro$GIS_ID)
```

```
## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion

## Warning in plot.xy(xy.coords(x, y), type = type, ...): NAs introduced by
## coercion
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-3.png)

To create a plot of a multiple layers, we can use the "add" argument.


```r
plot(st_geometry(dc_metro))
#Add stations, change color,size, and symbol
plot(st_geometry(dc_metro_sttn), add=T, col="red", pch=15, cex=1.2)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

Add some raster data in.


```r
plot(dc_elev)
plot(st_geometry(dc_metro), add=T)
plot(st_geometry(dc_metro_sttn), add=T, col="red", pch=15,cex=1.2)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

We can certainly get fancier with the final plot, but that means digging into the details of plotting with base R.  Also, we can plot maps with `ggplot2`, but that'd be a workshop in and of itself!  


## Mapping with javascript: `mapview`

Many of the visualization tasks (e.g. zoom, pan, identify) are implemented (and implemented well) in various javascript libraries.  As such, much of the development in R has been towards packages to access javascript libraries and allow the display of R objects. Our efforts are going to focus on the [`mpaview` package](https://cran.r-project.org/package=mapview) which provides a relatively streamlined way to access the [leaflet javascript library](http://leafletjs.com/) in R.  It uses the `leaflet` package, which  is written and maintained through RStudio.  For more on how to use `leaflet` directly, check out [RStudio's tutorial](https://rstudio.github.io/leaflet/).  For additional tutorials on mapview, see articles on [the r-spatial page.](https://r-spatial.github.io/mapview/index.html) 

Before we build some maps, let's get everything we need installed and loaded.


```r
install.packages("leaflet")
install.packages("mapview")
library(mapview)
```

Although the maps we can create with `mapview` are really nice, there is one downside.  It is expected that the data are all in unprojected latitude and longitude, so if you have projected data, that will need to be converted back in to geographic coordinates. This happens behind the scenes by `mapview` so it is easy to do, just be aware that your maps will display in the ubiquitous web mercator projection. For most applications this won't be a problem, but if your viz requires accurate shape and size and you are in high lattitudes, you will need to think carefully about the impacts of this.

So lets get started with the bare minimum of `mapview()` 


```r
map <- mapview(dc_metro_alb)
map
```

The default options from `mapview()` are pretty nice and we won't be going beyond these.  But since this is built off of `leaflet`, in theory most things that leaflet can do, we can use in our mapview maps.  Let's explore the map a bit before we move on.

Now, lets add other layers in and also change their styling.


```r
map + dc_metro_sttn
```

Lastly, we can add in rasters.


```r
map + dc_metro_sttn + dc_elev
```

## Exercise 4.2
For this exercise, we will create a `mapview` map

1. Create a `mapview` map and add in the DC boundary.
2. Add in the NLCD you clipped out as part of lesson 3.

## Ask me anything

We probably won't have additional time, but if for some reason we do, we can use the leftover time to do an Ask Me Anything.  Any questions are free game, but would assume they will focus on R, R for spatial analysis, R Package Development, etc.  Let the questions fly!

