#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# LC08_L2SP_193036_20140101_20200912_02_T1_SR_B1
# importing the image subset with 7 Landsat bands and display the raster map (polinalemenkova)
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B1.TIF output=L8_2015_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B2.TIF output=L8_2015_02 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B3.TIF output=L8_2015_03 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B4.TIF output=L8_2015_04 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B5.TIF output=L8_2015_05 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B6.TIF output=L8_2015_06 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Kenya/LC08_L2SP_167059_20150114_20200910_02_T1_SR_B7.TIF output=L8_2015_07 resample=bilinear extent=region resolution=region

# another way by r.in.gdal:
# r.in.gdal input=/Users/polinalemenkova/grassdata/Algeria/LC08_L2SP_193036_20140101_20200912_02_T1_SR_B7.TIF output=L8_2014_07 --overwrite
#
g.list rast
# raster metadata:
r.info -r L8_2015_07
#
# 2. grouping data by i.group
# Set computational region to match the scene
g.region raster=L8_2015_01 -p
# store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2015 subgroup=res_30m \
  input=L8_2015_01,L8_2015_02,L8_2015_03,L8_2015_04,L8_2015_05,L8_2015_06,L8_2015_07
#
# 4. Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2015 subgroup=res_30m \
  signaturefile=cluster_L8_2015 \
  classes=10 reportfile=rep_clust_L8_2015.txt --overwrite
# 5. Classification by i.maxlik module
#
i.maxlik group=L8_2015 subgroup=res_30m \
  signaturefile=cluster_L8_2015 \
  output=L8_2015_cluster_classes reject=L8_2015_cluster_reject
#
# 6. Mapping
d.mon wx0
g.region raster=L8_2015_cluster_classes -p
r.colors L8_2015_cluster_classes color=bcyr -e
# d.rast.leg L8_2014_cluster_classes
d.rast L8_2015_cluster_classes
d.legend raster=L8_2015_cluster_classes title="2015" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=Kenya_2015 format=jpg --overwrite
d.mon wx1
g.region raster=L8_2015_cluster_classes -p
d.rast L8_2015_cluster_reject
d.legend raster=L8_2015_cluster_reject title="2015" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=Kenya_2015_reject format=jpg --overwrite
#d.rast.leg L8_2014_cluster_reject
#
# Landsat 8 False Color Composite. RGB False Color Composite with NIR band B05 in the red channel, red band B04 in the green channel and green band B03 in the blue channel. The script is useful for plant density and health monitoring, as vegetation (displayed in red) heavily reflects NIR light while absorbing red. Vegetation is colored red, cities and exposed ground are grey or tan, and water appears blue or black.
#r.composite blue=L8_2015_02 green=L8_2015_03 red=L8_2015_04 \
            output=L8_2015_rgb
r.composite blue=L8_2015_03 green=L8_2015_04 red=L8_2015_05 \
            output=L8_2015_rgb_FCC
d.mon wx0
g.region raster=L8_2015_rgb_FCC -p
d.rast L8_2015_rgb_FCC
d.out.file output=L8_2015_rgb_FCC format=jpg --overwrite

# Landsat 8 true color composite uses visible light bands red (B04), green (B03) and blue (B02) in the corresponding red, green and blue color channels, resulting in a natural colored product, that is a good representation of the Earth as humans would see it naturally
r.composite blue=L8_2015_02 green=L8_2015_03 red=L8_2015_04 \
            output=L8_2015_rgb_TCC
d.mon wx0
g.region raster=L8_2015_rgb_TCC -p
d.rast L8_2015_rgb_TCC
d.out.file output=L8_2015_rgb_TCC format=jpg --overwrite
