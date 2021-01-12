/*
Code DDL du schéma G_GESTIONGEO, c'est-à-dire :
1. Les tables avec leurs contraintes et indexes ;
2. Les triggers ;
*/

-- 1. TA_GG_SOURCE
-- 1.1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_SOURCE (
	"SRC_ID" NUMBER(38,0),
	"SRC_LIBEL" VARCHAR2(100 BYTE) NOT NULL,
	"SRC_VAL" NUMBER(38,0) NOT NULL
 );

-- 1.2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_SOURCE IS 'Table recensant tous les agents participant à la création, l''édition et la suppression des dossiers dans GestionG_GESTIONGEO.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_SOURCE.SRC_ID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation. Il s''agit des codes agents.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_SOURCE.SRC_LIBEL IS 'Pnom de chaque agent.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_SOURCE.SRC_VAL IS 'Champ booléen permettant de savoir si l''agent participe encore à la vie des données de GestionGeo : 1 = oui ; 0 = non.';

-- 1.3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_SOURCE
ADD CONSTRAINT TA_GG_SOURCE_PK
PRIMARY KEY("SRC_ID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_SOURCE
ADD CONSTRAINT TA_GG_SOURCE_SRC_LIBEL_UN
UNIQUE("SRC_LIBEL")
USING INDEX TABLESPACE G_ADT_INDX;

-- 1.4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_SOURCE_SRC_VAL_IDX" ON G_GESTIONGEO.TA_GG_SOURCE ("SRC_VAL") 
	TABLESPACE G_ADT_INDX;

-- 1.5. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.TA_GG_SOURCE TO G_ADMIN_SIG;

-- 2. TA_GG_ETAT
-- 2.1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_ETAT (
	"ETAT_ID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"ETAT_LIB" VARCHAR2(4000 BYTE) NOT NULL,
	"ETAT_AFF" NUMBER(1,0) NOT NULL,
	"ETAT_LIB_SMALL" VARCHAR2(50 BYTE) NOT NULL,
	"ETAT_SMALL" VARCHAR2(25 BYTE) NOT NULL
);

-- 2.2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_ETAT IS 'Table listant tous les états d''avancement que peuvent prendre les dossiers créés dans GestionGeo, avec leur code couleur respectif :
   0 : actif en base (visible en carto : vert)
   1 : non valide (non visible en carto)
   2 : prévisionnel (visible en carto : bleu)
   3 : non vérifié (visible en carto : orange)
   4 : vérifié, non validé (visible en carto : rouge)
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_ID IS 'Identifiant de chaque état d''avancement.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_LIB IS 'Libellés longs expliquant les états d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_AFF IS 'Je ne sais pas à quoi correspond ce champ.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_LIB_SMALL IS 'Libellés courts.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_SMALL IS 'Etats d''avancement des dossiers en abrégé.';

-- 2.3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_PK
PRIMARY KEY("ETAT_ID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_AFF_UN
UNIQUE("ETAT_AFF")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_ETAT_LIB_SMALL_UN
UNIQUE("ETAT_LIB_SMALL")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_ETAT_SMALL_UN
UNIQUE("ETAT_SMALL")
USING INDEX TABLESPACE G_ADT_INDX;

-- 2.4. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT TO G_ADMIN_SIG;

-- 3. TA_GG_FAMILLE
-- 3.1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FAMILLE (
	"FAM_ID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"FAM_LIB" VARCHAR2(4000 BYTE) NOT NULL,
	"FAM_VAL" NUMBER(38,0) NOT NULL,
	"FAM_LIB_SMALL" VARCHAR2(2 BYTE) NOT NULL
 );

-- 3.2. Les commentaires
 COMMENT ON TABLE G_GESTIONGEO.TA_GG_FAMILLE IS 'Famille de données liées au dossier
 - plan topo
 - réseau (IC)
 - autres
Dans un premier temps l''appli se limitera au plan topo et au données des IC
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.FAM_ID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.FAM_LIB IS 'Libellé de la famille';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.FAM_VAL IS 'Champ permettant de savoir si la famille est encore valide ou non. 1 = oui ; 0 = non.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.FAM_LIB_SMALL IS 'Libellé abrégé de la famille sur 2 caractères uniquement.';

-- 3.3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_PK
PRIMARY KEY("FAM_ID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_FAM_LIB_SMALL_UN
UNIQUE("FAM_LIB_SMALL")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_FAMILLE_FAM_VAL_IDX" ON G_GESTIONGEO.TA_GG_FAMILLE ("FAM_VAL") 
	TABLESPACE G_ADT_INDX;

-- 3.5. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_ADMIN_SIG;

-- 4. TA_GG_GEO
-- 4.1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_GEO (
	"ID_GEOM" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"ID_DOS" NUMBER(38,0),
	"GEOM" MDSYS.SDO_GEOMETRY NOT NULL,
	"ETAT_ID" NUMBER(1,0) NULL,
	"DOS_NUM" NUMBER(10,0) NULL,
	"SURFACE" NUMBER(38,2)
);

-- 4.2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_GEO IS 'Table rassemblant les géométries des dossiers créés dans GestionGeo. Le lien avec TA_GG_DOSSIER se fait via le champ ID_DOS.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_GEOM IS 'Clé primaire (identifiant unique) de la table auto-incrémentée par un trigger.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_DOS IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un dossier à une géométrie.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.GEOM IS 'Champ géométrique de la table (mais sans contrainte de type de géométrie)';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ETAT_ID IS 'Identifiant de l''état d''avancement du dossier. Attention même si ce champ reprend les identifiants de la table TA_GG_ETAT, il n''y a pas de contrainte de clé étrangère dessus pour autant.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.DOS_NUM IS 'Numéro de dossier associé à la géométrie de la table. Ce numéro n''est plus renseigné car il faisait doublon avec ID_DOS.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.SURFACE IS 'Champ rempli via un déclencheur permettant de calculer la surface de chaque objet de la table en m².';

-- 4.3. Les métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_gg_geo',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4.4. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_GEO
ADD CONSTRAINT TA_GG_GEO_PK
PRIMARY KEY("ID_GEOM")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_GEO
ADD CONSTRAINT TA_GG_GEO_ID_DOS_UN
UNIQUE("ID_DOS")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4.5. Les indexes
-- Index spatial
CREATE INDEX TA_GG_GEO_SIDX
ON G_GESTIONGEO.TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_ETAT_ID_IDX" ON G_GESTIONGEO.TA_GG_GEO ("ETAT_ID") 
	TABLESPACE G_ADT_INDX;

-- 4.6. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_ADMIN_SIG;

-- 5. TA_GG_DOSSIER
-- 5.1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOSSIER (
	"ID_DOS" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"SRC_ID" NUMBER(38,0),
	"ETAT_ID" NUMBER(38,0),
	"USER_ID" NUMBER(38,0),
	"FAM_ID" NUMBER DEFAULT 1,
	"DOS_DC" DATE,
	"DOS_PRECISION" VARCHAR2(100 BYTE),
	"DOS_DMAJ" DATE,
	"DOS_RQ" VARCHAR2(2048 BYTE),
	"DOS_DT_FIN" DATE,
	"DOS_PRIORITE" NUMBER(1,0) NULL,
	"DOS_IDPERE" NUMBER(38,0),
	"DOS_DT_DEB_TR" DATE,
	"DOS_DT_FIN_TR" DATE,
	"DOS_DT_CMD_SAI" DATE,
	"DOS_INSEE" NUMBER(5,0),
	"DOS_VOIE" NUMBER(8,0),
	"DOS_MAO" VARCHAR2(200 BYTE),
	"DOS_ENTR" VARCHAR2(200 BYTE),
	"DOS_URL_FILE" VARCHAR2(200 BYTE),
	"ORDER_ID" NUMBER(10,0),
	"DOS_NUM" NUMBER(38,0) NULL,
	"DOS_OLD_ID" VARCHAR2(8 BYTE),
	"DOS_DT_DEB_LEVE" DATE,
	"DOS_DT_FIN_LEVE" DATE,
	"DOS_DT_PREV" DATE
 );

-- 5.2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOSSIER IS 'Table principale. Chaque dossier correspond à un numéro de chantier pour le plan topo et IC';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ID_DOS IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.SRC_ID IS 'Clé étrangère vers la table TA_GG_SOURCE permettant de savoir quel utilisateur a créé quel dossier - champ utilisé uniquement pour de la création';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ETAT_ID IS 'Clé étrangère vers la table TA_GG_ETAT indiquant l''état d''avancement du dossier - avec contrainte';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.USER_ID IS 'Identifiant du pnom ayant modifié ou qui modifie un dossier - ce champ fait référence à TA_GG_SOURCE.SRC_ID avec contrainte)';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FAM_ID IS 'Clé étrangère vers la table TA_GG_FAMILLE permettant de savoir à quelle famille appartient chaque dossier : plan de récolement, investigation complémentaire, maj carto - avec contrainte';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DC IS 'Date de création du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DMAJ IS 'Date de mise à jour du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_RQ IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_FIN IS 'Date de clôture du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_PRIORITE IS 'Priorité de traitement des dossiers par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_IDPERE IS 'Indique un numéro de dossier associé s''il y en a un (ce champ accepte les NULL) - n''est plus utilisé';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_DEB_TR IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_FIN_TR IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_CMD_SAI IS 'Date de commande ou de création de dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_INSEE IS 'Code INSEE de la commune dans laquelle se situe l''objet nécessitant un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_VOIE IS 'Clé étrangère (sans contrainte de FK)';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_MAO IS 'Nom du maître d''ouvrage';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_ENTR IS 'Nom de l''entreprise responsable du levé';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_URL_FILE IS 'Lien vers le fichier dwg intégré dans infogeo par DynMap';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_NUM IS 'Numéro de chaque dossier - différent de son identifiant ID_DOS (PK). Ce numéro est obtenu par la concaténation des deux derniers chiffres de l''année (sauf pour les années antérieures à 2010), du code commune (3 chiffres) et d''une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l''année.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_OLD_ID IS 'Ancien identifiant du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_DEB_LEVE IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_FIN_LEVE IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';

-- 5.3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_PK
PRIMARY KEY("ID_DOS")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_ETAT_ID_FK
FOREIGN KEY("ETAT_ID")
REFERENCES G_GESTIONGEO.TA_GG_ETAT ("ETAT_ID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FAM_ID_FK
FOREIGN KEY("FAM_ID")
REFERENCES G_GESTIONGEO.TA_GG_FAMILLE ("FAM_ID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_SRC_ID_FK
FOREIGN KEY("SRC_ID")
REFERENCES G_GESTIONGEO.TA_GG_SOURCE ("SRC_ID");

-- Contrainte de clé étrangère de TA_GG_GEO vers TA_GG_DOSSIER
ALTER TABLE G_GESTIONGEO.TA_GG_GEO
ADD	CONSTRAINT TA_GG_GEO_ID_DOS_FK
FOREIGN KEY ("ID_DOS") REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("ID_DOS") ON DELETE CASCADE;

-- 5.5. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_ADMIN_SIG;

-- 6. VM_GG_POINT
-- 6.1. La vue matérialisée
CREATE MATERIALIZED VIEW G_GESTIONGEO.VM_GG_POINT(
    ID_GEOM,
    ID_DOS,
    GEOM
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
	a.ID_GEOM,
	b.ID_DOS,
	SDO_GEOM.SDO_CENTROID(a.geom, 0.005) AS GEOM
FROM
	G_GESTIONGEO.TA_GG_GEO a
	INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.ID_DOS = a.ID_DOS;

-- 6.2. Les commentaires
COMMENT ON MATERIALIZED VIEW G_GESTIONGEO.VM_GG_POINT IS 'Vue matérialisée rassemblant les centroïdes de chaque périmètre de dossier de GestionGeo. Les sélections se font sur les tables TA_GG_GEO et TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_POINT.ID_DOS IS 'Clé primaire de la VM avec le champ ID_GEOM';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_POINT.ID_GEOM IS 'Clé primaire de la VM avec le champ ID_DOS';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_POINT.GEOM IS 'Champ géométrique de type point représentant le centroïde du périmètre de chaque dossier de GestionGeo.';

-- 6.3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_GG_POINT',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 6.4. Ccontrainte de clé primaire
ALTER MATERIALIZED VIEW G_GESTIONGEO.VM_GG_POINT
ADD CONSTRAINT VM_GG_POINT_PK 
PRIMARY KEY (ID_DOS, ID_GEOM);

-- 6.5. Création de l'index spatial
CREATE INDEX VM_GG_POINT_SIDX
ON G_GESTIONGEO.VM_GG_POINT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POINT, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 7. Insertion des métadonnées spatiales de TEMP_TA_GG_GEO afin d'avoir un SRID pour les données de cette table après leur import
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TEMP_TA_GG_GEO',
    'ora_geometry',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 8. Création de la vue V_GG_DOSSIER_GEO rassemblant toutes les données des dossiers de GestionGeo à des fins de consultation.
-- 8.1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_GEO (
	"NUMERO_DOSSIER",
	"FAMILLE",
	"ETAT",
	"CODE_INSEE",
	"CREATEUR",
	"DATE_CREATION",
	"DERNIER_EDITEUR",
	"DATE_EDITION",
	"MAITRE_D_OUVRAGE",
	"ENTREPRISE_RESPONSABLE_DU_LEVE",
	"CHEMIN_FICHIERS_AUTOCAD",
	"DATE_DEBUT_TRAVAUX",
	"DATE_FIN_TRAVAUX",
	"DATE_DEBUT_LEVE",
	"DATE_FIN_LEVE",
	"SURFACE(M2)",
	"PRECISION",
	"REMARQUE",
	"GEOM",
    CONSTRAINT "V_GG_DOSSIER_GEO_PK" PRIMARY KEY (numero_dossier) DISABLE
)
AS
SELECT
    a.id_dos AS numero_dossier,
    e.fam_lib AS famille,
    c.etat_lib AS etat,
    a.dos_insee AS code_insee,
    b.src_libel AS createur,
    a.dos_dc AS date_creation,
    d.src_libel AS dernier_editeur,
    a.dos_dmaj AS date_edition,
    a.dos_mao AS maitre_d_ouvrage,
    a.dos_entr AS entreprise_responsable_du_leve,
    a.dos_url_file AS chemin_fichiers_autocad,
    a.dos_dt_deb_tr AS date_debut_travaux,
    a.dos_dt_fin_tr AS date_fin_travaux,
    a.dos_dt_deb_leve AS date_debut_leve,
    a.dos_dt_fin_leve AS date_fin_leve,
    f.surface AS "SURFACE(M2)",
    a.dos_precision AS precision,
    a.dos_rq AS remarque,
    f.geom
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO f ON f.ID_DOS = a.ID_DOS
    INNER JOIN G_GESTIONGEO.TA_GG_SOURCE b ON b.SRC_ID = a.SRC_ID
    INNER JOIN G_GESTIONGEO.TA_GG_ETAT c ON c.ETAT_ID = a.ETAT_ID
    INNER JOIN G_GESTIONGEO.TA_GG_SOURCE d ON d.SRC_ID = a.USER_ID
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.FAM_ID = a.FAM_ID
 ;

-- 8.2. Création des commentaires de la vue et des colonnes
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_GEO IS 'Vue proposant toutes les informations des dossiers (périmètre inclu) créé via GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.NUMERO_DOSSIER IS 'Numéro du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.FAMILLE IS 'Familles des données issues de TA_GG_FAMILLE.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ETAT IS 'Etat d''avancement des dossiers issu de TA_GG_ETAT.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.CODE_INSEE IS 'Code INSEE issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.CREATEUR IS 'Pnom de l''agent créateur du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_CREATION IS 'Date de création du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DERNIER_EDITEUR IS 'Pnom de l''agent ayant fait la dernière modification sur le dossier (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_EDITION IS 'Date de la dernière édition du dossier, issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.MAITRE_D_OUVRAGE IS 'Maître d''ouvrage (commanditaire) du dossie (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ENTREPRISE_RESPONSABLE_DU_LEVE IS 'Entrprise responsable du levé, issue de TA_GG_DOSSIER';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.CHEMIN_FICHIERS_AUTOCAD IS 'Chemin d''accès des fichiers dwg à partir desquels le périmètre du dossier à été créé/modifié en base (fichiers importé par fme), issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_DEBUT_TRAVAUX IS 'Date de début des travaux issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_FIN_TRAVAUX IS 'Date de fin des travaux issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_DEBUT_LEVE IS 'Date de début des levés issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DATE_FIN_LEVE IS 'Date de début des levés issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO."SURFACE(M2)" IS 'Surface de chaque périmètre de dossier issue de TA_GG_GEO.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.REMARQUE IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.GEOM IS 'Géométrie des périmètres de chaque dossier (type polygone ou multi-polygone), issu de TA_GG_GEO.';

-- 8.3. Création des métadonnées spatiales de la vue
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('V_GG_DOSSIER_GEO', 'GEOM', SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 2154);
COMMIT;

-- 9. Trigger de calcul des surface en m² des objets de la table TA_GG_GEO
create or replace TRIGGER B_IUX_TA_GG_GEO
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE 
BEGIN
    IF INSERTING THEN -- En cas d'insertion on insère la surface du polygone dans le champ surface(m2)       
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

    IF UPDATING THEN -- En cas d'édition on édite la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_GEO','trigger@lillemetropole.fr');
END;
/

-- 10. Trigger permettant l'insertion des SRC_ID, USER_ID et DOS_DMAJ
create or replace TRIGGER B_IUX_TA_GG_DOSSIER
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_src_id NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_SOURCE
    SELECT src_id INTO v_src_id FROM G_GESTIONGEO.TA_GG_SOURCE WHERE src_libel = username;

    IF INSERTING THEN -- En cas d'insertion on insère le SRC_ID correspondant à l'utilisateur dans TA_GG_DOSSIER.SRC_ID        
        :new.SRC_ID := v_src_id;
        :new.DOS_DC := TO_DATE(sysdate, 'dd/mm/yy');
    END IF;

    IF UPDATING THEN -- En cas d'édition on insère le SRC_ID correspondant à l'utilisateur dans TA_GG_DOSSIER.USER_ID et on édite le champ DOS_DMAJ
        :new.USER_ID := v_src_id;
        :new.DOS_DMAJ := sysdate;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_DOSSIER','trigger@lillemetropole.fr');
END;
/