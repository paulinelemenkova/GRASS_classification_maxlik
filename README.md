# GRASS GIS Wetland Mapping of Kenya Using Remote Sensing Data

GRASS GIS shell scripts for maximum-likelihood land-cover classification of Landsat 8 OLI/TIRS imagery (2015, 2023) mapping and monitoring the wetlands of Kenya, East Africa, using i.group, i.cluster, i.maxlik and r.kappa accuracy assessment.

## Associated publication

Lemenkova, P. (2023). Mapping Wetlands of Kenya Using Geographic Resources Analysis Support System (GRASS GIS) with Remote Sensing Data. *Transylvanian Review of Systematical and Ecological Research*, 25(2), 1-18. ISSN 2344-3219.

Indexed in Web of Science.

## Links

- Published paper (DOI): https://doi.org/10.2478/trser-2023-0008
- Publisher (TRSER): https://magazines.ulbsibiu.ro/trser/trser25/trser_25.2_01-18
- Archived code (Zenodo): https://doi.org/10.5281/zenodo.8154351
- Preprint (HAL): https://hal.science/hal-04163212v1
- Preprint (SSRN): https://ssrn.com/abstract=4512741
- LifeScience.net: https://www.lifescience.net/publications/396159/mapping-wetlands-of-kenya-using-geographic-resourc/
- Author ORCID: https://orcid.org/0000-0002-5759-1089

## Scripts

- `01_GRASS_maxlik_Kenya_2015.sh`
- `01_GRASS_maxlik_Kenya_2023.sh`

## Data

The scripts import multiband Landsat 8 OLI/TIRS scenes (GeoTIFF). Input paths point to the author's local GRASS data directory and should be adapted to your own data.

## Requirements

GRASS GIS 8 (modules r.import, g.region, i.group, i.cluster, i.maxlik, r.kappa).

## Author

Polina Lemenkova

## License

MIT — see the LICENSE file (Copyright Polina Lemenkova).
