ALTER TABLE streets ALTER COLUMN geom TYPE geometry(LineString, 32633) USING ST_GeometryN(geom, 1);

SELECT pgr_nodeNetwork('streets', 0.001, the_geom :='geom',id :='gid', table_ending:='noded');

ALTER TABLE streets_noded ALTER COLUMN source TYPE integer;
ALTER TABLE streets_noded ALTER COLUMN target TYPE integer;
ALTER TABLE streets_noded ALTER COLUMN id TYPE integer;
ALTER TABLE streets_noded RENAME COLUMN id TO gid;

SELECT pgr_createTopology('streets_noded', 0.001, 'geom', 'gid');

DROP TABLE IF EXISTS nodes CASCADE;
CREATE TABLE nodes AS SELECT s.id, s.the_geom, n.gid as link_id, n.geom as link_geom
FROM streets_noded_vertices_pgr as s, streets_noded as n
WHERE ST_INTERSECTS(s.the_geom, n.geom);

DROP TABLE IF EXISTS nodes_with_azimuth CASCADE;
CREATE TABLE nodes_with_azimuth AS SELECT
n.*, (ST_Azimuth(n.the_geom, ST_Line_Interpolate_Point(n.link_geom, abs(ST_Line_Locate_Point(n.link_geom, n.the_geom) - 0.0001))
)) as azimuth FROM nodes as n;
