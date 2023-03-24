-- 1. Création de la table TA_RVLLP
-- 1.1. La table TA_RVLLP sert à acceuillir les informations provenant des données OCS2D
CREATE TABLE G_DGFIP.TA_RVLLP(
	objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
	fid_idu VARCHAR2(2000),
	fid_code_rvllp NUMBER(38,0),
	fid_metadonnee NUMBER(38,0)
);

-- 1.2. Création des commentaires
COMMENT ON TABLE G_DGFIP.TA_RVLLP IS 'La table TA_RVLLP sert à regrouper les secteurs fiscaux de la taxe dite RVLLP(Revision des Valeurs Locatives des Locaux Professionnels).';
COMMENT ON COLUMN G_DGFIP.TA_RVLLP.objectid IS 'Clé primaire de la table TA_RVLLP.';
COMMENT ON COLUMN G_DGFIP.TA_RVLLP.fid_idu IS 'Clé étrangère vers la table SECTION_CADASTRALE pour connaitre la section concerné par le code section de la section RVLLP.';
COMMENT ON COLUMN G_DGFIP.TA_RVLLP.fid_code_RVLLP IS 'Clé étrangère vers la table TA_CODE pour connaitre le code section de la section RVLLP.';
COMMENT ON COLUMN G_DGFIP.TA_RVLLP.fid_metadonnee IS 'Clé étrangère vers la table TA_METADONNEE.';

-- 1.3. Création de la clé primaire
ALTER TABLE G_DGFIP.TA_RVLLP
ADD CONSTRAINT ta_rvllp_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 1.4. Création des clé étrangère

-- 1.4.1. vers la table ta_libelle pour les occupations du sol
ALTER TABLE G_DGFIP.TA_RVLLP
ADD CONSTRAINT "TA_RVLLP_FID_IDU_FK" 
FOREIGN KEY ("FID_IDU")
REFERENCES S.EDIGEO.SECTION_CADASTRALE(SEC_IDU);

-- 1.4.2. vers la table ta_libelle pour les utilisations du sol
ALTER TABLE G_DGFIP.TA_RVLLP
ADD CONSTRAINT "TA_RVLLP_FID_CODE_RVLLP_FK" 
FOREIGN KEY ("FID_CODE_RVLLP")
REFERENCES G_GEO.TA_CODE(objectid);

-- 1.4.3. vers la table ta_metadonnee pour les commentaires OCS2D
ALTER TABLE G_DGFIP.TA_RVLLP
ADD CONSTRAINT "TA_RVLLP_FID_METADONNEE_FK" 
FOREIGN KEY ("FID_METADONNEE")
REFERENCES G_GEO.TA_METADONNEE(objectid);