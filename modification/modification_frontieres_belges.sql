
--Objectif : Modification des fontières belges par rapport aux frontières françaises.

--Contexte : Les frontières des municipalités belges et des communes françaises de la MEL, ne sont pas toujours jointives. 
--Il a donc été décidé par le groupe de travail "Socle de Données de Référence" de conserver les frontières françaises et de modifier celles de la MEL, car ces dernières ne seront pas utilisée à des fins juridiques.

--Sources :
--	- Communes françaises -> IGN ;
--	- Municipalités belges -> IGN belge ;  


-- Suppression de la table temporaire ta_modif_municipalites_belges et suppression de la métadonnée spatiale correspondante.
DROP table ta_modif_municipalites_belges CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TA_MODIF_MUNICIPALITES_BELGES';
COMMIT;

-- Création de la table temporaire

-- 1. Création de la structure de la table
CREATE TABLE ta_modif_municipalites_belges(
    objectid NUMBER GENERATED ALWAYS AS IDENTITY,
    nom VARCHAR2(100),
    geom MDSYS.SDO_GEOMETRY
);

-- 2. Création du commentaire de la table
COMMENT ON TABLE ta_modif_municipalites_belges IS 'Table temporaire servant à modifier les contours des municipalités belges afin d''avoir des contours communs avec la France.';
COMMIT;

-- 3. Création des métadonnées spatiales de la table temporaire
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_modif_municipalites_belges',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 4. Création de l'index spatial de la table temporaire
CREATE INDEX ta_modif_municipalites_belges_SIDX
ON ta_modif_municipalites_belges(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');
COMMIT;

-- 4. Modification des frontières belges par rapport aux frontières françaises
--Le code porte pour l'instant sur la table ta_test_limites_communes, puisque la géométrie des objets y a été corrigée.
--Méthode : 
--	4.1. Intersection des buffers de chaque municipalités avec celui de toute la MEL afin d'obtenir les parties à rajouter aux municipalité belges ;
--	4.2. Découpage des résultats de l'étape 4.1 avec l'union des 6 municipalités belges ;
--	4.3. Union des résultats de l'étape 4.2 avec leur municipalité respective ;
--	4.4. Différence entre les résultats des unions et la MEL toute entière ;
--	4.5. Remplissage de la table temporaire avec touts les éléments de type polygone résultants de l'étape 4.4 ;
--	4.6. Conservation du plus grand élément de chaque ensemble d'éléments catégorisé par les noms des municipalités ;
--	4.7. Suppression des éléments de construction de la table temporaire ;
--	4.8. Suppression de la partie extérieure du buffer de Comines-Warneton ;
--	4.9. Suppression de la partie extérieure du buffer de Tournai ;


SET SERVEROUTPUT ON
DECLARE   -- L.2
    CURSOR C_1 IS 
    WITH
-- 4.1. Intersection des buffers de chaque municipalités avec celui de toute la MEL afin d'obtenir les parties à rajouter aux municipalité belges ;
-- Fusion des 90 communes actuelles de la MEL - L. 5   
    v_regroupement AS (
    SELECT
        SDO_AGGR_UNION(
            SDOAGGRTYPE(a.geom, 0.001)
        ) AS geom
    FROM
        ta_test_limites_communes a
    WHERE
        a.geom IS NOT NULL
        AND a.fid_source = 3
    ),
  
-- Buffer de chaque municipalité à ajouter - L. 18
    v_buffer_6com AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_BUFFER(a.geom, 50, 0.001) AS geom
    FROM
        ta_test_limites_communes a
    WHERE
        a.geom IS NOT NULL
        AND a.fid_source = 25
    ),

-- Suppression des arcs pouvant occasionner des décalages entre la France et la Belgique - L. 30
    v_correction_arcs_v1 AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_ARC_DENSIFY(a.geom, 0.001, 'arc_tolerance = 0.005') AS geom
    FROM
        v_buffer_6com a
    ),   

-- Buffer de 90 communes actuelles de la MEL - L. 39    
    v_buffer_90com AS(
        SELECT
            SDO_GEOM.SDO_BUFFER(a.geom, 50, 0.001) AS geom
        FROM
            v_regroupement a
    ),
    
