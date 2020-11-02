-- insertion des données du RPG dans le schéma G_ADT_AGRI
------------------------------------------------
-- 1. Traitement SQL pour la couche RPG_2019_MEL
------------------------------------------------

-- 1.1. creation de la clé primaire

-- 1.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_1 VARCHAR2(200);
BEGIN
SELECT
    CONSTRAINT_NAME
    INTO v_nom_1
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_2019_MEL DROP CONSTRAINT ' || v_nom_1;
END;
/

-- 1.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 1.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_2019_MEL
SET OBJECTID = null;

-- 1.1.3. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 1.1.4. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_2019_MEL
BEFORE INSERT ON RPG_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_2019_MEL.nextval;
END;
/

-- 1.1.5. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_2019_MEL
SET objectid = SEQ_RPG_2019_MEL.nextval;

-- 1.1.6. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_2019_MEL
ADD CONSTRAINT RPG_2019_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";

-- 1.2. Création des métadonnées spatiales

-- 1.2.1. Ajouter une colonne SDO_GEOM à la fin de la table
ALTER TABLE G_ADT_AGRI.RPG_2019_MEL
ADD GEOM SDO_GEOMETRY;


-- 1.2.2 Ajout des métadonnées spatiales
DELETE FROM "USER_SDO_GEOM_METADATA" WHERE TABLE_NAME = 'RPG_2019_MEL';

INSERT INTO "USER_SDO_GEOM_METADATA" (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES (
    'RPG_2019_MEL',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),
    SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 2154);
COMMIT;

UPDATE USER_SDO_GEOM_METADATA
SET
   TABLE_NAME = 'RPG_2019_MEL',
   COLUMN_NAME = 'GEOM', 
   DIMINFO = SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005), SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)),
   SRID = 2154
WHERE TABLE_NAME = 'RPG_2019_MEL';

-- 1.2.3. Supression de l'index créé automatique
DROP INDEX RPG_2019_MEL_IDX;

-- 1.2.4. Ajout des index spatiaux
CREATE INDEX RPG_2019_MEL_SIDX
ON G_ADT_AGRI.RPG_2019_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=INDX_G_ADT, work_tablespace=DATA_TEMP');


-- 1.2.5. Ajout de la géométrie dans la colonne GEOM
UPDATE G_ADT_AGRI.RPG_2019_MEL
SET GEOM = ORA_GEOMETRY;


-- 1.2.6. Suppression de la colonne ORA_GEOMETRY
ALTER TABLE G_ADT_AGRI.RPG_2019_MEL DROP COLUMN ORA_GEOMETRY;

-- 1.3 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_2019_MEL IS 'table contenant les parcelles agricoles issues du Registre Parcellaire Graphique dit le RPG';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.NUM_ILOT IS 'Numéro de l''ilot';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.NUM_PARCEL IS 'Numéro de la parcelle';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.CODE_CULTU IS 'Code culture principale';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.SURF_ADM IS 'Surface admissible déclarée de la parcelle en ares';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.PRECISION IS 'Précision déclarée par l''agriculteur en ares.';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.RECONVER_P IS 'Reconversion prairie ';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.RETOURNMT_ IS 'Retournement_prairie ';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.SEMENCE IS 'Production semences certifiées';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.DEST_ICHN IS 'Indemnités compensatoires de handicaps naturels';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.CULTURE_D1 IS 'Code de la première culture composant le mélange SIE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.CULTURE_D2 IS 'Code de la deuxième culture composant le mélange SIE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.BIO IS 'Culture en agriculture biologique';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.ENGAGEMENT IS 'renseigné si l''agriculteur demande à bénéficier d''une aide RDR3 en faveur de l''agriculture biologique';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.MARAICHAGE IS 'Renserigné si l''agiculteur à déclaré que la culture était conduite en maraichage. 0 sinon';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.AGROFOREST IS 'renseigné que si la parcelle est conduite en agroforesterie';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.FORCE_MAJE IS 'PAS DE DEFINITION TROUVEE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.DEP_ILOT IS 'Departement de l''ilot';
COMMENT ON COLUMN G_ADT_AGRI.RPG_2019_MEL.OBJECTID IS 'Clé primaire de la table';

------------------------------------------------
-- 2. Traitement SQL pour la couche RPG_PARC_INSTRUITES_2019_MEL
------------------------------------------------
-- 2.1. creation de la clé primaire
-- 2.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_2 VARCHAR2(200);
BEGIN
    SELECT
        CONSTRAINT_NAME
    INTO v_nom_2
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_PARC_INSTRUITES_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
    
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL DROP CONSTRAINT ' || v_nom_2;
END;
/

-- 2.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 2.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL
SET OBJECTID = null;

