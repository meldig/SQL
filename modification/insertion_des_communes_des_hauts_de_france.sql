/*
Insertion des communes des Hauts-de-France de la BdTopo de l'IGN en base et création des départements et des régions

1. Création des départements et de la région des Hauts-de-France ;
	1.1. gestion des types de zones supra-communales ;
	1.2. gestion des codes des zones supra-communales ;
2. Création des métadonnées des communes ;
3. Insertion des communes en base ;
	3.1. gestion des noms ;
	3.2. gestion des codes ;
	3.3. gestion des géométries ;
4. Affectation des communes à leurs départements et région d'appartenance
*/

--1. Création des départements et de la région des Hauts-de-France ;
--1.1. gestion des types de zones supra-communales ;
-- Insertion de la famille des zones supra-communales qui contient les libellés de toutes les zones construites à partir des communes
MERGE INTO G_GEO.TA_FAMILLE a
    USING(SELECT 'zone supra-communale' AS nom FROM DUAL) t
    ON (a.valeur = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);
    
-- Insertion des libelles appartenant à la famille "zones supra-communales" dans la tableG_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(SELECT 'département' AS nom FROM DUAL UNION
            SELECT 'région' AS nom FROM DUAL) t
    ON (a.valeur = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);

-- Insertion des id des famille et libellés dans G_GEO.TA_FAMILLE_LIBELLE

MERGE INTO G_GEO.G_GEO.TA_FAMILLE_LIBELLE a
    USING (
        SELECT
            a.objectid AS id_famille,
            b.objectid AS id_libelle_long
        FROM
            G_GEO.TA_FAMILLE a,
           G_GEO.TA_LIBELLE_LONG b
        WHERE
            b.valeur IN('département', 'région')
            AND a.valeur = 'zone supra-communale'
    )t
    ON (a.fid_famille = t.id_famille AND a.fid_libelle_long = t.id_libelle_long)
WHEN NOT MATCHED
    INSERT (a.fid_famille, a.fid_libelle_long)
    VALUES(t.id_famille, t.id_libelle_long);

-- INSERTION des fid_libelle_long dans G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
USING(SELECT b.objectid FROM G_GEO.TA_LIBELLE_LONG b WHERE b.valeur IN('département', 'région')) t
ON (a.fid_libelle_long = t.objectid)
WHEN NOT MATCHED THEN
    INSERT(a.fid_libelle_long)
    VALUES(t.objectid);
    
-- Insertion des noms des départements dans la table G_GEO.TA_NOM
MERGE INTO G_GEO.TA_NOM a
    USING(SELECT 'Aisne' AS nom FROM DUAL UNION
            SELECT 'Nord' AS nom FROM DUAL UNION
            SELECT 'Oise' AS nom FROM DUAL UNION
            SELECT 'Pas-de-Calais' AS nom FROM DUAL UNION
            SELECT 'Somme' AS nom FROM DUAL)t
    ON (a.valeur = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);
    
-- Insertion du nom de la région Hauts-de-France dans la table G_GEO.TA_NOM
MERGE INTO G_GEO.TA_NOM a
    USING(SELECT 'Hauts-de-France' AS nom FROM DUAL)t
    ON (a.valeur = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.nom);
    
-- Insertion des zone supra-communales dans la table G_GEO.TA_ZONE_ADMINISTRATIVE
--Insertion de la région Hauts-de-France
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS NOM, c.objectid AS LIBELLE
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Hauts-de-France'
                AND d.valeur = 'région') t
    ON (a.fid_nom = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.NOM, t.LIBELLE);

--Insertion du département de l'Aisne
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS nom, c.objectid AS libelle
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Aisne'
                AND d.valeur = 'département') t
    ON (a.fid_nom = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.nom, t.libelle);

--Insertion du département du Nord
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS nom, c.objectid AS libelle
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Nord'
                AND d.valeur = 'département') t
    ON (a.fid_nom = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.nom, t.libelle);
    
--Insertion du département de l'Oise
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS nom, c.objectid AS libelle
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Oise'
                AND d.valeur = 'département') t
    ON (a.fid_nom = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.nom, t.libelle);
    
--Insertion du département du Pas-de-Calais
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS nom, c.objectid AS libelle
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Pas-de-Calais'
                AND d.valeur = 'département') t
    ON (a.fid_nom = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.nom, t.libelle);
    