-- Suppression des arcs pouvant occasionner des décalages entre la France et la Belgique - L. 47
    v_correction_arcs_v2 AS (
    SELECT
        SDO_GEOM.SDO_ARC_DENSIFY(a.geom, 0.001, 'arc_tolerance = 0.005') AS geom
    FROM
        v_buffer_90com a
    ), 
    
-- Intersection entre les deux buffers afin d'avoir uniquement les parties à ajouter aux nouvelles communes de la MEL - L. 55    
    v_intersection AS(
        SELECT
            a.nom,
            SDO_GEOM.SDO_INTERSECTION(a.geom, b.geom, 0.001) AS geom
        FROM
            v_correction_arcs_v1 a,
            v_correction_arcs_v2 b
    ),
    
-- Fusion des 6 communes à ajouter - L. 65
    v_regroupement_2 AS (
    SELECT
        SDO_AGGR_UNION(
            SDOAGGRTYPE(a.geom, 0.001)
        ) AS geom
    FROM
        ta_test_limites_communes a
    WHERE
        a.geom IS NOT NULL
        AND a.fid_source = 25
    ),

-- 4.2. Découpage des résultats de l'étape 4.1 avec l'union des 6 municipalités belges ;
-- Difference entre l'intersection et la fusion des municipalités belges originelles - L. 78
    v_difference_v1 AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        v_intersection a,
        v_regroupement_2 b
    ),
    
-- Suppression des arcs pouvant occasionner des décalages entre la France et la Belgique - L. 88
    v_correction_arcs_v3 AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_ARC_DENSIFY(a.geom, 0.001, 'arc_tolerance = 0.005') AS geom
    FROM
        v_difference_v1 a
    ),   

-- 4.3. Union des résultats de l'étape 4.2 avec leur municipalité respective ;
-- Union entre les communes à ajouter et le résultat de la différence_v1 - L. 97
    v_union AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_UNION(a.geom, b.geom, 0.001) AS geom
    FROM
        ta_test_limites_communes a,
        v_correction_arcs_v3 b
    WHERE
        a.nom = b.nom
        AND a.fid_source = 25
    ),
     
-- Suppression des arcs pouvant occasionner des décalages entre la France et la Belgique. L. 109
    v_correction_arcs_v4 AS (
    SELECT
        a.nom,
        SDO_GEOM.SDO_ARC_DENSIFY(a.geom, 0.001, 'arc_tolerance = 0.005') AS geom
    FROM
        v_union a
    )
    
-- 4.4. Différence entre les résultats des unions et la MEL toute entière ;
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        v_correction_arcs_v4 a,
        v_regroupement b;
        
    V_singlepolygon MDSYS.SDO_GEOMETRY;
    V_numelem INTEGER;
    V_compteur INTEGER;
    v_multipolygon C_1%ROWTYPE;
    v_nom VARCHAR2(100);
    
    BEGIN
--4.5. Remplissage de la table temporaire avec touts les éléments de type polygone résultants de l'étape 4.4 ;
    OPEN C_1; -- ouverture du curseur
    LOOP -- Première boucle 
        FETCH C_1 INTO v_multipolygon; -- Le FETCH permet de traiter une ligne à la fois.
        EXIT WHEN C_1%NOTFOUND; -- Fin de la première boucle : quand il n'y a plus de ligne dans le curseur, on sort de la boucle.
        V_compteur := 0;
        V_numelem := SDO_UTIL.GETNUMELEM(V_multipolygon.geom); -- Décompte du nombre total de sous-élément de chaque géométrie.
        LOOP -- Deuxième boucle : extraction de chaque sous-élément de la géométrie dans la table ta_test_limites_communes.
            V_compteur := V_compteur + 1;
            EXIT WHEN V_compteur > V_numelem; -- Quand le compteur excède V_numelem, cela veut dire que tous les sous-éléments ont été traités.
            IF V_numelem > 1 THEN
                V_singlepolygon := SDO_UTIL.EXTRACT(V_multipolygon.geom, V_compteur);
                v_nom := v_multipolygon.nom;
                INSERT INTO ta_modif_municipalites_belges(nom, geom)
                    VALUES(v_nom || '_sub', V_singlepolygon);
            ELSE
                V_singlepolygon := SDO_UTIL.EXTRACT(V_multipolygon.geom, V_compteur);
                v_nom := v_multipolygon.nom;
                INSERT INTO ta_modif_municipalites_belges(nom, geom)
                    VALUES(v_nom, V_singlepolygon);
            END IF;
        END LOOP;
    END LOOP;
    CLOSE C_1; -- Fermeture obligatoire du compteur.
