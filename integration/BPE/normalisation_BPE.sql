/*
Requête nécessaire à la normalisation des données issues de la Base Permanente des Equipements
*/

-- 1. Suppression des équipements présents dans la table BPE_ENSEMBLE mais également des les tables BPE_ENSEIGNEMENT et BPE_SPORT_LOISIR. Cela est nécessaire pour supprimer les doublons
-- 1.1. suppression des BPE enseignement de la table des BPE ensemble
DELETE
FROM
	BPE_ENSEMBLE
WHERE
	"TYPEQU"
	IN
	(SELECT
		"TYPEQU"
	FROM
		BPE_ENSEIGNEMENT);
COMMIT;


-- 1.2. suppression des BPE SPORT LOISIRS de la table des BPE ensemble.
DELETE
FROM
	BPE_ENSEMBLE
WHERE
	"TYPEQU"
	IN
	(SELECT
		"TYPEQU"
	FROM
		BPE_SPORT_LOISIR);
COMMIT;


-- 2. Création de la table temporaire pour synthétiser l'ensemble des informations des 3 couches BPE

-- 2.1. Creation de la table
CREATE TABLE BPE_TOUT AS
	SELECT
		"OGR_FID",
		"REG",
		"DEP",
		"DEPCOM",
		"DCIRIS",
		"AN",
		"TYPEQU",
		NULL AS "CANT",
		NULL AS "INT",
		NULL AS "RPIC",
		NULL AS "CL_PELEM",
		NULL AS "CL_PGE",
		NULL AS "EP",
		NULL AS "SECT",
		"LAMBERT_X",
		"LAMBERT_Y",
		"QUALITE_XY",
		NULL AS "COUVERT", 
		NULL AS "ECLAIRE",
		NULL AS "NB_AIREJEU", 
		NULL AS "NB_SALLES"
	FROM 
		BPE_ENSEMBLE
		UNION ALL
			SELECT
				"OGR_FID",
				"REG",
				"DEP",
				"DEPCOM",
				"DCIRIS",
				"AN",
				"TYPEQU",
				NULL AS "CANT",
				NULL AS "INT",
				NULL AS "RPIC",
				NULL AS "CL_PELEM",
				NULL AS "CL_PGE",
				NULL AS "EP",
				NULL AS "SECT",
				"LAMBERT_X",
				"LAMBERT_Y",
				"QUALITE_XY",
				"COUVERT", 
				"ECLAIRE",
				"NB_AIREJEU", 
				"NB_SALLES"
			FROM 
				BPE_SPORT_LOISIR
		UNION ALL
			SELECT
				"OGR_FID",
				"REG",
				"DEP",
				"DEPCOM",
				"DCIRIS",
				"AN",
				"TYPEQU",
				"CANT",
				"INT",
				"RPIC",
				"CL_PELEM",
				"CL_PGE",
				"EP",
				"SECT",
				"LAMBERT_X",
				"LAMBERT_Y",
				"QUALITE_XY",
				NULL AS "COUVERT", 
				NULL AS "ECLAIRE",
				NULL AS "NB_AIREJEU", 
				NULL AS "NB_SALLES"
			FROM 
				BPE_ENSEIGNEMENT;
COMMIT;


-- 2.2. Ajout d'une colonne IDENTITY dans la table pour créer des nouveaux identifiants
ALTER TABLE BPE_TOUT
ADD IDENTITE INTEGER GENERATED BY DEFAULT AS IDENTITY
START WITH 1
INCREMENT BY 1
NOCACHE;
COMMIT;


-- 2.3. Mise à jour de la colonne IDENTITY pour avoir des clé unique qui suivent l'incrémentation de la séquence de la table TA_BPE
UPDATE bpe_tout
-- Attention à la séquence utilisée
SET identite = ISEQ$$_1025560.nextval;
-- Attention à la séquence utilisée


