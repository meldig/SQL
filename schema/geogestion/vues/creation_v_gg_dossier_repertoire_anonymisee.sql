-- CREATION VUE G_GESTIONGEO:

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'V_GG_DOSSIER_REPERTOIRE_ANONYMISEE';
DROP VIEW V_GG_DOSSIER_REPERTOIRE_ANONYMISEE;

-----------------
-- V_GG_DOSSIER_REPERTOIRE_ANONYMISEE--
-----------------

-- Creation de la vue V_GG_DOSSIER_REPERTOIRE_ANONYMISEE afin de restituer les informations des dossiers

-- 1. Creation de la vue.
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE
	(
	NUMERO_DOSSIER, 
	TYPE_DE_DOSSIER, 
	AVANCEMENT, 
	DATE_CREATION, 
	DATE_MODIFICATION, 
	DATE_DEBUT_LEVE, 
	DATE_FIN_LEVE, 
	DATE_DEBUT_TRAVAUX, 
	DATE_FIN_TRAVAUX, 
	DATE_COMMANDE_DOSSIER, 
	DATE_CLOTURE, 
	MAITRE_OUVRAGE, 
	RESPONSABLE_LEVE, 
	ENTREPRISE_TRAVAUX, 
	REMARQUE_GEOMETRE, 
	REMARQUE_PHOTO_INTERPRETE,
	REPERTOIRE, 
	NOM_FICHIER, 
	GEOM,
CONSTRAINT "V_GG_DOSSIER_REPERTOIRE_ANONYMISEE_PK" PRIMARY KEY ("NUMERO_DOSSIER") DISABLE) 
AS
WITH CTE_FICHIER AS
    (
    SELECT
        a.OBJECTID AS NUMERO_DOSSIER,
        c.REPERTOIRE ||a.OBJECTID AS REPERTOIRE, 
        b.FICHIER AS FICHIER
    FROM
        G_GESTIONGEO.TA_GG_DOSSIER a
        RIGHT JOIN G_GESTIONGEO.TA_GG_FICHIER b ON b.FID_DOSSIER = a.OBJECTID,
        G_GESTIONGEO.TA_GG_REPERTOIRE c
    WHERE
        b.INTEGRATION = 1
        AND
        c.objectid = 2
	),
	CTE_SANS_FICHIER AS
	(
	SELECT
	    DISTINCT a.OBJECTID AS NUMERO_DOSSIER,
	    c.REPERTOIRE || a.OBJECTID AS REPERTOIRE,
	    'Fichier intégré non determiné' AS FICHIER
	FROM
	    G_GESTIONGEO.TA_GG_DOSSIER a
	    RIGHT JOIN G_GESTIONGEO.TA_GG_FICHIER b ON b.FID_DOSSIER = a.OBJECTID,
	    G_GESTIONGEO.TA_GG_REPERTOIRE c
	WHERE
	    c.objectid = 2
	    AND FID_DOSSIER NOT IN (SELECT NUMERO_DOSSIER FROM CTE_FICHIER)
	 ),
	CTE_DOSSIER_FICHIER AS
	(
	SELECT
		CTE_FICHIER.NUMERO_DOSSIER,
		CTE_FICHIER.REPERTOIRE,
		CTE_FICHIER.FICHIER
	FROM
		CTE_FICHIER
	UNION
	SELECT
		CTE_SANS_FICHIER.NUMERO_DOSSIER,
		CTE_SANS_FICHIER.REPERTOIRE,
		CTE_SANS_FICHIER.FICHIER
	FROM
		CTE_SANS_FICHIER
	)
SELECT
	a.OBJECTID AS NUMERO_DOSSIER,
	b.LIBELLE AS TYPE_DE_DOSSIER,
	c.LIBELLE_COURT AS AVANCEMENT,
	a.DATE_SAISIE AS DATE_CREATION,
	a.DATE_MODIFICATION AS DATE_MODIFICATION,
	a.DATE_DEBUT_LEVE AS DATE_DEBUT_LEVE,
	a.DATE_FIN_LEVE AS DATE_FIN_LEVE,
	a.DATE_DEBUT_TRAVAUX AS DATE_DEBUT_TRAVAUX,
	a.DATE_FIN_TRAVAUX AS DATE_FIN_TRAVAUX,
	a.DATE_COMMANDE_DOSSIER AS DATE_COMMANDE_DOSSIER,
	a.DATE_CLOTURE AS DATE_CLOTURE,
	a.MAITRE_OUVRAGE AS MAITRE_OUVRAGE,
	a.RESPONSABLE_LEVE AS RESPONSABLE_LEVE,
	a.ENTREPRISE_TRAVAUX AS ENTREPRISE_TRAVAUX,
	a.REMARQUE_GEOMETRE AS REMARQUE_GEOMETRE,
	a.REMARQUE_PHOTO_INTERPRETE AS REMARQUE_PHOTO_INTERPRETE,
    COALESCE(cte.REPERTOIRE,'Le dossier n''a pas de répertoire') AS REPERTOIRE,
    COALESCE(cte.FICHIER,'Fichier intégré non determiné') AS NOM_FICHIER,
	d.GEOM AS GEOM
FROM
	G_GESTIONGEO.TA_GG_DOSSIER a
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE b ON b.objectid = a.fid_famille
	INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement
	INNER JOIN G_GESTIONGEO.TA_GG_GEO d ON d.objectid = a.fid_perimetre
    LEFT JOIN CTE_DOSSIER_FICHIER cte ON cte.numero_dossier = a.objectid
;


-- 2. Commentaire de la vue.
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE IS 'Vue anonymisée qui présente les dossiers de l''appplication gestiongeo avec leurs informations. Les dossiers gestiongeo contiennent les périmètres des surfaces sur lesquelles les éléments urbains ont été relevés par des géomètres';


-- 3. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.NUMERO_DOSSIER IS 'Numéro du dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.TYPE_DE_DOSSIER IS 'Type de dossier: Investigation Complémentaire (IC) ou RECOLEMENT)';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.AVANCEMENT IS 'Etat d''avancement du dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_CREATION IS 'Date de création du dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_MODIFICATION IS 'Date de modification du dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_DEBUT_LEVE IS 'Date de début du levé';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_FIN_LEVE IS 'Date de fin du levé';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_DEBUT_TRAVAUX IS 'Date de début des travaux';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_FIN_TRAVAUX IS 'Date de fin des travaux';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_COMMANDE_DOSSIER IS 'Date de commande du levé';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.DATE_CLOTURE IS 'Date de cloture du dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.MAITRE_OUVRAGE IS 'Nom du maître d''ouvrage';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.RESPONSABLE_LEVE IS 'Nom de l''entreprise responsable du levé';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.ENTREPRISE_TRAVAUX IS 'Entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.REMARQUE_GEOMETRE IS 'Précision apportée au dossier par le géomètre telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.REMARQUE_PHOTO_INTERPRETE IS 'Remarque du photo-interprète lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.REPERTOIRE IS 'Répertoire dans lequel sont rangés les fichiers attachés au dossier';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.NOM_FICHIER IS 'Nom du fichier ayant permis l''intégration des données en base.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE.GEOM IS 'Géométrie du dossier - type multipolygone';


-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_GG_DOSSIER_REPERTOIRE_ANONYMISEE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;

-- 5. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_REPERTOIRE_ANONYMISEE TO G_GESTIONGEO_MAJ;

/