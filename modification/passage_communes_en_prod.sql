-- Insertion dans les tables de métadonnées, versionnement, provenance...
INSERT INTO ta_organisme(acronyme, nom_organisme)
VALUES('IGN', 'Institut National de l''Information Geographie et Forestiere');
INSERT INTO ta_source(nom_source, description)
VALUES('BDTOPO', 'Description vectorielle des elements du territoire francais et de ses infrastructures avec une precision metrique.')
INSERT INTO ta_provenance(url, methode_acquisition)
VALUES('https://geoservices.ign.fr/documentation/diffusion/index.html', 'Envoi d''une demande de telechargement de la bdtopo via un compte IGN de la DIG. Un mail nous est renvoye avec un lien de telechargement.');
INSERT INTO ta_date_acquisition(date_acquisition, millesime, nom_obtenteur)
VALUES('17/02/2020', '01/01/2019', 'bjacq');
COMMIT;

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

-- types de code
INSERT INTO ta_famille(famille)
VALUES('Identifiants de zone administrative');
INSERT INTO ta_libelle(libelle)
VALUES('code insee');
INSERT INTO ta_libelle(libelle)
VALUES('code postal');
COMMIT;

-- Insertion des codes dans ta_code
INSERT INTO ta_code(code, fid_libelle)
SELECT
	a.insee_com,
	b.objectid
FROM
	communes a,
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


-- Insertion des noms dans ta_nom
INSERT INTO ta_nom(nom)
SELECT
	nom
FROM
	commune
COMMIT;

-- Insertion des géométries dans ta_commune
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
	

-- insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes postaux
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

-- insertion des fid_commune / fid_code dans ta_identifiant_commune pour les codes insee
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

-- les zones administratives
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

-- Pour les 95 communes de la MEL
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

-- Pour les 90 communes de la MEL
INSERT INTO ta_za_communes(fid_commune, fid_zone_administrative, debut_validite, fin_validite)
SELECT
	a.objectid,
	b.objectid,
	'01/01/2017',
	'31/12/2019'
FROM
	ta_zone_administrative b
	ta_commune a
	INNER JOIN ta_identifiant_commune c ON a.objectid = c.fid_commune
	INNER JOIN ta_code d ON c.fid_identifiant = d.objectid
	INNER JOIN ta_libelle e ON d.fid_libelle = e.objectid
WHERE
	e.libelle = 'code insee'
	AND d.code NOT IN('59011', '59005', '59052', '59133', '59477');
COMMIT;
