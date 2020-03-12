-- Insertion dans les tables de métadonnées, versionnement, provenance...
INSERT INTO ta_organisme(acronyme, nom_organisme)
VALUES('IGN', 'Institut National de l''Information Geographie et Forestiere');
INSERT INTO ta_source(nom_source, description)
VALUES('BDTOPO', 'Description vectorielle des elements du territoire francais et de ses infrastructures avec une precision metrique.');
INSERT INTO ta_provenance(url, methode_acquisition)
VALUES('https://geoservices.ign.fr/documentation/diffusion/index.html', 'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.');
INSERT INTO ta_date_acquisition(date_acquisition, millesime, nom_obtenteur)
VALUES('17/02/2020', '01/01/2019', 'bjacq');
COMMIT;

-----------------------------------------------------------------------------------------------------

-- Insertion dans la table de metadonnee
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

-- Insertion des familles et des libelles

--1. types de commune
INSERT INTO ta_famille(famille)
VALUES('types de commune');
INSERT INTO ta_libelle(libelle)
VALUES('commune simple');
INSERT INTO ta_libelle(libelle)
VALUES('commune associée');
COMMIT;

INSERT INTO ta_famille_libelle(fid_libelle, fid_famille)
SELECT
	a.objectid,
	b.objectid
FROM
	ta_libelle a,
	ta_famille b;
COMMIT;

-- 2. types de code
INSERT INTO ta_famille(famille)
VALUES('Identifiants de zone administrative');
INSERT INTO ta_libelle(libelle)
VALUES('code insee');
INSERT INTO ta_libelle(libelle)
VALUES('code postal');
COMMIT;

-- 3. Insertion des codes dans ta_code
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


-- 4. Insertion des noms dans ta_nom
INSERT INTO ta_nom(nom)
SELECT
	nom
FROM
	commune
COMMIT;

-- 5. Insertion des géométries dans ta_commune
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

-- 6. insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes postaux
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

-- 7. insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes insee
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

-- 8. les zones administratives
INSERT INTO ta_nom(acronyme, nom)
VALUES('MEL', 'Métropole Européenne de Lille');
COMMIT;

INSERT INTO ta_libelle(libelle)
VALUES('Etablissements de Coopération Intercommunale (EPCI)');
COMMIT;

INSERT INTO ta_zone_administrative(fid_nom, fid_libelle)
SELECT
	MAX(a.objectid),
	MAX(b.objectid)
FROM
	ta_nom a,
	ta_libelle b;
COMMIT;

-- 9. Pour les 95 communes de la MEL
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

-- 10. Pour les 90 communes de la MEL
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

DROP TABLE COMMUNE CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'COMMUNE';

-----------------------------------------------------------------------------------------------------

-- Insertion du libelle territoire dans la table TA_LIBELLE 
INSERT INTO ta_libelle(libelle)
VALUES('Territoire');
INSERT INTO ta_famille_libelle(fid_famille, fid_libelle)
SELECT
    23,
    MAX(objectid)
FROM
    ta_libelle;

-- Insertion des noms des territoires dans la table TA_NOM  
INSERT INTO ta_nom(nom)
VALUES('TERRITOIRE  EST');
INSERT INTO ta_nom(nom)
VALUES('TERRITOIRE TOURQUENNOIS');
INSERT INTO ta_nom(nom)
VALUES('TERRITOIRE DES  WEPPES');
INSERT INTO ta_nom(nom)
VALUES('COURONNE NORD DE LILLE');
INSERT INTO ta_nom(nom)
VALUES('TERRITOIRE DE LA LYS');
INSERT INTO ta_nom(nom)
VALUES('TERRITOIRE ROUBAISIEN');
INSERT INTO ta_nom(nom)
VALUES('LILLE-LOMME-HELLEMMES');
INSERT INTO ta_nom(nom)
VALUES('COURONNE SUD DE LILLE');
COMMIT;

-- Insertion dans la table ta_zone_administrative
INSERT INTO ta_zone_administrative(fid_libelle, fid_nom)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_nom b
WHERE
    a.libelle = 'Territoire'
    AND b.nom IN('TERRITOIRE  EST', 'TERRITOIRE TOURQUENNOIS', 'TERRITOIRE DES  WEPPES', 'COURONNE NORD DE LILLE', 'TERRITOIRE DE LA LYS', 'TERRITOIRE ROUBAISIEN', 'LILLE-LOMME-HELLEMMES', 'COURONNE SUD DE LILLE');
COMMIT;

-- Insertion dans la table ta_za_communes
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
    AND f.nom = 'TERRITOIRE  EST'
    AND c.code IN('59013','59044','59106','59146','59247','59275','59410','59522','59523','59602','59009','59660','59458');
    --AND f.nom = 'TERRITOIRE TOURQUENNOIS'
    --AND c.code IN('59090','59279','59421','59426','59508','59599');
    --AND f.nom = 'TERRITOIRE DES  WEPPES'
    --AND c.code IN('59051','59056','59670','59195','59196','59201','59208','59250','59278','59281','59286','59303','59320','59388','59524','59550','59553','59566','59653','59658','59088','59025','59257','59487','59371');
    --AND f.nom = 'COURONNE NORD DE LILLE'
    --AND c.code IN('59128','59328','59356','59368','59378','59386','59457','59470','59527','59611','59636');
    --AND f.nom = 'TERRITOIRE DE LA LYS'
    --AND c.code IN('59017', '59098', '59143', '59152', '59173', '59202', '59252', '59317', '59352', '59482', '59643', '59656');
    --AND f.nom = 'TERRITOIRE ROUBAISIEN'
    --AND c.code IN('59163','59299','59332','59339','59367','59512','59598','59646','59650');
    --AND f.nom = 'LILLE-LOMME-HELLEMMES'
    --AND c.code IN('59350');
    --AND f.nom = 'COURONNE SUD DE LILLE'
    --AND c.code IN('59193','59220','59256','59316','59343','59346','59360','59437','59507','59560','59585','59648','59609', '59185', '59112', '59221', '59251', '59112');

