#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# LC08_L2SP_193036_20140101_20200912_02_T1_SR_B1
# importing the image subset with 7 Landsat bands and display the raster map (polinalemenkova)
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B1.TIF output=L8_2022_01 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B2.TIF output=L8_2022_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B3.TIF output=L8_2022_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B4.TIF output=L8_2022_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B5.TIF output=L8_2022_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B6.TIF output=L8_2022_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Algeria/LC09_L2SP_193036_20220115_20220118_02_T1_SR_B7.TIF output=L8_2022_07 extent=region resolution=region
# another way by r.in.gdal:
# r.in.gdal input=/Users/polinalemenkova/grassdata/Algeria/LC08_L2SP_193036_20140101_20200912_02_T1_SR_B7.TIF output=L8_2014_07 --overwrite
# g.remove -f type=raster name=L8_2018_04
g.list rast
# raster metadata:
r.info -r L8_2021_07
#
# 2. grouping data by i.group
# Set computational region to match the scene
g.region raster=L8_2022_01 -p
# store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2022 subgroup=res_30m \
  input=L8_2022_01,L8_2022_02,L8_2022_03,L8_2022_04,L8_2022_05,L8_2022_06,L8_2022_07
#
# 3. Define semantic labels for all Landsat bands
r.support map=L8_2022_01 semantic_label=OLI_1
r.support map=L8_2022_02 semantic_label=OLI_2
r.support map=L8_2022_03 semantic_label=OLI_3
r.support map=L8_2022_04 semantic_label=OLI_4
r.support map=L8_2022_05 semantic_label=OLI_5
r.support map=L8_2022_06 semantic_label=OLI_6
r.support map=L8_2022_07 semantic_label=OLI_7
#
# 4. Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2022 subgroup=res_30m \
  signaturefile=cluster_L8_2022 \
  classes=10 reportfile=rep_clust_L8_2022.txt --overwrite
# 5. Classification by i.maxlik module
#
i.maxlik group=L8_2022 subgroup=res_30m \
  signaturefile=cluster_L8_2022 \
  output=L8_2022_cluster_classes reject=L8_2022_cluster_reject --overwrite
#
# 6. Mapping
d.mon wx0
g.region raster=L8_2022_cluster_classes -p
r.colors L8_2022_cluster_classes color=bcyr -e
# d.rast.leg L8_2022_cluster_classes
d.rast L8_2022_cluster_classes
d.legend raster=L8_2022_cluster_classes title="2022" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=Algeria_2022 format=jpg --overwrite
#
d.mon wx1
g.region raster=L8_2022_cluster_classes -p
d.rast L8_2022_cluster_reject
d.legend raster=L8_2022_cluster_reject title="2022" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=Algeria_2022_reject format=jpg --overwrite
#d.rast.leg L8_2014_cluster_reject
#
# segmentation
# i.segment group=L8_2014 output=L8_2014_seg_14 threshold=0.4 memory=1000
