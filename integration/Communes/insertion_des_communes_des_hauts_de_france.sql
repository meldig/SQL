/*
Insertion des communes des Hauts-de-France de la BdTopo de l'IGN en base et création des régions, des départements, des UT, des Territoires et de la Métropole

Prérequis : création d'un index spatial sur la table d'import des communes TEMP_COMMUNES ;

1. Création des métadonnées ;
    1.1. Insertion de l'organisme créateur des données dans TA_ORGANISME ;
    1.2. Insertion de la source des données dans TA_SOURCE ;
    1.3. Insertion du millésime, date d'insertion et nom de l'obtenteur des données dans TA_DATE_ACQUISITION ;
    1.4. Insertion de la provenance des données dans TA_PROVENANCE ;
    1.5. Insertion des clés étrangères dans la table pivot TA_METADONNEE ;
    1.6. Insertion des clés étrangères dans la table pivot TA_METADONNEE_RELATION_ORGANISME ;
    
2. Création des familles et libelles ;
    2.1. Insertion de toutes les familles requises pour les communes dans TA_FAMILLE ;
    2.2. Insertion de tous les libelles longs requis pour les communes dans TA_LIBELLE_LONG ;
    2.3. Insertion des clés étrangères dans la table pivot TA_FAMILLE_LIBELLE ;
    2.4. Insertion des clés étrangères dans la table pivot TA_LIBELLE ;
  
3. Création des noms requis pour les communes dans TA_NOM ;
    3.1. Insertion des noms des zones supra-communales ;
        3.2. Insertion des noms dans TA_NOM ; 
            3.2.1. Communes simples ;
            3.2.2. Communes associées ou déléguées ;
    
4. Insertion des codes requis pour les communes dans TA_CODE ;
    4.1. Insertion des codes départementaux, régionaux, territoriaux et des unités territoriales ;
    4.2. Insertion des codes INSEE ;
        4.2.1. Communes simples ;
        4.2.2. Communes associées ou déléguées ;

5. Création des zones supra-communales, des territoires et des unités territoriales dans TA_ZONE_ADMINISTRATIVE ;

6. Insertion des géométries des communes dans la table TA_COMMUNE ;
    6.1. Communes simples ;
    6.1. Communes associées ou déléguées ;

7. Insertion des id_commune et id_code dans la table pivot TA_IDENTIFIANT_COMMUNE ;
    7.1. Communes simples ;
    7.1. Communes associées ou déléguées ;

8. Insertion des id_zone_administrative et des id_code dans la table pivot TA_IDENTIFIANT_ZONE_ADMINISTRATIVE ;

9. Association des communes avec leur zone supra-communales respectives dans TA_ZA_COMMUNES ;
    9.1. Association des communes à leurs régions, départements, UT et Territoires respectifs ;
    9.2. Association des communes à leur Métropole (MEL) ;

Suppression de la table d'import des communes TEMP_COMMUNES
*/

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_INSERTION_COMMUNES;

