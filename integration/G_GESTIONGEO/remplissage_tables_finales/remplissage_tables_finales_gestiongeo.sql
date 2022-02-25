SET SERVEROUTPUT ON
DECLARE
	v_id NUMBER(38,0);
BEGIN
/*
Code permettant d'insérer les données gestiongeo des tables temporaires dans les tables finales suite aux corrections des données.

SOMMAIRE
1. Désactivation des triggers, clés étrangères, contraintes et index ;
2. Remplissage de la table TA_GG_AGENT ;
3. Remplissage de la table TA_GG_FAMILLE ;
4. Remplissage de la table TA_GG_ETAT_AVANCEMENT ;
9. Remplissage de la table TA_GG_CLASSE ;
5. Remplissage de la table TA_GG_GEO ;
6. Remplissage de la table TA_GG_DOS_NUM ;
7. Remplissage de la table TA_GG_DOSSIER ;
8. Remplissage de la table TA_GG_GEO ;
10. Remplissage de la table TA_GG_DOMAINE ;
11. Remplissage de la table TA_GG_RELATION_CLASSE_DOMAINE ;
12. Remplissage de la table TA_GG_FME_DECALAGE_ABSCISSE ;
13. Remplissage de la table TA_GG_FME_MESURE ;
14. Remplissage de la table TA_GG_FME_FILTRE_SUR_LIGNE ;
15. Redéfinition du START WITH des clés primaires ;
	15.1. Modification de l'id de départ de la clé primaire de TA_GG_DOSSIER ;
	15.2. Modification de l'id de départ de la clé primaire de TA_GG_GEO ;
	15.3. Modification de l'id de départ de la clé primaire de TA_GG_DOS_NUM ;
	15.4. Modification de l'id de départ de la clé primaire de TA_GG_ETAT_AVANCEMENT ;
	15.5. Modification de l'id de départ de la clé primaire de TA_GG_FAMILLE ;
	15.6. Modification de l'id de départ de la clé primaire de TA_GG_FICHIER ;
	15.7. Modification de l'id de départ de la clé primaire de TA_GG_CLASSE ;
	15.8. Modification de l'id de départ de la clé primaire de TA_GG_FME_DECALAGE_ABSCISSE ;
	15.9. Modification de l'id de départ de la clé primaire de TA_GG_FME_MESURE ;
	15.10. Modification de l'id de départ de la clé primaire de TA_GG_FME_FILTRE_SUR_LIGNE ;
16. Réactivation des triggers, clés étrangères, contraintes, index et suppression des champs temporaires ;
	16.1. Contrainte de clé étrangère de TA_GG_DOSSIER ;
	16.2. Réactivation du trigger B_UXX_TA_GG_DOSSIER ;
	16.3. Réactivation du trigger A_IXX_TA_GG_DOSSIER ;
	16.4. Recréation des index de TA_GG_FAMILLE ;
	16.5. Recréation des index de TA_GG_ETAT_AVANCEMENT ;
	16.6. Recréation des index de TA_GG_DOS_NUM ;
	16.7. Recréation des index de TA_GG_GEO ;
	16.8. Recréation des index de TA_GG_DOSSIER ;
*/

SAVEPOINT POINT_SAUVEGARDE_REMPLISSAGE;

--1. Désactivation des triggers, clés étrangères et index
/* Prérequis :
- Désactivation du trigger B_IUX_TA_GG_DOSSIER ;
- Désactivation de la clé étrangère TA_GG_GEO_ID_DOS_FK ;
- Désactivation des index pour accélérer l'insertion des données
*/
EXECUTE IMMEDIATE 'ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER DISABLE CONSTRAINT TA_GG_DOSSIER_FID_PERIMETRE_FK';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IXX_TA_GG_GEO DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER B_UXX_TA_GG_DOSSIER DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_DOSSIER_LOG DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_GEO_LOG DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER B_IXX_TA_GG_DOSSIER DISABLE';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_SIDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_SURFACE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_CODE_INSEE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_ETAT_AVANCEMENT_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_FAMILLE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PERIMETRE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PNOM_DATE_CREATION_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PNOM_DATE_MODIFICATION_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_MAITRE_OUVRAGE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_RESPONSABLE_LEVE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_ENTREPRISE_TRAVAUX_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_REPERTOIRE_REPERTOIRE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_REPERTOIRE_PROTOCOLE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOS_NUM_DOS_NUM_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOS_NUM_FID_DOSSIER_IDX';

