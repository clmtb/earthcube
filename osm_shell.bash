#Get OSM data from Geofabrik
wget https://download.geofabrik.de/europe/france/provence-alpes-cote-d-azur-latest.osm.pbf

#Extract a smaller area
osmium extract --bbox 5.83,43.01,6.19,43.14 provence-alpes-cote-d-azur-latest.osm.pbf --output toulon-hyeres.osm.pbf

#Convert the file format from osm.pbf to osm
osmium cat --input-format osm.pbf --output-format osm toulon-hyeres.osm.pbf --output toulon-hyeres.osm

#Filter to only keep the data related to airports, harbours and highways
osmium tags-filter toulon-hyeres.osm nwr/highway nwr/aeroway nwr/harbour --output toulon-hyeres-filtered.osm

#Import the data from the osm file into the GIS database
osm2pgrouting --file toulon-hyeres-filtered.osm -c /usr/share/osm2pgrouting/mapconfig.xml --tags --addnodes --dbname osmdata --username postgres --password admin123 --clean

#Export the data to the GeoJSON format using ogr
ogr2ogr -f GeoJSON shortest_path.json "PG:host:localhost dbname=shortest_path user=postgres password=admin123" -sql "select geom from shortest_path"