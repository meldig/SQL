/*
Insertion des communes des Hauts-de-France de la BdTopo de l'IGN en base et création des départements et des régions

1. Création des métadonnées ;
    1.1. Insertion de l'organisme créateur des données ;
    1.2. Insertion de la source des données ;
    1.3. Insertion du millésime, date d'insertion et nom de l'obtenteur des données ;
    1.4. Insertion de la provenance des données ;
    1.5. Insertion des clés étrangères dans la table pivot TA_METADONNEE ;
    1.6. Insertion des clés étrangères dans la table pivot TA_METADONNEE_RELATION_ORGANISME ;
    
2. Création des familles et libelles ;
    2.1. Insertion de toutes les familles requises pour les communes ;
    2.2. Insertion de tous les libelles longs requis pour les communes ;
    2.3. Insertion des clés étrangères dans la table pivot TA_FAMILLE_LIBELLE ;
    2.4. Insertion des clés étrangères dans la table pivot TA_LIBELLE ;
  
3. Création des noms requis pour les communes
    3.1. Insertion des noms des zones supra-communales ;
    3.2. Insertion des noms des communes ;
    
4. Mise en base des codes requis pour les communes
    4.1. Insertion des codes départementaux, régionaux, territoriaux et des unités territoriales ;
    4.2. Insertion des codes INSEE ;
    
5. Création des zones supra-communales, des territoires et des unités territoriales

6. Insertion des géométries des communes dans la table TA_COMMUNE

7. Association des géométries communales avec leur code INSEE

8. Association des géométries communales avec leur nom

9. Association des communes avec leur zone supra-communales respectives
    9.1. Association des communes à leur département d'appartenance ;
    9.2. Associaition des communes à la MEL d'appartenance ;
    9.3. Association des communes à leur région d'appartenance ;
*/


-- 1. Création des métadonnées ;
-- 1.1. Insertion de l'organisme créateur des données ;
/*MERGE INTO G_GEO.TA_ORGANISME a
USING(
    SELECT 
        'IGN' AS acronyme, 
        'Institut National de l''Information Geographie et Forestiere' AS valeur 
    FROM DUAL
    )t
ON (a.acronyme = t.acronyme AND a.nom_organisme = t.valeur)
WHEN NOT MATCHED THEN
    INSERT(a.acronyme, a.nom_organisme)
    VALUES(t.acronyme, t.valeur);
COMMIT;

-- 1.2. Insertion de la source des données ;
MERGE INTO G_GEO.TA_SOURCE a
USING(
    SELECT 
        'BDTOPO' AS nom, 
        'Description vectorielle des elements du territoire francais et de ses infrastructures avec une precision metrique.' AS description 
    FROM DUAL
    )t
ON (a.nom_source = t.nom AND a.description = t.description)
WHEN NOT MATCHED THEN
    INSERT(a.nom_source, a.description)
    VALUES(t.nom, t.description);
COMMIT;

-- 1.3. Insertion du millésime, date d'insertion et nom de l'obtenteur des données ;
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
COMMIT;

-- 1.4. Insertion de la provenance des données ;
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
COMMIT;
    
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
            b.nom_source = 'BDTOPO'
            AND c.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND c.millesime = '01/01/2019'
            AND c.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
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
COMMIT;

-- 1.6. Insertion des clés étrangères dans la table pivot TA_METADONNEE_RELATION_ORGANISME
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
            c.nom_source = 'BDTOPO'
            AND d.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND d.millesime = '01/01/2019'
            AND d.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
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
COMMIT;
*/
-- 2. Création des familles et libelles ;
-- 2.1. Insertion de toutes les familles requises pour les communes ;
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
COMMIT;

-- 2.2. Insertion de tous les libelles longs requis pour les communes ;
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
COMMIT;

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
COMMIT;