-- Prérequis : création d'un index spatial sur la table d'import des communes TEMP_COMMUNES ;
CREATE INDEX temp_communes_SIDX
ON temp_communes(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 1. Création des métadonnées ;
-- 1.1. Insertion de l'organisme créateur des données dans TA_ORGANISME ;
MERGE INTO G_GEO.TA_ORGANISME a
USING(
    SELECT 
        'IGN' AS acronyme, 
        'Institut National de l''Information Geographie et Forestiere' AS valeur 
    FROM DUAL
    )t
ON (UPPER(a.acronyme) = UPPER(t.acronyme) AND UPPER(a.nom_organisme) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
    INSERT(a.acronyme, a.nom_organisme)
    VALUES(t.acronyme, t.valeur);


-- 1.2. Insertion de la source des données dans TA_SOURCE ;
MERGE INTO G_GEO.TA_SOURCE a
USING(
    SELECT 
        'BDTOPO' AS nom, 
        'Description vectorielle des elements du territoire francais et de ses infrastructures avec une precision metrique.' AS description 
    FROM DUAL
    )t
ON (UPPER(a.nom_source) = UPPER(t.nom) AND UPPER(a.description) = UPPER(t.description))
WHEN NOT MATCHED THEN
    INSERT(a.nom_source, a.description)
    VALUES(t.nom, t.description);


-- 1.3. Insertion du millésime, date d'insertion et nom de l'obtenteur des données dans TA_DATE_ACQUISITION ;
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
    USING(
        SELECT 
            TO_DATE(sysdate, 'dd/mm/yy') AS date_insertion, 
            '01/01/2019' AS date_millesime,
            sys_context('USERENV','OS_USER') AS nom_obtenteur 
        FROM DUAL
    )t
    ON (
            a.date_acquisition = t.date_insertion 
            AND a.millesime = t.date_millesime
            AND a.nom_obtenteur = t.nom_obtenteur
        )
WHEN NOT MATCHED THEN
    INSERT (a.date_acquisition, a.millesime, a.nom_obtenteur)
    VALUES(t.date_insertion, t.date_millesime, t.nom_obtenteur);


-- 1.4. Insertion de la provenance des données dans TA_PROVENANCE ;
MERGE INTO G_GEO.TA_PROVENANCE a
    USING(
        SELECT 
            'https://geoservices.ign.fr/documentation/diffusion/index.html' AS url,
            'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.' AS methode
        FROM
            DUAL
    )t
    ON(
        a.url = t.url AND a.methode_acquisition = t.methode
    )
WHEN NOT MATCHED THEN
    INSERT(a.url, a.methode_acquisition)
    VALUES(t.url, t.methode);

    
-- 1.5. Insertion des clés étrangères dans la table pivot TA_METADONNEE ;
MERGE INTO G_GEO.TA_METADONNEE a
    USING(
        SELECT 
            b.objectid AS fid_source,
            c.objectid AS fid_acquisition,
            d.objectid AS fid_provenance
        FROM
            G_GEO.TA_SOURCE b,
            G_GEO.TA_DATE_ACQUISITION c,
            G_GEO.TA_PROVENANCE d
        WHERE
            UPPER(b.nom_source) = UPPER('BDTOPO')
            AND c.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND c.millesime = '01/01/2019'
            AND c.nom_obtenteur = sys_context('USERENV','OS_USER')
            AND d.url = 'https://geoservices.ign.fr/documentation/diffusion/index.html'
            AND d.methode_acquisition = 'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.'
    )t
    ON(
        a.fid_source = t.fid_source 
        AND a.fid_acquisition = t.fid_acquisition
        AND a.fid_provenance = t.fid_provenance
    )
WHEN NOT MATCHED THEN
    INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
    VALUES(t.fid_source, t.fid_acquisition, t.fid_provenance);


-- 1.6. Insertion des clés étrangères dans la table pivot TA_METADONNEE_RELATION_ORGANISME ;
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
    USING(
        SELECT 
            b.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE b
            INNER JOIN G_GEO.TA_SOURCE c ON c.objectid = b.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = b.fid_acquisition
            INNER JOIN G_GEO.TA_PROVENANCE e ON e.objectid = b.fid_provenance,
            G_GEO.TA_ORGANISME f
        WHERE
            UPPER(c.nom_source) = UPPER('BDTOPO')
            AND d.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND d.millesime = '01/01/2019'
            AND d.nom_obtenteur = sys_context('USERENV','OS_USER')
            AND e.url = 'https://geoservices.ign.fr/documentation/diffusion/index.html'
            AND e.methode_acquisition = 'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.'
            AND f.acronyme = 'IGN'
    )t
    ON (
        a.fid_metadonnee = t.fid_metadonnee
        AND a.fid_organisme = t.fid_organisme
    )
WHEN NOT MATCHED THEN
    INSERT (a.fid_metadonnee, a.fid_organisme)
    VALUES (t.fid_metadonnee, t.fid_organisme);


-- 2. Création des familles et libelles ;
-- 2.1. Insertion de toutes les familles requises pour les communes dans TA_FAMILLE ;
MERGE INTO G_GEO.TA_FAMILLE a
    USING(
        SELECT 'types de commune' AS FAMILLE FROM DUAL
        UNION
        SELECT 'zone supra-communale' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Identifiants de zone administrative' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Identifiants des divisions territoriales de la MEL' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Division territoriale de la MEL' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Etablissements de Coopération Intercommunale (EPCI)' AS FAMILLE FROM DUAL
    )t
    ON(
        UPPER(a.valeur) = UPPER(t.famille)
    )
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.famille);

-- 2.2. Insertion de tous les libelles longs requis pour les communes dans TA_LIBELLE_LONG ;
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(
            SELECT 'département' AS libelle FROM DUAL 
            UNION
            SELECT 'région' AS libelle FROM DUAL
            UNION
            SELECT 'commune simple' AS libelle FROM DUAL 
            UNION
            SELECT 'commune associée' AS libelle FROM DUAL 
            UNION
            SELECT 'commune déléguée' AS libelle FROM DUAL 
            UNION
            SELECT 'Métropole' AS libelle FROM DUAL
            UNION
            SELECT 'Unité Territoriale' AS libelle FROM DUAL
            UNION
            SELECT 'code unité territoriale' AS libelle FROM DUAL
            UNION
            SELECT 'Territoire' AS libelle FROM DUAL
            UNION
            SELECT 'code insee' AS libelle FROM DUAL
            UNION
            SELECT 'code département' AS libelle FROM DUAL
            UNION
            SELECT 'code région' AS libelle FROM DUAL
            UNION
            SELECT 'code territoire' AS libelle FROM DUAL
    ) t
    ON (UPPER(a.valeur) = UPPER(t.libelle))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.libelle);


