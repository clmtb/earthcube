#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 24 17:14:19 2020

@author: clement


Name: rasterProcess.py

Role: create a raster processing chain
- get some informations about MS & PAN rasters
- pansharpen them;
- convert them to 8 bits;
- tile them to get browsed on web.
"""

import gdal #to manipulate our rasters
import subprocess as sp #to launch line commands from the shell

#Get the rasters files names
MSfile = 'MS_img.tif'
PANfile = 'PAN_img.tif'

#Opening the rasters with GDAL library
MSraster = gdal.Open(MSfile, gdal.GA_ReadOnly)
PANraster = gdal.Open(PANfile, gdal.GA_ReadOnly)

#To make sure the rasters are correctly opened
if MSraster is None and PANraster is None:
	print('Impossible to open ' + MSfile + ' and/ or ' + PANfile)
else:
	print('Rasters ' + MSfile + ' and ' + PANfile + ' imported')
    
#Get some informations about the rasters
print(MSraster.GetMetadata())
print(PANraster.GetMetadata())

#Define processing
pansharpen = 'gdal_pansharpen.py' + ' ' + PANfile + ' ' + MSfile + ' pansharpened_img.tif'
translate = 'gdal_translate -ot Byte -of GTiff -scale 0 4095 0 255 pansharpened_img.tif pansharpened_img_8bits.tif'
tiles = 'gdal2tiles.py -t Massy-Palaiseau -w leaflet pansharpened_img_8bits.tif webRaster'

#Launch the applications from the shell
sp.run(pansharpen, shell=True)
sp.run(translate, shell=True)
sp.run(tiles, shell=True)

#Close the datasets
MSfile = None
PANfile = None