/*
TA_GG_AGENT : Création de la table TA_GG_AGENT dans laquelle sont recensés les pnoms de tous les agents travaillant avec gestiongeo.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_AGENT (
	"OBJECTID" NUMBER(38,0),
	"PNOM" VARCHAR2(100 BYTE) NOT NULL,
	"VALIDITE" NUMBER(38,0) NOT NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_AGENT IS 'Table recensant tous les agents participant à la création, l''édition et la suppression des dossiers dans GestionG_GESTIONGEO.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.OBJECTID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation. Il s''agit des codes agents.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.PNOM IS 'Pnom de chaque agent.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.VALIDITE IS 'Champ booléen permettant de savoir si l''agent participe encore à la vie des données de GestionGeo : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_AGENT
ADD CONSTRAINT TA_GG_AGENT_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_AGENT
ADD CONSTRAINT TA_GG_AGENT_PNOM_UN
UNIQUE("PNOM")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_AGENT_VALIDITE_IDX" ON G_GESTIONGEO.TA_GG_AGENT ("VALIDITE") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_ADMIN_SIG;

/

/*
TA_GG_ETAT : Création de la table TA_GG_ETAT qui spécificie les états d'avancement des dossiers
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_ETAT (
	"ETAT_ID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"ETAT_LIB" VARCHAR2(4000 BYTE) NOT NULL,
	"ETAT_AFF" NUMBER(1,0) NOT NULL,
	"ETAT_LIB_SMALL" VARCHAR2(50 BYTE) NOT NULL,
	"ETAT_SMALL" VARCHAR2(25 BYTE) NOT NULL
);

-- 2. Les commentaires
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

-- 3. Les contraintes
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

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT TO G_ADMIN_SIG;

/

/*
TA_GG_FAMILLE : Création de la table TA_GG_FAMILLE qui contient les familles de dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FAMILLE (
	"FAM_ID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"FAM_LIB" VARCHAR2(4000 BYTE) NOT NULL,
	"FAM_VAL" NUMBER(38,0) NOT NULL,
	"FAM_LIB_SMALL" VARCHAR2(2 BYTE) NOT NULL
 );

-- 2. Les commentaires
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

-- 3. Les contraintes
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

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_FAMILLE_FAM_VAL_IDX" ON G_GESTIONGEO.TA_GG_FAMILLE ("FAM_VAL") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_ADMIN_SIG;

/

/*
TA_GG_DOSSIER : Création de la table TA_GG_DOSSIER contenant les données attributaires des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOSSIER (
	"ID_DOS" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"SRC_ID" NUMBER(38,0) NOT NULL,
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
    "ENTREPRISE_TRAVAUX" VARCHAR2(200 BYTE),
	"ORDER_ID" NUMBER(10,0),
	"DOS_NUM" NUMBER(38,0) NULL,
	"DOS_OLD_ID" VARCHAR2(8 BYTE),
	"DOS_DT_DEB_LEVE" DATE,
	"DOS_DT_FIN_LEVE" DATE,
	"DOS_DT_PREV" DATE
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOSSIER IS 'Table principale. Chaque dossier correspond à un numéro de chantier pour le plan topo et IC.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ID_DOS IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.SRC_ID IS 'Clé étrangère vers la table TA_GG_AGENT permettant de savoir quel utilisateur a créé quel dossier - champ utilisé uniquement pour de la création';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ETAT_ID IS 'Clé étrangère vers la table TA_GG_ETAT indiquant l''état d''avancement du dossier - avec contrainte';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.USER_ID IS 'Identifiant du pnom ayant modifié ou qui modifie un dossier - ce champ fait référence à TA_GG_AGENT.OBJECTID avec contrainte)';
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
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ENTREPRISE_TRAVAUX IS 'entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_NUM IS 'Numéro de chaque dossier - différent de son identifiant ID_DOS (PK). Ce numéro est obtenu par la concaténation des deux derniers chiffres de l''année (sauf pour les années antérieures à 2010), du code commune (3 chiffres) et d''une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l''année.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_OLD_ID IS 'Ancien identifiant du dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_DEB_LEVE IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_DT_FIN_LEVE IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';

-- 3. Les contraintes
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
REFERENCES G_GESTIONGEO.TA_GG_AGENT ("OBJECTID");

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_ADMIN_SIG;

/

/*
TA_GG_GEO : Création de la table TA_GG_GEO contenant le périmètre géométrique des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_GEO (
	"ID_GEOM" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"ID_DOS" NUMBER(38,0),
	"GEOM" MDSYS.SDO_GEOMETRY NOT NULL,
	"ETAT_ID" NUMBER(1,0) NULL,
	"DOS_NUM" NUMBER(10,0) NULL,
	"SURFACE" NUMBER(38,2)
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_GEO IS 'Table rassemblant les géométries des dossiers créés dans GestionGeo. Le lien avec TA_GG_DOSSIER se fait via le champ ID_DOS.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_GEOM IS 'Clé primaire (identifiant unique) de la table auto-incrémentée par un trigger.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_DOS IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un dossier à une géométrie.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.GEOM IS 'Champ géométrique de la table (mais sans contrainte de type de géométrie)';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ETAT_ID IS 'Identifiant de l''état d''avancement du dossier. Attention même si ce champ reprend les identifiants de la table TA_GG_ETAT, il n''y a pas de contrainte de clé étrangère dessus pour autant.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.DOS_NUM IS 'Numéro de dossier associé à la géométrie de la table. Ce numéro n''est plus renseigné car il faisait doublon avec ID_DOS.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.SURFACE IS 'Champ rempli via un déclencheur permettant de calculer la surface de chaque objet de la table en m².';

-- 3. Les métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GG_GEO',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. Les contraintes
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

-- Contrainte d'intégrité sur TA_GG_DOSSIER
ALTER TABLE G_GESTIONGEO.TA_GG_GEO
ADD CONSTRAINT TA_GG_GEO_ID_DOS_FK
FOREIGN KEY ("ID_DOS") REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("ID_DOS") ON DELETE CASCADE;

-- 5. Les indexes
-- Index spatial
CREATE INDEX TA_GG_GEO_SIDX
ON G_GESTIONGEO.TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_ETAT_ID_IDX" ON G_GESTIONGEO.TA_GG_GEO ("ETAT_ID") 
	TABLESPACE G_ADT_INDX;

-- 6. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_ADMIN_SIG;

/

/*
TA_GG_URL_FILE : Création de la table TA_GG_URL_FILE permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_URL_FILE (
    "OBJECTID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    "DOS_URL_FILE" VARCHAR2(250) NOT NULL,
    "FID_DOSSIER" NUMBER(38,0),
    "INTEGRATION" NUMBER(1,0) NOT NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_URL_FILE IS 'Table GestionGEO permettant de lister tous les fichiers correspondants à un dossier (dwg, pdf, etc).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.OBJECTID IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque URL.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.DOS_URL_FILE IS 'URL de chaque fichier correspondant à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un URL à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.INTEGRATION IS 'Champ permettant de savoir si le fichier a été utilisé lors de l''intégration du fichier dwg par FME pour déterminer le périmètre du dossier. : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_URL_FILE
ADD CONSTRAINT TA_GG_URL_FILE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_URL_FILE
ADD CONSTRAINT TA_GG_URL_FILE_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("ID_DOS") ON DELETE CASCADE ;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("FID_DOSSIER") 
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_URL_FILE TO G_ADMIN_SIG;

/

/*
B_IUX_TA_GG_DOSSIER : Création du trigger B_IUX_TA_GG_DOSSIER permettant l'insertion automatique des USER_ID et DOS_DMAJ 
dans la table TA_GG_DOSSIER, lors d'insertion ou d'édition d'entités.
*/
create or replace TRIGGER B_IUX_TA_GG_DOSSIER
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_OBJECTID NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT OBJECTID INTO v_OBJECTID FROM G_GESTIONGEO.TA_GG_AGENT WHERE PNOM = username;

    IF INSERTING THEN -- En cas d'insertion on insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.USER_ID et on insère la date du jour dans le champ DOS_DC   
        :new.USER_ID := v_OBJECTID;
        :new.DOS_DC := TO_DATE(sysdate, 'dd/mm/yy');
    END IF;

    IF UPDATING THEN -- En cas d'édition on insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.USER_ID et on édite le champ DOS_DMAJ
        :new.USER_ID := v_OBJECTID;
        :new.DOS_DMAJ := sysdate;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