-- 2.1.3. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_INSTRUITES_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 2.1.4. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_INSTRUITES_2019_MEL
BEFORE INSERT ON RPG_PARC_INSTRUITES_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_INSTRUITES_2019_MEL.nextval;
END;
/

-- 2.1.5. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL
SET objectid = SEQ_RPG_INSTRUITES_2019_MEL.nextval;

-- 2.1.6. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL
ADD CONSTRAINT RPG_INSTRUITES_2019_MEL_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";

-- 2.2 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL IS 'Table contenant les surfaces instruites du Registe Parcellaire Graphique';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.NUMILOT IS 'Numéro de l''ilot';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.NUMPAR IS 'Numéro de la parcelle';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.IDPAR IS 'Identification de la parcelle concatenation NUMILOT et NUMPAR';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.DEPPAR IS 'Departement de la parcelle';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.COMMPAR IS 'Code commune de la parcelle';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.CODCULTPAR IS 'Code culture principale';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.CATEG_CULT_PR IS 'Catégorie de la culture principale';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.SURFPAR_ADMISS_CST_ARE IS 'Surface admissible constatée 1er pilier';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.SURFPAR_ADMISS_DEC_ARE IS 'Surface admissible déclarée 1er pilier';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.SURFPAR_GRAPH_CST_ARE IS 'Surface graphique constatée';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.PRECISION_CULTURE IS 'Precision_culture';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.ID_PAR_RATTACH IS 'PAS DE DEFINITION TROUVEE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.DESTINATION_ICHN IS 'Destination Indemnités compensatoires de handicaps naturels';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.PREM_CULT_SIE IS 'Première culture mélange SIE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.DEUX_CULT_SIE IS 'Deuxième culture mélange SIE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.CULT_AB IS 'Culture AB';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.CULT_AB_MARAICH IS 'Culture AB en maraichage';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.PROD_SEM_CERTI IS 'Production semences certifiées';
COMMENT ON COLUMN G_ADT_AGRI.RPG_PARC_INSTRUITES_2019_MEL.OBJECTID IS 'Clé primaire de la table';

------------------------------------------------
-- 3. Traitement SQL pour la couche RPG_FORMEJURIDIQUE_2019_MEL
------------------------------------------------
-- 3.1. creation de la clé primaire
-- 3.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_3 VARCHAR2(200);
BEGIN
    SELECT
        CONSTRAINT_NAME
    INTO v_nom_3
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_FORMEJURIDIQUE_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
    
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL DROP CONSTRAINT ' || v_nom_3;
END;
/

-- 3.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 3.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL
SET OBJECTID = null;

-- 3.1.4. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_JURIDIQUE_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 3.1.5. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_JURIDIQUE_2019_MEL
BEFORE INSERT ON RPG_FORMEJURIDIQUE_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_JURIDIQUE_2019_MEL.nextval;
END;
/

-- 3.1.6. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL
SET objectid = SEQ_RPG_JURIDIQUE_2019_MEL.nextval;

-- 3.1.7. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL
ADD CONSTRAINT RPG_FORMEJURIDIQUE_2019_MEL_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";

-- 3.2 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL IS 'Table contenant les numéros de pacage des exploitants et la forme juridique de l''exploitation';
COMMENT ON COLUMN G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL.FORME_JURIDIQUE IS 'Forme juridique de l''exploitation';
COMMENT ON COLUMN G_ADT_AGRI.RPG_FORMEJURIDIQUE_2019_MEL.OBJECTID IS 'Clé primaire de la table';

------------------------------------------------
-- 4. Traitement SQL pour la couche RPG_ILOTS_DESCRIPTION_2019_MEL
------------------------------------------------
-- 4.1. creation de la clé primaire
-- 4.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_4 VARCHAR2(200);
BEGIN
    SELECT
        CONSTRAINT_NAME
    INTO v_nom_4
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_ILOTS_DESCRIPTION_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
    
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL DROP CONSTRAINT ' || v_nom_4;
END;
/

-- 4.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 4.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL
SET OBJECTID = null;

-- 4.1.4. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_DESCRIPTION_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 4.1.5. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_DESCRIPTION_2019_MEL
BEFORE INSERT ON RPG_ILOTS_DESCRIPTION_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_DESCRIPTION_2019_MEL.nextval;
END;
/

-- 4.1.6. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL
SET objectid = SEQ_RPG_DESCRIPTION_2019_MEL.nextval;

-- 4.1.7. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL
ADD CONSTRAINT RPG_DESCRIPTION_2019_MEL_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";


-- 4.2 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL IS 'Table contenant les numéros de pacage des exploitants et leurs ilots';
COMMENT ON COLUMN G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL.NUMILOT IS 'Numéro d''ilot de l''exploitation';
COMMENT ON COLUMN G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL.COMMUNE_ILOT IS 'Code insee de l''ilot';
COMMENT ON COLUMN G_ADT_AGRI.RPG_ILOTS_DESCRIPTION_2019_MEL.OBJECTID IS 'Clé primaire de la table';

