/*
TA_GG_DOSSIER : Création de la table TA_GG_DOSSIER contenant les données attributaires des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOSSIER (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID.NEXTVAL NOT NULL,
	"FID_ETAT_AVANCEMENT" NUMBER(38,0) DEFAULT 5 NOT NULL,
	"FID_FAMILLE" NUMBER DEFAULT 1,
	"FID_PERIMETRE" NUMBER(38,0),
	"FID_PNOM_CREATION" NUMBER(38,0) NOT NULL,
	"FID_PNOM_MODIFICATION" NUMBER(38,0),
	"DATE_SAISIE" DATE,
	"DATE_MODIFICATION" DATE,
	"DATE_CLOTURE" DATE,
	"DATE_DEBUT_LEVE" DATE,
	"DATE_FIN_LEVE" DATE,
	"DATE_DEBUT_TRAVAUX" DATE,
	"DATE_FIN_TRAVAUX" DATE,
	"DATE_COMMANDE_DOSSIER" DATE,
	"MAITRE_OUVRAGE" VARCHAR2(200 BYTE),
	"RESPONSABLE_LEVE" VARCHAR2(200 BYTE),
    "ENTREPRISE_TRAVAUX" VARCHAR2(200 BYTE),
	"REMARQUE_GEOMETRE" VARCHAR2(4000 BYTE),
	"REMARQUE_PHOTO_INTERPRETE" VARCHAR2(4000 BYTE),
	"CODE_INSEE" VARCHAR2(5)
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOSSIER IS 'Table principale. Chaque dossier correspond à un numéro de chantier pour le plan topo et IC.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.OBJECTID IS 'Clé primaire auto-incrémentée de la table (identifiant de chaque dossier). Champ correspondant à l''ancien ID_DOS.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FID_ETAT_AVANCEMENT IS 'Clé étrangère vers la table TA_GG_ETAT_AVANCEMENT dans laquelle se trouve tous les états que peuvent prendre les dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FID_FAMILLE IS 'Clé étrangère vers la table TA_GG_FAMILLE permettant de savoir à quelle famille appartient chaque dossier : plan de récolement, investigation complémentaire, maj carto.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FID_PERIMETRE IS 'Clé étrangère vers la table TA_GG_GEO, permettant d''associer un périmètre à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FID_PNOM_CREATION IS 'Clé étrangère vers la table TA_GG_AGENT permettant de savoir quel utilisateur a créé quel dossier - champ utilisé uniquement pour de la création.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.FID_PNOM_MODIFICATION IS 'Clé étrangère vers la table TA_GG_AGENT permettant de savoir quel utilisateur a modifié quel dossier en dernier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_SAISIE IS 'Date de création du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_MODIFICATION IS 'Date de mise à jour du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_CLOTURE IS 'Date de clôture du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_DEBUT_LEVE IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_FIN_LEVE IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_DEBUT_TRAVAUX IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_FIN_TRAVAUX IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_COMMANDE_DOSSIER IS 'Date de commande ou de création de dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.MAITRE_OUVRAGE IS 'Nom du maître d''ouvrage.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.RESPONSABLE_LEVE IS 'Nom de l''entreprise responsable du levé.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ENTREPRISE_TRAVAUX IS 'Entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.REMARQUE_GEOMETRE IS 'Précision apportée au dossier par le géomètre telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.REMARQUE_PHOTO_INTERPRETE IS 'Remarque du photo-interprète lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.CODE_INSEE IS 'Code INSEE de la commune d''appartenance du périmètre du dossier. Ce code INSEE est calculé via une requête spatiale.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FID_ETAT_AVANCEMENT_FK
FOREIGN KEY("FID_ETAT_AVANCEMENT")
REFERENCES G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT("OBJECTID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FID_FAMILLE_FK
FOREIGN KEY("FID_FAMILLE")
REFERENCES G_GESTIONGEO.TA_GG_FAMILLE("OBJECTID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FID_PNOM_CREATION_FK
FOREIGN KEY("FID_PNOM_CREATION")
REFERENCES G_GESTIONGEO.TA_GG_AGENT("OBJECTID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FID_PNOM_MODIFICATION_FK
FOREIGN KEY("FID_PNOM_MODIFICATION")
REFERENCES G_GESTIONGEO.TA_GG_AGENT("OBJECTID");

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER
ADD CONSTRAINT TA_GG_DOSSIER_FID_PERIMETRE_FK
FOREIGN KEY("FID_PERIMETRE")
REFERENCES G_GESTIONGEO.TA_GG_GEO("OBJECTID") ON DELETE CASCADE;

-- 4. Les index
CREATE INDEX TA_GG_DOSSIER_FID_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_FID_FAMILLE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_FAMILLE")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_FID_PERIMETRE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PERIMETRE")
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_FID_PNOM_CREATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_CREATION")
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_FID_PNOM_MODIFICATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_MODIFICATION")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_MAITRE_OUVRAGE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("MAITRE_OUVRAGE")
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_RESPONSABLE_LEVE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("RESPONSABLE_LEVE")
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_ENTREPRISE_TRAVAUX_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("ENTREPRISE_TRAVAUX")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_CODE_INSEE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("CODE_INSEE")
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_ADMIN_SIG;

/