--Insertion du département du Somme
MERGE INTO G_GEO.TA_ZONE_ADMINISTRATIVE a
    USING(SELECT b.objectid AS nom, c.objectid AS libelle
            FROM G_GEO.TA_NOM b,
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
            WHERE
                b.valeur = 'Somme'
                AND d.valeur = 'département') t
    ON (a.fid_nom = t.nom)
WHEN NOT MATCHED THEN
    INSERT(a.fid_nom, a.fid_libelle)
    VALUES(t.nom, t.libelle);

-- 1.2. gestion des codes des zones supra-communales ;
-- Insertion du libelle code département dans la tableG_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(SELECT 'code département' AS libelle FROM DUAL) t
    ON (a.valeur = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.libelle);

-- Insertion du libelle code région dans la tableG_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(SELECT 'code région' AS libelle FROM DUAL) t
    ON (a.valeur = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.libelle);

-- Insertion dans la table de liaison G_GEO.TA_FAMILLE_LIBELLE pour les départements
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
    USING(SELECT b.objectid AS famille, c.objectid AS libelle 
            FROM G_GEO.TA_FAMILLE b,G_GEO.TA_LIBELLE_LONG c
            WHERE b.valeur = 'Identifiants de zone administrative' AND c.valeur = 'code département') t
    ON (a.fid_famille = t.famille AND a.fid_libelle_long = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.fid_famille, a.fid_libelle_long)
    VALUES(t.famille, t.libelle);
    
-- Insertion dans la table de liaison G_GEO.TA_FAMILLE_LIBELLE pour les régions
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
    USING(SELECT b.objectid AS famille, c.objectid AS libelle 
            FROM G_GEO.TA_FAMILLE b,G_GEO.TA_LIBELLE_LONG c
            WHERE b.valeur = 'Identifiants de zone administrative' AND c.valeur = 'code région') t
    ON (a.fid_famille = t.famille AND a.fid_libelle_long = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.fid_famille, a.fid_libelle_long)
    VALUES(t.famille, t.libelle);
    
-- Insertion des fid_libelle_long dans la table G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
    USING (SELECT b.objectid AS libelle
           FROM G_GEO.TA_LIBELLE_LONG b
            WHERE b.valeur IN('code département', 'code région')) t
    ON (a.fid_libelle_long = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.fid_libelle_long)
    VALUES(t.libelle);

-- Insertion des codes départementaux et du code régional dans la table G_GEO.TA_CODE
-- Département de l'Aisne
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '02' AS code, b.objectid AS libelle, c.valeur
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code département') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);

-- Département du Nord
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '59' AS code, b.objectid AS libelle
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code département') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);
    
-- Département de l'Oise
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '60' AS code, b.objectid AS libelle
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code département') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);
    
-- Département du Pas-de-Calais
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '62' AS code, b.objectid AS libelle
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code département') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);
    
-- Département de la Somme
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '80' AS code, b.objectid AS libelle
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code département') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);
    
-- Région des Hauts-de-France
MERGE INTO G_GEO.TA_CODE a
    USING(SELECT '32' AS code, b.objectid AS libelle
            FROM G_GEO.TA_LIBELLE b 
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
            WHERE c.valeur = 'code région') t
    ON (a.valeur = t.code)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, fid_libelle)
    VALUES(t.code, t.libelle);

--2. Création des métadonnées des communes ;
-- Insertion de la date d'import des données en base
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
    USING(
        SELECT 
            TO_DATE(sysdate, 'dd/mm/yy') AS date_insertion, 
            '01/01/2019' AS date_millesime,
            sys_context('USERENV','OS_USER') AS nom_obtenteur 
        FROM DUAL)t
    ON (
            a.date_acquisition = t.date_insertion 
            AND a.millesime = t.date_millesime
            AND a.nom_obtenteur = t.nom_obtenteur
        )
WHEN NOT MATCHED THEN
    INSERT (a.date_acquisition, a.millesime, a.nom_obtenteur)
    VALUES(t.date_insertion, t.date_millesime, t.nom_obtenteur);

-- Insertion de la nouvelle métadonnée
MERGE INTO G_GEO.TA_METADONNEE a
    USING (SELECT b.objectid AS source, c.objectid AS acquisition, d.objectid AS provenance
            FROM G_GEO.TA_SOURCE b, G_GEO.TA_DATE_ACQUISITION c, ta_provenance d 
            WHERE b.nom_source = 'BDTOPO' AND c.date_acquisition = sysdate AND d.objectid = 1 AND c.nom_obtenteur = 'bjacq') t
    ON (a.fid_acquisition = t.acquisition)