-- 2.4 Correction du format des codes IRIS pour permettre une jointure avec TA_CODE afin d'insérer des données dans la table TA_BPE_RELATION_CODE
-- Les codes IRIS de la base BPE ne sont pas au bon format. Il y a d'une part un underscore entre le code INSEE et le code IRIS
-- et d'autre part pour les communes non divisés en IRIS le code IRIS est le code INSEE de la commune alors que normalement il s'agit du code INSEE suivi de quatre zéros.
-- l'instruction CASE permet suivant les cas soit de rajouter quatre zéros si le code IRIS ne comporte que 4 chiffre
-- ou de supprimer le underscore s'il y en a un.
UPDATE bpe_tout
SET "DCIRIS" = (
    CASE
        WHEN LENGTH("DCIRIS") = '5' THEN "DCIRIS" || '0000'
        WHEN dciris LIKE '%_%' THEN REPLACE("DCIRIS",'_','')
    END)
    ;


-- 2.5. Ajout de la colonne geométrique
ALTER TABLE BPE_TOUT
ADD geom SDO_GEOMETRY;
COMMIT;


-- 2.6. Ajout des métadonnées
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'BPE_TOUT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
)
;
COMMIT;


-- 2.7. Création de l'index spatial sur le champ geom
CREATE INDEX bpe_tout_SIDX
ON bpe_tout(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 2.8. Mise en forme des coordonnées X et Y.
UPDATE bpe_tout
SET lambert_x = REPLACE(lambert_x, '.', ',');

UPDATE bpe_tout
SET lambert_y = REPLACE(lambert_y, '.', ',');


-- 2.9. Calcul des geométries
UPDATE bpe_tout a
SET geom = (
    WITH cte AS (
    SELECT
        identite,
        SDO_GEOMETRY
            (
            2001,
            2154,
            SDO_POINT_TYPE(LAMBERT_X, LAMBERT_Y, NULL),
            NULL,
            NULL
            ) new_geom
    FROM
        BPE_TOUT
    WHERE
        lambert_x IS NOT NULL
    AND
        lambert_y IS NOT NULL)
        SELECT new_geom FROM cte WHERE a.identite = cte.identite);


-- 2.10. Ajout de la colonne fid_metadonnee
ALTER TABLE BPE_TOUT
ADD FID_METADONNEE INTEGER;
COMMIT;


-- 2.11. Mise à jour de la colonne metadonnee
UPDATE BPE_TOUT a
SET fid_metadonnee =
        (
            WITH cte AS
            (
                SELECT
                    m.objectid,
                    s.nom_source,
                    a.date_acquisition,
                    a.millesime,
                    p.url,
                    o.acronyme,
                    listagg(e.valeur, '; ') within group (ORDER BY e.valeur)"echelle"
                FROM
                    ta_metadonnee m
                INNER JOIN ta_source s ON s.objectid = m.fid_source
                INNER JOIN ta_date_acquisition a ON a.objectid = m.fid_acquisition
                INNER JOIN ta_provenance p ON p.objectid = m.fid_provenance
                INNER JOIN ta_metadonnee_relation_organisme mo ON mo.fid_metadonnee = m.objectid
                INNER JOIN ta_organisme o ON o.objectid = mo.fid_organisme
                INNER JOIN ta_metadonnee_relation_echelle me ON me.fid_metadonnee = m.objectid
                INNER JOIN ta_echelle e ON e.objectid = me.fid_echelle
                WHERE
                    s.nom_source = 'Base Permanente des Equipements'
                AND
                    a.date_acquisition = '06/04/2020'
                AND
                    a.millesime = '01/01/2018'
                AND
                    p.url = 'https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656'
                AND
                    o.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
                AND
                    e.valeur IN ('10000','30000','50000','1000000')
                GROUP BY
                    m.objectid,
                    s.nom_source,
                    a.date_acquisition,
                    a.millesime,
                    p.url,
                    o.acronyme
            )
        SELECT objectid FROM cte
        )
;


-- 3. Insertion des données geometrique dans la table TA_BPE_GEOMETRIE
-- le WHERE permet de selectionner uniquement les géométries uniques et non les doublons
-- le AND permet de ne pas insérer des géométrie déja existante dans la table.
INSERT INTO ta_bpe_geom(geom)
SELECT 
    geom
FROM
    bpe_tout a
-- le WHERE permet de selectionner uniquement les géométries uniques et non les doublons
WHERE
    identite NOT IN
        (SELECT id_b
            FROM
                (SELECT
                        a.identite AS id_a,
                        b.identite AS id_b
                    FROM
                        bpe_tout a,
                        bpe_tout b
                    WHERE
                        a.identite < b.identite
                    AND
                        ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.geom))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.geom)))
                    AND
                        a.geom IS NOT NULL
                    AND
                        b.geom IS NOT NULL
                )
        )
