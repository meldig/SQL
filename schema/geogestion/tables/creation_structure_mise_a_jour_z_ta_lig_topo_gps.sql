-- Creation structure pour mettre à jour l'altimétrie des éléments linéaires de la table TA_LIG_TOPO_GPSS.

-- 1. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_1: Recuperation de la geométrie des éléments linéaire au format WKT
-- 1.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_1" 
	(
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"GEO_REF" VARCHAR2(13 BYTE), 
	"TYPE_WKT_LIGNE_GEOMETRY" CLOB, 
	"GEOM" CLOB
	)
;

-- 1.2. Contrainte d'unicité de la table.
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_1
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_1_OBJECTID_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE");

-- 1.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_1"  IS  'Table temporaire utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Récupère la geométrie des éléments linéaire au format WKT.';

-- 1.4. Creation des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_1.OBJECTID_LIGNE IS 'Contrainte d''unicité de la table TA_GG_RECUPERATION_Z_ETAPE_1, Identifiant de la ligne';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_1.GEO_REF IS 'Numéro du dossier de l''élément';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_1.TYPE_WKT_LIGNE_GEOMETRY IS 'Type de géométrie WKT de la ligne.';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_1.GEOM IS 'Géométrie de l''élément au format WKT';


-- 2. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_2: Extraire pour chaque géométrie les sous éléments.
-- 2.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_2" 
	(
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER,
	"TYPE_WKT_LIGNE_GEOMETRY" CLOB, 
	"TYPE_WKT_ELEMENT_GEOMETRY" CLOB, 
	"GEOM" CLOB
	)
;

-- 2.2. Contrainte d'unicite de la table.
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_2
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_2_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE");


-- 2.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_2"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: récupère les sous éléments des géométries au format WKT.';

-- 2.4. Creation des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_2.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_2.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_2.TYPE_WKT_LIGNE_GEOMETRY IS 'Type de géométrie WKT des lignes completes';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_2.TYPE_WKT_ELEMENT_GEOMETRY IS 'Type de géométrie WKT des éléments des lignes';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_2.GEOM IS 'Géométrie de l''élément au format WKT';

-- 3. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_3: Conversion des géométries des sous éléments au format SDO_GEOMETRY
-- 3.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_3" 
   (
   	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"TYPE_WKT_ELEMENT_GEOMETRY" CLOB, 
	"GEOM" "MDSYS"."SDO_GEOMETRY" 
   ) 
;

-- 3.2. Contrainte d'unicite de la table.
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_3
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_3_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE");


-- 3.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_3" IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: récupère les sous éléments des géométries au format SDO_GEOMETRY.';

-- 3.4. Créa des commantaires de la table.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_3.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_3.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_3.TYPE_WKT_ELEMENT_GEOMETRY IS 'Type de géométrie WKT des éléments des lignes';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_3.GEOM IS 'Géométrie de l''élément - TYPE LINE';


-- 4. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_4: Récupération des sommets des sous éléments géométrique
-- 4.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_4" 
	(
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"OBJECTID_SOMMET" NUMBER, 
	"COORD_X" NUMBER, 
	"COORD_Y" NUMBER, 
	"COORD_Z" NUMBER, 
	"GEOM" "MDSYS"."SDO_GEOMETRY" 
	)
;

-- 4.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_4
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_4_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");


-- 4.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_4"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Récupération des sommets des sous éléments géométrique';

-- 4.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_Z IS 'Coordonnée Z du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_4.GEOM IS 'Géométrie du sommet de type point';

-- 5. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_5: Attribution du Z du point topo localisé sous le sommet de la ligne.
-- 5.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_5" 
	(
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"OBJECTID_SOMMET" NUMBER, 
	"COORD_X" NUMBER, 
	"COORD_Y" NUMBER, 
	"COORD_Z" NUMBER(6,3)
	)
;

-- 5.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_5
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_5_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");



-- 5.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_5"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Attribution de l''altitude du point topo situé à la même localisation au sommet';

-- 5.4. Création des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_5.COORD_Z IS 'Coordonnée Z du sommet';