COMMIT;
END;

/
-- 4.6. Conservation du plus grand élément de chaque ensemble d'éléments catégorisé par les noms des municipalités ;
-- Suppression de toutes les petites parties incohérentes issues de la découpe du buffer des municipalités par les communes françaises.
SET SERVEROUTPUT ON
DECLARE   -- L.2
    CURSOR C_1 IS 
    WITH

    v_selection_1 AS ( -- calcul des aires maximales
    SELECT
        a.nom,
        MAX(SDO_GEOM.SDO_AREA(a.geom, 0.005)) AS aire
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a
    WHERE
        SUBSTR(a.nom, -4) = '_sub'
    GROUP BY a.nom
    ),
    
    v_selection_2 AS ( -- sélection des polygones ayant la plus grande aire de leur multipolygone d'origine
    SELECT
        a.nom,
        a.geom
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a,
        v_selection_1 b
    WHERE
        SDO_GEOM.SDO_AREA(a.geom, 0.005) = b.aire
    ),
    
    v_selection_3 AS( -- Création d'un jeux de comparaison
    
    SELECT
        a.nom,
        a.geom
    FROM
        v_selection_2 a
    UNION ALL
    SELECT
        a.nom,
        a.geom
    FROM
        ta_modif_municipalites_belges a
    WHERE
        SUBSTR(a.nom, -4, 4)  <> '_sub'
    ),
    
    v_difference_2 AS( -- Découpage des polygones avec leurs voisins pour éviter qu'ils ne se chevauchent, comme c'est le cas pour Comines-Warneton et Wervik
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS geom
    FROM
        v_selection_2 a,
        v_selection_3 b
    WHERE
        SDO_ANYINTERACT(a.geom, b.geom) = 'TRUE'
        AND a.nom <> b.nom
    ),

    v_difference_3 AS( -- Découpage des polygones avec leurs voisins pour éviter qu'ils ne se chevauchent, comme c'est le cas pour Menen et Mouscron
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS geom
    FROM
        v_selection_3 a,
        v_difference_2 b
    WHERE
        SDO_ANYINTERACT(a.geom, b.geom) = 'TRUE'
        AND a.nom <> b.nom
    ),

    v_aire AS(
    SELECT
        a.nom, 
        MAX(SDO_GEOM.SDO_AREA(a.geom, 0.005)) AS aire
    FROM
        v_difference_2 a
    GROUP BY a.nom
    )

    SELECT
        '1_' || REPLACE(a.nom, '_sub', ''),
        a.geom
    FROM
        v_difference_2 a,
        v_aire b
    WHERE
        SDO_GEOM.SDO_AREA(a.geom, 0.005) = b.aire
    UNION ALL
    SELECT
        '1_' || a.nom AS nom,
        a.geom
    FROM
        ta_modif_municipalites_belges a
    WHERE
        SUBSTR(a.nom, -4, 4)  <> '_sub';

        v_nom G_REFERENTIEL.TA_MODIF_MUNICIPALITES_BELGES.nom%TYPE;
        v_geom G_REFERENTIEL.TA_MODIF_MUNICIPALITES_BELGES.geom%TYPE;
BEGIN
    OPEN C_1; -- ouverture du curseur
    LOOP -- ouverture de la boucle 
        FETCH C_1 INTO v_nom, v_geom;
        EXIT WHEN C_1%NOTFOUND;
            INSERT INTO TA_MODIF_MUNICIPALITES_BELGES(nom, geom)
                VALUES(v_nom, v_geom);
    END LOOP;
    CLOSE C_1;
    COMMIT;
END;

/

-- 4.7. Suppression des éléments de construction de la table temporaire ;
DELETE FROM ta_modif_municipalites_belges a WHERE SUBSTR(a.nom, 0, 2) <> '1_';
COMMIT;

UPDATE ta_modif_municipalites_belges a SET a.nom = SUBSTR(a.nom, 3) WHERE SUBSTR(a.nom, 0, 2) = '1_';
COMMIT;