AND
    geom IS NOT NULL
-- le AND permet de ne pas insérer des géométrie déja existante dans la table.
AND
    identite not IN
        (SELECT
            a.identite
        FROM
            bpe_tout a,
            ta_bpe_geom b
        WHERE
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.geom))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.geom)))
        AND
            a.geom IS NOT NULL
        AND
            b.geom IS NOT NULL
            );


-- 4. Insertion des données dans la table ta_bpe
MERGE INTO ta_bpe a
USING
    (
    SELECT
        identite AS objectid,
        fid_metadonnee AS fid_metadonnee
    FROM
        bpe_tout
    )b
ON (a.objectid = b.objectid
AND a.fid_metadonnee = b.fid_metadonnee)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.fid_metadonnee)
VALUES (b.objectid, b.fid_metadonnee)
;


-- 5. Insertion des données dans la table ta_bpe_relation_geom
MERGE INTO ta_bpe_relation_geom a
USING
    (
    SELECT
        a.identite AS fid_bpe,
        b.objectid AS fid_bpe_geom
    FROM
        bpe_tout a,
        ta_bpe_geom b
    WHERE
        ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.ora_geometry))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.geom)))
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_bpe_geom = b.fid_bpe_geom)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_bpe_geom)
VALUES (b.fid_bpe, b.fid_bpe_geom)
;


-- 6. Insertion des données dans la table ta_bpe_caracteristique nombre
-- 6.1 Insertion des caracteristiques liés aux nb_airejeu (Nombre d'aires de pratique d'un meme type au sein de l'equipement)
MERGE INTO ta_bpe_caracteristique_quantitative a
USING
    (
    SELECT 
        a.identite AS fid_bpe,
        c.objectid AS fid_libelle,
        a."NB_AIREJEU" AS nombre
    FROM 
        bpe_tout a
        INNER JOIN ta_bpe b ON b.objectid = a.identite,
        ta_libelle c
        INNER JOIN ta_libelle_long d ON c.fid_libelle_long = d.objectid
    WHERE
        a."NB_AIREJEU" IS NOT NULL
    AND
        d.valeur = ('Nombre d''aires de pratique d''un même type au sein de l''équipement')
    )b
ON ( a.fid_bpe = b.fid_bpe
AND a.fid_libelle = b.fid_libelle
AND a.nombre = b.nombre)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_libelle, a.nombre)
VALUES (b.fid_bpe, b.fid_libelle, b.nombre)
;


-- 6.2 Insertion des caracteristiques liés aux nb_salles(nombre de salles par theatre ou cinema)
MERGE INTO ta_bpe_caracteristique_quantitative a
USING
    (
    SELECT 
        a."IDENTITE" AS fid_bpe,
        c.objectid AS fid_libelle,
        a."NB_SALLES" AS nombre
    FROM 
        bpe_tout a
        INNER JOIN ta_bpe b ON b.objectid = a.identite,
        ta_libelle c
        INNER JOIN ta_libelle_long d ON c.fid_libelle_long = d.objectid
    WHERE
        a."NB_SALLES" IS NOT NULL
    AND
        d.valeur = ('Nombre de salles par théâtre ou cinéma')
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_libelle = b.fid_libelle
AND a.nombre = b.nombre)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_libelle, a.nombre)
VALUES (b.fid_bpe, b.fid_libelle, b.nombre)
;


-- 7. Insertion des données dans la table ta_bpe_caracteristique
-- Pour insérer ces données il est nécessaire de générer précédemment deux vues synthétisant les nomenclatures BPE.
-- 7.1 Insertion des caracteristique TYPEQU.
MERGE INTO ta_bpe_caracteristique a
USING
    (
        SELECT
            a.identite AS fid_bpe,
            b.fid_libelle_niv_3 AS fid_libelle
        FROM
            bpe_tout a
        INNER JOIN V_NOMENCLATURE_EQUIPEMENT_BPE b ON b.libelle_court_niv_3 = a.TYPEQU
        INNER JOIN ta_bpe c ON c.objectid = a.identite
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe,a.fid_libelle)
VALUES (b.fid_bpe,b.fid_libelle);