-- 2. Remplissage de la table TA_GG_AGENT Ce code est en commentaires, puisque ces valeurs ont déjà été insérées pour les points de vigilance et OCS2D
-- Insertion des pnoms des agents utilisant gestiongeo
/*INSERT INTO G_GESTIONGEO.TA_GG_AGENT(OBJECTID, PNOM, VALIDITE)
SELECT
	SRC_ID, 
	TRIM(SRC_LIBEL), 
	SRC_VAL
FROM
	G_GESTIONGEO.TEMP_TA_GG_AGENT;

-- Insertion des pnoms génériques nécessaires pour des cas bien particuliers
MERGE INTO G_GESTIONGEO.TA_GG_AGENT a
USING(
	SELECT
		88888 AS OBJECTID,
		'plusieurs gestionnaires' AS PNOM,
		1 AS VALIDITE
	FROM
		DUAL
	UNION ALL
	SELECT
		77777 AS OBJECTID,
		'pas encore de gestionnaire' AS PNOM,
		1 AS VALIDITE
	FROM
		DUAL
	UNION ALL
	SELECT
		99999 AS OBJECTID,
		'migration données' AS PNOM,
		1 AS VALIDITE
	FROM
		DUAL
	UNION ALL
	SELECT
		6068 AS OBJECTID,
		'rjault' AS PNOM,
		1 AS VALIDITE
	FROM
		DUAL
	UNION ALL
	SELECT
		5741 AS OBJECTID,
		'bjacq' AS PNOM,
		1 AS VALIDITE
	FROM
		DUAL
)t
ON(a.objectid = t.objectid AND a.pnom = t.pnom)
WHEN NOT MATCHED THEN
	INSERT(a.objectid, a.pnom, a.validite)
	VALUES(t.objectid, t.pnom, t.validite);
*/
-- 3. Remplissage de la table TA_GG_FAMILLE
INSERT INTO G_GESTIONGEO.TA_GG_FAMILLE(OBJECTID, LIBELLE, VALIDITE, LIBELLE_ABREGE)
SELECT
	FAM_ID, 
	FAM_LIB, 
	FAM_VAL,
	FAM_LIB_SMALL
FROM
	G_GESTIONGEO.TEMP_TA_GG_FAMILLE;

-- 4. Remplissage de la table TA_GG_ETAT_AVANCEMENT
INSERT INTO G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT(OBJECTID, LIBELLE_LONG, LIBELLE_COURT, LIBELLE_ABREGE)
SELECT 
	ETAT_ID, 
	ETAT_LIB, 
	ETAT_LIB_SMALL, 
	ETAT_SMALL
FROM
	G_GESTIONGEO.TEMP_TA_GG_ETAT;

-- 9. Remplissage de la table TA_GG_CLASSE
MERGE INTO G_GESTIONGEO.TA_GG_CLASSE a
USING(
    SELECT
        cla_inu,
        dom_inu,
        cla_code,
        cla_li,
        cla_val
    FROM
        G_GESTIONGEO.TEMP_TA_CLASSE
)t
ON(a.objectid = t.cla_inu)
WHEN NOT MATCHED THEN
INSERT(a.objectid, a.libelle_court, a.libelle_long, validite)
VALUES(t.cla_inu, t.cla_code, t.cla_li, t.cla_val);

-- Remplissage de la table TA_GG_TYPE_LEVE
INSERT INTO G_GESTIONGEO.TA_GG_TYPE_LEVE(OBJECTID, VALEUR)
SELECT
	OBJECTID,  
	VALEUR
FROM
	G_GESTIONGEO.TEMP_GG_TYPE_LEVE;

-- 5. Remplissage de la table TA_GG_GEO
INSERT INTO G_GESTIONGEO.TA_GG_GEO(OBJECTID, GEOM)
SELECT
	ID_GEOM,  
	ORA_GEOMETRY
FROM
	G_GESTIONGEO.TEMP_TA_GG_GEO;

