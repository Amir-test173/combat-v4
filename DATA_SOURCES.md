# Data sources used by the build

World Dominion keeps its gameplay code separate from external geographic datasets.

## Natural Earth
The v1.4 province polygon builder uses Natural Earth Admin-1 at 1:10m, pinned to the `v5.1.2` repository tag for reproducible geometry. Natural Earth states that its raster and vector map data are public domain and may be used, modified and distributed, including commercially.

## mledoze/countries
The build currently uses the `mledoze/countries` database for ISO country metadata, population, capitals and land-border lists. That project declares ODbL-1.0. Keep this notice and perform a data-license review before a commercial store release, especially if the generated database is distributed publicly.

The game does not download these sources during normal offline play. GitHub Actions runs `tool/fetch_world_data.py`, then bundles the generated assets into the application.
