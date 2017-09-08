
 
# Setting up R to do GIS
Out of the box, R is not ready to do GIS analysis.  As such, we need to add a few packages that will provide most of the functionality you'd expect out of a GIS.  In this lesson we will introduce the bare minimum packages for doing GIS.

## Lesson Outline
- [Required packages](#required-packages)
- [Interacting with an external GIS](#interacting-with-an-external-gis)

## Lesson Exercises
- [Exercise 1.1](#exercise-11)

## Required packages

Since the late 2000's there has been a rapid increase in the spatial data handling and analysis capability of R.  The `rgdal`, `rgeos`, `raster`, and `sp` packages (through the very significant effort of the package authors) provided the foundation for doing GIS entirely within R. More recently a new route for handling vector data has emerged in the [`sf` package](https://cran.r-project.org/package=sf).  Most current development for vector processing is focusing on `sf`.  As such, this workshop will as well.  Raster data is still dealt with via [`raster`](https://cran.r-project.org/package=raster) and we will also be using that.

Let's dig in a bit deeper into these two packages.

### sf
The [`sf` package](http://r-spatial.github.io/sf/) provides vector data handling via the Simple Features standard, an Open Geospatial Consortium and International Standards Organization standard for spatial data. In addition, `sf` provides a tidy spatial data format that allows for manipulation with the popular `dplyr` package.

Getting `sf` added is no different than adding any other package that is on CRAN.


```r
install.packages("sf")
library("sf")
```


### raster

For our raster data processing we will use the venerable `raster` package.   

To install, just do: 


```r
install.packages("raster")
library("raster")
```


### rgdal and sp

While we won't be using the `rgdal` and `sp` packages directly, `raster` does depend on them so I wanted to mention it breifly. The `rgdal` package provides tools for reading and writing multiple spatial data formats.  It is based on the [Geospatial Data Abstraction Library (GDAL)](http://www.gdal.org/) which is a project of the Open Source Geospatial Foundation (OSGeo).  The `sp` package has been the *de-facto* package for spatial data handling and is required for us to use the `raster` package. 

As before, nothing special to get set up with `rgdal` or `sp` on windows.  Simply:


```r
install.packages("rgdal")
library("rgdal")

install.packages("sp")
libaray("rgdal")
```

Getting set up on Linux or Mac requires more effort (i.e. need to have GDAL installed).  As this is for a USEPA audience the windows installs will work for most.  Thus, discussion of this is mostly beyond the scope of this workshop.  

## Exercise 1.1
The first exercise won't be too thrilling, but we need to make sure everyone has the five packages installed. 

1. Install `dplyr` first. We will use that for spatial data manipulation and the version of it you have determines what gets installed with `sf`.
2. Install `sf` and load `sf` into your library.
3. Repeat, with `raster` `sp`, and `rgdal`.



## Interacting with an external GIS
Although we won't be working with external GIS in this workshop, there are several packages that provide ways to move back and forth from another GIS and R.  

- [spgrass6](https://cran.r-project.org/web/packages/spgrass6/index.html): Provides an interface between R and [GRASS 6+](https://grass.osgeo.org/download/software/#g64x).  Allows for running R from within GRASS as well as running GRASS from within R.  
- [rgrass7](https://cran.r-project.org/web/packages/rgrass7/index.html): Same as `spgrass6`, but for the latest version of GRASS, [GRASS 7](https://grass.osgeo.org/download/software/#g70x).
- [RPyGeo](https://cran.r-project.org/web/packages/RPyGeo/index.html): A wrapper for accessing ArcGIS from R.  Utilizes intermediate python scripts to fire up ArcGIS.  Hasn't been updated in some time.
- [RSAGA](https://cran.r-project.org/web/packages/RSAGA/index.html): R interface to the command line version of [SAGA GIS](http://www.saga-gis.org/en/index.html).
- [RQGIS](https://cran.r-project.org/package=RQGIS): Provides an interface to [QGIS](http://www.qgis.org/en/site/) from R. 







