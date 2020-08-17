/*
La table ta_source permet de rassembler toutes les données sources provenant d'une source extérieure à la MEL.
*/

-- 1. Création de la table ta_source
CREATE TABLE ta_date_acquisition(
    objectid NUMBER(38,0),
    date_acquisition DATE,
    millesime DATE,
    nom_obtenteur VARCHAR2(200)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_date_acquisition IS 'Table recensant les dates d''acquisition, de millésime et du nom de l''obtenteur de chaque donnée source extérieure à la MEL.';
COMMENT ON COLUMN geo.ta_date_acquisition.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_date_acquisition.date_acquisition IS 'Date d''importation de la donnée dans la table - DD/MM/AAAA.';
COMMENT ON COLUMN geo.ta_date_acquisition.millesime IS 'Date de création de la donnée - MM/AAAA.';
COMMENT ON COLUMN geo.ta_date_acquisition.nom_obtenteur IS 'Nom de la personne ayant inséré la donnée source dans la base.';

-- 3. Création de la clé primaire
ALTER TABLE ta_date_acquisition 
ADD CONSTRAINT ta_date_acquisition_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_date_acquisition
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_date_acquisition
BEFORE INSERT ON ta_date_acquisition
FOR EACH ROW
BEGIN
    	:new.objectid := SEQ_ta_date_acquisition.nextval;
    END IF;
END;

-- 8. Création du déclencheur d'enregistrement de la date d'insertion de la donnée et du nom de la personne ayant fait cet import, dans la table ta_date_acquisition.

CREATE OR REPLACE TRIGGER ta_date_acquisition
BEFORE INSERT ON ta_source
FOR EACH ROW
DECLARE
	username VARCHAR2(200)

BEGIN
	select sys_context('USERENV','OS_USER') into username from dual;
	IF INSERTING THEN
		ta_date_acquisition.date_acquisition := sysdate;
		ta_date_acquisition.nom_obtenteur := username; 
	END IF;

END;
-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_date_acquisition TO G_ADMIN_SIG;