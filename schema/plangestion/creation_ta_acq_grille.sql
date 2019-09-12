-- Création de la table ta_acq_grille

-- 1. Création de la table
CREATE TABLE ta_acq_grille(
	objectid NUMBER(38,0),
	thematique VARCHAR2(255),
	avancement NUMBER(1,0),
	geo_nmn Varchar2(20),
	geo_dm DATE,
	geom SDO_GEOMETRY
);

-- 2. Création de la clé primaire
ALTER TABLE 
  ta_acq_grille 
ADD CONSTRAINT 
  ta_acq_grille_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX 
TABLESPACE 
  "INDX_GEO";

-- 3. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_acq_grille IS 'Table de libellés des points d''intérêts utilisés dans le plan de déplacement piéton. Lien avec la table points_interet';
COMMENT ON COLUMN geo.ta_acq_grille.objectid IS 'Identifiant autoincrémenté de chaque hexagone.';
COMMENT ON COLUMN geo.ta_acq_grille.thematique IS 'Thématique des hexagones.';
COMMENT ON COLUMN geo.ta_acq_grille.avancement IS 'Etat d''avancement des hexagones - 1 = fait et 0 = à faire';
COMMENT ON COLUMN geo.ta_acq_grille.geo_nmn IS 'Auteur de la dernière modification de l''objet';
COMMENT ON COLUMN geo.ta_acq_grille.geo_dm IS 'Date de la dernière modification de l''objet.';
COMMENT ON COLUMN geo.ta_acq_grille.geom IS 'Géométrie des objets de type polygone.';

-- 4. Création des métadonnées spatiales de la table ta_acq_grille
INSERT INTO USER_SDO_GEOM_METADATA(
    table_name, 
    column_name,
    diminfo, 
    srid
)
VALUES(
    'ta_acq_grille', 
    'geom', 
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),
        SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)
    ), 
    2154
);

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX ta_acq_grille_SIDX
ON ta_acq_grille(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=INDX_GEO , work_tablespace=DATA_TEMP');

-- 6. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_acq_grille
START WITH 1 INCREMENT BY 1;

-- 7. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_acq_grille
BEFORE INSERT ON ta_acq_grille
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_acq_grille.nextval;
END;

-- 8. Création du déclencheur mettant à jour le champ geo_dm
CREATE OR REPLACE TRIGGER geo.ta_acq_grille
    BEFORE UPDATE ON ta_acq_grille
    FOR EACH ROW

    BEGIN

        IF UPDATING THEN
            :new.geo_dm := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.ta_acq_grille','trigger@lillemetropole.fr');
    END;

-- 9. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_acq_grille TO G_ADT_DSIG_ADM;

-- Création de la table ta_acq_libelle
