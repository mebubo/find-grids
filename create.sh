sudo -u postgres createdb -O postgres gis
sudo -u postgres psql -d gis -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d gis -c "CREATE EXTENSION pgrouting;"
