/*
    Création d'une table temporaire qui servira à enregistrer les bâtis issus du lidar uniquement et dont la géométrie peut être de type multi-polygone. 
*/
-- 1. Création de la table
CREATE TABLE temp_diff_carto_lidar(
    objectid NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    geom MDSYS.SDO_GEOMETRY,
    id_carto NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE geo.temp_diff_carto_lidar IS 'Table temporaire permettant d''insérer les différences de bâti entre le plan de gestion et le lidar dans la table ta_diff_carto_lidar.';

-- 3. Création de la clé primaire
ALTER TABLE temp_diff_carto_lidar 
ADD CONSTRAINT temp_diff_carto_lidar_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_temp_diff_carto_lidar
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_temp_diff_carto_lidar
BEFORE INSERT ON temp_diff_carto_lidar
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_temp_diff_carto_lidar.nextval;
END;

-- 6. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'temp_diff_carto_lidar',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 7. Création de l'index spatial sur le champ geom
CREATE INDEX temp_diff_carto_lidar_SIDX
ON temp_diff_carto_lidar(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');

--------------------------------------------

/*
Cette requête permet d'insérer uniquement des polygones simples dans la table ta_diff_carto_lidar
Problème : si cette requête fonctionne bien pour les données issues du lidar uniquement, le temps de traitement est anormalement long (plus de 02h00) pour les donnnées issues du plan de gestion uniquement.
*/

SET SERVEROUTPUT ON

DECLARE
    V_singlepolygon MDSYS.SDO_GEOMETRY;
    V_numelem INTEGER;
    V_compteur INTEGER;
    CURSOR C_1 IS
    SELECT
        a.geom
    FROM
        temp_diff_bati_lidar a;
    v_multipolygon MDSYS.SDO_GEOMETRY;
    
BEGIN

    OPEN C_1; -- ouverture du curseur
    LOOP -- Première boucle 
        FETCH C_1 INTO v_multipolygon; -- Le FETCH permet de traiter une ligne à la fois.
        EXIT WHEN C_1%NOTFOUND; -- Fin de la première boucle : quand il n'y a plus de ligne dans le curseur, on sort de la boucle.
        V_compteur := 0;
        V_numelem := SDO_UTIL.GETNUMELEM(V_multipolygon); -- Décompte du nombre total de sous-élément de chaque géométrie.
        LOOP -- Deuxième boucle : extraction de chaque sous-élément de la géométrie dans la table test_diff_bati_lidar.
            V_compteur := V_compteur + 1;
            EXIT WHEN V_compteur > V_numelem; -- Quand le compteur excède V_numelem, cela veut dire que tous les sous-éléments ont été traités.
            V_singlepolygon := SDO_UTIL.EXTRACT(V_multipolygon, V_compteur);
            INSERT INTO temp_diff_bati_lidar(categorie, geom)
                VALUES(22, V_singlepolygon);
        END LOOP;
    END LOOP;
    CLOSE C_1; -- Fermeture obligatoire du compteur.
END;