-- 7.2 creation d'une vue pivot pour inserer les caractéristiques des variables
CREATE OR REPLACE VIEW bpe_variable_normalisation AS  
    SELECT
        identite,
        libelle_court_fils,
        libelle_court_parent
    FROM
    bpe_tout
    UNPIVOT
        (libelle_court_fils for (libelle_court_parent) IN
        (CANT AS 'CANT',
        INT AS 'INT',
        RPIC AS 'RPIC',
        CL_PELEM AS 'CL_PELEM',
        CL_PGE AS 'CL_PGE',
        EP AS 'EP',
        SECT AS 'SECT',
        QUALITE_XY AS 'QUALITE_XY',
        COUVERT AS 'COUVERT',
        ECLAIRE AS 'ECLAIRE'
        ))
        ;


-- 8. Etape de normalisation des variables BPE.
MERGE INTO ta_bpe_caracteristique a
USING
    (
        SELECT
            a.identite AS fid_bpe,
            b.fid_libelle_court_fils AS fid_libelle_court_fils,
            a.libelle_court_fils AS libelle_court_fils,
            b.fid_libelle_court_parent AS fid_libelle_court_parent,
            a.libelle_court_parent AS libelle_court_parent
        FROM
            BPE_VARIABLE_NORMALISATION a
        INNER JOIN V_NOMENCLATURE_VARIABLES_BPE b ON a.libelle_court_fils = b.libelle_court_fils
        AND a.libelle_court_parent = b.libelle_court_parent
        INNER JOIN ta_bpe c ON c.objectid = a.identite
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_libelle = b.fid_libelle_court_fils)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_libelle)
VALUES (b.fid_bpe, b.fid_libelle_court_fils);


-- 9. Insertion des relations BPE/code de localisation
-- 9.1. Equipement/code insee dans la table TA_BPE_RELATION_CODE
MERGE INTO ta_bpe_relation_code a
USING
    (
        SELECT
            a.identite AS fid_bpe,
            b.objectid AS fid_code
        FROM
            bpe_tout a,
            ta_code b
        INNER JOIN ta_libelle c ON c.objectid = b.fid_libelle
        INNER JOIN ta_libelle_long d ON d.objectid = c.fid_libelle_long
        WHERE
            a.depcom = b.valeur
        AND
            d.valeur = 'code insee'
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_code = b.fid_code)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_code)
VALUES (b.fid_bpe, b.fid_code);


-- 9.2. equipement/code iris dans la table TA_BPE_RELATION_CODE
MERGE INTO ta_bpe_relation_code a
USING
    (
        SELECT
            a.identite AS fid_bpe,
            b.objectid AS fid_code
        FROM
            bpe_tout a,
            ta_code b
        INNER JOIN ta_libelle c ON c.objectid = b.fid_libelle
        INNER JOIN ta_libelle_long d ON d.objectid = c.fid_libelle_long
        WHERE
            substr(a.dciris,6,4) = b.valeur
        AND
            d.valeur = 'code IRIS'
    )b
ON (a.fid_bpe = b.fid_bpe
AND a.fid_code = b.fid_code)
WHEN NOT MATCHED THEN
INSERT (a.fid_bpe, a.fid_code)
VALUES (b.fid_bpe, b.fid_code);



-- 10. Suppression de la table sythétisant les informations des BPE et des metadonnées de celle-ci. 
-- 10.1 Suppression de la table synthétisant les données BPE
DROP TABLE bpe_tout CASCADE CONSTRAINTS PURGE;

-- 10.2 Suppresion des metadonnées spatiales
DELETE
FROM
    user_sdo_geom_metadata
WHERE
    table_name = 'BPE_TOUT';

-- 10.3 Suppresion de la vue bpe_variable_normalisation
DROP VIEW bpe_variable_normalisation CASCADE CONSTRAINTS PURGE;

-- 10.4 Suppression de la vue bpe_variable_liste
DROP VIEW BPE_VARIABLE_LISTE cascade constraints;