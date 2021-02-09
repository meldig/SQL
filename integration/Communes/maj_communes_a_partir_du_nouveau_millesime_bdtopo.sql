/*
Objectif : insérer le nouveau millésime de la BdTopo.
*/

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_MAJ_COMMUNES;

-- 1. Insérer une nouvelle métadonnées
-- 1.1. Insertion du millésime, date d'insertion et nom de l'obtenteur des données dans TA_DATE_ACQUISITION ;
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
    USING(
        SELECT 
            TO_DATE(sysdate, 'dd/mm/yy') AS date_insertion, 
            '01/01/2020' AS date_millesime,
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


-- 1.2. Insertion de la provenance des données dans TA_PROVENANCE ;
MERGE INTO G_GEO.TA_PROVENANCE a
    USING(
        SELECT 
            'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-topo' AS url,
            'La BdTopo est diffusée librement depuis le 01/01/2021, conformément à la licence Etalab 2.0. la BdTopo a donc été téléchargée depuis le site de l''IGN, sans demande préalable.' AS methode
        FROM
            DUAL
    )t
    ON(
        a.url = t.url AND a.methode_acquisition = t.methode
    )
WHEN NOT MATCHED THEN
    INSERT(a.url, a.methode_acquisition)
    VALUES(t.url, t.methode);

    
-- 1.3. Insertion des clés étrangères dans la table pivot TA_METADONNEE ;
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
            AND c.millesime = '01/01/2020'
            AND c.nom_obtenteur = sys_context('USERENV','OS_USER')
            AND d.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-topo'
            AND d.methode_acquisition = 'La BdTopo est diffusée librement depuis le 01/01/2021, conformément à la licence Etalab 2.0. la BdTopo a donc été téléchargée depuis le site de l''IGN, sans demande préalable.'
    )t
    ON(
        a.fid_source = t.fid_source 
        AND a.fid_acquisition = t.fid_acquisition
        AND a.fid_provenance = t.fid_provenance
    )
WHEN NOT MATCHED THEN
    INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
    VALUES(t.fid_source, t.fid_acquisition, t.fid_provenance);


-- 1.4. Insertion des clés étrangères dans la table pivot TA_METADONNEE_RELATION_ORGANISME ;
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
            AND d.millesime = '01/01/2020'
            AND d.nom_obtenteur = sys_context('USERENV','OS_USER')
            AND e.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-topo'
            AND e.methode_acquisition = 'La BdTopo est diffusée librement depuis le 01/01/2021, conformément à la licence Etalab 2.0. la BdTopo a donc été téléchargée depuis le site de l''IGN, sans demande préalable.'
            AND f.acronyme = 'IGN'
    )t
    ON (
        a.fid_metadonnee = t.fid_metadonnee
        AND a.fid_organisme = t.fid_organisme
    )
WHEN NOT MATCHED THEN
    INSERT (a.fid_metadonnee, a.fid_organisme)
    VALUES (t.fid_metadonnee, t.fid_organisme);

-- 2. Insertion dans TA_COMMUNE
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
            --AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND g.millesime = TO_DATE('01/01/20', 'dd/mm/yy')
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

-- 3. Insertion dans TA_IDENTIFIANT_COMMUNE
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
            AND g.millesime = TO_DATE('01/01/20', 'dd/mm/yy')
            --AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND UPPER(j.valeur) = UPPER('Code INSEE')
            AND h.valeur = a.INSEE_COM
    ) t
    ON (a.fid_identifiant = t.fid_identifiant AND a.fid_commune = t.fid_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.fid_commune, t.fid_identifiant);

-- Insertion dans TA_ZA_COMMUNES
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
                                        '59648','59609', '59011', '59005', '59052', '59133', '59477'
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
                    '01/01/2021' AS debut_validite, 
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
                    AND o.millesime = TO_DATE('01/01/20', 'dd/mm/yy')
                    --AND o.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
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
    
-- Clôture de la validité des données de l'ancien millésime afin que les zones supra-communales soient construites à partir de la BdTopo la plus récente
UPDATE G_GEO.TA_ZA_COMMUNES
SET fin_validite = '31/12/2020'
WHERE
    fid_commune IN(
SELECT
    c.objectid
FROM
    -- Communes de la MEL
    G_GEO.TA_CODE a
    INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE b ON b.fid_identifiant = a.objectid
    INNER JOIN G_GEO.TA_COMMUNE c ON c.objectid = b.fid_commune
    INNER JOIN G_GEO.TA_NOM d ON d.objectid = c.fid_nom
    INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = a.fid_libelle
    INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
    INNER JOIN G_GEO.TA_ZA_COMMUNES g ON g.fid_commune = c.objectid
    INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = c.fid_lib_type_commune
    INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
    -- MTD -> Les commentaires de cette partie de FROM seront enlevés une fois les correctifs appliqués en prod
    INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = c.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition
WHERE
    UPPER(f.valeur) = UPPER('code insee')
    AND UPPER(k.valeur) = UPPER('commune simple')
    AND UPPER(m.nom_source) = UPPER('bdtopo')
    AND UPPER(o.acronyme) = UPPER('ign')
    AND p.millesime = '01/01/2019'
    AND g.debut_validite = '01/01/2020'
);
COMMIT;
-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_MAJ_COMMUNES;
END;