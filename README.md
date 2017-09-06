Introduction to Spatial Analysis and GIS in R
=============================================

2017 US EPA R User Group Workshop
---------------------------------

### September 12, 2017

### Washington, DC

This repository contains the materials used in the Introduction to
Spatial Analysis and GIS in R workshop presented at the 2017 US EPA R
User Group Workshop.

Schedule for the AM and PM workshops is below:

<table>
<thead>
<tr class="header">
<th>Time</th>
<th>Topic</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>8:00 AM - 8:15 AM</td>
<td>Welcome</td>
</tr>
<tr class="even">
<td>8:15 AM - 8:30 AM</td>
<td><a href="lessons/set_up.md">Set-up</a></td>
</tr>
<tr class="odd">
<td>8:30 AM - 9:15 AM</td>
<td><a href="lessons/spatial_data_io.md">Spatial data I/O</a></td>
</tr>
<tr class="even">
<td>9:15 AM - 10:15 AM</td>
<td><a href="lessons/basic_spatial_analysis.md">Basic Spatial Analysis</a></td>
</tr>
<tr class="odd">
<td>10:15 AM - 10:30 AM</td>
<td>BREAK</td>
</tr>
<tr class="even">
<td>10:30 AM - 11:30 AM</td>
<td><a href="lessons/spatial_data_viz.md">Spatial Data Visualization</a></td>
</tr>
<tr class="odd">
<td>11:30 AM - 1:30 PM</td>
<td>LUNCH</td>
</tr>
<tr class="even">
<td>1:30 PM - 1:45 PM</td>
<td>Welcome</td>
</tr>
<tr class="odd">
<td>1:45 PM - 2:00 PM</td>
<td><a href="lessons/set_up.md">Set-up</a></td>
</tr>
<tr class="even">
<td>2:00 PM - 2:45 PM</td>
<td><a href="lessons/spatial_data_io.md">Spatial data I/O</a></td>
</tr>
<tr class="odd">
<td>2:45 PM - 3:45 PM</td>
<td><a href="lessons/basic_spatial_analysis.md">Basic Spatial Analysis</a></td>
</tr>
<tr class="even">
<td>3:45 PM - 4:00 PM</td>
<td>BREAK</td>
</tr>
<tr class="odd">
<td>4:00 PM - 5:00 PM</td>
<td><a href="lessons/spatial_data_viz.md">Spatial Data Visualization</a></td>
</tr>
</tbody>
</table>

#### Registrants

    readr::read_csv("spatial_registrants.csv")%>% 
      select(name,time) %>%
      knitr::kable(format="markdown")

    ## Parsed with column specification:
    ## cols(
    ##   name = col_character(),
    ##   time = col_character(),
    ##   email = col_character()
    ## )

<table>
<thead>
<tr class="header">
<th align="left">name</th>
<th align="left">time</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Amr Safwat</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Jaleh Abedini</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Leah Ettema</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Alicia Frame</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Angela McFadden</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Britt Dean</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Cory Strope</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">David Gibbs</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Erik Beck</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Lucas Neas</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Marta Fuoco</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Sarah Menassian</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">David Pawel</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">George Zipf</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Glenn Fernandez</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Jameel Alsalam</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Jennifer Williams</td>
<td align="left">AM</td>
</tr>
<tr class="even">
<td align="left">Jimmy Wong</td>
<td align="left">AM</td>
</tr>
<tr class="odd">
<td align="left">Stephanie Wilson</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Andrea Maguire</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Dave Smith</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">David Wahman</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Deeba Yavrom</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Dwane Young</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Emily Crispell</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Kurt Pluntke</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Sharon D. Kenny</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Sophie Greene</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Steve Krabbe</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Troy D. Hill</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Brian Schnitker</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Christine Hartless</td>
<td align="left">PM</td>
</tr>
<tr class="odd">
<td align="left">Sarah Waldo</td>
<td align="left">PM</td>
</tr>
<tr class="even">
<td align="left">Will Wheeler</td>
<td align="left">PM</td>
</tr>
</tbody>
</table>
