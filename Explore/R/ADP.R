####### --------- Accessing AURIN Data Provider via RStudio --------- ####### 
# The goal of this tutorial is to introduce how to use RStudio to connect to AURIN 
# Data Provider and download data. This is designed with no prerequisite of R experiences.
# 
# The ADP is an interface that allows you to use programming scripts to interact with 
# and access the AURIN Data Catalogue. You can send a request to the AURIN Data 
# Provider using R scripts and get a response to download specific datasets.
# 
# The ADP is based on ipts to interact with and access the AURIN Data Catalogue.
# You can send a request to the AURIN Data Provider using R scripts and get a 
# response to download specific datasets. The ADP is based on Open Geospatial
# Consortium Web Feature Service (WFS) Interface Standards. With ADP credentials, 
# AURIN’s data repository is at your fingertips.
# 
# Before commencing this step, please ensure you have generated your 
# unique ADP Credentials (username and password) using https://adp-access.aurin.org.au/login

########### ------ 1. Tutorial goals: ------- #########

## Tutorial goals:
# In this tutorial, our goal is to use RStudio to connect to the ADP and download a dataset. 
# You will learn how to:
# 2. Install related R packages
# 3. Interact with the ADP


########### ------ 2. Packages and Libraries ------- #########
# 
# R packages are collections of functions developed by the community. By utilising these existing R packages, we can simply call these libraries in our R code and realise the functions. You don't need to code functions that have been shared by others. 
# 
# The packages that we are going to use in this tutorials include these libraries:

## --- Install --- ### 
install.packages(c("sf", "httr", "tidyverse", "ows4R", "mapview"))
# After installation, we can use library() to load these packages. 
# Again, you can copy the code below, and paste it into the Console.
library(sf)
library(httr)
library(tidyverse)
library(ows4R)
library(mapview)
library(utils)


########### ------  4. Interact with the ADP ------- #########

###  --- a. Setup connection parameters --- ###
# To connect to the ADP you need to let RStudio know 
# the address of the ADP and your access credentials.
# Please replace yourName and yourPassword below with your own ADP username 
# and password and execute the code to define the connection parameters. 
# If you don’t have ADP credentials, please generate your own unique credentials 
# in the [ADP Access Dashboard](https://adp-access.aurin.org.au).
#### ------ Setup variables ------- #####
wfs_url <- "https://adp.aurin.org.au/geoserver/wfs"
user_name <- "yourName"
password <- "yourPassword"
#### ------ Define url ----- ####
url <- parse_url(wfs_url)
url$hostname <- paste(user_name,":",password,"@",url$hostname, sep="")

########### ------  4. Use WFS service to connect AURIN Data Provider ------- #########
adp_client <- WFSClient$new(url = wfs_url, user = user_name, pwd = password, serviceVersion = '2.0.0')

###  --- b. List available datasets --- ###
# We can view information about dataset name and title of the first 10 datasets:
#Get all available layers
head(adp_client$getFeatureTypes(pretty = TRUE),10)

### --- c. Download data --- ###
# You can search the https://data.aurin.org.au to find datasets you would like to download.

# For example, if you are interested in a dataset describing 
# the locations of fire stations in Victoria, enter “fire station”
# and click search. Browse the results and select 
# VIC DELWP – Vicmap Features of Interest – Country Fire Authority (CFA) Fire Stations 
# and view its description, including its metadata table.

# To download that dataset into R, find and copy its ADP ID in 
# the metadata table, in this case it is 
# `datasource-VIC_Govt_DELWP-VIC_Govt_DELWP:datavic_VMFEAT_CFA_FIRE_STATION`. 
# Then create the following query, pasting the ADP ID into the typeName variable within RStudio.

url$query <- list(service = "wfs",
                  #version = "2.0.0", # optional
                  request = "GetFeature",
                  typeName = "datasource-VIC_Govt_DELWP-VIC_Govt_DELWP:datavic_VMFEAT_CFA_FIRE_STATION",
                  srsName = "EPSG:4326")

# Use the following functions to build the query and download the data from the 
# ADP and save it. In this case we are downloading the data in GML format 
# and saving it with the file name data_fire.gml. 
# You can see a list of other supported ADP output formats here.

request <- build_url(url)
### ---- Download the data ---- ###
download.file(request, destfile = "./data_fire.gml", mode='wb')
### ---- Read the data ---- #### 
data <- read_sf("data_fire.gml")

### --- d. View data --- ###
# Use the `head()` function again to view some of the dataset’s rows:
# Now you will see information about the fire stations in tabular format:
View(head(data))

### --- e.  Visualise data --- ###
# Use the `mapview()` function to visualise the dataset:
# Now you will see fire stations on a map as individual point locations:
mapview(data)

  