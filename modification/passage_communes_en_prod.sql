/*
Insertion des données relatives aux communes en base.

Organisation du fichier :
1. Insertion des communes ;
2. Insertion dans les tables de métadonnées, versionnement, provenance... ;
3. Insertion des familles et des libelles des communes ;
4. Insertion des types de codes dans ta_famille et ta_libelle ;
5. Insertion des communes ;
6. Création des zones supra-communales ;
7. Création des Unité Territoriales ;
8. Création des Territoires ;
*/

-- 1. Insertion des communes
-- 1.1. Insertion des communes de la bdtopo dans une table temporaire de la base via Ogr2ogr
/*bin\ogr2ogr.exe -f OCI -sql "SELECT INSEE_COM, CODE_POST, NOM FROM COMMUNE WHERE INSEE_COM IN('59670', '59202', '59275', '59279', '59320', '59356', '59009', '59609', '59458', '59017', '59056', '59146', '59173', '59278', '59332', '59339', '59367', '59368', '59437', '59550', '59560', '59602', '59611', '59650', '59025', '59220', '59281', '59286', '59386', '59507', '59512', '59522', '59598', '59371', '59051', '59106', '59128', '59201', '59250', '59299', '59346', '59421', '59585', '59599', '59636', '59643', '59660', '59257', '59487', '59196', '59247', '59252', '59352', '59426', '59457', '59524', '59553', '59656', '59088', '59013', '59163', '59303', '59316', '59317', '59378', '59388', '59410', '59566', '59098', '59143', '59208', '59256', '59328', '59470', '59527', '59646', '59653', '59044', '59090', '59152', '59193', '59195', '59343', '59350', '59360', '59482', '59508', '59523', '59648', '59658', '59524', '59011', '59005', '59052', '59133', '59477')" OCI:nom_schema/mot_de_passe@instance O:\Donnees\Externe\IGN\BD_TOPO\2019\BDTOPO_3-0_D059_2019-12-16\donnees\ADMINISTRATIF\COMMUNE.shp -lco SRID=2154 
*/



-- 2. Insertion dans les tables de métadonnées, versionnement, provenance...
-- 2.1. Insertion dans ta_organisme
INSERT INTO ta_organisme(acronyme, nom_organisme)
VALUES('IGN', 'Institut National de l''Information Geographie et Forestiere');
COMMIT;

-- 2.2. Insertion dans ta_source
INSERT INTO ta_source(nom_source, description)
VALUES('BDTOPO', 'Description vectorielle des elements du territoire francais et de ses infrastructures avec une precision metrique.');
COMMIT;

-- 2.3. Insertion dans ta_provenance
INSERT INTO ta_provenance(url, methode_acquisition)
VALUES('https://geoservices.ign.fr/documentation/diffusion/index.html', 'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.');
COMMIT;

-- 2.4. Insertion dans ta_date_acquisition
INSERT INTO ta_date_acquisition(date_acquisition, millesime, nom_obtenteur)
VALUES('17/02/2020', '01/01/2019', 'bjacq');
COMMIT;

-- 2.5. Insertion dans ta_metadonnee
INSERT INTO ta_metadonnee(fid_source, fid_acquisition, fid_provenance, fid_organisme)
SELECT
	MAX(a.objectid),
	MAX(b.objectid),
	MAX(c.objectid),
	MAX(d.objectid)
FROM
	ta_source a,
	ta_date_acquisition b,
	ta_provenance c,
	ta_organisme d;
COMMIT;

-- 3. Insertion des familles et des libelles des communes
-- 3.1. Insertion dans ta_famille
INSERT INTO ta_famille(famille)
VALUES('types de commune');
COMMIT;

-- 3.2. Insertion dans ta_famille
INSERT INTO ta_libelle(libelle)
VALUES('commune simple');
COMMIT;

INSERT INTO ta_libelle(libelle)
VALUES('commune associée');
COMMIT;

