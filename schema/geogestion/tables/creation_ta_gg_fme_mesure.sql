
/*
TA_GG_FME_MESURE : La table TA_GG_FME_MESURE est utilisée pour attribuer génériquement une longueur et une largeur cartographique à des classes d''objets.
*/

-- 1. Création de la table TA_GG_FME_MESURE
CREATE TABLE G_GESTIONGEO.TA_GG_FME_MESURE (
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID.NEXTVAL NOT NULL,
	FID_CLASSE NUMBER(38,0) NOT NULL,
	LONGUEUR NUMBER(38,0) NOT NULL,
	LARGEUR NUMBER(38,0) NOT NULL
 );

 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FME_MESURE IS 'Table utilisée par la chaine d''intégration FME. Elle permet d''attribuer au symbole de chaque type de point une longueur et une largeur correspondant à la longueur et la largeur de leur classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.FID_CLASSE IS 'Clé étrangère vers la table TA_GG_CLASSE.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.LONGUEUR IS 'Valeur de la longueur attribuée au symbole de la classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.LARGEUR IS 'Valeur de la largeur attribuée au symbole de la classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.fid_traitement IS 'Clé étrangère vers la table TA_GG_TRAITEMENT_FME pour connaitre le signet des opérations FME utilisant les valeurs de la table.';

-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.2. Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_FID_CLASSE_FK
FOREIGN KEY("FID_CLASSE")
REFERENCES G_GESTIONGEO.TA_GG_CLASSE ("OBJECTID");

-- 4. Création des index sur les clés étrangères
CREATE INDEX TA_GG_FME_MESURE_FID_CLASSE_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (FID_CLASSE)
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_LONGUEUR_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (LONGUEUR) 
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_LARGEUR_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (LARGEUR) 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW;

/