-- 2.3. Insertion des clés étrangères dans la table pivot TA_FAMILLE_LIBELLE ;
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
    USING(
        SELECT
            y.fid_famille,
            y.fid_libelle_long
        FROM
            (SELECT DISTINCT
                a.objectid AS fid_famille,
                CASE
                    WHEN UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('commune simple')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('commune associée')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('commune déléguée')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('zone supra-communale') AND UPPER(b.valeur) = UPPER('département')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('zone supra-communale') AND UPPER(b.valeur) = UPPER('région')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Etablissements de Coopération Intercommunale (EPCI)') AND UPPER(b.valeur) = UPPER('Métropole')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Division territoriale de la MEL') AND UPPER(b.valeur) = UPPER('Territoire')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Division territoriale de la MEL') AND UPPER(b.valeur) = UPPER('Unité Territoriale')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code insee')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code département')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code région')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants des divisions territoriales de la MEL') AND UPPER(b.valeur) = UPPER('code unité territoriale')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants des divisions territoriales de la MEL') AND UPPER(b.valeur) = UPPER('code territoire')
                    THEN b.objectid
                END AS fid_libelle_long
            FROM
                G_GEO.TA_FAMILLE a,
                G_GEO.TA_LIBELLE_LONG b
        )y
        WHERE
            y.fid_famille IS NOT NULL
            AND y.fid_libelle_long IS NOT NULL
    )t
    ON(a.fid_famille = t.fid_famille AND a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
    INSERT(a.fid_famille, a.fid_libelle_long)
    VALUES(t.fid_famille, t.fid_libelle_long);


-- 2.4. Insertion des clés étrangères dans la table pivot TA_LIBELLE ;
MERGE INTO G_GEO.TA_LIBELLE a
    USING(
        SELECT
            b.objectid AS fid_libelle_long
        FROM
            G_GEO.TA_LIBELLE_LONG b
        WHERE
            UPPER(b.valeur) IN(
                    UPPER('département'),
                    UPPER('région'), 
                    UPPER('commune simple'), 
                    UPPER('commune associée'),
                    UPPER('commune déléguée'), 
                    UPPER('Métropole'), 
                    UPPER('Unité Territoriale'), 
                    UPPER('code unité territoriale'), 
                    UPPER('Territoire'), 
                    UPPER('code insee'), 
                    UPPER('code département'), 
                    UPPER('code région'), 
                    UPPER('code territoire'))
    )t
    ON (a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
    INSERT(a.fid_libelle_long)
    VALUES(t.fid_libelle_long);


-- 3. Création des noms requis pour les communes dans TA_NOM ;
-- 3.1. Insertion des noms des zones supra-communales ;
MERGE INTO G_GEO.TA_NOM a
    USING(
            SELECT 'Aisne' AS nom FROM DUAL 
            UNION
            SELECT 'Nord' AS nom FROM DUAL 
            UNION
            SELECT 'Oise' AS nom FROM DUAL 
            UNION
            SELECT 'Pas-de-Calais' AS nom FROM DUAL 
            UNION   
            SELECT 'Somme' AS nom FROM DUAL
            UNION
            SELECT 'Territoire Est' AS nom FROM DUAL
            UNION
            SELECT 'Territoire Tourquennois' AS nom FROM DUAL
            UNION
            SELECT 'Territoire des Weppes' AS nom FROM DUAL
            UNION
            SELECT 'Couronne Nord de Lille' AS nom FROM DUAL
            UNION
            SELECT 'Territoire de la Lys' AS nom FROM DUAL
            UNION
            SELECT 'Territoire Roubaisien' AS nom FROM DUAL
            UNION
            SELECT 'Territoire Lillois' AS nom FROM DUAL
            UNION
            SELECT 'Couronne Sud de Lille' AS nom FROM DUAL
            UNION
            SELECT 'Tourcoing-Armentières' AS nom FROM DUAL
            UNION
            SELECT 'Roubaix-Villeneuve d''Ascq' AS nom FROM DUAL
            UNION
            SELECT 'Lille-Seclin' AS nom FROM DUAL
            UNION
            SELECT 'Marcq en Baroeul-la-Bassee' AS nom FROM DUAL
            UNION
            SELECT 'Hauts-de-France' AS nom FROM DUAL
            UNION
            SELECT 'Métropole Européenne de Lille' AS nom FROM DUAL
            )t
    ON (UPPER(a.valeur) = UPPER(t.nom))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);

-- 3.2. Insertion des noms dans TA_NOM ; 
-- 3.2.1. Communes simples ;
MERGE INTO G_GEO.TA_NOM a
    USING (
            SELECT
                a.NOM
            FROM
                G_GEO.TEMP_COMMUNES a
            WHERE
                a.INSEE_DEP IN('02', '59', '60', '62', '80')
            ) t
    ON (UPPER(a.valeur) = UPPER(t.NOM))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);

-- 3.2.2. Communes associées ou déléguées ;
MERGE INTO G_GEO.TA_NOM a
    USING (
            SELECT
                a.NOM
            FROM
                G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE a
            ) t
    ON (UPPER(a.valeur) = UPPER(t.NOM))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);

