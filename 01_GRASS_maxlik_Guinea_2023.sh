#!/bin/sh
# 1. Import data
# listing the files

# g.mapset location=Guinea_Bissau_2017 mapset=PERMANENT

g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B1.TIF output=L8_2023_01 resample=bilinear extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B2.TIF output=L8_2023_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B3.TIF output=L8_2023_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B4.TIF output=L8_2023_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B5.TIF output=L8_2023_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B6.TIF output=L8_2023_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Guinea_2023/LC08_L2SP_202053_20230210_20230217_02_T1_SR_B7.TIF output=L8_2023_07 extent=region resolution=region
#
g.list rast
#
# grouping data by i.group
# Set computational region to match the scene
g.region raster=L8_2023_01 -p
#projection: 1 (UTM)
#zone:       28
#datum:      wgs84
#ellipsoid:  wgs84
#north:      1234815
#south:      1003485
#west:       607485
#east:       834315
#nsres:      30
#ewres:      30
#rows:       7711
#cols:       7561
#cells:      58302871
i.group group=L8_2023 subgroup=res_30m \
  input=L8_2023_01,L8_2023_02,L8_2023_03,L8_2023_04,L8_2023_05,L8_2023_06,L8_2023_07
#
# 4. Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2023 subgroup=res_30m \
  signaturefile=cluster_L8_2023 \
  classes=19 reportfile=rep_clust_L8_2023.txt --overwrite
  
  i.cluster group=L8_2023 subgroup=res_30m \
  signaturefile=cluster_L8_2023 \
  classes=10 reportfile=rep_clust_L8_2023.txt --overwrite
# 5. Classification by i.maxlik module
#
i.maxlik group=L8_2023 subgroup=res_30m \
  signaturefile=cluster_L8_2023 \
  output=L8_2023_cluster_classes reject=L8_2023_cluster_reject --overwrite
#
# 6. Mapping
d.mon wx0
g.region raster=L8_2023_cluster_classes -p
r.colors L8_2023_cluster_classes color=roygbiv -e
d.rast L8_2023_cluster_classes
d.legend raster=L8_2023_cluster_classes title="2023 February 10" title_fontsize=14 font="Helvetica" fontsize=12 bgcolor=white border_color=white
d.out.file output=Guinea_2023 format=jpg --overwrite
#
d.mon wx1
g.region raster=L8_2023_cluster_classes -p
r.colors L8_2023_cluster_reject color=bcyr -e
d.rast L8_2023_cluster_reject
d.legend raster=L8_2023_cluster_reject title="2023 February 10" title_fontsize=14 font="Helvetica" fontsize=12 bgcolor=white border_color=white
d.out.file output=Guinea_2023_reject format=jpg --overwrite
#d.rast.leg L8_2023_cluster_reject
#
# r.kappa - Calculates error matrix and kappa parameter for accuracy assessment of classification result.
g.region raster=L8_2023_cluster_classes -p
r.kappa -w classification=L8_2023_cluster_classes reference=L8_2015_cluster_classes

# export Kappa matrix as CSV file "kappa.csv"
r.kappa classification=L8_2023_cluster_classes reference=L8_2015_cluster_classes output=kappa.csv -m -h --overwrite


r.composite blue=L8_2023_07 green=L8_2023_06 red=L8_2023_04 \
            output=L8_2023_rgb --overwrite
r.composite blue=L8_2023_04 green=L8_2023_03 red=L8_2023_02 \
            output=L8_2023_rgb_nat --overwrite
r.composite blue=L8_2023_02 green=L8_2023_03 red=L8_2023_04 \
            output=L8_2023_rgb_nat_234 --overwrite
# FCC
# false color composite: FCC of the Landsat 8-9 OLI/TIRS images: Band B05 as the Red channel, Band B04 in the Green channel, and Band B03 in the blue channel.
r.composite blue=L8_2023_03 green=L8_2023_04 red=L8_2023_05 \
            output=L8_2023_fcc --overwrite
d.mon wx0
d.rast L8_2023_fcc
d.out.file output=Guinea_fcc_2018 format=jpg --overwrite

# NCC natural color composite: NCC a band combination of red (4), green (3), and blue (2).
r.composite blue=L8_2023_02 green=L8_2023_03 red=L8_2023_04 \
            output=L8_2023_ncc --overwrite
d.mon wx0
d.rast L8_2023_ncc
d.out.file output=Guinea_ncc_2018 format=jpg --overwrite

# FCC false color composite: FCC a band combination of SWIR2 (7), NIR (5), and Red (4).
r.composite blue=L8_2023_07 green=L8_2023_05 red=L8_2023_04 \
            output=L8_2023_fcc_new --overwrite
d.mon wx0
d.rast L8_2023_fcc_new
d.out.file output=Guinea_fcc_new format=jpg --overwrite

# FCC false color composite: combination of NIR (5), SWIR2 (2), and the coastal aerosol band (1).
r.composite blue=L8_2023_05 green=L8_2023_02 red=L8_2023_01 \
            output=L8_2023_fcc_ae --overwrite
d.mon wx0
d.rast L8_2023_fcc_ae
d.out.file output=Guinea_fcc_ae format=jpg --overwrite

# FCC false color composite: combination 3-2-1.
r.composite blue=L8_2023_03 green=L8_2023_02 red=L8_2023_01 \
            output=L8_2023_fcc_321 --overwrite
d.mon wx0
d.rast L8_2023_fcc_321
d.out.file output=Guinea_fcc_321 format=jpg --overwrite

# FCC false color composite: combination 7-4-2.
r.composite blue=L8_2023_07 green=L8_2023_04 red=L8_2023_02 \
            output=L8_2023_fcc_742 --overwrite
d.mon wx0
d.rast L8_2023_fcc_742
d.out.file output=Guinea_fcc_742 format=jpg --overwrite

# FCC false color composite: combination 7-5-1.
r.composite blue=L8_2023_07 green=L8_2023_05 red=L8_2023_01 \
            output=L8_2023_fcc_751 --overwrite
d.mon wx0
d.rast L8_2023_fcc_751
d.out.file output=Guinea_fcc_751 format=jpg --overwrite
