-- CREATE TABLE TA_RTGE_MUF_STATUT
-- Table qui présente les MUF relevé par les géomètres selon leurs statu (relevé par le geometre / perpendiculaire / construction)

CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_RTGE_MUF_STATUT
	(
		OBJECTID INTEGER,
		STATUT INTEGER
	)
;

-- 2.1.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_MUF_STATUT IS 'Table qui présente les MUF relevé par les géomètres selon leurs statu (relevé par le geometre / perpendiculaire / construction)';


-- 2.1.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_MUF_STATUT.objectid IS 'Identifiant de la ligne considérée';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_MUF_STATUT.statut IS 'Statut de la ligne: relevé, parrallèle, construite.';


-- 2.1.4. Contraintes

-- 2.1.4.1. Clé primaire
ALTER TABLE TA_RTGE_MUF_STATUT
ADD CONSTRAINT TA_RTGE_MUF_STATUT_PK 
PRIMARY KEY (objectid)
;


-- 2.1.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_MUF_STATUT TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_MUF_STATUT TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_MUF_STATUT TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_MUF_STATUT TO G_GESTIONGEO_LEC;
GRANT SELECT, UPDATE, DELETE, INSERT ON G_GESTIONGEO.TA_RTGE_MUF_STATUT TO G_GESTIONGEO_MAJ;

/