WHEN NOT MATCHED THEN
    INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
    VALUES(t.source, t.acquisition, t.provenance);

--3. Insertion des communes en base ;
--3.1. gestion des noms ;

-- Insertion des noms des communes dans la table G_GEO.TA_NOM
-- Communes de l'Aisne
MERGE INTO G_GEO.TA_NOM a
    USING (SELECT NOM FROM G_GEO.COMMUNES_AISNE WHERE SUBSTR(INSEE_COM, 0, 2) = '02') t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);

-- Communes du Nord
MERGE INTO G_GEO.TA_NOM a
    USING (SELECT NOM FROM G_GEO.COMMUNES_NORD WHERE SUBSTR(INSEE_COM, 0, 2) = '59') t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);
    
-- Communes de l'Oise
MERGE INTO G_GEO.TA_NOM a
    USING (SELECT NOM FROM G_GEO.COMMUNES_OISE WHERE SUBSTR(INSEE_COM, 0, 2) = '60') t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);
    
-- Communes du Pas-de-Calais
MERGE INTO G_GEO.TA_NOM a
    USING (SELECT NOM FROM G_GEO.COMMUNES_PAS_DE_CALAIS WHERE SUBSTR(INSEE_COM, 0, 2) = '62') t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);
    
-- Communes de la somme
MERGE INTO G_GEO.TA_NOM a
    USING (SELECT NOM FROM G_GEO.TEMP_COMMUNES_SOMME WHERE SUBSTR(INSEE_COM, 0, 2) = '80') t
    ON (a.valeur = t.NOM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.NOM);
 
-- 3.2. gestion des codes ;
-- Communes de l'Aisne
MERGE INTO G_GEO.TA_CODE a
    USING (SELECT b.INSEE_COM, c.objectid 
            FROM G_GEO.COMMUNES_AISNE  b, 
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long 
            WHERE SUBSTR(b.INSEE_COM, 0, 2) = '02' AND d.valeur = 'code insee') t
    ON (a.valeur = t.INSEE_COM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.objectid);

-- Communes du Nord
MERGE INTO G_GEO.TA_CODE a
    USING (SELECT b.INSEE_COM, c.objectid 
            FROM G_GEO.COMMUNES_NORD  b, 
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long 
            WHERE SUBSTR(b.INSEE_COM, 0, 2) = '59' AND d.valeur = 'code insee') t
    ON (a.valeur = t.INSEE_COM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.objectid);
    
-- Communes de l'Oise
MERGE INTO G_GEO.TA_CODE a
    USING (SELECT b.INSEE_COM, c.objectid 
            FROM G_GEO.COMMUNES_OISE  b, 
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long 
            WHERE SUBSTR(b.INSEE_COM, 0, 2) = '60' AND d.valeur = 'code insee') t
    ON (a.valeur = t.INSEE_COM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.objectid);
    
-- Communes du Pas-de-Calais
MERGE INTO G_GEO.TA_CODE a
    USING (SELECT b.INSEE_COM, c.objectid 
            FROM G_GEO.COMMUNES_PAS_DE_CALAIS  b, 
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long 
            WHERE SUBSTR(b.INSEE_COM, 0, 2) = '62' AND d.valeur = 'code insee') t
    ON (a.valeur = t.INSEE_COM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.objectid);
    
-- Communes de la somme
MERGE INTO G_GEO.TA_CODE a
    USING (SELECT b.INSEE_COM, c.objectid 
            FROM G_GEO.TEMP_COMMUNES_SOMME  b, 
                G_GEO.TA_LIBELLE c 
                INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long 
            WHERE SUBSTR(b.INSEE_COM, 0, 2) = '80' AND d.valeur = 'code insee') t
    ON (a.valeur = t.INSEE_COM)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.objectid);
    
--3.3. gestion des géométries ;
-- Communes de l'Aisne
MERGE INTO G_GEO.TA_COMMUNE a
    USING(SELECT a.ORA_GEOMETRY, b.objectid AS libelle, d.objectid AS fid_nom, a.INSEE_COM, f.objectid AS metadonnee
    FROM 
        G_GEO.TEMP_COMMUNES_SOMME a
        INNER JOIN G_GEO.TA_NOM d ON d.valeur = a.nom,
        G_GEO.TA_LIBELLE b
        INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid,
        G_GEO.TA_METADONNEE f 
        INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
        INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source
    WHERE 
        SUBSTR(a.INSEE_COM, 0, 2) = '02'
        AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        AND g.nom_obtenteur = 'bjacq'
        AND c.valeur = 'commune simple'
        AND h.nom_source = 'BDTOPO') t
