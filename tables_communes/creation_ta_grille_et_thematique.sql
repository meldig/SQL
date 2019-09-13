-- Création de la table ta_grille

-- 1. Création de la table
CREATE TABLE ta_grille(
	objectid NUMBER(38,0),
	fid_thematique NUMBER(38,0),
	fid_lib_etat NUMBER(38,0),
	geo_nmn Varchar2(20),
	geo_dm DATE,
	geom SDO_GEOMETRY
);

-- 2. Création de la clé primaire
ALTER TABLE 
  ta_grille 
ADD CONSTRAINT 
  ta_grille_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX 
TABLESPACE 
  "INDX_GEO";

-- 3. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_grille IS 'Table octroyant une grille de lecture et de gestion au territoire de la MEL';
COMMENT ON COLUMN geo.ta_grille.objectid IS 'Identifiant autoincrémenté de chaque objet de la grille.';
COMMENT ON COLUMN geo.ta_grille.fid_thematique IS 'clé étrangère liant les objets de la grille à la thématique - ta_thematique.';
COMMENT ON COLUMN geo.ta_grille.fid_lib_etat IS 'Clé étrangère liant les objets de la grille à leur libellé.';
COMMENT ON COLUMN geo.ta_grille.geo_nmn IS 'Auteur de la dernière modification de l''objet';
COMMENT ON COLUMN geo.ta_grille.geo_dm IS 'Date de la dernière modification de l''objet.';
COMMENT ON COLUMN geo.ta_grille.geom IS 'Géométrie des objets de type polygone.';

-- 4. Création des métadonnées spatiales de la table ta_grille
INSERT INTO USER_SDO_GEOM_METADATA(
    table_name, 
    column_name,
    diminfo, 
    srid
)
VALUES(
    'ta_grille', 
    'geom', 
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),
        SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)
    ), 
    2154
);

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX ta_grille_SIDX
ON ta_grille(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=INDX_GEO , work_tablespace=DATA_TEMP');

-- 6. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_grille
START WITH 1 INCREMENT BY 1;

-- 7. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_grille
BEFORE INSERT ON ta_grille
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_grille.nextval;
END;

-- 8. Création des clés étrangères
ALTER TABLE ta_grille
ADD CONSTRAINT ta_grille_fid_theme_FK 
FOREIGN KEY (fid_thematique)
REFERENCES GEO.ta_thematique(objectid)
;

ALTER TABLE ta_grille
ADD CONSTRAINT ta_grille_fid_lib_etat_FK 
FOREIGN KEY (fid_lib_etat)
REFERENCES GEO.ta_libelle(objectid)
;

-- 9. Création d'un index sur les clés étrangères
CREATE INDEX ta_grille_fid_theme_IDX ON ta_grille(fid_thematique)
    TABLESPACE INDX_GEO;

CREATE INDEX ta_grille_fid_lib_etat_IDX ON ta_grille(fid_lib_etat)
    TABLESPACE INDX_GEO;

-- 10. Création du déclencheur mettant à jour des champs geo_nmn et geo_dm
CREATE OR REPLACE TRIGGER ta_grille
    BEFORE UPDATE ON ta_grille
    FOR EACH ROW

    BEGIN
        IF UPDATING THEN
            :new.geo_dm := sysdate;
            :new.geo_nmn := sys_context('USERENV','OS_USER');
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.ta_grille','trigger@lillemetropole.fr');
    END;

/* 11. Trigger empêchant la suppression des données
Source : Defining Your Own Error Messages: Procedure RAISE_APPLICATION_ERROR
https://docs.oracle.com/cd/B19306_01/appdev.102/b14261/errors.htm#i3372
*/

CREATE OR REPLACE  TRIGGER ta_grille_no_delete
    BEFORE DELETE ON ta_grille
    FOR EACH ROW

    BEGIN
        IF DELETING THEN
            RAISE_APPLICATION_ERROR(-20001, 'Vous devez catégoriser les objets de la grille et non les supprimer. Il faut donc créer une nouvelle thématique, refaire une grille et affecter la nouvelle thématique à la nouvelle grille.');
        END IF;

END;
        
-- 12. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_grille TO G_ADT_DSIG_ADM;

-- 1. Création de la table ta_thematique

CREATE TABLE ta_thematique(
    objectid NUMBER(38,0),
    thematique VARCHAR2(4000),
    geo_ds DATE
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_thematique IS 'Table regroupant toutes les thématiques utilisées dans la table ta_grille';
COMMENT ON COLUMN geo.ta_thematique.objectid IS 'Identifiant autoincrémenté de chaque thématique.';
COMMENT ON COLUMN geo.ta_thematique.thematique IS 'Thématique décrivant l''utilisation de la grille ta_grille.';
COMMENT ON COLUMN geo.ta_thematique.geo_ds IS 'Date de création de la thématique.';

-- 3. Création de la clé primaire
ALTER TABLE 
  ta_thematique 
ADD CONSTRAINT 
  ta_thematique_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX 
TABLESPACE 
  "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_thematique
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_thematique
BEFORE INSERT ON ta_thematique
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_thematique.nextval;
END;

-- 6. Création du déclencheur d'insertion de la date de création de la thématique dans le champ geo_ds
CREATE OR REPLACE TRIGGER ta_thematique_geo_ds
    BEFORE INSERT ON ta_thematique
    FOR EACH ROW

    BEGIN
        IF INSERTING THEN
            :new.geo_ds := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.ta_grille','trigger@lillemetropole.fr');
    END;

-- 7. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_thematique TO G_ADT_DSIG_ADM;