-- 6. Remplissage de la table TA_GG_DOSSIER
INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER(OBJECTID, FID_PNOM_CREATION, FID_ETAT_AVANCEMENT, FID_PNOM_MODIFICATION, FID_FAMILLE, DATE_SAISIE, REMARQUE_GEOMETRE, DATE_MODIFICATION, REMARQUE_PHOTO_INTERPRETE, DATE_CLOTURE, DATE_DEBUT_TRAVAUX, DATE_FIN_TRAVAUX, DATE_COMMANDE_DOSSIER, MAITRE_OUVRAGE, RESPONSABLE_LEVE, DATE_DEBUT_LEVE, DATE_FIN_LEVE)
SELECT
	a.id_dos, 
	a.src_id, 
	a.etat_id, 
	a.user_id, 
	a.fam_id, 
	a.dos_dc, 
	a.dos_precision, 
	a.dos_dmaj, 
	a.dos_rq, 
	a.dos_dt_fin, 
	a.dos_dt_deb_tr, 
	a.dos_dt_fin_tr, 
	a.dos_dt_cmd_sai, 
	a.dos_mao, 
	a.dos_entr,  
	a.dos_dt_deb_leve, 
	a.dos_dt_fin_leve
FROM
	G_GESTIONGEO.TEMP_TA_GG_DOSSIER a;

-- 7. Mise à jour de la FK FID_PERIMETRE permettant d'associer un dossier à son périmètre
MERGE INTO G_GESTIONGEO.TA_GG_DOSSIER a
USING(
    SELECT
        id_geom,
        id_dos
    FROM
        G_GESTIONGEO.TEMP_TA_GG_GEO
)t
ON (a.objectid = t.id_dos)
WHEN MATCHED THEN
    UPDATE SET a.fid_perimetre = t.id_geom;

-- 8. Insertion des DOS_NUM dans TA_GG_DOS_NUM
INSERT INTO G_GESTIONGEO.TA_GG_DOS_NUM(dos_num, fid_dossier)
SELECT dos_num, id_dos
FROM
    G_GESTIONGEO.TEMP_TA_GG_DOSSIER
WHERE
    dos_num IS NOT NULL;

-- 9. Remplissage de la table TA_GG_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
    (
        SELECT
            a.DOM_INU AS OBJECTID,
            a.DOM_LI AS DOMAINE
        FROM
            G_GESTIONGEO.TEMP_TA_DOM a
    )b
ON(a.OBJECTID = b.OBJECTID AND UPPER(a.DOMAINE) = UPPER(b.DOMAINE))
WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID,a.DOMAINE)
    VALUES (b.OBJECTID, b.DOMAINE);

--Modification de l'id de départ de la clé primaire de TA_GG_DOMAINE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_DOMAINE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_DOMAINE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_DOMAINE_OBJECTID START WITH ' || v_id || ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_RW';

-- Insertion d'une nouvelle valeur dans TA_GG_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
    (
        SELECT
            'Classe intégrée en base par la chaine de traitement FME' AS DOMAINE
        FROM
            DUAL
    )b
ON(UPPER(a.DOMAINE) = UPPER(b.DOMAINE))
WHEN NOT MATCHED THEN 
	INSERT (a.DOMAINE)
	VALUES (b.DOMAINE);

-- 11. Remplissage de la table TA_GG_RELATION_CLASSE_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
    (
        SELECT
            a.cla_inu AS FID_CLASSE,
            b.dom_inu AS FID_DOMAINE
        FROM
            G_GESTIONGEO.TEMP_TA_CLASSE a
            INNER JOIN G_GESTIONGEO.TEMP_TA_DOM b ON a.dom_inu = b.dom_inu
        UNION ALL
        SELECT
            a.cla_inu AS FID_CLASSE,
            b.dom_inu_pere AS FID_PERE
        FROM
            G_GESTIONGEO.TEMP_TA_CLASSE a
            INNER JOIN G_GESTIONGEO.TEMP_TA_DOM b ON a.dom_inu = b.dom_inu
            WHERE b.DOM_INU_PERE IS NOT NULL
        UNION ALL
        SELECT
            a.OBJECTID AS FID_CLASSE,
            b.OBJECTID AS FID_DOMAINE
        FROM
            G_GESTIONGEO.TEMP_FME_VALUE_LISTE a,
            G_GESTIONGEO.TA_GG_DOMAINE b
        WHERE
            b.DOMAINE = 'Classe intégrée en base par la chaine de traitement FME'
    )b