-- 4. Insertion des codes requis pour les communes dans TA_CODE ;
-- 4.1. Insertion des codes départementaux, régionaux, territoriaux et des unités territoriales ;
MERGE INTO G_GEO.TA_CODE a
    USING(
            SELECT *
            FROM
                (WITH
                    C_1 AS(
                        SELECT '1' AS code
                        FROM DUAL
                        UNION
                        SELECT '2' AS code
                        FROM DUAL
                        UNION
                        SELECT '3' AS code
                        FROM DUAL
                        UNION
                        SELECT '4' AS code
                        FROM DUAL
                        UNION
                        SELECT '5' AS code
                        FROM DUAL
                        UNION
                        SELECT '6' AS code
                        FROM DUAL
                        UNION
                        SELECT '7' AS code
                        FROM DUAL
                        UNION
                        SELECT '8' AS code
                        FROM DUAL
                        UNION
                        SELECT '02' AS code
                        FROM DUAL
                        UNION
                        SELECT '59' AS code
                        FROM DUAL
                        UNION
                        SELECT '60' AS code
                        FROM DUAL
                        UNION
                        SELECT '62' AS code
                        FROM DUAL
                        UNION
                        SELECT '80' AS code
                        FROM DUAL
                        UNION
                        SELECT '32' AS code
                        FROM DUAL
                    )
                SELECT
                    CASE
                        WHEN UPPER(c.valeur) = UPPER('code territoire') AND a.code IN('1', '2', '3', '4', '5', '6', '7', '8') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code unité territoriale') AND a.code IN('1', '2', '3', '4') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code département') AND a.code IN('02', '59', '60', '62', '80') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code région') AND a.code = '32' THEN a.code
                    END AS code,
                    b.objectid AS libelle,
                    c.valeur AS libelle_long
                FROM
                    C_1 a,
                    G_GEO.TA_LIBELLE b 
                    INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                )x
            WHERE
                x.code IS NOT NULL
                AND x.libelle IS NOT NULL            
    ) t
    ON (a.valeur = t.code AND a.fid_libelle = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.code, t.libelle);

-- 4.2. Insertion des codes INSEE ;
-- 4.2.1. Communes simples ;
MERGE INTO G_GEO.TA_CODE a
    USING (
        SELECT
            b.INSEE_COM,
            c.objectid AS fid_libelle
        FROM
            G_GEO.TEMP_COMMUNES  b, 
            G_GEO.TA_LIBELLE c 
            INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
        WHERE
            b.INSEE_DEP IN('02', '59', '60', '62', '80')
            AND UPPER(d.valeur) = UPPER('code insee')
    ) t
    ON (a.valeur = t.INSEE_COM AND a.fid_libelle = t.fid_libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.fid_libelle);

-- 4.2.2. Communes associées ou déléguées ;
MERGE INTO G_GEO.TA_CODE a
    USING (
        SELECT
            b.INSEE_COM,
            c.objectid AS fid_libelle
        FROM
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE  b, 
            G_GEO.TA_LIBELLE c 
            INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
        WHERE
            UPPER(d.valeur) = UPPER('code insee')
    ) t
    ON (a.valeur = t.INSEE_COM AND a.fid_libelle = t.fid_libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.fid_libelle);

-- 5. Création des zones supra-communales, des territoires et des unités territoriales dans TA_ZONE_ADMINISTRATIVE ;
-- Par zone supra-communale j'entends toute zone administrative se basant sur les communes.
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(
        SELECT *
            FROM
                (
                    SELECT
                        CASE
                            WHEN UPPER(b.valeur) IN(UPPER('Aisne'), UPPER('Nord'), UPPER('Oise'), UPPER('Pas-de-Calais'), UPPER('Somme')) AND UPPER(d.valeur) = UPPER('département')
                                THEN b.objectid
                            WHEN UPPER(b.valeur) = UPPER('Hauts-de-France') AND UPPER(d.valeur) = UPPER('région')
                                THEN b.objectid
                            WHEN UPPER(b.valeur) IN(UPPER('Territoire Est'), UPPER('Territoire Tourquennois'), UPPER('Territoire des Weppes'), UPPER('Couronne Nord de Lille'), UPPER('Territoire de la Lys'), UPPER('Territoire Roubaisien'), UPPER('Territoire Lillois'), UPPER('Couronne Sud de Lille')) AND UPPER(d.valeur) = UPPER('Territoire')
                                THEN b.objectid
                            WHEN UPPER(b.valeur) IN(UPPER('Tourcoing-Armentières'), UPPER('Roubaix-Villeneuve d''Ascq'), UPPER('Lille-Seclin'), UPPER('Marcq en Baroeul-la-Bassee')) AND UPPER(d.valeur) = UPPER('Unité Territoriale')
                                THEN b.objectid
                            WHEN UPPER(b.valeur) = UPPER('Métropole Européenne de Lille') AND UPPER(d.valeur) = UPPER('Métropole')
                                THEN b.objectid
                        END AS fid_nom,
                        c.objectid AS fid_libelle,
                        b.valeur AS NOM,
                        d.valeur AS LIBELLE_LONG
                    FROM 
                            G_GEO.TA_NOM b,
                            G_GEO.TA_LIBELLE c 
                            INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long

                )x
            WHERE
                x.fid_nom IS NOT NULL
                AND x.fid_libelle IS NOT NULL
    )t
    ON (a.fid_nom = t.fid_nom AND a.fid_libelle = t.fid_libelle)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.fid_nom, t.fid_libelle);