-- 3.3. Insertion dans ta_famille_libelle (table de liaison entre ta_famille et ta_libelle)
INSERT INTO ta_famille_libelle(fid_libelle, fid_famille)
SELECT
	a.objectid,
	b.objectid
FROM
	ta_libelle a,
	ta_famille b;
COMMIT;

-- 4. Insertion des types de codes dans ta_famille et ta_libelle
-- 4.1. Insertion dans ta_famille
INSERT INTO ta_famille(famille)
VALUES('Identifiants de zone administrative');
COMMIT;

-- 4.2. Insertion dans ta_libelle
INSERT INTO ta_libelle(libelle)
VALUES('code insee');
COMMIT;

INSERT INTO ta_libelle(libelle)
VALUES('code postal');
COMMIT;

-- 5. Insertion des communes dans la base
-- 5.1. Insertion des codes dans ta_code
INSERT INTO ta_code(code, fid_libelle)
SELECT
	a.insee_com,
	b.objectid
FROM
	commune a,
	ta_libelle b
WHERE
	b.libelle = 'code insee';
COMMIT;

INSERT INTO ta_code(code, fid_libelle)
SELECT DISTINCT
	a.code_post,
	b.objectid
FROM
	commune a,
	ta_libelle b
WHERE
	b.libelle = 'code postal';
COMMIT;

-- 5.2. Insertion des noms dans ta_nom
INSERT INTO ta_nom(nom)
SELECT
	nom
FROM
	commune
COMMIT;

-- 5.3. Insertion des géométries dans ta_commune
INSERT INTO ta_commune(geom, fid_lib_type_commune, fid_metadonnee, fid_nom)
SELECT
	a.ora_geometry,
	b.objectid,
	c.objectid,
	d.objectid
FROM
	ta_libelle b,
	ta_metadonnee c,
	commune a
	INNER JOIN ta_nom d ON a.nom = d.nom
WHERE
	b.libelle = 'commune simple';
COMMIT;

-- 5.4. insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes postaux (normalement il y a 63 codes postaux uniques)
INSERT INTO ta_identifiant_commune(fid_commune, fid_identifiant)
SELECT
    a.objectid,
    d.objectid
FROM
    ta_commune a
    INNER JOIN ta_nom b ON a.fid_nom = b.objectid
    INNER JOIN commune c ON b.nom = c.nom
    INNER JOIN ta_code d ON c.code_post = d.code
    INNER JOIN ta_libelle e ON d.fid_libelle = e.objectid
WHERE 
	e.libelle = 'code postal';
COMMIT;

-- 5.5. insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes insee
INSERT INTO ta_identifiant_commune(fid_commune, fid_identifiant)
SELECT
    a.objectid,
    d.objectid
FROM
    ta_commune a
    INNER JOIN ta_nom b ON a.fid_nom = b.objectid
    INNER JOIN commune c ON b.nom = c.nom
    INNER JOIN ta_code d ON c.insee_com = d.code
	INNER JOIN ta_libelle e ON d.fid_libelle = e.objectid
WHERE 
	e.libelle = 'code insee';
COMMIT;

-- 6. Création des zones supra-communales
-- 6.1. Insertion dans la table ta_famille
INSERT INTO ta_famille(famille)
VALUES('Etablissements de Coopération Intercommunale (EPCI)');
COMMIT;

-- 6.2. Insertion dans la table ta_libelle
INSERT INTO ta_libelle(libelle)
VALUES('Etablissements de Coopération Intercommunale (EPCI)');
COMMIT;

-- 6.3. Insertion dans la table ta_famille_libelle
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_famille a,
    ta_libelle b
WHERE
    a.famille = 'Etablissements de Coopération Intercommunale (EPCI)'
    AND b.libelle = 'Métropole';
COMMIT;

-- 6.4. Insertion dans la table ta_nom
INSERT INTO ta_nom(acronyme, nom)
VALUES('MEL', 'Métropole Européenne de Lille');
COMMIT;