ON(a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN 
	INSERT (a.FID_CLASSE,a.FID_DOMAINE)
	VALUES (b.FID_CLASSE, b.FID_DOMAINE);

-- 12. Remplissage de la table TA_GG_FME_DECALAGE_ABSCISSE
MERGE INTO G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE a
USING (
    SELECT
        b.OBJECTID AS FID_CLASSE,
        a.GEO_LIG_OFFSET_D AS DECALAGE_ABSCISSE_D,
        a.GEO_LIG_OFFSET_G AS DECALAGE_ABSCISSE_G
    FROM
        G_GESTIONGEO.TEMP_FME_VALUE_LISTE a
        INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b on TRIM(b.LIBELLE_COURT) = a.ENTREE_TRANSFORMER
    WHERE
        a.GEO_LIG_OFFSET_D IS NOT NULL
        OR
        a.GEO_LIG_OFFSET_G IS NOT NULL
)b
ON(
	a.FID_CLASSE = b.FID_CLASSE
	AND a.DECALAGE_ABSCISSE_D = b.DECALAGE_ABSCISSE_D
	AND a.DECALAGE_ABSCISSE_G = b.DECALAGE_ABSCISSE_G
)
WHEN NOT MATCHED THEN 
	INSERT (a.FID_CLASSE,a.DECALAGE_ABSCISSE_D, a.DECALAGE_ABSCISSE_G)
	VALUES (b.FID_CLASSE,b.DECALAGE_ABSCISSE_D, b.DECALAGE_ABSCISSE_G);

-- 13. Remplissage de la table TA_GG_FME_MESURE
MERGE INTO G_GESTIONGEO.TA_GG_FME_MESURE a
USING (
    SELECT
        b.OBJECTID AS FID_CLASSE,
        a.GEO_POI_LN AS LONGUEUR,
        a.GEO_POI_LA AS LARGEUR
    FROM
        G_GESTIONGEO.TEMP_FME_VALUE_LISTE a
        INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b on TRIM(b.LIBELLE_COURT) = a.ENTREE_TRANSFORMER
    WHERE
        a.GEO_POI_LN IS NOT NULL
        AND a.GEO_POI_LA IS NOT NULL
)b
ON(
	a.FID_CLASSE = b.FID_CLASSE
	AND a.LONGUEUR = b.LONGUEUR
	AND a.LARGEUR = b.LARGEUR
)
WHEN NOT MATCHED THEN 
	INSERT (a.FID_CLASSE,a.LONGUEUR, a.LARGEUR)
	VALUES (b.FID_CLASSE,b.LONGUEUR, b.LARGEUR);

-- 14. Remplissage de la table TA_GG_FME_FILTRE_SUR_LIGNE
MERGE INTO G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE a
USING (
    SELECT
        b.OBJECTID AS FID_CLASSE,
        c.OBJECTID AS FID_CLASSE_SOURCE
    FROM
        G_GESTIONGEO.TEMP_FME_VALUE_LISTE a
        INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b ON TRIM(b.LIBELLE_COURT) = a.VALEUR_FILTRE
        INNER JOIN G_GESTIONGEO.TA_GG_CLASSE c ON TRIM(c.LIBELLE_COURT) = a.ENTREE_TRANSFORMER
    WHERE
        a.VALEUR_FILTRE IS NOT NULL
)b
ON(a.FID_CLASSE = b.FID_CLASSE)
WHEN NOT MATCHED THEN 
	INSERT (a.FID_CLASSE,a.FID_CLASSE_SOURCE)
	VALUES (b.FID_CLASSE,b.FID_CLASSE_SOURCE);

-- 15. Remplissage de la table TA_GG_REPERTOIRE
MERGE INTO G_GESTIONGEO.TA_GG_REPERTOIRE a
USING
	(
		SELECT
			'/var/www/extraction/apps/gestiongeo' AS repertoire,
			'SFTP' AS protocole
		FROM
			DUAL
		UNION
		SELECT
			'https://gtf.lillemetropole.fr/apps/gestiongeo/' AS repertoire,
			'HTTPS' AS protocole
		FROM
			DUAL
	)b
ON (UPPER(a.repertoire) = UPPER(b.repertoire)
AND UPPER(a.protocole) = UPPER(b.protocole))
WHEN NOT MATCHED THEN
INSERT (a.repertoire,a.protocole)
VALUES (b.repertoire,b.protocole);

-- 16. Remplissage de la table TA_GG_FICHIER
INSERT INTO G_GESTIONGEO.TA_GG_FICHIER(objectid, fichier, fid_dossier, integration)
SELECT
    objectid, fichier, fid_dossier, integration
FROM
    G_GESTIONGEO.TEMP_TA_GG_FICHIER
WHERE
    fid_dossier IN(SELECT objectid FROM G_GESTIONGEO.TA_GG_DOSSIER);

-- 16. Redéfinition du START WITH des clés primaires
-- 16.1. Modification de l'id de départ de la clé primaire de TA_GG_DOSSIER
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_DOSSIER a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_DOSSIER_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_DOSSIER_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_RW';

-- 16.2. Modification de l'id de départ de la clé primaire de TA_GG_GEO
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_GEO a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_GEO_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_GEO_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_RW';

-- 16.3. Modification de l'id de départ de la clé primaire de TA_GG_DOS_NUM
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_DOS_NUM a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_DOS_NUM_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_DOS_NUM_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW';

-- 16.4. Modification de l'id de départ de la clé primaire de TA_GG_ETAT_AVANCEMENT
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_RW';

-- 16.5. Modification de l'id de départ de la clé primaire de TA_GG_FAMILLE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_FAMILLE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_FAMILLE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_FAMILLE_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_RW';

-- 16.6. Modification de l'id de départ de la clé primaire de TA_GG_FICHIER 
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_FICHIER a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_FICHIER_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_FICHIER_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_RW';

-- 16.7. Modification de l'id de départ de la clé primaire de TA_GG_CLASSE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_CLASSE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_CLASSE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_CLASSE_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_CLASSE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_CLASSE_OBJECTID TO G_GESTIONGEO_RW';

-- 16.8. Modification de l'id de départ de la clé primaire de TA_GG_FME_DECALAGE_ABSCISSE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_RW';

-- 16.9. Modification de l'id de départ de la clé primaire de TA_GG_FME_MESURE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_FME_MESURE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_FME_MESURE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_FME_MESURE_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW';

-- 16.10. Modification de l'id de départ de la clé primaire de TA_GG_FME_FILTRE_SUR_LIGNE
SELECT
	MAX(a.OBJECTID)+1
	INTO v_id
FROM
	G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE a;

EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID';
EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID START WITH ' ||v_id|| ' INCREMENT BY 1';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_R';
EXECUTE IMMEDIATE 'GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_RW';

COMMIT;

-- 16. Réactivation des triggers, clés étrangères, contraintes, index et suppression des champs temporaires
-- 16.1. Contrainte de clé étrangère de TA_GG_DOSSIER
EXECUTE IMMEDIATE 'ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER ENABLE CONSTRAINT TA_GG_DOSSIER_FID_PERIMETRE_FK';

-- 16.2. Réactivation du trigger B_UXX_TA_GG_DOSSIER
EXECUTE IMMEDIATE 'ALTER TRIGGER B_UXX_TA_GG_DOSSIER ENABLE';

-- 16.3. Réactivation du trigger A_IXX_TA_GG_DOSSIER
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IXX_TA_GG_GEO ENABLE';

-- 16.4. Réactivation des triggers des tables de log
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_GEO_LOG ENABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_DOSSIER_LOG ENABLE';

-- 16.5. Recréation des index de TA_GG_DOS_NUM
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_DOS_NUM_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM ("DOS_NUM") TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM("FID_DOSSIER")TABLESPACE G_ADT_INDX';

-- 16.6. Recréation des index de TA_GG_GEO
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_GEO_SIDX ON G_GESTIONGEO.TA_GG_GEO(GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARAMETERS(''sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP'')';
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_GEO_SURFACE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("SURFACE") TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_GEO_CODE_INSEE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("CODE_INSEE") TABLESPACE G_ADT_INDX';

-- 16.7. Recréation des index de TA_GG_DOSSIER
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_FID_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_ETAT_AVANCEMENT")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_FID_FAMILLE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_FAMILLE")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_FID_PERIMETRE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PERIMETRE")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_FID_PNOM_DATE_CREATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_CREATION")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_FID_PNOM_DATE_MODIFICATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_MODIFICATION")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_MAITRE_OUVRAGE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("MAITRE_OUVRAGE")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_RESPONSABLE_LEVE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("RESPONSABLE_LEVE")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX TA_GG_DOSSIER_ENTREPRISE_TRAVAUX_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("ENTREPRISE_TRAVAUX")TABLESPACE G_ADT_INDX';

-- 16.8. Recréation des index de TA_GG_REPERTOIRE
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_REPERTOIRE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("REPERTOIRE")TABLESPACE G_ADT_INDX';
EXECUTE IMMEDIATE 'CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_PROTOCOLE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("PROTOCOLE")TABLESPACE G_ADT_INDX';

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_REMPLISSAGE;
END;