------------------------------------------------
-- 5. Traitement SQL pour la couche RPG_AIDES_2ND_PILIER_2019_MEL
------------------------------------------------
-- 5.1. creation de la clé primaire
-- 5.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_5 VARCHAR2(200);
BEGIN
    SELECT
        CONSTRAINT_NAME
    INTO v_nom_5
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_AIDES_2ND_PILIER_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
    
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL DROP CONSTRAINT ' || v_nom_5;
END;
/

-- 5.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 5.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL
SET OBJECTID = null;

-- 5.1.4. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_2ND_PILIER_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 5.1.5. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_2ND_PILIER_2019_MEL
BEFORE INSERT ON RPG_AIDES_2ND_PILIER_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_2ND_PILIER_2019_MEL.nextval;
END;
/

-- 5.1.6. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL
SET objectid = SEQ_RPG_2ND_PILIER_2019_MEL.nextval;

-- 5.1.7. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL
ADD CONSTRAINT RPG_2ND_PILIER_2019_MEL_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";


-- 5.2 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL IS 'Table contenant les droits des agriculteurs aux aides dites du 2nd pilier';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.FINANCEUR IS 'Financeur';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.MONTANT_NET_PAYE_ASSUR_RECOLTE IS 'Montant net payé Assurance récolte';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.MONTANT_NET_PAYE_ICHN_RDR3 IS 'Montant net payé ichn Base (RDR 3: règlement de développement rural 3)';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.MONTANT_NET_PAYE_ICHN_MP IS 'Montant net payé ICHN Marais Poitevin';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.MONTANT_NET_PAYE_TOTAL_P2 IS 'Montant net paye total';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.N IS 'PAS DE DEFINITION TROUVE';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_2ND_PILIER_2019_MEL.OBJECTID IS 'Clé primaire de la table';


------------------------------------------------
-- 6. Traitement SQL pour la couche RPG_AIDES_1ER_PILIER_2019_MEL
------------------------------------------------
-- 6.1. creation de la clé primaire
-- 6.1.1. suppression de la contrainte de la clé primaire
SET SERVEROUTPUT ON
DECLARE
    v_nom_6 VARCHAR2(200);
BEGIN
    SELECT
        CONSTRAINT_NAME
    INTO v_nom_6
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'RPG_AIDES_1ER_PILIER_2019_MEL'
    AND CONSTRAINT_TYPE = 'P';
    
EXECUTE IMMEDIATE 'ALTER TABLE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL DROP CONSTRAINT ' || v_nom_6;
END;
/

-- 6.1.2. Renommer la colonne OGR_FID en OBJECTID
ALTER TABLE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL RENAME COLUMN OGR_FID TO OBJECTID;

-- 6.1.3. Vider la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL
SET OBJECTID = null;

-- 6.1.4. Ajout de la séquence
CREATE SEQUENCE SEQ_RPG_1ER_PILIER_2019_MEL INCREMENT BY 1 START WITH 1 NOCACHE;

-- 6.1.5. Ajout du trigger
CREATE OR REPLACE TRIGGER BEF_RPG_1ER_PILIER_2019_MEL
BEFORE INSERT ON RPG_AIDES_1ER_PILIER_2019_MEL FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_RPG_1ER_PILIER_2019_MEL.nextval;
END;
/

-- 6.1.6. Mise à jour de la colonne OBJECTID
UPDATE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL
SET objectid = SEQ_RPG_1ER_PILIER_2019_MEL.nextval;

-- 6.1.7. Ajout de la contrainte de clé primaire
ALTER TABLE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL
ADD CONSTRAINT RPG_1ER_PILIER_2019_MEL_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_G_ADT";


-- 6.2 Commentaire des tables et des colonnes
COMMENT ON TABLE G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL IS 'Table contenant les droits des agriculteurs aux aides dites du 1er pilier';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.PACAGE IS 'Numéro pacage, numéro d''identification de l''exploitation agricole';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.NB_DPB IS 'Nombre de droits attribués';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.VALEUR_UNITAIRE_2015 IS 'Montant unitaire 2015';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.VALEUR_UNITAIRE_2016 IS 'Montant unitaire 2016';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.VALEUR_UNITAIRE_2017 IS 'Montant unitaire 2017';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.VALEUR_UNITAIRE_2018 IS 'Montant unitaire 2018';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.VALEUR_UNITAIRE_2019 IS 'Montant unitaire 2018';
COMMENT ON COLUMN G_ADT_AGRI.RPG_AIDES_1ER_PILIER_2019_MEL.OBJECTID IS 'Clé primaire de la table';

COMMIT;