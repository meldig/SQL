/*
Création de la table contenant toutes les modifications des grilles utilisées pour la saisie des données
*/
-- 1. Création de la table
CREATE TABLE G_GESTIONGEO.TA_GRILLE_LOG(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    id_grille NUMBER(38,0) NOT NULL,
    id_usage NUMBER(38,0) NOT NULL,
    id_etat NUMBER(38,0) NOT NULL,
    id_gestionnaire NUMBER(38,0) NOT NULL,
    fid_type_action NUMBER(38,0) NOT NULL,
    fid_pnom NUMBER(38,0) NOT NULL,
    date_action DATE NOT NULL,
    geom SDO_GEOMETRY NOT NULL
);

-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GRILLE_LOG IS 'Table de log permettant d''avoir l''historique de toutes les évolutions des éléments des grilles.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.geom IS 'Géométrie, de type polygone, de chaque élément des grilles.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.id_grille IS 'Identifiant de l''élément de la grille ayant été modifié.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.id_usage IS 'Identifiant de la table G_GEO.TA_LIBELLE permettant d''associer un usage aux éléments d''une grille. Chaque grille est dévolue à un et un seul usage. Exemple : la grille de recalage est uniquement à utiliser pour le recalage des objets par photo-interprétation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.id_etat IS 'Identifiant de la table G_GEO.TA_LIBELLE permettant d''associer un état d''avancement à un élément d''une grille.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.id_gestionnaire IS 'Identifiant de la table TA_GG_AGENT permettant d''attribuer le pnom d''un agent à un élément de la grille afin d''indiquer qu''il doit s''en occuper.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.date_action IS 'Date de la création, modification ou suppression d''un objet de la table G_GESTIONGEO.TA_GRILLE.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.fid_type_action IS 'Clé étrangère vers la table G_GEO.TA_LIBELLE permettant de savoir quelle action a été effectuée sur un élément d''une grille.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.fid_pnom IS 'Clé étrangère vers la table TA_GG_AGENT permettant d''associer à chaque objet le pnom de l''agent l''ayant créé ou modifié.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GRILLE_LOG.geom IS 'Champ géométrique de type polygone contenant l''état précédent la modification de chaque objet.';

-- 3. Création de la contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GRILLE_LOG
ADD CONSTRAINT TA_GRILLE_LOG_PK
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
    'TA_GRILLE_LOG',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX TA_GRILLE_LOG_SIDX
ON G_GESTIONGEO.TA_GRILLE_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE G_GESTIONGEO.TA_GRILLE_LOG
ADD CONSTRAINT TA_GRILLE_LOG_FID_TYPE_ACTION_FK
FOREIGN KEY (FID_TYPE_ACTION)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GRILLE_LOG
ADD CONSTRAINT TA_GRILLE_LOG_FID_PNOM_FK
FOREIGN KEY (fid_pnom)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 7. Création des index sur les clés étrangères et autres
CREATE INDEX TA_GRILLE_LOG_FID_TYPE_ACTION_IDX ON G_GESTIONGEO.TA_GRILLE_LOG(fid_type_action)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GRILLE_LOG_FID_PNOM_IDX ON G_GESTIONGEO.TA_GRILLE_LOG(fid_pnom)
    TABLESPACE G_ADT_INDX;
    
-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GESTIONGEO.TA_GRILLE_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GRILLE_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_GRILLE_LOG TO G_GESTIONGEO_MAJ;