-- 6. Insertion des géométries des communes dans la table TA_COMMUNE ;
-- 6.1. Communes simples ;
MERGE INTO G_GEO.TA_COMMUNE a
    USING(
        SELECT a.ORA_GEOMETRY, 
            b.objectid AS fid_lib_type_commune, 
            d.objectid AS fid_nom, 
            a.INSEE_COM, 
            f.objectid AS fid_metadonnee
        FROM 
            G_GEO.TEMP_COMMUNES a
            INNER JOIN G_GEO.TA_NOM d ON d.valeur = a.nom,
            G_GEO.TA_LIBELLE b
            INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid,
            G_GEO.TA_METADONNEE f 
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
            INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source
        WHERE 
            INSEE_DEP IN('02', '59', '60', '62', '80')
            AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND g.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
            AND g.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
            AND UPPER(c.valeur) = UPPER('commune simple')
            AND UPPER(h.nom_source) = UPPER('BdTopo')
    )t
    ON(
        a.fid_lib_type_commune = t.fid_lib_type_commune
        AND a.fid_nom = t.fid_nom
        AND a.fid_metadonnee = t.fid_metadonnee
    )
WHEN NOT MATCHED THEN
    INSERT(a.geom, a.fid_lib_type_commune, a.fid_nom, a.fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.fid_lib_type_commune, t.fid_nom, t.fid_metadonnee);

-- 6.1. Communes associées ou déléguées ;
MERGE INTO G_GEO.TA_COMMUNE a
    USING(
        SELECT 
            CASE
                WHEN UPPER(a.NATURE) = UPPER(c.valeur) AND UPPER(c.valeur) = UPPER(commune associée)
                    THEN a.ORA_GEOMETRY
                WHEN UPPER(a.NATURE) = UPPER(c.valeur) AND UPPER(c.valeur) = UPPER(commune déléguée)
                    THEN a.ORA_GEOMETRY
            END AS geom, 
            b.objectid AS fid_lib_type_commune, 
            d.objectid AS fid_nom, 
            a.INSEE_COM, 
            f.objectid AS fid_metadonnee
        FROM 
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE a
            INNER JOIN G_GEO.TA_NOM d ON d.valeur = a.nom,
            G_GEO.TA_LIBELLE b
            INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid,
            G_GEO.TA_METADONNEE f 
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
            INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source
        WHERE 
            INSEE_DEP IN('02', '59', '60', '62', '80')
            AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND g.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
            AND g.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
            AND UPPER(h.nom_source) = UPPER('BdTopo')
    )t
    ON(
        a.fid_lib_type_commune = t.fid_lib_type_commune
        AND a.fid_nom = t.fid_nom
        AND a.fid_metadonnee = t.fid_metadonnee
    )
WHEN NOT MATCHED THEN
    INSERT(a.geom, a.fid_lib_type_commune, a.fid_nom, a.fid_metadonnee)
    VALUES(t.geom, t.fid_lib_type_commune, t.fid_nom, t.fid_metadonnee);

-- 7. Insertion des id_commune et id_code dans la table pivot TA_IDENTIFIANT_COMMUNE ;
/*Objectif : associer la géométrie des communes avec leur code insee respectif.
Cette table est nécessaire puisque l'on veut garder l'évolution des limites communales et parce que nous conservons tous les millésimes de la BdTopo, 
ce qui signifie que dans la table TA_IDENTIFIANT_COMMUNE l'id du même code INSEE sera présent plusieurs fois pour différents id de géométries communales.
Exemple : les contours de la commune de Lille de 1950 peuvent être différents de ceux de 1990, pour autant son code INSEE reste le même,
il nous faut donc une table qui stocke ces différents états, c'est le rôle de la table TA_IDENTIFIANT_COMMUNE.
*/
-- 7.1. Communes simples ;
MERGE INTO G_GEO.TA_IDENTIFIANT_COMMUNE a
    USING(
        SELECT
            b.OBJECTID AS fid_commune,
            a.INSEE_COM AS temp_code_insee,
            h.objectid AS fid_identifiant,
            h.valeur AS prod_code_insee
        FROM
            -- Sélection des géométries de communes et de leur code INSEE dans la table d'import
            G_GEO.TEMP_COMMUNES a,
            -- Sélection des géométries de communes de TA_COMMUNE que l'on vient d'insérer
            G_GEO.TA_COMMUNE b
            INNER JOIN G_GEO.TA_METADONNEE e ON e.objectid = b.fid_metadonnee
            INNER JOIN G_GEO.TA_SOURCE f ON f.objectid = e.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = e.fid_acquisition,
            -- Sélection des codes communaux de TA_CODE que l'on vient d'insérer (merger)
            G_GEO.TA_CODE h
            INNER JOIN G_GEO.TA_LIBELLE i ON i.objectid = h.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
        WHERE
            -- Condition d'égalité de géométrie entre la table d'import et TA_COMMUNE
            SDO_EQUAL(a.ORA_GEOMETRY, b.GEOM) = 'TRUE'
            AND UPPER(f.nom_source) = UPPER('BdTopo')
            AND g.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
            AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND UPPER(j.valeur) = UPPER('Code INSEE')
            AND h.valeur = a.INSEE_COM
    ) t
    ON (a.fid_identifiant = t.fid_identifiant AND a.fid_commune = t.fid_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.fid_commune, t.fid_identifiant);