-- 6.5. Insertion dans la table ta_zone_administrative
INSERT INTO ta_zone_administrative(fid_nom, fid_libelle)
SELECT
	MAX(a.objectid),
	MAX(b.objectid)
FROM
	ta_nom a,
	ta_libelle b;
COMMIT;

-- 6.6. Insertion dans la table de liaison ta_za_communes pour les 95 communes de la MEL
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
	a.objectid,
	b.objectid,
	'01/01/2020',
	'01/01/2999'
FROM
	ta_commune a,
	ta_zone_administrative b;
COMMIT;

-- 6.7. Insertion dans la table de liaison ta_za_communes pour les 90 communes de la MEL
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
	a.objectid,
	b.objectid,
	'01/01/2017',
	'31/12/2019'
FROM
	ta_zone_administrative b,
	ta_commune a
	INNER JOIN ta_identifiant_commune c ON a.objectid = c.fid_commune
	INNER JOIN ta_code d ON c.fid_identifiant = d.objectid
	INNER JOIN ta_libelle e ON d.fid_libelle = e.objectid
WHERE
	e.libelle = 'code insee'
	AND d.code NOT IN('59011', '59005', '59052', '59133', '59477');
COMMIT;

-- 6.8. Suppression de la table temporaire "COMMUNE"
DROP TABLE COMMUNE CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'COMMUNE';
COMMIT;

-- 7. Création des Unités Territoriales
-- 7.1. Insertion dans la table ta_famille
INSERT INTO ta_famille(famille)
VALUES('Division territoriale de la MEL');
COMMIT;
INSERT INTO ta_famille(famille)
VALUES('Identifiants des divisions territoriales de la MEL');
COMMIT;

-- 7.2. Insertion dans la table ta_libelle
INSERT INTO ta_libelle(libelle)
VALUES('Unité Territoriale');
COMMIT;
INSERT INTO ta_libelle(libelle)
VALUES('Code Unité Territoriale');
COMMIT;

-- 7.3. Insertion dans ta_famille_libelle (table de liaison entre ta_famille et ta_libelle)
-- 7.3.1. Liaison des libellés avec la famille 'Division territoriale de la MEL'
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
	a.objectid,
	b.objectid
FROM
	ta_famille a,
	ta_libelle b	
WHERE
	a.famille = 'Division territoriale de la MEL'
	AND b.libelle = 'Unité Territoriale';
COMMIT;

-- 7.3.2. Liaison des libellés avec la famille "Identifiants des divisions territoriales de la MEL"
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
	a.objectid,
	b.objectid
FROM
	ta_famille a,
	ta_libelle b	
WHERE
	a.famille = 'Identifiants des divisions territoriales de la MEL'
	AND b.libelle = 'Code Unité Territoriale';
COMMIT;

-- 7.4. Insertion dans la table ta_nom des noms des Unités Territoriales
INSERT INTO ta_nom(nom)
WITH
    v_1 AS(
    SELECT 'Tourcoing-Armentières' FROM DUAL
    UNION
    SELECT 'Roubaix-Villeneuve d''Ascq' FROM DUAL
    UNION
    SELECT 'Lille-Seclin' FROM DUAL
    UNION
    SELECT 'Marcq en Baroeul-la-Bassee' FROM DUAL
    )
SELECT * FROM v_1;
COMMIT;

-- 7.5. Insertion des codes des Unités Territoriales
INSERT INTO ta_code(code, fid_libelle)
WITH
    v_1 AS(
    SELECT '1' AS code FROM DUAL
    UNION
    SELECT '2' AS code FROM DUAL
    UNION
    SELECT '3' AS code FROM DUAL
    UNION
    SELECT '4' AS code FROM DUAL
    )
SELECT 
    a.code,
    b.objectid
FROM 
    v_1 a,
    ta_libelle b
WHERE
    b.libelle = 'Code Unité Territoriale';