-- 2.4. Insertion des clés étrangères dans la table pivot TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
    USING(
        SELECT
            b.objectid AS fid_libelle_long
        FROM
            G_GEO.TA_LIBELLE_LONG b
        WHERE
            b.valeur IN(
                    UPPER('département'),
                    UPPER('région'), 
                    UPPER('commune simple'), 
                    UPPER('commune associée'), 
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
COMMIT;

-- 3. Création des noms requis pour les communes
-- 3.1. Insertion des noms des zones supra-communales ;
--##CORRECTIF - Nom du Territoire Lillois## :
UPDATE G_GEO.TA_NOM
SET VALEUR = 'Territoire Lillois'
WHERE VALEUR = 'Lille-Lomme-Hellemmes';
COMMIT ;

UPDATE G_GEO.TA_NOM
SET VALEUR = 'Marcq en Baroeul-la-Bassee'
WHERE VALEUR = 'La Basse-Marcq en Baroeul';
COMMIT ;
/*
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
    ON (a.valeur = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);
COMMIT;

-- 3.2. Insertion des noms des communes ;
MERGE INTO G_GEO.TA_NOM a
    USING (
            SELECT
                a.NOM
            FROM
                G_GEO.TEMP_COMMUNES a
            WHERE
                a.INSEE_DEP IN('02', '59', '60', '62', '80')
            ) t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);
COMMIT;
*/
-- 4. Mise en base des codes requis pour les communes
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
COMMIT;
/*
-- 4.2. Insertion des codes INSEE ;
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
            AND d.valeur = 'code insee'
    ) t
    ON (a.valeur = t.INSEE_COM AND a.fid_libelle = t.fid_libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.fid_libelle);
COMMIT;

-- 5. Création des zones supra-communales, des territoires et des unités territoriales
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(
        SELECT *
            FROM
                (
                    SELECT
                        CASE
                            WHEN b.valeur IN('Aisne', 'Nord', 'Oise', 'Pas-de-Calais', 'Somme') AND d.valeur = 'département'
                                THEN b.objectid
                            WHEN b.valeur = 'Hauts-de-France' AND d.valeur = 'région'
                                THEN b.objectid
                            WHEN b.valeur IN('Territoire Est', 'Territoire Tourquennois', 'Territoire des Weppes', 'Couronne Nord de Lille', 'Territoire de la Lys', 'Territoire Roubaisien', 'Territoire Lillois', 'Couronne Sud de Lille') AND d.valeur = 'Territoire'
                                THEN b.objectid
                            WHEN b.valeur IN('Tourcoing-Armentières', 'Roubaix-Villeneuve d''Ascq', 'Lille-Seclin', 'Marcq en Baroeul-la-Bassee') AND d.valeur = 'Unité Territoriale'
                                THEN b.objectid
                            WHEN b.valeur = 'Métropole Européenne de Lille' AND d.valeur = 'Métropole'
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
COMMIT;
/*
-- 6. Insertion des géométries des communes dans la table TA_COMMUNE
MERGE INTO G_GEO.TA_COMMUNES a
    USING(
        SELECT a.ORA_GEOMETRY, b.objectid AS fid_libelle, d.objectid AS fid_nom, a.INSEE_COM, f.objectid AS fid_metadonnee
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
                AND g.millesime = '01/01/19'
                AND g.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
                AND c.valeur = 'commune simple'
                AND h.nom_source = 'BDTOPO'
        )t
        ON(
            t.fid_metadonnee <> (SELECT
                                    x.objectid
                                FROM
                                    G_GEO.TA_METADONNEE x
                                    INNER JOIN G_GEO.TA_DATE_ACQUISITION y ON y.objectid = x.fid_acquisition
                                    INNER JOIN G_GEO.TA_SOURCE z ON z.objectid = x.fid_source
                                WHERE
                                    y.millesime = '01/01/19'
                                    AND y.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
                                    AND z.nom_source = 'BDTOPO'
                                )
        )
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.fid_libelle, t.fid_nom, t.fid_metadonnee);
COMMIT;

-- 7. Association des géométries communales avec leur code INSEE

  
-- Insertion dans la table TA_identifiant_commune pour faire le lien entre les géométries et les codes insee des communes
-- Insertion dans TA_IDENTIFIANT_COMMUNE pour l'Aisne
MERGE INTO TA_IDENTIFIANT_COMMUNE a
    USING(SELECT b.objectid AS id_commune, p.valeur AS nom_base, h.nom AS nom_commune, e.objectid AS id_code_insee, e.valeur AS valeur_insee_base, h.INSEE_COM AS valeur_insee_commune
            FROM ta_commune b
                INNER JOIN G_GEO.TA_METADONNEE c ON c.objectid = b.fid_metadonnee
                INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = c.fid_acquisition
                INNER JOIN G_GEO.TA_NOM p ON p.objectid = b.fid_nom, 
                G_GEO.TA_CODE e 
                INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                INNER JOIN COMMUNES_AISNE h ON h.INSEE_COM = e.valeur
            WHERE d.date_acquisition = sysdate AND d.nom_obtenteur = 'bjacq' 
                AND g.valeur = 'code insee' 
                AND SDO_RELATE(b.geom, h.ora_geometry, 'mask=equal') = 'TRUE'
                AND e.valeur LIKE '02%') t
    ON (a.fid_identifiant = t.id_code_insee AND a.fid_commune = t.id_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.id_commune, t.id_code_insee);
 
-- Insertion dans TA_IDENTIFIANT_COMMUNE pour le Nord
MERGE INTO TA_IDENTIFIANT_COMMUNE a
    USING(SELECT b.objectid AS id_commune, p.valeur AS nom_base, h.nom AS nom_commune, e.objectid AS id_code_insee, e.valeur AS valeur_insee_base, h.INSEE_COM AS valeur_insee_commune
            FROM ta_commune b
                INNER JOIN G_GEO.TA_METADONNEE c ON c.objectid = b.fid_metadonnee
                INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = c.fid_acquisition
                INNER JOIN G_GEO.TA_NOM p ON p.objectid = b.fid_nom, 
                G_GEO.TA_CODE e 
                INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                INNER JOIN COMMUNES_NORD h ON h.INSEE_COM = e.valeur
            WHERE d.date_acquisition = sysdate AND d.nom_obtenteur = 'bjacq' 
                AND g.valeur = 'code insee' 
                AND SDO_RELATE(b.geom, h.ora_geometry, 'mask=equal') = 'TRUE'
                AND e.valeur LIKE '59%') t
    ON (a.fid_identifiant = t.id_code_insee AND a.fid_commune = t.id_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.id_commune, t.id_code_insee);
    
-- Insertion dans TA_IDENTIFIANT_COMMUNE pour l'Oise
MERGE INTO TA_IDENTIFIANT_COMMUNE a
    USING(SELECT b.objectid AS id_commune, p.valeur AS nom_base, h.nom AS nom_commune, e.objectid AS id_code_insee, e.valeur AS valeur_insee_base, h.INSEE_COM AS valeur_insee_commune
            FROM ta_commune b
                INNER JOIN G_GEO.TA_METADONNEE c ON c.objectid = b.fid_metadonnee
                INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = c.fid_acquisition
                INNER JOIN G_GEO.TA_NOM p ON p.objectid = b.fid_nom, 
                G_GEO.TA_CODE e 
                INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                INNER JOIN COMMUNES_OISE h ON h.INSEE_COM = e.valeur
            WHERE d.date_acquisition = sysdate AND d.nom_obtenteur = 'bjacq' 
                AND g.valeur = 'code insee' 
                AND SDO_RELATE(b.geom, h.ora_geometry, 'mask=equal') = 'TRUE'
                AND e.valeur LIKE '60%') t
    ON (a.fid_identifiant = t.id_code_insee AND a.fid_commune = t.id_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.id_commune, t.id_code_insee);
    
-- Insertion dans TA_IDENTIFIANT_COMMUNE pour le Pas-de-Calais
MERGE INTO TA_IDENTIFIANT_COMMUNE a
    USING(SELECT b.objectid AS id_commune, p.valeur AS nom_base, h.nom AS nom_commune, e.objectid AS id_code_insee, e.valeur AS valeur_insee_base, h.INSEE_COM AS valeur_insee_commune
            FROM ta_commune b
                INNER JOIN G_GEO.TA_METADONNEE c ON c.objectid = b.fid_metadonnee
                INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = c.fid_acquisition
                INNER JOIN G_GEO.TA_NOM p ON p.objectid = b.fid_nom, 
                G_GEO.TA_CODE e 
                INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                INNER JOIN COMMUNES_PAS_DE_CALAIS h ON h.INSEE_COM = e.valeur
            WHERE d.date_acquisition = sysdate AND d.nom_obtenteur = 'bjacq' 
                AND g.valeur = 'code insee' 
                AND SDO_RELATE(b.geom, h.ora_geometry, 'mask=equal') = 'TRUE'
                AND e.valeur LIKE '62%') t
    ON (a.fid_identifiant = t.id_code_insee AND a.fid_commune = t.id_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.id_commune, t.id_code_insee);
    
-- Insertion dans TA_IDENTIFIANT_COMMUNE pour la Somme
MERGE INTO TA_IDENTIFIANT_COMMUNE a
    USING(SELECT b.objectid AS id_commune, p.valeur AS nom_base, h.nom AS nom_commune, e.objectid AS id_code_insee, e.valeur AS valeur_insee_base, h.INSEE_COM AS valeur_insee_commune
            FROM ta_commune b
                INNER JOIN G_GEO.TA_METADONNEE c ON c.objectid = b.fid_metadonnee
                INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = c.fid_acquisition
                INNER JOIN G_GEO.TA_NOM p ON p.objectid = b.fid_nom, 
                G_GEO.TA_CODE e 
                INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                INNER JOIN G_GEO.TEMP_COMMUNES_SOMME h ON h.INSEE_COM = e.valeur
            WHERE d.date_acquisition = sysdate AND d.nom_obtenteur = 'bjacq' 
                AND g.valeur = 'code insee' 
                AND SDO_RELATE(b.geom, h.ora_geometry, 'mask=equal') = 'TRUE'
                AND e.valeur LIKE '80%') t
    ON (a.fid_identifiant = t.id_code_insee AND a.fid_commune = t.id_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.id_commune, t.id_code_insee);

-- 4. Affectation des communes à leurs départements et région d'appartenance
    
-- Insertion dans la table TA_IDENTIFIANT_ZONE_ADMINISTRATIF
-- Département de l'Aisne
*/

MERGE INTO G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
    SELECT *
    FROM
        (
            SELECT DISTINCT
                    CASE
                        WHEN UPPER(b.valeur) = UPPER('Territoire Est') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '5' AND UPPER(g.valeur = UPPER('Code Territoire')
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
                        WHEN UPPER(b.valeur) = UPPER('Tourcoing-Armentières') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '4' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale'
                            THEN e.objectid
                        /*WHEN UPPER(b.valeur) = UPPER('Aisne') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '02' AND UPPER(g.valeur) = UPPER('code département')
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
                            THEN e.objectid*/
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
COMMIT;

/*-- Insertion dans la table ta_za_communes des communes par département et région
-- Département de l'Aisne
MERGE INTO TA_ZA_COMMUNES a
    USING(
        SELECT 
            b.objectid AS commune, 
            e.objectid AS zone_admin, 
            '01/01/2020' AS debut_validite, 
            '01/01/2999' AS fin_validite  
        FROM ta_commune b
            INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
            INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
            INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
            G_GEO.TA_ZONE_ADMINISTRATIVE e
            INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
            INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
            INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
        WHERE 
            SUBSTR(d.valeur, 0, 2) = '02' 
            AND UPPER(i.valeur) = UPPER('code insee')
            AND g.valeur = '02'
            AND UPPER(k.valeur) = UPPER('code département')
    ) t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
    
-- Département du Nord
MERGE INTO TA_ZA_COMMUNES a
    USING(SELECT b.objectid AS commune, e.objectid AS zone_admin, '01/01/2020' AS debut_validite, '01/01/2999' AS fin_validite  
            FROM ta_commune b
                INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
                INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
                G_GEO.TA_ZONE_ADMINISTRATIVE e
                INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
                INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            WHERE 
                SUBSTR(d.valeur, 0, 2) = '59' 
                AND i.valeur = 'code insee'
                AND g.valeur = '59'
                AND k.valeur = 'code département') t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
    
-- Département de l'Oise
MERGE INTO TA_ZA_COMMUNES a
    USING(SELECT b.objectid AS commune, e.objectid AS zone_admin, '01/01/2020' AS debut_validite, '01/01/2999' AS fin_validite  
            FROM ta_commune b
                INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
                INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
                G_GEO.TA_ZONE_ADMINISTRATIVE e
                INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
                INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            WHERE 
                SUBSTR(d.valeur, 0, 2) = '60' 
                AND i.valeur = 'code insee'
                AND g.valeur = '60'
                AND k.valeur = 'code département') t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
    
-- Département du Pas-de-Calais
MERGE INTO TA_ZA_COMMUNES a
    USING(SELECT b.objectid AS commune, e.objectid AS zone_admin, '01/01/2020' AS debut_validite, '01/01/2999' AS fin_validite  
            FROM ta_commune b
                INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
                INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
                G_GEO.TA_ZONE_ADMINISTRATIVE e
                INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
                INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            WHERE 
                SUBSTR(d.valeur, 0, 2) = '62' 
                AND i.valeur = 'code insee'
                AND g.valeur = '62'
                AND k.valeur = 'code département') t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
    
-- Département de la Somme
MERGE INTO TA_ZA_COMMUNES a
    USING(SELECT b.objectid AS commune, e.objectid AS zone_admin, '01/01/2020' AS debut_validite, '01/01/2999' AS fin_validite  
            FROM ta_commune b
                INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
                INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
                G_GEO.TA_ZONE_ADMINISTRATIVE e
                INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
                INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            WHERE 
                SUBSTR(d.valeur, 0, 2) = '80' 
                AND i.valeur = 'code insee'
                AND g.valeur = '80'
                AND k.valeur = 'code département') t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
    
-- Région Hauts-de-France
MERGE INTO TA_ZA_COMMUNES a
    USING(SELECT b.objectid AS commune, e.objectid AS zone_admin, '01/01/2020' AS debut_validite, '01/01/2999' AS fin_validite  
            FROM ta_commune b
                INNER JOIN ta_identifiant_commune c ON c.fid_commune = b.objectid
                INNER JOIN G_GEO.TA_CODE d ON d.objectid = c.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = d.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long, 
                G_GEO.TA_ZONE_ADMINISTRATIVE e
                INNER JOIN ta_identifiant_zone_administrative f ON f.fid_zone_administrative = e.objectid
                INNER JOIN G_GEO.TA_CODE g ON g.objectid = f.fid_identifiant
                INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = g.fid_libelle
                INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            WHERE 
                i.valeur = 'code insee'
                AND g.valeur = '32'
                AND k.valeur = 'code région') t
    ON (a.fid_zone_administrative = t.zone_admin)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_ZONE_ADMINISTRATIVE, DEBUT_VALIDITE, FIN_VALIDITE)
    VALUES(t.commune, t.zone_admin, t.debut_validite, t.fin_validite);
*/
