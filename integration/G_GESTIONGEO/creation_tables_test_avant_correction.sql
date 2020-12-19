-- Suppression des tables test
/*
DROP TABLE GEO.TEMP_TA_GG_GEO CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'TEMP_TA_GG_GEO';
COMMIT;

DROP TABLE GEO.TEMP_TA_GG_DOSSIER CASCADE CONSTRAINTS;
DROP SEQUENCE "GEO"."SEQ_TEMP_TA_GG_DOSSIER";

DROP TABLE GEO.TEMP_GEO_CORRECT_DOUBLONS CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'TEMP_GEO_CORRECT_DOUBLONS';
COMMIT;
DROP SEQUENCE "GEO"."SEQ_TEMP_GEO_CORRECT_DOUBLONS";
*/
-- Création d'une table temporaire pour TA_GG_DOSSIER
-- 1. Création de la table TEMP_TA_GG_DOSSIER
CREATE TABLE GEO.TEMP_TA_GG_DOSSIER
AS (SELECT * FROM GEO.TA_GG_DOSSIER);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE GEO.TEMP_TA_GG_DOSSIER IS 'TABLE A NE PAS UTILISER. Table de correction et de test des données de TA_GG_DOSSIER.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.ID_DOS IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.SRC_ID IS 'Clé étrangère vers la table TA_GG_SOURCE permettant de savoir quel utilisateur a créé quel dossier - champ utilisé uniquement pour de la création';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.ETAT_ID IS 'Clé étrangère vers la table TA_GG_ETAT indiquant l''état d''avancement du dossier - avec contrainte';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.USER_ID IS 'Identifiant du pnom ayant modifié ou qui modifie un dossier - ce champ fait référence à TA_GG_SOURCE.SRC_ID avec contrainte)';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.FAM_ID IS 'Clé étrangère vers la table TA_GG_FAMILLE permettant de savoir à quelle famille appartient chaque dossier : plan de récolement, investigation complémentaire, maj carto - avec contrainte';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DC IS 'Date de création du dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DMAJ IS 'Date de mise à jour du dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_RQ IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_FIN IS 'Date de clôture du dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_PRIORITE IS 'Priorité de traitement des dossiers par les géomètres.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_IDPERE IS 'Indique un numéro de dossier associé s''il y en a un (ce champ accepte les NULL) - n''est plus utilisé';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_DEB_TR IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_FIN_TR IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_CMD_SAI IS 'Date de commande ou de création de dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_INSEE IS 'Code INSEE de la commune dans laquelle se situe l''objet nécessitant un dossier.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_VOIE IS 'Clé étrangère (sans contrainte de FK)';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_MAO IS 'Nom du maître d''ouvrage';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_ENTR IS 'Nom de l''entreprise responsable du levé';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_URL_FILE IS 'Lien vers le fichier dwg intégré dans infogeo par DynMap';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_NUM IS 'Numéro de chaque dossier - différent de son identifiant ID_DOS (PK). Ce numéro est obtenu par la concaténation des deux derniers chiffres de l''année (sauf pour les années antérieures à 2010), du code commune (3 chiffres) et d''une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l''année.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_OLD_ID IS 'Ancien identifiant du dossier';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_DEB_LEVE IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_DOSSIER.DOS_DT_FIN_LEVE IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';

-- Contrainte de clé primaire
ALTER TABLE GEO.TEMP_TA_GG_DOSSIER
ADD CONSTRAINT TEMP_TA_GG_DOSSIER_PK
PRIMARY KEY("ID_DOS")
USING INDEX TABLESPACE INDX_GEO;

-- Contraintes de clé étrangère
ALTER TABLE GEO.TEMP_TA_GG_DOSSIER
ADD CONSTRAINT TMP_DOS_CORRECTION_ETAT_ID_FK
FOREIGN KEY("ETAT_ID")
REFERENCES GEO.TA_GG_ETAT ("ETAT_ID");

ALTER TABLE GEO.TEMP_TA_GG_DOSSIER
ADD CONSTRAINT TMP_DOS_CORRECTION_FAM_ID_FK
FOREIGN KEY("FAM_ID")
REFERENCES GEO.TA_GG_FAMILLE ("FAM_ID");

ALTER TABLE GEO.TEMP_TA_GG_DOSSIER
ADD CONSTRAINT TMP_DOS_CORRECTION_SRC_ID_FK
FOREIGN KEY("SRC_ID")
REFERENCES GEO.TA_GG_SOURCE ("SRC_ID");