COMMIT;

-- 7.6. Insertion des Unités Territoriales dans la table ta_zone_administrative
INSERT INTO ta_zone_administrative(fid_nom, fid_libelle)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_nom a,
    ta_libelle b
WHERE
    a.nom IN ('Tourcoing-Armentières', 'Roubaix-Villeneuve d''Ascq', 'Lille-Seclin', 'Marcq en Baroeul-la-Bassee')
    AND b.libelle = 'Unité Territoriale';
COMMIT;

-- 7.8. Insertion dans la table de liaison ta_identifiant_zone_administrative pour faire la liaison entre les Unités Territoriales et leur code
INSERT INTO ta_identifiant_zone_administrative(fid_zone_administrative, fid_identifiant)
WITH
    -- Sélection des objectid des noms d'Unité Territoriale
    v_nom AS(
    SELECT
        CASE a.nom
            WHEN 'Lille-Seclin' THEN a.objectid
            WHEN 'Marcq en Baroeul-la-Bassee' THEN a.objectid
            WHEN 'Roubaix-Villeneuve d''Ascq' THEN a.objectid
            WHEN 'Tourcoing-Armentières' THEN a.objectid
        END AS id_nom,
        a.nom
    FROM
        ta_nom a
    ),
    
    -- Vérification qu'il s'agit de zones administratives
    v_za AS( 
    SELECT
        CASE a.fid_nom
            WHEN b.id_nom THEN a.objectid
        END AS id_za,
        a.fid_libelle,
        b.nom
    FROM
        ta_zone_administrative a
        INNER JOIN v_nom b ON b.id_nom = a.fid_nom
    ),

    -- Vérification qu'il s'agit d'Unités Territoriales
    v_ut AS(
    SELECT
        CASE
            WHEN a.fid_libelle = b.objectid AND b.libelle = 'Unité Territoriale' THEN a.id_za
        END AS id_ut,
        a.nom
    FROM
        v_za a
        INNER JOIN ta_libelle b ON a.fid_libelle = b.objectid
    ),

    -- Sélection des objectid des codes des Unités Territoriales
    v_code AS(
    SELECT
        CASE a.code
            WHEN '1' THEN a.objectid
            WHEN '2' THEN a.objectid
            WHEN '3' THEN a.objectid
            WHEN '4' THEN a.objectid
        END AS id_code,
        a.code,
        a.fid_libelle
    FROM
        ta_code a
    ),

    -- vérification qu'il s'agit bien de code d'Unités Territoriales
    v_code_ut AS(
    SELECT
        CASE 
            WHEN a.objectid = b.fid_libelle AND a.libelle = 'Code Unité Territoriale' THEN b.id_code
        END AS id_code_ut,
        b.code
    FROM
        ta_libelle a
        INNER JOIN v_code b ON a.objectid = b.fid_libelle
    )

    -- Sélection des objectids des UT avec leur code correspondant
    SELECT
        a.id_ut,
        b.id_code_ut
    FROM
        v_ut a,
        v_code_ut b
    WHERE
        b.id_code_ut IS NOT NULL
        AND((a.nom = 'Lille-Seclin' AND b.code = '1')
        OR (a.nom = 'Marcq en Baroeul-la-Bassee' AND b.code = '2')
        OR (a.nom = 'Roubaix-Villeneuve d''Ascq' AND b.code = '3')
        OR (a.nom = 'Tourcoing-Armentières' AND b.code = '4'));

-- 7.9. Insertion dans la table ta_za_communes des objectid des communes et ceux des Unités Territoriales correspondantes
-- 7.9.1. Marcq en Baroeul-la Bassee
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    g.objectid,
    f.debut_validite,
    f.fin_validite
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_za_communes f ON a.objectid = f.fid_commune
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative g
    INNER JOIN ta_nom h ON g.fid_nom = h.objectid