/
--4.8. Suppression de la partie extérieure du buffer de Comines-Warneton ;
SET SERVEROUTPUT ON
DECLARE 
    CURSOR C_1 IS 
    WITH
    v_union_comines_warneton AS (
    SELECT
    SDO_AGGR_UNION(
            SDOAGGRTYPE(a.geom, 6)
        ) AS geom
    FROM
        ta_commune a
    WHERE
        a.fid_source IN(3, 25)
        AND a.insee IN (59017, 57097)
    )
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        ta_modif_municipalites_belges a,
        v_union_comines_warneton b
    WHERE
        a.nom = 'Comines-Warneton';
    
    V_singlepolygon MDSYS.SDO_GEOMETRY;
    V_numelem INTEGER;
    V_compteur INTEGER;
    v_multipolygon C_1%ROWTYPE;
    v_nom VARCHAR2(100);
    v_prefixe VARCHAR2(10);

BEGIN
    v_prefixe := '57097_';
    OPEN C_1; -- ouverture du curseur
    LOOP -- Première boucle 
        FETCH C_1 INTO v_multipolygon; -- Le FETCH permet de traiter une ligne à la fois.
        EXIT WHEN C_1%NOTFOUND; -- Fin de la première boucle : quand il n'y a plus de ligne dans le curseur, on sort de la boucle.
        V_compteur := 0;
        V_numelem := SDO_UTIL.GETNUMELEM(V_multipolygon.geom); -- Décompte du nombre total de sous-élément de chaque géométrie.
        LOOP -- Deuxième boucle : extraction de chaque sous-élément de la géométrie dans la table ta_test_limites_communes.
            V_compteur := V_compteur + 1;
            EXIT WHEN V_compteur > V_numelem; -- Quand le compteur excède V_numelem, cela veut dire que tous les sous-éléments ont été traités.
                V_singlepolygon := SDO_UTIL.EXTRACT(V_multipolygon.geom, V_compteur);
                v_nom :=  v_prefixe || v_multipolygon.nom;
                INSERT INTO ta_modif_municipalites_belges(nom, geom)
                    VALUES(v_nom, V_singlepolygon);
        END LOOP;
    END LOOP;
    CLOSE C_1; -- Fermeture obligatoire du compteur.
COMMIT;
END;

/

SET SERVEROUTPUT ON
DECLARE 
    CURSOR C_1 IS
    WITH
    v_calcul_aire AS (
    SELECT
        a.nom,
        MAX(SDO_GEOM.SDO_AREA(a.geom, 0.005)) AS aire
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a
    WHERE
        SUBSTR(a.nom, 0, 6) = '57097_'
    GROUP BY
        a.nom
    ),
    
    v_selection_aire_max AS (
    SELECT
        a.objectid,
        a.nom,
        a.geom
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a,
        v_calcul_aire b
    WHERE
        SDO_GEOM.SDO_AREA(a.geom, 0.005) = b.aire
    )
    
    SELECT
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        ta_modif_municipalites_belges a,
        v_selection_aire_max b
    WHERE
        a.nom = 'Comines-Warneton';

    v_geom MDSYS.SDO_GEOMETRY;

BEGIN
    OPEN C_1;
    FETCH C_1 INTO v_geom;

    UPDATE ta_modif_municipalites_belges SET geom = v_geom WHERE nom = 'Comines-Warneton';
    COMMIT;
END;

/

DELETE FROM ta_modif_municipalites_belges a WHERE SUBSTR(a.nom, 0, 6) = '57097_';
COMMIT;

/

--4.9. Suppression de la partie extérieure du buffer de Tournai ;
SET SERVEROUTPUT ON
DECLARE 
    CURSOR C_1 IS 
    WITH
    v_union_tournai AS (
    SELECT
    SDO_AGGR_UNION(
            SDOAGGRTYPE(a.geom, 6)
        ) AS geom
    FROM
        ta_commune a
    WHERE
        a.fid_source IN(3, 25)
        AND a.insee IN (5944, 57081)
    )
    SELECT
        a.nom,
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        ta_modif_municipalites_belges a,
        v_union_tournai b
    WHERE
        a.nom = 'Tournai';
    
    V_singlepolygon MDSYS.SDO_GEOMETRY;
    V_numelem INTEGER;
    V_compteur INTEGER;
    v_multipolygon C_1%ROWTYPE;
    v_nom VARCHAR2(100);
    v_prefixe VARCHAR2(10);

