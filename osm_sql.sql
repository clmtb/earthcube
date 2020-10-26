--Create the database and its extensions
CREATE DATABASE osmroads;
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
CREATE EXTENSION hstore;

--Call the pgr_bdAstar function to get the shortest path between two points
SELECT *
FROM pgr_bdAstar('SELECT gid AS id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways', -- Selection request
21032, -- start point id from ways_vertices_pgr table
19883 -- end point id from ways_vertices_pgr table
);

--Merge all lines to get the whole path
SELECT ST_LineMerge(ST_Union(ways.the_geom)) AS geom
	FROM pgr_bdAstar('SELECT gid AS id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways', -- Selection request
	21032, -- start point
	19883 -- end point
	) 
LEFT JOIN ways ON edge != -1 AND ways.gid = edge;

--Save the result of the previous request to an other table
CREATE TABLE shortest_path AS (
SELECT ST_LineMerge(ST_Union(ways.the_geom))
	FROM pgr_bdAstar('SELECT gid AS id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways', -- Selection request
	21032, -- start point
	19883 -- end point
	) 
LEFT JOIN ways ON edge != -1 AND ways.gid = edge
);


--Get the result to the GeoJSON format
SELECT ST_AsGeoJSON(geom) FROM shortest_path;