WHERE
    a.fid_metadonnee = 1
    AND d.libelle = 'code insee'
    AND f.fin_validite = '01/01/2999'
    AND h.nom = 'Marcq en Baroeul-la Bassee'
    AND c.code IN ('59051', '59056', '59128', '59670', '59195', '59196', '59201', '59208', '59250', '59278', '59281', '59286', '59303', '59320', '59328', '59356', '59378', '59386', '59388', '59457', '59470', '59524', '59527', '59550', '59553', '59566', '59611', '59636', '59653', '59658', '59088', '59025', '59257', '59487', '59371');
COMMIT;

-- 7.9.2. Lille-Seclin
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    g.objectid,
    f.debut_validite,
    f.fin_validite
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_za_communes f ON a.objectid = f.fid_commune
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative g
    INNER JOIN ta_nom h ON g.fid_nom = h.objectid
WHERE
    a.fid_metadonnee = 1
    AND d.libelle = 'code insee'
    AND f.fin_validite = '01/01/2999'
    AND h.nom = 'Lille-Seclin'
    AND c.code IN ('59011','59346','59368','59648','59256','59609','59350','59360','59477','59005','59193','59220','59437','59133','59052','59585','59316','59507','59560','59343');
COMMIT;
    
-- 7.9.3. Roubaix-Villeneuve d'Ascq
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    g.objectid,
    f.debut_validite,
    f.fin_validite
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_za_communes f ON a.objectid = f.fid_commune
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative g
    INNER JOIN ta_nom h ON g.fid_nom = h.objectid
WHERE
    a.fid_metadonnee = 1
    AND d.libelle = 'code insee'
    AND f.fin_validite = '01/01/2999'
    AND h.nom = 'Roubaix-Villeneuve d''Ascq'
    AND c.code IN ('59275','59339','59523','59522','59044','59367','59163','59512','59299','59146','59410','59650','59106','59247','59602','59013','59458','59332','59009','59646','59598','59660');
COMMIT;

-- 7.9.4. Tourcoing-Armentières
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    g.objectid,
    f.debut_validite,
    f.fin_validite
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_za_communes f ON a.objectid = f.fid_commune
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative g
    INNER JOIN ta_nom h ON g.fid_nom = h.objectid
WHERE
    a.fid_metadonnee = 1
    AND d.libelle = 'code insee'
    AND f.fin_validite = '01/01/2999'
    AND h.nom = 'Tourcoing-Armentières'
    AND c.code IN ('59017','59252','59656','59508','59352','59482','59173','59143','59090','59317','59098','59643','59152','59599','59421','59202','59279','59426');
COMMIT;

-- 8. Création des territoires
-- 8.1. Insertion du libelle "Territoire" dans la table ta_libelle
INSERT INTO ta_libelle(libelle)
VALUES('Territoire');
COMMIT;

-- 8.2. Insertion du libelle "Code Territoire"
INSERT INTO ta_libelle(libelle)
VALUES('Code Territoire');
COMMIT;

-- 8.3. Insertion dans la table de liaison ta_famille_libelle (table de liaison entre ta_famille et ta_libelle) des objectid des familles et des libellés de la MEL
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
    a.objectid,
    b.objectid
FROM
	ta_famille a,
    ta_libelle b
WHERE
	a.famille = 'Division territoriale de la MEL'
    AND b.libelle = 'Territoire';
COMMIT;

-- 8.4. Insertion dans la table de liaison ta_famille_libelle famille / Codes des Territoires
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
	a.objectid,
	b.objectid
FROM
	ta_famille a,
	ta_libelle b	
WHERE
	a.famille = 'Identifiants des divisions territoriales de la MEL'
	AND b.libelle = 'Code Territoire';
COMMIT;