/* 
B_IUX_TA_GG_GEO : Création du trigger B_IUX_TA_GG_GEO permettant de calculer les surface en m² des périmètres des dossiers de la table TA_GG_GEO
*/

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
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;

/

/*
V_GG_DOSSIER_GEO : Création de la vue V_GG_DOSSIER_GEO qui propose les informations attributaires et géométriques des dossiers. 
Utile pour la visualisation des dossiers.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_GEO (
    id_dos,
    id_geom,
    dos_num,
    fam_id,
    etat_id,
    dos_insee,
    OBJECTID,
    dos_dc,
    user_id,
    dos_dmaj,
    dos_mao,
    dos_entr,
    entreprise_travaux,
    dos_url_file,
    dos_dt_deb_tr,
    dos_dt_fin_tr,
    dos_dt_deb_leve,
    dos_dt_fin_leve,
    surface,
    dos_precision,
    dos_rq,
    geom,
    CONSTRAINT "V_GG_DOSSIER_GEO_PK" PRIMARY KEY (id_dos) DISABLE
)
AS
SELECT
    a.id_dos,
    f.id_geom,
    f.dos_num,
    e.fam_lib AS FAM_ID,
    c.etat_lib AS ETAT_ID,
    a.dos_insee,
    b.PNOM AS OBJECTID,
    a.dos_dc,
    d.PNOM AS user_ID,
    a.dos_dmaj,
    a.dos_mao,
    a.dos_entr,
    a.entreprise_travaux,
    g.dos_url_file,
    a.dos_dt_deb_tr,
    a.dos_dt_fin_tr,
    a.dos_dt_deb_leve,
    a.dos_dt_fin_leve,
    f.surface,
    a.dos_precision,
    a.dos_rq,
    f.geom
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO f ON f.ID_DOS = a.ID_DOS
    INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.OBJECTID = a.SRC_ID
    INNER JOIN G_GESTIONGEO.TA_GG_ETAT c ON c.ETAT_ID = a.ETAT_ID
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.FAM_ID = a.FAM_ID
    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT d ON d.OBJECTID = a.USER_ID
    INNER JOIN G_GESTIONGEO.TA_GG_URL_FILE g ON g.fid_dossier = a.id_dos
 ;

-- 2. Création des commentaires de la vue et des colonnes
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_GEO IS 'Vue proposant toutes les informations des dossiers (périmètre inclu) créé via GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ID_DOS IS 'Clé primaire du dossier issu de TA_GG_DOSSIER (il s''agit donc du numéo valide de chaque dossier).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ID_GEOM IS 'Clé primaire du périmètre issu de TA_GG_GEO et associé au dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_NUM IS 'Numéro du dossier obsolète issu de TA_GG_DOSSIER (ce numéro n''est plus mis à jour et est abandonné).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.FAM_ID IS 'Familles des données issues de TA_GG_FAMILLE.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ETAT_ID IS 'Etat d''avancement des dossiers issu de TA_GG_ETAT.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_INSEE IS 'Code INSEE issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.OBJECTID IS 'Pnom de l''agent créateur du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DC IS 'Date de création du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.USER_ID IS 'Pnom de l''agent ayant fait la dernière modification sur le dossier (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DMAJ IS 'Date de la dernière édition du dossier, issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_MAO IS 'Maître d''ouvrage (commanditaire) du dossie (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_ENTR IS 'Entrprise responsable du levé, issue de TA_GG_DOSSIER';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.ENTREPRISE_TRAVAUX IS 'entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_URL_FILE IS 'Chemin d''accès des fichiers dwg à partir desquels le périmètre du dossier à été créé/modifié en base (fichiers importé par fme), issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DT_DEB_TR IS 'Date de début des travaux issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DT_FIN_TR IS 'Date de fin des travaux issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DT_DEB_LEVE IS 'Date de début des levés issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_DT_FIN_LEVE IS 'Date de début des levés issue de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.SURFACE IS 'Surface de chaque périmètre de dossier issue de TA_GG_GEO.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.DOS_RQ IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit (issu de TA_GG_DOSSIER).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.GEOM IS 'Géométrie des périmètres de chaque dossier (type polygone ou multi-polygone), issu de TA_GG_GEO.';

-- 3. Création des métadonnées spatiales de la vue
INSERT INTO USER_SDO_GEOM_METADATA (
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES (
    'V_GG_DOSSIER_GEO', 
    'GEOM', 
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_ADMIN_SIG;

/

/*
V_GG_POINT : Création de la vue V_GG_POINT qui proposent les centroïdes de chaque dossier.
Utile pour localiser rapidement un dossier.
*/

-- 1. La vue
CREATE OR REPLACE FORCE VIEW V_GG_POINT(
    ID_GEOM,
    ID_DOS,
    GEOM,
    CONSTRAINT "V_GG_POINT_PK" PRIMARY KEY (ID_GEOM, ID_DOS) DISABLE
)
AS
SELECT
    a.ID_GEOM,
    a.ID_DOS,
    SDO_GEOM.SDO_CENTROID(a.geom, 0.005) AS GEOM
FROM
    G_GESTIONGEO.V_GG_DOSSIER_GEO a;
    
-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.V_GG_POINT IS 'Vue rassemblant les centroïdes de chaque périmètre de dossier de GestionGeo. Les sélections se font sur la vue V_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.ID_DOS IS 'Clé primaire de la VM avec le champ ID_GEOM';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.ID_GEOM IS 'Clé primaire de la VM avec le champ ID_DOS';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.GEOM IS 'Champ géométrique de type point représentant le centroïde du périmètre de chaque dossier de GestionGeo.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_GG_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_ADMIN_SIG;

/