-- 7.1. Communes associées ou déléguées ;
MERGE INTO G_GEO.TA_IDENTIFIANT_COMMUNE a
    USING(
        SELECT
            b.OBJECTID AS fid_commune,
            a.INSEE_COM AS temp_code_insee,
            h.objectid AS fid_identifiant,
            h.valeur AS prod_code_insee
        FROM
            -- Sélection des géométries de communes et de leur code INSEE dans la table d'import
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE a,
            -- Sélection des géométries de communes de TA_COMMUNE que l'on vient d'insérer
            G_GEO.TA_COMMUNE b
            INNER JOIN G_GEO.TA_METADONNEE e ON e.objectid = b.fid_metadonnee
            INNER JOIN G_GEO.TA_SOURCE f ON f.objectid = e.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = e.fid_acquisition,
            -- Sélection des codes communaux de TA_CODE que l'on vient d'insérer (merger)
            G_GEO.TA_CODE h
            INNER JOIN G_GEO.TA_LIBELLE i ON i.objectid = h.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
        WHERE
            -- Condition d'égalité de géométrie entre la table d'import et TA_COMMUNE
            SDO_EQUAL(a.ORA_GEOMETRY, b.GEOM) = 'TRUE'
            AND UPPER(f.nom_source) = UPPER('BdTopo')
            AND g.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
            AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND UPPER(j.valeur) = UPPER('Code INSEE')
            AND h.valeur = a.INSEE_COM
    ) t
    ON (a.fid_identifiant = t.fid_identifiant AND a.fid_commune = t.fid_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.fid_commune, t.fid_identifiant);

-- 8. Insertion des id_zone_administrative et des id_code dans la table pivot TA_IDENTIFIANT_ZONE_ADMINISTRATIVE ;
/*Objectif : associer les zones administratives avec leur code respectif quand elles en ont.
 Exemple : la région Hauts-de-France a le code 32. 
 L'avantage d'utiliser la table pivot TA_IDENTIFIANT_ZONE_ADMINISTRATIVE pour ces associations permet de n'écrire qu'une seule fois les codes et de les réutiliser autant de fois que nécessaire.
*/
MERGE INTO G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
    SELECT *
    FROM
        (
            SELECT DISTINCT
                    CASE
                        WHEN UPPER(b.valeur) = UPPER('Territoire Est') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '5' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Tourquennois') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '2' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire des Weppes') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '1' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Lillois') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '8' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Couronne Nord de Lille') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '6' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Couronne Sud de Lille') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '7' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Roubaisien') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '3' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire de la Lys') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '4' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Lille-Seclin') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '1' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Marcq en Baroeul-la-Bassee') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '2' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Roubaix-Villeneuve d''Ascq') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '3' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Tourcoing-Armentières') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '4' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Aisne') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '02' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Nord') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '59' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Pas-de-Calais') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '62' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Somme') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '80' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Oise') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '60' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Hauts-de-France') AND UPPER(d.valeur) = UPPER('région') AND e.valeur = '32' AND UPPER(g.valeur) = UPPER('code région')
                            THEN e.objectid
                    END AS ID_CODE,
                    e.valeur AS code,
                    a.objectid AS ID_ZONE_ADMIN,
                    b.valeur AS NOM_ZONE_ADMIN
                FROM
                    G_GEO.TA_ZONE_ADMINISTRATIVE a
                    INNER JOIN G_GEO.TA_NOM b ON b.objectid = a.fid_nom
                    INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = a.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
                    G_GEO.TA_CODE e
                    INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                WHERE
                    UPPER(d.valeur) IN(UPPER('Territoire'), UPPER('Unité Territoriale'), UPPER('département'), UPPER('région'))
                    AND UPPER(g.valeur) IN(UPPER('code territoire'), UPPER('code unité territoriale'), UPPER('code département'), UPPER('code région'))
        ) a
    WHERE
        a.ID_CODE IS NOT NULL
) t
ON (a.fid_zone_administrative = t.ID_ZONE_ADMIN AND a.fid_identifiant = t.ID_CODE)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);


