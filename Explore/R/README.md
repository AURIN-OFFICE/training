# Accessing AURIN Data Provider via RStudio

The goal of this tutorial is to introduce how to use RStudio to connect to AURIN Data Provider and download data. This is designed with no prerequisite of R experiences.

The ADP is an interface that allows you to use programming scripts to interact with and access the AURIN Data Catalogue. You can send a request to the AURIN Data Provider using R scripts and get a response to download specific datasets.

The ADP is based on ipts to interact with and access the AURIN Data Catalogue. You can send a request to the AURIN Data Provider using R scripts and get a response to download specific datasets. The ADP is based on [Open Geospatial Consortium](https://en.wikipedia.org/wiki/Open_Geospatial_Consortium) Web Feature Service (WFS) Interface Standards. With ADP credentials, AURIN’s data repository is at your fingertips.

**Before commencing this step, please ensure you have generated your unique ADP Credentials (username and password) using the [ADP Access Dashboard](https://adp-access.aurin.org.au/login).**

## Tutorial goals:

In this tutorial, our goal is to use RStudio to connect to the ADP and download a dataset. You will learn how to:

1. Choose between different R environments
2. Install related R packages
3. Use R coding environments
4. Interact with the ADP

## 1. Choose between Different R Environments
[R](https://www.r-project.org) is a free and open-source statistical software program and programming language. It is a very powerful tool for data analysts from all disciplines, from economics to ecology and geography. The [geographic information system](https://en.wikipedia.org/wiki/Geographic_information_system) (GIS) capabilities of R have developed significantly over the last decade.

If you are getting started with R, we suggest you use a cloud environment, such as SWAN in the CloudStor, as it has R and its prerequisites already installed. If you wish to use your personal computer, we recommend using R version 4.2.1 or later on your computer. We hope the image below may help you understand the benefits and limitations of each option.

### <img src="https://user-images.githubusercontent.com/106126121/177250393-a6a97131-f098-42a4-8eb8-44cf088166fb.png" width="600"> 

[Click here to learn how to set up the environment](https://aurin.aurin.org.au/resources/training/explore-r/) 



## 2. Packages and Libraries

R packages are libraries of functions developed by the R community.

The packages that we are going to use in this tutorial include:

[sf](https://cran.r-project.org/web/packages/sf/index.html) - Provides support for simple features, a standardized way to use geospatial data.

[httr](https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html) - This is a web service package that can be used to create a request to AURIN.

[tidyverse](https://www.tidyverse.org) - A huge collection of R packages designed for data science.

[ows4R](https://cran.r-project.org/web/packages/ows4R/index.html) - Provides an Interface to Web-Services defined as standards by the Open Geospatial Consortium (OGC).

[mapview]()- Enables functions to quickly and conveniently create interactive visualisations of spatial data.



## 3. Use R coding environments
In this repository you find two versions of the scripts: 
- Rstudio: [ADP.R](https://github.com/AURIN-OFFICE/training/blob/main/Explore/R/ADP.R)
- Jupyter Lab: [ADP.ipynb](https://github.com/AURIN-OFFICE/training/blob/main/Explore/R/ADP.ipynb)


You can choose your graphical user interface (GUI) and Install packages. You can copy then paste the following code into the RStudio console/Jupyter Notebook.   



```R
install.packages(c("sf", "httr", "tidyverse", "ows4R", "mapview"))

```

After installation, we can use `library()` to load these packages. Again, you can copy the code below, and paste it into the Console.


```R
library(sf)
library(httr)
library(tidyverse)
library(ows4R)
library(mapview)
library(utils)

```

## 4. Interact with the ADP

### a. Setup connection parameters
To connect to the ADP you need to let RStudio know the address of the ADP and your access credentials.

Please replace yourName and yourPassword below with your own ADP username and password and execute the code to define the connection parameters. If you don’t have ADP credentials, please generate your own unique credentials in the [ADP Access Dashboard](https://adp-access.aurin.org.au).


```R
#### ------ Setup variables ------- #####
wfs_url <- "https://adp.aurin.org.au/geoserver/wfs"
user_name <- "yourName"
password <- "yourPassword"
#### ------ Define url ----- ####
url <- parse_url(wfs_url)
url$hostname <- paste(user_name,":",password,"@",url$hostname, sep="")
```

Create a new adp_client, using the below code to connect to the ADP, which is itself a Web Feature Service (WFS).


```R
adp_client <- WFSClient$new(url = wfs_url, user = user_name, pwd = password, serviceVersion = '2.0.0')
```

### b. List available datasets

We can view information about dataset name and title of the first 10 datasets:


```R
#Get all available layers
head(adp_client$getFeatureTypes(pretty = TRUE),10)
```


<table class="dataframe">
<caption>A data.frame: 10 × 2</caption>
<thead>
	<tr><th></th><th scope=col>name</th><th scope=col>title</th></tr>
	<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>
</thead>
<tbody>
	<tr><th scope=row>1</th><td>datasource-NSW_Govt_DPE-UoM_AURIN_DB:nsw_srlup_additional_rural_2014</td><td> Additional Rural Village Land 18/01/2014 for NSW              </td></tr>
	<tr><th scope=row>2</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:aus_2016_aust          </td><td>ABS - ASGS - Country (AUS) 2016                                </td></tr>
	<tr><th scope=row>3</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:gccsa_2011_aust        </td><td>ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2011</td></tr>
	<tr><th scope=row>4</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:gccsa_2016_aust        </td><td>ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2016</td></tr>
	<tr><th scope=row>5</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2016_aust           </td><td>ABS - ASGS - Mesh Block (MB) 2016                              </td></tr>
	<tr><th scope=row>6</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_act            </td><td>ABS - ASGS - Mesh Block (MB) ACT 2011                          </td></tr>
	<tr><th scope=row>7</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_nsw            </td><td>ABS - ASGS - Mesh Block (MB) NSW 2011                          </td></tr>
	<tr><th scope=row>8</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_nt             </td><td>ABS - ASGS - Mesh Block (MB) NT 2011                           </td></tr>
	<tr><th scope=row>9</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_ot             </td><td>ABS - ASGS - Mesh Block (MB) OT 2011                           </td></tr>
	<tr><th scope=row>10</th><td>datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_qld            </td><td>ABS - ASGS - Mesh Block (MB) QLD 2011                          </td></tr>
</tbody>
</table>



### c. Download data

You can search the [AURIN Data Catalogue](https://data.aurin.org.au) to find datasets you would like to download.

For example, if you are interested in a dataset describing the locations of fire stations in Victoria, enter “fire station” and click search. Browse the results and select 
[VIC DELWP – Vicmap Features of Interest – Country Fire Authority (CFA) Fire Stations (Points)](https://data.aurin.org.au/dataset/vic-govt-delwp-datavic-vmfeat-cfa-fire-station-na) and view its description, including its metadata table.

To download that dataset into R, find and copy its ADP ID in the metadata table, in this case it is `datasource-VIC_Govt_DELWP-VIC_Govt_DELWP:datavic_VMFEAT_CFA_FIRE_STATION`. Then create the following query, pasting the ADP ID into the typeName variable within RStudio.


```R
url$query <- list(service = "wfs",
                    #version = "2.0.0", # optional
                    request = "GetFeature",
                    typeName = "datasource-VIC_Govt_DELWP-VIC_Govt_DELWP:datavic_VMFEAT_CFA_FIRE_STATION",
                    srsName = "EPSG:4326")
```

Use the following functions to build the query and download the data from the ADP and save it. In this case we are downloading the data in GML format and saving it with the file name data_fire.gml. You can see a list of other supported ADP output formats here.


```R
request <- build_url(url)
### ---- Download the data ---- ###
download.file(request, destfile = "./data_fire.gml", mode='wb')
### ---- Read the data ---- #### 
data <- read_sf("data_fire.gml")
```

    Warning message in CPL_read_ogr(dsn, layer, query, as.character(options), quiet, :
    “GDAL Error 1: HTTP error code : 400”


###  d.  View data


Use the `head()` function again to view some of the dataset’s rows:

Now you will see information about the fire stations in tabular format:


```R
View(head(data))
```


<table class="dataframe">
<caption>A sf: 6 × 20</caption>
<thead>
	<tr><th scope=col>gml_id</th><th scope=col>PFI</th><th scope=col>FEATURE_ID</th><th scope=col>FEATURE_TYPE</th><th scope=col>FEATURE_SUBTYPE</th><th scope=col>NAME</th><th scope=col>NAME_LABEL</th><th scope=col>AUTH_ORG_CODE</th><th scope=col>AUTH_ORG_ID</th><th scope=col>AUTH_ORG_VERIFIED</th><th scope=col>VMADD_PFI</th><th scope=col>VICNAMES_ID</th><th scope=col>VICNAMES_STATUS_CODE</th><th scope=col>STATE</th><th scope=col>CREATE_DATE_PFI</th><th scope=col>CREATE_DATE_UFI</th><th scope=col>OBJECTID</th><th scope=col>PARENT_FEATURE_ID</th><th scope=col>PARENT_NAME</th><th scope=col>SHAPE</th></tr>
	<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;POINT [°]&gt;</th></tr>
</thead>
<tbody>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926122</td><td>655590</td><td>655590</td><td>emergency facility</td><td>fire station</td><td>KARABEAL FIRE STATION  </td><td>Karabeal Fire Station  </td><td>106</td><td>917</td><td>2022-03-22T00:00:00Z</td><td>425361444</td><td>   13118</td><td>10</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997676</td><td>    NA</td><td>NA</td><td>POINT (142.2315 -37.5882)</td></tr>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926123</td><td>655591</td><td>655591</td><td>emergency facility</td><td>fire station</td><td>KARNAK FIRE STATION    </td><td>Karnak Fire Station    </td><td>106</td><td>620</td><td>2022-03-22T00:00:00Z</td><td> 54327520</td><td>-1909887</td><td>11</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997677</td><td>637910</td><td>NA</td><td>POINT (141.4716 -36.8264)</td></tr>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926124</td><td>655592</td><td>655592</td><td>emergency facility</td><td>fire station</td><td>KARRAMOMUS FIRE STATION</td><td>Karramomus Fire Station</td><td>106</td><td>136</td><td>2022-03-22T00:00:00Z</td><td>425481983</td><td>   13160</td><td>10</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997678</td><td>    NA</td><td>NA</td><td>POINT (145.4981 -36.5375)</td></tr>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926125</td><td>655593</td><td>655593</td><td>emergency facility</td><td>fire station</td><td>KATAMATITE FIRE STATION</td><td>Katamatite Fire Station</td><td>106</td><td>137</td><td>2022-03-22T00:00:00Z</td><td> 54237347</td><td>   13174</td><td>10</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997679</td><td>    NA</td><td>NA</td><td>POINT (145.6887 -36.0788)</td></tr>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926126</td><td>655594</td><td>655594</td><td>emergency facility</td><td>fire station</td><td>KATANDRA FIRE STATION  </td><td>Katandra Fire Station  </td><td>106</td><td>138</td><td>2022-03-22T00:00:00Z</td><td> 54113246</td><td>   13181</td><td>10</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997680</td><td>    NA</td><td>NA</td><td>POINT (145.5592 -36.2256)</td></tr>
	<tr><td>VMFEAT_CFA_FIRE_STATION.62926127</td><td>655595</td><td>655595</td><td>emergency facility</td><td>fire station</td><td>KATUNGA FIRE STATION   </td><td>Katunga Fire Station   </td><td>106</td><td>139</td><td>2022-03-22T00:00:00Z</td><td>423884498</td><td>   13202</td><td>10</td><td>VIC</td><td>2010-04-01T10:26:44Z</td><td>2022-03-25T11:28:46Z</td><td>1997681</td><td>    NA</td><td>NA</td><td>POINT (145.4573 -35.9993)</td></tr>
</tbody>
</table>



### e.  Visualise data

Use the `mapview()` function to visualise the dataset:




```R
mapview(data)
```

Now you will see fire stations on a map as individual point locations:

![mapview](https://user-images.githubusercontent.com/106126121/177097879-ea34dfdd-ea65-40d3-9e1b-3c79ec4e6aa2.png)


```R

```


## g. Filter data by bounding box

The ADP supports spatial queries that permit filtering your data in a particular spatial area. For example, you can filter the data by bounding box (BBOX). By adding the BBOX, instead of downloading entire datasets, which can be very large and irrelevant to your project, you can download data according to your area of interest. Here we show an example to use the Melbourne CBD as the area of interest.

The BBOX parameter allows you to search for features that are contained (or partially contained) inside a box of user-defined coordinates. The format of the BBOX parameter is `bbox=a1,b1,a2,b2,[crs]` where `a1`,`b1`,`a2` and `b2` represent the coordinate values. The `shapely.geometry.box()` function makes a rectangular polygon from the provided BBOX parameters.

We recommend using [BBox finder](http://bboxfinder.com/#-37.821684,144.951425,-37.806563,144.976358) to create your BBOX using a base map. Click the rectangle icon and draw a rectangle using your mouse to cover the Melbourne CBD area or any other areas you are interested in.

![Screen-Shot-2022-07-12-at-2 41 38-pm-1089x800](https://user-images.githubusercontent.com/106126121/178858710-14892508-aecf-4cfa-9078-bb5fbab94e96.png)

Now you can see the selected rectangle is covered in pink. You may check if it is the right area you’d like to collect data from. Copy the BBOX coordinates from the highlighted area, and replace the coordinates after the code `min_x,min_y,max_x,max_y -`. 

![Screen-Shot-2022-07-12-at-2 44 19-pm-1089x800](https://user-images.githubusercontent.com/106126121/178858739-a1749d5a-b51b-4a84-81ec-09a448a4538b.png)

You also need to replace yourName and yourPassword in the code block below with your ADP username and password. If you don’t have ADP credentials, please generate your credentials via the [ADP Access Dashboard](https://adp-access.aurin.org.au/).


```R
###### ------ Libraries ------- ####
library(sf)
library(httr)
library(tidyverse)
library(ows4R)
library(mapview)
library(utils)

##### ----- Crendentials ------ #####
wfs_url <- "https://adp.aurin.org.au/geoserver/wfs"
user_name <- "yourName"
password <- "yourPassword"
#### ------ Define url ----- ####
url <- parse_url(wfs_url)
url$hostname <- paste(user_name,":",password,"@",url$hostname, sep="")

#### ------ Select the data set ----- #####
ADP_ID = 'datasource-OSM-UoM_AURIN_DB:osm_lines_2017'

### ------ Copy vector from http://bboxfinder.com/ ---- #####
bbox = '144.927135,-37.828836,145.000648,-37.799408'

### ------ Create request ---- #####
url$query <- list(service = "WFS",
                  version='2.0.0',
                  request = "GetFeature",
                  typeNames = ADP_ID,
                  bbox=paste0(bbox,',EPSG:4326'))
request <- build_url(url)

#### ---- Download data from server ----- ####
download.file(request, destfile = "data_bbox.gml", mode='wb')
### ---- Read the data ---- #### 
data <- read_sf("data_bbox.gml")
### --- Show the map --- ###
mapview(data)
```

Output:

![Screen Shot 2022-07-14 at 11 17 56 am](https://user-images.githubusercontent.com/106126121/178866924-69e3f627-abdf-442f-907f-6c12ece156f3.png)