ON(
        t.insee_com IN(
                        SELECT DISTINCT y.valeur
                        FROM
                            G_GEO.TA_CODE y
                            INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE u ON u.fid_identifiant = y.objectid
                            INNER JOIN G_GEO.TA_COMMUNE x ON x.objectid = u.fid_commune
                            INNER JOIN G_GEO.TA_LIBELLE z ON z.objectid = y.fid_libelle
                            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = z.fid_libelle_long
                        WHERE
                            e.valeur = 'code insee'
                            AND SUBSTR(y.valeur, 1,2) = 02
        ) 
    AND 
    a.fid_metadonnee = t.metadonnee
)
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.libelle, t.fid_nom, t.metadonnee);
---------------------------------------    
-- Communes du Nord
MERGE INTO G_GEO.TA_COMMUNE a
    USING(SELECT a.ORA_GEOMETRY, i.objectid AS libelle, a.INSEE_COM, f.objectid AS metadonnee
    FROM 
        G_GEO.COMMUNES_Nord a
        INNER JOIN G_GEO.TA_CODE b ON b.valeur = a.insee_com
        INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = b.fid_libelle
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
        G_GEO.TA_METADONNEE f 
        INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
        INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source,
        G_GEO.TA_LIBELLE i
        INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
    WHERE 
        a.INSEE_DEP = '59'
        AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        AND g.millesime = '01/01/19'
        AND d.valeur = 'code insee'
        AND h.nom_source = 'BDTOPO'
        AND j.valeur = 'commune simple'
    ) t
ON(
        t.insee_com IN(
                        SELECT DISTINCT y.valeur
                        FROM
                            G_GEO.TA_CODE y
                            INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE u ON u.fid_identifiant = y.objectid
                            INNER JOIN G_GEO.TA_COMMUNE x ON x.objectid = u.fid_commune
                            INNER JOIN G_GEO.TA_LIBELLE z ON z.objectid = y.fid_libelle
                            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = z.fid_libelle_long
                        WHERE
                            e.valeur = 'code insee'
                            AND SUBSTR(y.valeur, 1,2) = 59
        ) 
    AND 
    a.fid_metadonnee = t.metadonnee
)
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.libelle, t.fid_nom, t.metadonnee);
    
-- Communes de l'Oise
MERGE INTO G_GEO.TA_COMMUNE a
    USING(SELECT a.ORA_GEOMETRY, i.objectid AS libelle, a.INSEE_COM, f.objectid AS metadonnee
    FROM 
        G_GEO.COMMUNES_OISE a
        INNER JOIN G_GEO.TA_CODE b ON b.valeur = a.insee_com
        INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = b.fid_libelle
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
        G_GEO.TA_METADONNEE f 
        INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
        INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source,
        G_GEO.TA_LIBELLE i
        INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
    WHERE 
        a.INSEE_DEP = '60'
        AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        AND g.millesime = '01/01/19'
        AND d.valeur = 'code insee'
        AND h.nom_source = 'BDTOPO'
        AND j.valeur = 'commune simple'
    ) t
ON(
        t.insee_com IN(
                        SELECT DISTINCT y.valeur
                        FROM
                            G_GEO.TA_CODE y
                            INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE u ON u.fid_identifiant = y.objectid
                            INNER JOIN G_GEO.TA_COMMUNE x ON x.objectid = u.fid_commune
                            INNER JOIN G_GEO.TA_LIBELLE z ON z.objectid = y.fid_libelle
                            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = z.fid_libelle_long
                        WHERE
                            e.valeur = 'code insee'
                            AND SUBSTR(y.valeur, 1,2) = 60
        ) 
    AND 
    a.fid_metadonnee = t.metadonnee
)
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.libelle, t.fid_nom, t.metadonnee);
    
-- Communes du Pas-de-Calais
MERGE INTO G_GEO.TA_COMMUNE a
    USING(SELECT a.ORA_GEOMETRY, i.objectid AS libelle, a.INSEE_COM, f.objectid AS metadonnee
    FROM 
        G_GEO.COMMUNES_PAS_DE_CAlAIS a
        INNER JOIN G_GEO.TA_CODE b ON b.valeur = a.insee_com
        INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = b.fid_libelle
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
        G_GEO.TA_METADONNEE f 
        INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
        INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source,
        G_GEO.TA_LIBELLE i
        INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
    WHERE 
        a.INSEE_DEP = '62'
        AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        AND g.millesime = '01/01/19'
        AND d.valeur = 'code insee'
        AND h.nom_source = 'BDTOPO'
        AND j.valeur = 'commune simple'
    ) t