-- 8.5. Insertion des noms des territoires dans la table TA_NOM  
INSERT INTO ta_nom(nom)
WITH
    v_1 AS(
    SELECT 'Territoire Est' FROM DUAL
    UNION
    SELECT 'Territoire Tourquennois' FROM DUAL
    UNION
    SELECT 'Territoire des Weppes' FROM DUAL
    UNION
    SELECT 'Couronne Nord de Lille' FROM DUAL
    UNION
    SELECT 'Territoire de la Lys' FROM DUAL
    UNION
    SELECT 'Territoire Roubaisien' FROM DUAL
    UNION
    SELECT 'Territoire Lillois' FROM DUAL
    UNION
    SELECT 'Couronne Sud de Lille' FROM DUAL
    )
SELECT * FROM v_1;
COMMIT;

-- 8.6. Insertion des codes des Territoires dans TA_CODE
INSERT INTO ta_code(code, fid_libelle)
WITH
    v_1 AS(
    SELECT '1' AS code FROM DUAL
    UNION
    SELECT '2' AS code FROM DUAL
    UNION
    SELECT '3' AS code FROM DUAL
    UNION
    SELECT '4' AS code FROM DUAL
    UNION
    SELECT '5' AS code FROM DUAL
    UNION
    SELECT '6' AS code FROM DUAL
    UNION
    SELECT '7' AS code FROM DUAL
    UNION
    SELECT '8' AS code FROM DUAL
    )
SELECT 
    a.code,
    b.objectid
FROM 
    v_1 a,
    ta_libelle b
WHERE
    b.libelle = 'Code Territoire';
COMMIT;

-- 8.7. Insertion des Territoires dans la table ta_zone_administrative
INSERT INTO ta_zone_administrative(fid_libelle, fid_nom)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_nom b
WHERE
    a.libelle = 'Territoire'
    AND b.nom IN('Territoire Est', 'Territoire Tourquennois', 'Territoire des Weppes', 'Couronne Nord de Lille', 'Territoire de la Lys', 'Territoire Roubaisien', 'Territoire Lillois', 'Couronne Sud de Lille');
COMMIT;

-- 8.8. Insertion dans la table de liaison ta_identifiant_zone_administrative pour faire la liaison entre les territoires et leur code
INSERT INTO ta_identifiant_zone_administrative(fid_zone_administrative, fid_identifiant)
WITH
    -- Sélection des objectid des noms des Territoires
    v_nom AS(
    SELECT
        CASE a.nom
            WHEN 'Territoire Est' THEN a.objectid
            WHEN 'Territoire Tourquennois' THEN a.objectid
            WHEN 'Territoire des Weppes' THEN a.objectid
            WHEN 'Couronne Nord de Lille' THEN a.objectid
            WHEN 'Territoire de la Lys' THEN a.objectid
            WHEN 'Territoire Roubaisien' THEN a.objectid
            WHEN 'Territoire Lillois' THEN a.objectid
            WHEN 'Couronne Sud de Lille' THEN a.objectid
        END AS id_nom,
        a.nom
    FROM
        ta_nom a
    ),
    
    -- Vérification qu'il s'agit de zones administratives
    v_za AS(
    SELECT
        CASE a.fid_nom
            WHEN b.id_nom THEN a.objectid
        END AS id_za,
        a.fid_libelle,
        b.nom
    FROM
        ta_zone_administrative a
        INNER JOIN v_nom b ON b.id_nom = a.fid_nom
    ),

    -- Vérification qu'il s'agit des Territoires
    v_territoire AS(
    SELECT
        CASE
            WHEN a.fid_libelle = b.objectid AND b.libelle = 'Territoire' THEN a.id_za
        END AS id_territoire,
        a.nom
    FROM
        v_za a
        INNER JOIN ta_libelle b ON a.fid_libelle = b.objectid
    ),
    
    -- Sélection des objectid des codes des Unités Territoriales
    v_code AS(
    SELECT
        CASE a.code
            WHEN '1' THEN a.objectid
            WHEN '2' THEN a.objectid
            WHEN '3' THEN a.objectid
            WHEN '4' THEN a.objectid
            WHEN '5' THEN a.objectid
            WHEN '6' THEN a.objectid
            WHEN '7' THEN a.objectid
            WHEN '8' THEN a.objectid
        END AS id_code,
        a.code,
        a.fid_libelle
    FROM
        ta_code a
    ),

    -- vérification qu'il s'agit bien de code des Territoires
    v_code_territoire AS(
    SELECT
        CASE 
            WHEN a.objectid = b.fid_libelle AND a.libelle = 'Code Territoire' THEN b.id_code
        END AS id_code_territoire,
        b.code
    FROM
        ta_libelle a
        INNER JOIN v_code b ON a.objectid = b.fid_libelle
    )

    -- Sélection des objectids des Territoires avec leur code correspondant
    SELECT
        a.id_territoire,
        b.id_code_territoire
    FROM
        v_territoire a,
        v_code_territoire b
    WHERE
        b.id_code_territoire IS NOT NULL
        AND((a.nom = 'Territoire des Weppes' AND b.code = '1')
        OR (a.nom = 'Territoire Tourquennois' AND b.code = '2')
        OR (a.nom = 'Territoire Roubaisien' AND b.code = '3')
        OR (a.nom = 'Territoire de la Lys' AND b.code = '4')
        OR (a.nom = 'Territoire Est' AND b.code = '5')
        OR (a.nom = 'Couronne Nord de Lille' AND b.code = '6')
        OR (a.nom = 'Couronne Sud de Lille' AND b.code = '7')
        OR (a.nom = 'Territoire Lillois' AND b.code = '8'));
