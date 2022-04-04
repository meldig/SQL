-- Commande d'insertion des données dans les tables du schéma g_gestiongeo.

-- 2. table TA_GG_FAMILE
MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		LIBELLE AS libelle,
		VALIDITE AS validite,
		LIBELLE_ABREGE AS libelle_abrege
	FROM
		G_DALC.TA_GG_FAMILLE
	) b
ON (a.objectid = b.objectid
AND a.libelle = b.libelle
AND a.validite = b.validite
AND a.libelle_abrege = b.libelle_abrege)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.libelle, a.validite, a.libelle_abrege)
VALUES (b.objectid, b.libelle, b.validite, b.libelle_abrege)
;


-- 3. table TA_GG_ETAT_AVANCEMENT
MERGE INTO G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT a
USING
	(
	SELECT
		OBJECTID AS objectid,
		LIBELLE_LONG AS libelle_long,
		LIBELLE_COURT AS libelle_court,
		LIBELLE_ABREGE AS libelle_abrege
	FROM
		G_DALC.TA_GG_ETAT_AVANCEMENT
	) b
ON (a.objectid = b.objectid
AND a.libelle_long = b.libelle_long
AND a.libelle_court = b.libelle_court
AND a.libelle_abrege = b.libelle_abrege)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.libelle_long, a.libelle_court, a.libelle_abrege)
VALUES (b.objectid, b.libelle_long, b.libelle_court, b.libelle_abrege)
;


-- 4. table TA_GG_DOSSIER
MERGE INTO G_GESTIONGEO.TA_GG_DOSSIER a
USING
	(
	SELECT
		OBJECTID AS objectid,
		FID_ETAT_AVANCEMENT AS fid_etat_avancement,
		FID_FAMILLE AS fid_famille,
		FID_PERIMETRE AS fid_perimetre,
		FID_PNOM_CREATION AS fid_pnom_creation,
		FID_PNOM_MODIFICATION AS fid_pnom_modification,
		DATE_SAISIE AS date_saisie,
		DATE_MODIFICATION AS date_modification,
		DATE_CLOTURE AS date_cloture,
		DATE_DEBUT_LEVE AS date_debut_leve,
		DATE_FIN_LEVE AS date_fin_leve,
		DATE_DEBUT_TRAVAUX AS date_debut_travaux,
		DATE_FIN_TRAVAUX AS date_fin_travaux,
		DATE_COMMANDE_DOSSIER AS date_commande_dossier,
		MAITRE_OUVRAGE AS maitre_ouvrage,
		RESPONSABLE_LEVE AS responsable_leve,
		ENTREPRISE_TRAVAUX AS entreprise_travaux,
		REMARQUE_GEOMETRE AS remarque_geometre,
		REMARQUE_PHOTO_INTERPRETE AS remarque_photo_interprete
    FROM
        G_DALC.TA_GG_DOSSIER
	) b
ON (a.objectid = b.objectid
AND a.fid_etat_avancement = b.fid_etat_avancement
AND a.fid_famille = b.fid_famille
AND a.fid_perimetre = b.fid_perimetre
AND a.fid_pnom_creation = b.fid_pnom_creation
AND a.fid_pnom_modification = b.fid_pnom_modification
AND a.date_saisie = b.date_saisie
AND a.date_modification = b.date_modification
AND a.date_cloture = b.date_cloture
AND a.date_debut_leve = b.date_debut_leve
AND a.date_fin_leve = b.date_fin_leve
AND a.date_debut_travaux = b.date_debut_travaux
AND a.date_fin_travaux = b.date_fin_travaux
AND a.date_commande_dossier = b.date_commande_dossier
AND a.maitre_ouvrage = b.maitre_ouvrage
AND a.responsable_leve = b.responsable_leve
AND a.entreprise_travaux = b.entreprise_travaux
AND a.remarque_geometre = b.remarque_geometre
AND a.remarque_photo_interprete = b.remarque_photo_interprete
)
WHEN NOT MATCHED
THEN INSERT (a.objectid,a.fid_etat_avancement,a.fid_famille,a.fid_perimetre,a.fid_pnom_creation,a.fid_pnom_modification,a.date_saisie,a.date_modification,a.date_cloture,a.date_debut_leve,a.date_fin_leve,a.date_debut_travaux,a.date_fin_travaux,a.date_commande_dossier,a.maitre_ouvrage,a.responsable_leve,a.entreprise_travaux,a.remarque_geometre,a.remarque_photo_interprete)
VALUES (b.objectid,b.fid_etat_avancement,b.fid_famille,b.fid_perimetre,b.fid_pnom_creation,b.fid_pnom_modification,b.date_saisie,b.date_modification,b.date_cloture,b.date_debut_leve,b.date_fin_leve,b.date_debut_travaux,b.date_fin_travaux,b.date_commande_dossier,b.maitre_ouvrage,b.responsable_leve,b.entreprise_travaux,b.remarque_geometre,b.remarque_photo_interprete)
;