BEGIN
    v_prefixe := '57081_';
    OPEN C_1; -- ouverture du curseur
    LOOP -- Première boucle 
        FETCH C_1 INTO v_multipolygon; -- Le FETCH permet de traiter une ligne à la fois.
        EXIT WHEN C_1%NOTFOUND; -- Fin de la première boucle : quand il n'y a plus de ligne dans le curseur, on sort de la boucle.
        V_compteur := 0;
        V_numelem := SDO_UTIL.GETNUMELEM(V_multipolygon.geom); -- Décompte du nombre total de sous-élément de chaque géométrie.
        LOOP -- Deuxième boucle : extraction de chaque sous-élément de la géométrie dans la table ta_test_limites_communes.
            V_compteur := V_compteur + 1;
            EXIT WHEN V_compteur > V_numelem; -- Quand le compteur excède V_numelem, cela veut dire que tous les sous-éléments ont été traités.
                V_singlepolygon := SDO_UTIL.EXTRACT(V_multipolygon.geom, V_compteur);
                v_nom :=  v_prefixe || v_multipolygon.nom;
                INSERT INTO ta_modif_municipalites_belges(nom, geom)
                    VALUES(v_nom, V_singlepolygon);
        END LOOP;
    END LOOP;
    CLOSE C_1; -- Fermeture obligatoire du compteur.
COMMIT;
END;

/
-- Suppression de la partie extérieure du buffer de Tournai, en comparant ce dernier à la géométrie initiale de Tournai.
SET SERVEROUTPUT ON
DECLARE 
    CURSOR C_1 IS
    WITH
    v_calcul_aire AS (
    SELECT
        a.nom,
        MAX(SDO_GEOM.SDO_AREA(a.geom, 0.005)) AS aire
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a
    WHERE
        SUBSTR(a.nom, 0, 6) = '57081_'
    GROUP BY
        a.nom
    ),
    
    v_selection_aire_max AS (
    SELECT
        a.objectid,
        a.nom,
        a.geom
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a,
        v_calcul_aire b
    WHERE
        SDO_GEOM.SDO_AREA(a.geom, 0.005) = b.aire
    )
    
    SELECT
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        ta_modif_municipalites_belges a,
        v_selection_aire_max b
    WHERE
        a.nom = 'Tournai';

    v_geom MDSYS.SDO_GEOMETRY;

BEGIN
    OPEN C_1;
    FETCH C_1 INTO v_geom;

    UPDATE ta_modif_municipalites_belges SET geom = v_geom WHERE nom = 'Tournai';
    COMMIT;
END;
        

/
-- Mise  àjour de la géométrie de la municipalité de Tournai
SET SERVEROUTPUT ON
DECLARE 
    CURSOR C_1 IS
    WITH
    v_calcul_aire AS (
    SELECT
        a.nom,
        MAX(SDO_GEOM.SDO_AREA(a.geom, 0.005)) AS aire
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a
    WHERE
        SUBSTR(a.nom, 0, 6) = '57081_'
    GROUP BY
        a.nom
    ),
    
    v_selection_aire_max AS (
    SELECT
        a.objectid,
        a.nom,
        a.geom
    FROM
        TA_MODIF_MUNICIPALITES_BELGES a,
        v_calcul_aire b
    WHERE
        SDO_GEOM.SDO_AREA(a.geom, 0.005) = b.aire
    )
    
    SELECT
        SDO_GEOM.SDO_DIFFERENCE(a.geom, b.geom, 0.005) AS GEOM
    FROM
        ta_modif_municipalites_belges a,
        v_selection_aire_max b
    WHERE
        a.nom = 'Tournai';

    v_geom MDSYS.SDO_GEOMETRY;

BEGIN
    OPEN C_1;
    FETCH C_1 INTO v_geom;

    UPDATE ta_modif_municipalites_belges SET geom = v_geom WHERE nom = 'Tournai';
    CLOSE C_1;
    COMMIT;
END;

/

DELETE FROM ta_modif_municipalites_belges a WHERE SUBSTR(a.nom, 0, 6) = '57081_';
COMMIT;



-- Inconvénient de la méthode :
-- Si cette méthode règle 95% des problèmes de géométries jointives, il existe 5 cas qui restent incorects.
