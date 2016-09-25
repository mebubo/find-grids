shp2pgsql -s 32633 gis.osm_roads_free_1.shp streets_all > roads.sql
sudo -u postgres psql -d gis < roads.sql > load.log
sudo -u postgres psql -d gis -c "CREATE TABLE streets as select * from streets_all limit 1000;"
