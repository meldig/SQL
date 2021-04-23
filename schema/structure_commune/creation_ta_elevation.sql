-- Création de la table TA_ELEVATION
-- 1. Création de la table
CREATE TABLE G_GEO.TA_ELEVATION(
	objectid NUMBER(38,0),
	elevation NUMBER(38,5) NOT NULL,
	fid_libelle NUMBER(38,0) NOT NULL,
	fid_type_elevation NUMBER(38,0) NOT NULL,
	fid_sur_topo_g NUMBER(38,0) NOT NULL,
	fid_metadonnee NUMBER(38,0) NOT NULL
);

-- 2. Création des commentaires
COMMENT ON TABLE G_GEO.TA_ELEVATION IS 'Table permettant d''associer les valeurs d''élévation issues du LIDAR aux objets surfaciques de la table TA_SUR_TOPO_G, permettant d''extruder les bâtiments et d''offrir une meilleure visualisation de la morphologie du territoire';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.objectid IS 'Clé primaire de la table auto-incrémentée.';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.elevation IS 'Valeur d''élévation permettant d''extruder les polygones.';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.fid_libelle IS 'Clé étrangère vers la table TA_LIBELLE permettant de distinguer les valeurs d''élévation entre valeur minimale, valeur moyenne, valeur médiane et valeur maximale.';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.fid_type_elevation IS 'Clé étrangère vers la table TA_LIBELLE permettant de distinguer l''élévation absolue (mesurée au-dessus du niveau de la mer, donc du niveau 0) de l''élévation relative (mesurée au-dessus du sol et donc pouvant différer du niveau 0).';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.fid_sur_topo_g IS 'Clé étrangère vers la table TA_SUR_TOPO_G permettant d''associer une surface de cette table avec une élévation.';
COMMENT ON COLUMN G_GEO.TA_ELEVATION.fid_metadonnee IS 'Clé étrangère vers la table TA_METADONNEE permettant de connaître la source, la date d''acquisition et l''organisme créateur de la donnée.';

-- 3. Création de la contrainte de clé primaire
ALTER TABLE G_GEO.TA_ELEVATION
ADD CONSTRAINT TA_ELEVATION_PK
PRIMARY KEY(objectid)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des contraintes
-- Contraintes de clé étrangères
ALTER TABLE G_GEO.TA_ELEVATION
ADD CONSTRAINT TA_ELEVATION_FID_LIBELLE_FK
FOREIGN KEY(fid_libelle)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_ELEVATION
ADD CONSTRAINT TA_ELEVATION_FID_TYPE_ELEVATION_FK
FOREIGN KEY(fid_type_elevation)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_ELEVATION
ADD CONSTRAINT TA_ELEVATION_FID_SUR_TOPO_G_FK
FOREIGN KEY(fid_sur_topo_g)
REFERENCES G_GEO.TA_SUR_TOPO_G(objectid);

ALTER TABLE G_GEO.TA_ELEVATION
ADD CONSTRAINT TA_ELEVATION_FID_METADONNEE_FK
FOREIGN KEY(fid_metadonnee)
REFERENCES G_GEO.TA_METADONNEE(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX TA_ELEVATION_FID_LIBELLE_IDX ON G_GEO.TA_ELEVATION(fid_libelle)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_ELEVATION_FID_TYPE_ELEVATION_IDX ON G_GEO.TA_ELEVATION(fid_type_elevation)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_ELEVATION_FID_SUR_TOPO_G_IDX ON G_GEO.TA_ELEVATION(fid_sur_topo_g)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_ELEVATION_FID_METADONNEE_IDX ON G_GEO.TA_ELEVATION(fid_metadonnee)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GEO.TA_ELEVATION TO G_ADMIN_SIG;