-- 9. Association des communes avec leur zone supra-communales respectives dans TA_ZA_COMMUNES ; 
/*
Objectif : Regrouper les communes dans TA_ZA_COMMUNE par leur zone administrative d'appartenance avec la date de début et de fin de validité de ces zones.
Cette table permet de voir l'évolution des zones administratives dans le temps, exemple : MEL90, MEL95.
*/
-- 9.1. Association des communes à leurs régions, départements, UT et Territoires respectifs
/* 
L'utilisation du CASE WHEN permet de d'associer dans une seule requête toutes les communes à leur zone administrative respective.
Il y a donc un WHEN par zone administrative.
*/
MERGE INTO G_GEO.TA_ZA_COMMUNES a
    USING(
        SELECT *
        FROM
            (
                SELECT 
                    CASE
                        -- Gestion des départements
                        WHEN SUBSTR(d.valeur, 0, 2) = '02' AND g.valeur = '02'
                            THEN b.objectid
                        WHEN SUBSTR(d.valeur, 0, 2) = '59' AND g.valeur = '59'
                            THEN b.objectid
                        WHEN SUBSTR(d.valeur, 0, 2) = '60' AND g.valeur = '60'
                            THEN b.objectid
                        WHEN SUBSTR(d.valeur, 0, 2) = '62' AND g.valeur = '62'
                            THEN b.objectid
                        WHEN SUBSTR(d.valeur, 0, 2) = '80' AND g.valeur = '80'
                            THEN b.objectid
                        -- Gestion des Unités Territoriales
                        WHEN d.valeur IN('59011','59346','59368','59648','59256','59609','59350','59360','59477','59005','59193',
                                        '59220','59437','59133','59052','59585','59316','59507','59560','59343'
                                )
                                AND g.valeur = '1'
                                AND UPPER(k.valeur) = UPPER('code Unité Territoriale')
                            THEN b.objectid
                        WHEN d.valeur IN('59051', '59056', '59128', '59670', '59195', '59196', '59201', '59208', '59250', '59278', 
                                        '59281', '59286', '59303', '59320', '59328', '59356', '59378', '59386', '59388', '59457', 
                                        '59470', '59524', '59527', '59550', '59553', '59566', '59611', '59636', '59653', '59658', 
                                        '59088', '59025', '59257', '59487', '59371'
                                )
                                AND g.valeur = '2'
                                AND UPPER(k.valeur) = UPPER('code Unité Territoriale')
                            THEN b.objectid
                        WHEN d.valeur IN('59275','59339','59523','59522','59044','59367','59163','59512','59299','59146','59410',
                                        '59650','59106','59247','59602','59013','59458','59332','59009','59646','59598','59660'
                                )
                                AND g.valeur = '3'
                                AND UPPER(k.valeur) = UPPER('code Unité Territoriale')
                            THEN b.objectid
                        WHEN d.valeur IN('59017','59252','59656','59508','59352','59482','59173','59143','59090','59317','59098',
                                        '59643','59152','59599','59421','59202','59279','59426'
                                )
                                AND g.valeur = '4'
                                AND UPPER(k.valeur) = UPPER('code Unité Territoriale')
                            THEN b.objectid
                        -- Gestion des Territoires
                        WHEN d.valeur IN('59051','59056','59670','59195','59196','59201','59208','59250','59278','59281','59286',
                                        '59303','59320','59388','59524','59550','59553','59566','59653','59658','59088','59025',
                                        '59257','59487','59371'
                                )
                                AND g.valeur = '1'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59090','59279','59421','59426','59508','59599')
                                AND g.valeur = '2'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59163','59299','59332','59339','59367','59512','59598','59646','59650')
                                AND g.valeur = '3'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59017', '59098', '59143', '59152', '59173', '59202', '59252', '59317', '59352', '59482', '59643', '59656')
                                AND g.valeur = '4'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59013','59044','59106','59146','59247','59275','59410','59522','59523','59602','59009','59660','59458')
                                AND g.valeur = '5'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59128','59328','59356','59368','59378','59386','59457','59470','59527','59611','59636')
                                AND g.valeur = '6'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59193','59220','59256','59316','59343','59346','59360','59437','59507','59560','59585',
                                        '59648','59609', '59185', '59112', '59221', '59251', '59112', '59011', '59005', '59052', '59133', '59477'
                                )
                                AND g.valeur = '7'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        WHEN d.valeur IN('59350')
                                AND g.valeur = '8'
                                AND UPPER(k.valeur) = UPPER('code Territoire')
                            THEN b.objectid
                        -- Gestion de la région Hauts-de-France
                        WHEN SUBSTR(d.valeur, 0, 2) IN('02', '59', '60', '62', '80')
                                AND g.valeur = '32'
                                AND UPPER(k.valeur) = UPPER('code région')
                            THEN b.objectid
                    END AS fid_commune, 
                    e.objectid AS fid_zone_administrative,
                    g.valeur AS code_zone_admin,
                    k.valeur AS type_code_zone_admin,
                    '01/01/2020' AS debut_validite, 
                    '01/01/2999' AS fin_validite  
                FROM 
                    -- Sélection des objets dans TA_COMMUNE disposant d'un code INSEE (certifiant que ce sont des communes) et provenant du millésime que l'on vient d'insérer.
                    G_GEO.TA_COMMUNE b
                    INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE c ON c.fid_commune = b.objectid
                    INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                    INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long
                    INNER JOIN G_GEO.TA_METADONNEE m ON m.objectid = b.fid_metadonnee
                    INNER JOIN G_GEO.TA_SOURCE n ON n.objectid = m.fid_source
                    INNER JOIN G_GEO.TA_DATE_ACQUISITION o ON o.objectid = m.fid_acquisition, 
                    -- Sélection des zones administratives que l'on veut associer aux communes
                    G_GEO.TA_ZONE_ADMINISTRATIVE e
                    INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE f ON f.fid_zone_administrative = e.objectid
                    INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                    INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
                    INNER JOIN G_GEO.TA_NOM p ON p.objectid = e.fid_nom
                WHERE 
                    UPPER(i.valeur) = UPPER('code insee')
                    --AND UPPER(k.valeur) IN (UPPER('code département'), UPPER('code Territoire'), UPPER('code Unité Territoriale'), UPPER('code région'))
                    AND UPPER(n.nom_source) = UPPER('BdTopo')
                    AND o.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
                    AND o.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            )t
        WHERE
            t.fid_commune IS NOT NULL
        ORDER BY
            t.type_code_zone_admin,
            t.code_zone_admin
    )t