ON(
        t.insee_com IN(
                        SELECT DISTINCT y.valeur
                        FROM
                            G_GEO.TA_CODE y
                            INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE u ON u.fid_identifiant = y.objectid
                            INNER JOIN G_GEO.TA_COMMUNE x ON x.objectid = u.fid_commune
                            INNER JOIN G_GEO.TA_LIBELLE z ON z.objectid = y.fid_libelle
                            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = z.fid_libelle_long
                        WHERE
                            e.valeur = 'code insee'
                            AND SUBSTR(y.valeur, 1,2) = 62
        ) 
    AND 
    a.fid_metadonnee = t.metadonnee
)
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.libelle, t.fid_nom, t.metadonnee);
    
-- Communes de la somme
MERGE INTO G_GEO.TA_COMMUNE a
    USING(SELECT a.ORA_GEOMETRY, i.objectid AS libelle, a.INSEE_COM, f.objectid AS metadonnee
    FROM 
        G_GEO.COMMUNES_SOMME a
        INNER JOIN G_GEO.TA_CODE b ON b.valeur = a.insee_com
        INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = b.fid_libelle
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
        G_GEO.TA_METADONNEE f 
        INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
        INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source,
        G_GEO.TA_LIBELLE i
        INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
    WHERE 
        a.INSEE_DEP = '80'
        AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        AND g.millesime = '01/01/19'
        AND d.valeur = 'code insee'
        AND h.nom_source = 'BDTOPO'
        AND j.valeur = 'commune simple'
    ) t
ON(
        t.insee_com IN(
                        SELECT DISTINCT y.valeur
                        FROM
                            G_GEO.TA_CODE y
                            INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE u ON u.fid_identifiant = y.objectid
                            INNER JOIN G_GEO.TA_COMMUNE x ON x.objectid = u.fid_commune
                            INNER JOIN G_GEO.TA_LIBELLE z ON z.objectid = y.fid_libelle
                            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = z.fid_libelle_long
                        WHERE
                            e.valeur = 'code insee'
                            AND SUBSTR(y.valeur, 1,2) = 80
        ) 
    AND 
    a.fid_metadonnee = t.metadonnee
)
WHEN NOT MATCHED THEN
    INSERT(geom, fid_lib_type_commune, fid_nom, fid_metadonnee)
    VALUES(t.ORA_GEOMETRY, t.libelle, t.fid_nom, t.metadonnee);
    
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

--4. Affectation des communes à leurs départements et région d'appartenance
    
-- Insertion dans la table TA_IDENTIFIANT_ZONE_ADMINISTRATIF
-- Département de l'Aisne
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Aisne'
            AND f.valeur = 'code département'
            AND d.valeur = '02') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);

-- Département du Nord
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Nord'
            AND f.valeur = 'code département'
            AND d.valeur = '59') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);
    
-- Département de l'Oise
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Oise'
            AND f.valeur = 'code département'
            AND d.valeur = '60') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);
    
-- Département du Pas-de-Calais
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Pas-de-Calais'
            AND f.valeur = 'code département'
            AND d.valeur = '62') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);
    
-- Département de la Somme
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Somme'
            AND f.valeur = 'code département'
            AND d.valeur = '80') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);
    
-- Région Hauts-de-France
MERGE INTO TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
        SELECT
            b.objectid AS id_zone_admin,
            c.valeur AS nom_zone_admin,
            d.objectid AS id_code,
            d.valeur AS valeur_code
        FROM
            G_GEO.TA_ZONE_ADMINISTRATIVE b
            INNER JOIN G_GEO.TA_NOM c ON c.objectid = b.fid_nom,
            G_GEO.TA_CODE d
            INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = d.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
        WHERE
            c.valeur = 'Hauts-de-France'
            AND f.valeur = 'code région'
            AND d.valeur = '32') t
ON (a.fid_zone_administrative = t.id_zone_admin AND a.fid_identifiant = t.id_code)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);

-- Insertion dans la table ta_za_communes des communes par département et région
-- Département de l'Aisne
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
                SUBSTR(d.valeur, 0, 2) = '02' 
                AND i.valeur = 'code insee'
                AND g.valeur = '02'
                AND k.valeur = 'code département') t
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