COMMIT;
    
-- 8.9. Insertion dans la table ta_za_communes des objectid des communes et ceux des Territoires correspondants
-- 8.9.1. Territoire Est
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire Est'
    AND c.code IN('59013','59044','59106','59146','59247','59275','59410','59522','59523','59602','59009','59660','59458');
COMMIT;

-- 8.9.2 Territoire Tourquennois
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire Tourquennois'
    AND c.code IN('59090','59279','59421','59426','59508','59599');
COMMIT;

-- 8.9.3. Territoire des Weppes
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire des Weppes'
    AND c.code IN('59051','59056','59670','59195','59196','59201','59208','59250','59278','59281','59286','59303','59320','59388','59524','59550','59553','59566','59653','59658','59088','59025','59257','59487','59371');
COMMIT;

-- 8.9.4. Couronne Nord de Lille
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Couronne Nord de Lille'
    AND c.code IN('59128','59328','59356','59368','59378','59386','59457','59470','59527','59611','59636');
COMMIT;

-- 8.9.5. Territoire de la Lys
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire de la Lys'
    AND c.code IN('59017', '59098', '59143', '59152', '59173', '59202', '59252', '59317', '59352', '59482', '59643', '59656');
COMMIT;

-- 8.9.6. Territoire Roubaisien
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire Roubaisien'
    AND c.code IN('59163','59299','59332','59339','59367','59512','59598','59646','59650');
COMMIT;

-- 8.9.7. Territoire Lillois
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Territoire Lillois'
    AND c.code IN('59350');
COMMIT;

-- 8.9.8. Couronne Sud de Lille
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
    a.objectid,
    e.objectid,
    '01/01/2020',
    '31/12/2999'
FROM
    ta_commune a
    INNER JOIN ta_identifiant_commune b ON a.objectid = b.fid_commune
    INNER JOIN ta_code c ON b.fid_identifiant = c.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid,
    ta_zone_administrative e
    INNER JOIN ta_nom f ON e.fid_nom = f.objectid
WHERE
    d.libelle = 'code insee'
    AND f.nom = 'Couronne Sud de Lille'
    AND c.code IN('59193','59220','59256','59316','59343','59346','59360','59437','59507','59560','59585','59648','59609', '59185', '59112', '59221', '59251', '59112', '59011', '59005', '59052', '59133', '59477');
COMMIT;