-- 5. table TA_GG_FME_FILTRE_SUR_LIGNE
MERGE INTO G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		FID_CLASSE AS fid_classe,
		FID_CLASSE_SOURCE AS fid_classe_source
	FROM
		G_DALC.TA_GG_FME_FILTRE_SUR_LIGNE
	) b
ON (a.objectid = b.objectid
AND a.fid_classe = b.fid_classe
AND a.fid_classe_source = b.fid_classe_source)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.fid_classe, a.fid_classe_source)
VALUES (b.objectid, b.fid_classe, b.fid_classe_source)
;


-- 6. table TA_GG_CLASSE
MERGE INTO G_GESTIONGEO.TA_GG_CLASSE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		LIBELLE_COURT AS libelle_court,
		LIBELLE_LONG AS libelle_long,
		VAlIDITE AS validite
	FROM
		G_DALC.TA_GG_CLASSE
	) b
ON (a.objectid = b.objectid
AND a.libelle_court = b.libelle_court
AND a.libelle_long = b.libelle_long
AND a.validite = b.validite)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.libelle_court, a.libelle_long, a.validite)
VALUES (b.objectid, b.libelle_court, b.libelle_long, b.validite)
;


-- 7. table TA_GG_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		DOMAINE AS domaine
	FROM
		G_DALC.TA_GG_DOMAINE
	) b
ON (a.objectid = b.objectid
AND a.domaine = b.domaine)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.domaine)
VALUES (b.objectid, b.domaine)
;


-- 8. table TA_GG_FICHIER
MERGE INTO G_GESTIONGEO.TA_GG_FICHIER a
USING
	(
	SELECT
		OBJECTID AS objectid,
		FID_DOSSIER AS fid_dossier,
		FICHIER AS fichier,
		INTEGRATION AS integration
	FROM
		G_DALC.TA_GG_FICHIER
	) b
ON (a.objectid = b.objectid
AND a.fid_dossier = b.fid_dossier
AND a.fichier = b.fichier
AND a.integration = b.integration)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.fid_dossier, a.fichier, a.integration)
VALUES (b.objectid, b.fid_dossier, b.fichier, b.integration)
;


-- 9. table TA_GG_DOS_NUM
MERGE INTO G_GESTIONGEO.TA_GG_DOS_NUM a
USING
	(
	SELECT
		OBJECTID AS objectid,
		FID_DOSSIER AS fid_dossier,
		DOS_NUM AS dos_num
	FROM
		G_DALC.TA_GG_DOS_NUM
	) b
ON (a.objectid = b.objectid
AND a.fid_dossier = b.fid_dossier
AND a.dos_num = b.dos_num)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.fid_dossier, a.dos_num)
VALUES (b.objectid, b.fid_dossier, b.dos_num)
;


-- 10. table TA_GG_RELATION_CLASSE_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
	SELECT
		FID_CLASSE AS fid_classe,
		FID_DOMAINE AS fid_domaine
	FROM
		G_DALC.TA_GG_RELATION_CLASSE_DOMAINE
	) b
ON (a.fid_classe = b.fid_classe
AND a.fid_domaine = b.fid_domaine)
WHEN NOT MATCHED
THEN INSERT (a.fid_classe, a.fid_domaine)
VALUES (b.fid_classe, b.fid_domaine)
;


-- 11. table TA_GG_FME_MESURE
MERGE INTO G_GESTIONGEO.TA_GG_FME_MESURE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		FID_CLASSE AS fid_classe,
		VALEUR AS valeur,
		FID_MESURE AS fid_mesure
	FROM
		G_DALC.TA_GG_FME_MESURE
	) b
ON (a.objectid = b.objectid
AND a.fid_classe = b.fid_classe
AND a.valeur = b.valeur
AND a.fid_mesure = b.fid_mesure)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.fid_classe, a.valeur, a.fid_mesure)
VALUES (b.objectid, b.fid_classe, b.valeur, b.fid_mesure)
;

-- 12. table TA_GG_GEO
MERGE INTO G_GESTIONGEO.TA_GG_GEO a
USING
	(
	SELECT
		OBJECTID AS objectid,
		ORA_GEOMETRY AS geom
	FROM
		G_DALC.TA_GG_GEO
	) b
ON (a.objectid = b.objectid)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.geom)
VALUES (b.objectid, b.geom)
;

-- 13. table TA_GG_REPERTOIRE
MERGE INTO G_GESTIONGEO.TA_GG_REPERTOIRE a
USING
	(
	SELECT
		OBJECTID AS objectid,
		REPERTOIRE AS repertoire,
		PROTOCOLE AS protocole
	FROM
		G_DALC.TA_GG_REPERTOIRE
	) b
ON (a.objectid = b.objectid
AND a.repertoire = b.repertoire
AND a.protocole = b.protocole)
WHEN NOT MATCHED
THEN INSERT (a.objectid, a.repertoire, a.protocole)
VALUES (b.objectid, b.repertoire, b.protocole)
;