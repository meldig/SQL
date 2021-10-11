/*
Création de la table contenant toutes les grilles utilisées pour la saisie des données
*/
-- 1. Création de la table
CREATE TABLE G_GESTIONGEO.TA_GRILLE(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    geom SDO_GEOMETRY NOT NULL,
    fid_usage NUMBER(38,0) NOT NULL,
    fid_etat NUMBER(38,0) NOT NULL,
    fid_gestionnaire NUMBER(38,0) NULL
);

-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GRILLE IS 'Table contenant toutes les grilles utilisées pour la saisie/vérification de données.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE.geom IS 'Champ géométrique de type polygone.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE.fid_usage IS 'Clé étrangère vers la table G_GEO.TA_LIBELLE permettant d''associer un usage aux éléments d''une grille. Chaque grille est dévolue à un et un seul usage. Exemple : la grille de recalage est uniquement à utiliser pour le recalage des objets par photo-interprétation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE.fid_etat IS 'Clé étrangère vers la table G_GEO.TA_LIBELLE permettant d''associer un état d''avancement à un élément d''une grille.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE.fid_gestionnaire IS 'Clé étrangère vers la table TA_GG_AGENT permettant d''attribuer le pnom d''un agent à un élément de la grille afin d''indiquer qu''il doit s''en occuper.';

-- 3. Création de la contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GRILLE
ADD CONSTRAINT TA_GRILLE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GRILLE',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX TA_GRILLE_SIDX
ON G_GESTIONGEO.TA_GRILLE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE G_GESTIONGEO.TA_GRILLE
ADD CONSTRAINT TA_GRILLE_FID_USAGE_FK
FOREIGN KEY (fid_usage)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GRILLE
ADD CONSTRAINT TA_GRILLE_FID_ETAT_FK
FOREIGN KEY (fid_etat)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GRILLE
ADD CONSTRAINT TA_GRILLE_FID_GESTIONNAIRE_FK
FOREIGN KEY (fid_gestionnaire)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 7. Création des index sur les clés étrangères et autres
CREATE INDEX TA_GRILLE_FID_USAGE_IDX ON G_GESTIONGEO.TA_GRILLE(fid_usage)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GRILLE_FID_ETAT_IDX ON G_GESTIONGEO.TA_GRILLE(fid_etat)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GRILLE_FID_GESTIONNAIRE_IDX ON G_GESTIONGEO.TA_GRILLE(fid_gestionnaire)
    TABLESPACE G_ADT_INDX;
    
-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GESTIONGEO.TA_GRILLE TO G_ADMIN_SIG;