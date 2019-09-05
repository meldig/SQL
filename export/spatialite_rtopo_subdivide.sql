/*
tables présentes
- parcelles, table des polygones edigeo
- bati, table de polygone dig
*/

-- découpage du bâti par les parcelles, création d'une table bati_cutted
SELECT
	  ST_Cutter (NULL, 'bati', 'GEOMETRY', NULL, 'parcelles', 'GEOMETRY', 'bati_cutted')

-- création d'une topologie
SELECT CreateTopology('bati_topo', 2154);

-- import de bati_cutted dans le schéma topo
-- limite la longueur des segments à 2 vertices
SELECT TopoGeo_FromGeoTable('bati_topo', NULL, 'bati_cutted', 'GEOMETRY', NULL, 2, 0.);

-- verification de la topologie
SELECT ST_ValidateTopoGeo('bati_topo');

-- export des segments ayant
SELECT TopoGeo_ToGeoTable('bati_topo', NULL, 'bati_topo_edge', NULL, 'bati_topo_segment_2vertex');

/*
à envisager pour un prochain usage
SELECT TopoGeo_SubdivideLines('bati_topo', 2, 0.)
*/