-- 6. Création de la table TA_GG_RECUPERATION_2_ETAPE_6: Mise à 0 de l'atitude pour des sommets pour lesquels il n'y a pas de point topo.
-- 6.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_6" 
   (	
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"OBJECTID_SOMMET" NUMBER, 
	"COORD_X" NUMBER, 
	"COORD_Y" NUMBER, 
	"COORD_Z" NUMBER
   )
;

-- 6.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_6
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_6_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");



-- 6.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_6"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Mise à 0 de l''altitude des sommets pour lesquels il n''y a pas de point topo.';

-- 6.4. Création des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_Z IS 'Coordonnée Z du sommet';

-- 7. TA_GG_RECUPERATION_Z_ETAPE_7: Union de l'ensemble des sommets des éléments linéaire du dossier.
-- 7.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_7" 
   (	
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"OBJECTID_SOMMET" NUMBER, 
	"COORD_X" NUMBER, 
	"COORD_Y" NUMBER, 
	"COORD_Z" NUMBER
   )
;

-- 7.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_7
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_7_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");



-- 7.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_7"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Union de l''ensemble des sommets des éléments linaires du projet.';

-- 7.4. Création des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_7.COORD_Z IS 'Coordonnée Z du sommet';


-- 8. TA_GG_RECUPERATION_Z_ETAPE_8: Conversion des sommets au format wkt
-- 8.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_8" 
	(	
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"OBJECTID_SOMMET" NUMBER, 
	"GEOM" CLOB
	)
;

-- 8.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_8
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_8_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");



-- 8.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_8"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Conversion des sommets des éléments au format WKT après jointure avec la table GEO.PTTOPO.';

-- 8.4. Création des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_8.GEOM IS 'Géométrie du sommet au format SDO_GEOM - type point';


-- 9. TA_GG_RECUPERATION_Z_ETAPE_9: Reconstitution des sous éléments en concaténant les sommets d'un meme sous élément suivant les identifiants des sommets.
-- 9.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_9" 
	(	
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"GEOM" VARCHAR2(4000 BYTE)
	)
;

-- 9.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_9
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_9_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE");


-- 9.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_9"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Reconstitution des sous éléments en concaténant les sommets d''un meme sous élément suivant les identifiants des sommets.';

-- 9.4. Création des commentaires des colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_9.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_9.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_9.GEOM IS 'Géométrie du sous élément de la ligne';


-- 10. TA_GG_RECUPERATION_Z_ETAPE_10: Conversion des géométries des sous éléments au format SDO_GEOMETRY.
-- 10.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_10" 
	(	
	"OBJECTID_LIGNE" NUMBER(38,0), 
	"OBJECTID_ELEMENT_LIGNE" NUMBER, 
	"GEOM" "MDSYS"."SDO_GEOMETRY" 
   )
;

-- 10.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_10
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_10_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE");


-- 10.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_10"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Conversion des géométries des sous éléments au format SDO_GEOMETRY.';

--10.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_10.GEOM IS 'Géométrie du sous élément de la ligne';


-- 11. TA_GG_RECUPERATION_Z_ETAPE_11: Reconstitution de la géométrie complète avec la fonction SDO_AGGR_UNION 
-- 11.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_11" 
   (	
   	"OBJECTID_LIGNE" NUMBER(38,0), 
	"GEO_REF" VARCHAR2(13 BYTE), 
	"GEOM" "MDSYS"."SDO_GEOMETRY" 
   )
;

-- 11.2. Création de la contrainte d'unité
ALTER TABLE GEO.TA_GG_RECUPERATION_Z_ETAPE_11
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_11_OBJECTID_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE");



-- 11.3. Création du commentaire de la table.
COMMENT ON TABLE "GEO"."TA_GG_RECUPERATION_Z_ETAPE_11"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Reconstitution de la géométrie complète avec la fonction SDO_AGGR_UNION ';

-- 11.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_11.OBJECTID_LIGNE IS 'Identifiant de la ligne, contrainte d''unicité de la table';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_11.GEO_REF IS 'Numéro du dossier de l''élément';
COMMENT ON COLUMN GEO.TA_GG_RECUPERATION_Z_ETAPE_11.GEOM IS 'Géométrie de la ligne';