-- Création d'une table test pour TA_GG_GEO
-- 1. Création de la table TEMP_TA_GG_GEO
CREATE TABLE GEO.TEMP_TA_GG_GEO
AS (SELECT * FROM GEO.TA_GG_GEO);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE GEO.TEMP_TA_GG_GEO IS 'TABLE A NE PAS UTILISER. Sauvegarde de la table TA_GG_DOSSIER avant l''exécution des corrections et sa migration sur MULTIT.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.ID_GEOM IS 'Clé primaire (identifiant unique) de la table auto-incrémentée par un trigger.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.ID_DOS IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un dossier à une géométrie.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.CLASSE_DICT IS 'Identifiant des réseaux contenus dans la charte topographique et réseaux de la DSIG';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.GEOM IS 'Champ géométrique de la table (mais sans contrainte de type de géométrie).';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.ETAT_ID IS 'Identifiant de l''état d''avancement du dossier. Attention même si ce champ reprend les identifiants de la table TA_GG_ETAT, il n''y a pas de contrainte de clé étrangère dessus pour autant.';
COMMENT ON COLUMN GEO.TEMP_TA_GG_GEO.DOS_NUM IS 'Numéro de dossier associé à la géométrie de la table. Ce numéro est obtenu par la concaténation des deux derniers chiffres de l''année (sauf pour les années antérieures à 2010), du code commune (3 chiffres) et d''une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l''année.';

-- 3. Création de la clé primaire
ALTER TABLE GEO.TEMP_TA_GG_GEO 
ADD CONSTRAINT TEMP_TA_GG_GEO_PK 
PRIMARY KEY("ID_GEOM") 
USING INDEX TABLESPACE "INDX_GEO";

-- Contrainte de clé étrangère de TA_GG_GEO vers TA_GG_DOSSIER
ALTER TABLE GEO.TEMP_TA_GG_GEO
ADD CONSTRAINT TEMP_TA_GG_GEO_ID_DOS_FK
FOREIGN KEY ("ID_DOS") REFERENCES GEO.TEMP_TA_GG_DOSSIER ("ID_DOS") ON DELETE CASCADE;

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TEMP_TA_GG_GEO',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;
-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX TEMP_TA_GG_GEO_SIDX
ON GEO.TEMP_TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');

-- Création d'une table test pour TA_GEO_CORRECT_DOUBLONS
-- 1. Création de la table TEMP_TA_GG_GEO
CREATE TABLE GEO.TEMP_GEO_CORRECT_DOUBLONS
AS (SELECT * FROM GEO.TA_GEO_CORRECT_DOUBLONS);

COMMENT ON COLUMN "GEO"."TEMP_GEO_CORRECT_DOUBLONS"."OBJECTID" IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN "GEO"."TEMP_GEO_CORRECT_DOUBLONS"."ID_GEOM" IS 'Identifiant unique des entités de la table TA_GG_GEO.';
COMMENT ON COLUMN "GEO"."TEMP_GEO_CORRECT_DOUBLONS"."DOS_NUM" IS 'Numéro de dossier.';
COMMENT ON COLUMN "GEO"."TEMP_GEO_CORRECT_DOUBLONS"."GEOM" IS 'Géométrie de chaque objet.';
COMMENT ON COLUMN "GEO"."TEMP_GEO_CORRECT_DOUBLONS"."ACTION" IS 'Action à entreprendre suite à une vérification visuelle (QGIS), afin de corriger les doublons. Exemple : fusion, suppression.';
COMMENT ON TABLE "GEO"."TEMP_GEO_CORRECT_DOUBLONS"  IS 'TABLE A NE PAS UTILISER. Table test servant à tester l''enchaînement des codes de correction et import. C''est le duplicata de TA_GEO_CORRECT_DOUBLONS.';

-- 4.3. Les métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TEMP_GEO_CORRECT_DOUBLONS',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4.4. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE GEO.TEMP_GEO_CORRECT_DOUBLONS
ADD CONSTRAINT TEMP_GEO_CORRECT_DOUBLONS_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE INDX_GEO;

CREATE INDEX "GEO"."TEMP_GEO_CORRECT_DOUBLONS_SIDX" ON "GEO"."TEMP_GEO_CORRECT_DOUBLONS" ("GEOM") 
INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS ('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');

/*SELECT MAX(objectid)+1
FROM
    GEO.TEMP_GEO_CORRECT_DOUBLONS;*/
  
CREATE SEQUENCE  "GEO"."SEQ_TEMP_GEO_CORRECT_DOUBLONS"  
INCREMENT BY 1 START WITH 486;
   
CREATE OR REPLACE TRIGGER "GEO"."BEF_TEMP_GEO_CORRECT_DOUBLONS" 
BEFORE INSERT ON TEMP_GEO_CORRECT_DOUBLONS
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TEMP_GEO_CORRECT_DOUBLONS.nextval;
END;