ON (a.fid_commune = t.fid_commune AND a.fid_zone_administrative = t.fid_zone_administrative AND a.debut_validite = t.debut_validite AND a.fin_validite = t.fin_validite)
WHEN NOT MATCHED THEN
    INSERT(a.FID_COMMUNE, a.FID_ZONE_ADMINISTRATIVE, a.DEBUT_VALIDITE, a.FIN_VALIDITE)
    VALUES(t.fid_commune, t.fid_zone_administrative, t.debut_validite, t.fin_validite);

-- 9.2. Association des communes à leur Métropole (MEL)
/* 
La raison pour laquelle je sépare l'association des communes à la MEL de celle des communes aux autres zones supra-communales 
est que la Métropole ne dispose pas de code particulier, je suis donc obligé de faire une jointure sur son nom (qui est d'ailleurs 
unique) et le type de zone administrative. Ce code peut donc être utilisé pour toutes zones supra-communales ne disposant pas de code.
*/
MERGE INTO G_GEO.TEMP_ZA_COMMUNES a
    USING(
        SELECT *
        FROM
            (
                SELECT 
                    CASE
                         WHEN d.valeur IN('59247','59332','59650','59173','59356','59257','59566','59133','59056','59470','59550',
                                        '59303','59196','59648','59477','59410','59585','59602','59017','59508','59009','59598',
                                        '59106','59195','59643','59507','59088','59220','59670','59609','59317','59523','59660',
                                        '59275','59044','59343','59350','59011','59487','59208','59346','59146','59013','59360',
                                        '59560','59437','59286','59193','59458','59281','59025','59250','59653','59524','59388',
                                        '59512','59005','59143','59201','59658','59052','59316','59278','59320','59553','59252',
                                        '59457','59051','59128','59611','59163','59368','59421','59339','59599','59098','59152',
                                        '59367','59352','59386','59328','59527','59378','59656','59522','59426','59090','59299',
                                        '59636','59646','59482','59256','59202','59371','59279'
                                    )
                                AND UPPER(k.valeur) = UPPER('Métropole')
                                AND UPPER(p.valeur) = UPPER('Métropole Européenne de Lille')
                            THEN b.objectid
                    END AS fid_commune, 
                    e.objectid AS fid_zone_administrative,
                    k.valeur AS type_zone_administrative,
                    '01/01/2020' AS debut_validite, 
                    '01/01/2999' AS fin_validite
                FROM 
                    -- Sélection des objets dans TA_COMMUNE disposant d'un code INSEE (certifiant que ce sont des communes) et provenant du millésime que l'on vient d'insérer.
                    G_GEO.TA_COMMUNE b 
                    INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE c ON c.fid_commune = b.objectid
                    INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                    INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long
                    INNER JOIN G_GEO.TA_METADONNEE m ON m.objectid = b.fid_metadonnee
                    INNER JOIN G_GEO.TA_SOURCE n ON n.objectid = m.fid_source
                    INNER JOIN G_GEO.TA_DATE_ACQUISITION o ON o.objectid = m.fid_acquisition, 
                    -- Sélection des zones administratives que l'on veut associer aux communes
                    G_GEO.TEMP_ZONE_ADMINISTRATIVE e
                    INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = e.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
                    INNER JOIN G_GEO.TA_NOM p ON p.objectid = e.fid_nom
                WHERE 
                    UPPER(i.valeur) = UPPER('code insee')
                    AND UPPER(n.nom_source) = UPPER('BdTopo')
                    AND o.millesime = TO_DATE('01/01/19', 'dd/mm/yy')
                    AND o.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            )t
        WHERE
            t.fid_commune IS NOT NULL
    )t
ON (a.fid_commune = t.fid_commune AND a.fid_zone_administrative = t.fid_zone_administrative AND a.debut_validite = t.debut_validite AND a.fin_validite = t.fin_validite)
WHEN NOT MATCHED THEN
    INSERT(a.FID_COMMUNE, a.FID_ZONE_ADMINISTRATIVE, a.DEBUT_VALIDITE, a.FIN_VALIDITE)
    VALUES(t.fid_commune, t.fid_zone_administrative, t.debut_validite, t.fin_validite);

-- Suppression des tables d'import
DROP TABLE G_GEO.TEMP_COMMUNES CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TEMP_COMMUNES';

DROP TABLE G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE';

COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_INSERTION_COMMUNES;
END;
/