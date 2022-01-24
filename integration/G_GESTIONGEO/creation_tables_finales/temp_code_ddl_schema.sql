/*
GET_CODE_INSEE_POLYGON : Création de la fonction permettant d'identifier la commune d'appartenance d'un polygone ou d'un multi-polygone. 
*/

create or replace FUNCTION GET_CODE_INSEE_POLYGON(v_geometry SDO_GEOMETRY) RETURN CHAR
/*
Cette fonction a pour objectif de récupérer le code INSEE de la commune dans laquelle se situe le centroïd d'un polygone, ou d'un multipolygone.
La variable v_table_name doit contenir le nom de la table dont on veut connaître le code INSEE des objets.
La variable v_geometry doit contenir le nom du champ géométrique de la table interrogée.

ATTENTION : pour les multipolygones à cheval sur deux communes, le centroïd peut ne pas se situer dans la commune que vous voulez...
*/
    DETERMINISTIC
    As
    v_code_insee CHAR(5);
    BEGIN
        SELECT 
            TRIM(b.code_insee)
            INTO v_code_insee 
        FROM
            G_REFERENTIEL.MEL_COMMUNE b
        WHERE
            SDO_RELATE(SDO_GEOM.SDO_CENTROID(v_geometry, 0.001), b.geom, 'mask=INSIDE')='TRUE';
        RETURN TRIM(v_code_insee);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'error';
    END GET_CODE_INSEE_POLYGON;

/

/*
SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_ETAT_AVANCEMENT
*/

CREATE SEQUENCE SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_ETAT_AVANCEMENT : Création de la table TA_GG_ETAT_AVANCEMENT qui spécificie les états d'avancement des dossiers
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID.NEXTVAL NOT NULL,
	"LIBELLE_LONG" VARCHAR2(4000 BYTE),
	"LIBELLE_COURT" VARCHAR2(50 BYTE),
	"LIBELLE_ABREGE" VARCHAR2(25 BYTE)
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT IS 'Table listant tous les états d''avancement que peuvent prendre les dossiers créés dans GestionGeo, avec leur code couleur respectif :
   0 : actif en base (visible en carto : vert)
   1 : non valide (non visible en carto)
   2 : prévisionnel (visible en carto : bleu)
   3 : non vérifié (visible en carto : orange)
   4 : vérifié, non validé (visible en carto : rouge)
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT.OBJECTID IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT.LIBELLE_LONG IS 'Libellés longs expliquant les états d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT.LIBELLE_COURT IS 'Libellés courts.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT.LIBELLE_ABREGE IS 'Etats d''avancement des dossiers en abrégé.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
ADD CONSTRAINT TA_GG_ETAT_AVANCEMENT_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
ADD CONSTRAINT TA_GG_ETAT_AVANCEMENT_LIBELLE_LONG_UN
UNIQUE("LIBELLE_LONG")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
ADD CONSTRAINT TA_GG_ETAT_AVANCEMENT_LIBELLE_COURT_UN
UNIQUE("LIBELLE_COURT")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
ADD CONSTRAINT TA_GG_ETAT_AVANCEMENT_LIBELLE_ABREGE_UN
UNIQUE("LIBELLE_ABREGE")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_FAMILLE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_FAMILLE
*/

CREATE SEQUENCE SEQ_TA_GG_FAMILLE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_FAMILLE : Création de la table TA_GG_FAMILLE qui contient les familles de dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FAMILLE (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID.NEXTVAL NOT NULL,
	"LIBELLE" VARCHAR2(4000 BYTE),
	"VALIDITE" NUMBER(38,0),
	"LIBELLE_ABREGE" VARCHAR2(2 BYTE)
 );

-- 2. Les commentaires
 COMMENT ON TABLE G_GESTIONGEO.TA_GG_FAMILLE IS 'Famille de données liées au dossier
 - plan topo
 - réseau (IC)
 - autres
Dans un premier temps l''appli se limitera au plan topo et au données des IC
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.OBJECTID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.LIBELLE IS 'Libellé de la famille';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.VALIDITE IS 'Champ permettant de savoir si la famille est encore valide ou non. 1 = oui ; 0 = non.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.LIBELLE_ABREGE IS 'Libellé abrégé de la famille sur 2 caractères uniquement.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_LIBELLE_UN
UNIQUE("LIBELLE")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_LIBELLE_ABREGE_UN
UNIQUE("LIBELLE_ABREGE")
USING INDEX TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_CLASSE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_CLASSE
*/

CREATE SEQUENCE SEQ_TA_GG_CLASSE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_CLASSE : Création de la table TA_GG_CLASSE dans laquelle sont recensés les états de tous les objets saisis par les géomètres (plan topo fin) et les photo-interprètes (plan de gestion).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_CLASSE (
	"OBJECTID" NUMBER(38,0) DEFAULT SEQ_TA_GG_CLASSE_OBJECTID.NEXTVAL NOT NULL,
	"LIBELLE_COURT" VARCHAR2(6 BYTE) NULL,
	"LIBELLE_LONG" VARCHAR2(1000 BYTE) NULL,
	"VALIDITE" NUMBER(38,0) NOT NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_CLASSE IS 'Table recensant tous les états des objets du plan de gestion et du plan topo fin.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.OBJECTID IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.LIBELLE_COURT IS 'Libellé court de chaque état.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.LIBELLE_LONG IS 'Libellé long de chaque état.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.VALIDITE IS 'Champ booléen permettant de savoir si l''état est encore valide/utilisé ou non : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_CLASSE
ADD CONSTRAINT TA_GG_CLASSE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_VALIDITE_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("VALIDITE") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_LIBELLE_COURT_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("LIBELLE_COURT") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_LIBELLE_LONG_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("LIBELLE_LONG") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_CLASSE TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_GEO_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_GEO
*/

CREATE SEQUENCE SEQ_TA_GG_GEO_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_GEO : Création de la table TA_GG_GEO contenant le périmètre géométrique des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_GEO (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID.NEXTVAL NOT NULL,
    "CODE_INSEE" AS (TRIM(GET_CODE_INSEE_POLYGON(geom))),
    --"ID_DOSSIER" NUMBER(38,0) AS(GET_ID_DOSSIER(objectid)),
    --"ETAT_AVANCEMENT" VARCHAR2(4000) AS(GET_ETAT_AVANCEMENT(objectid)),
    --"DOS_NUM" NUMBER(38,0) AS(GET_DOS_NUM(objectid)),
	"SURFACE" NUMBER(38,2) AS (ROUND(SDO_GEOM.SDO_AREA(geom, 0.005, 'UNIT=SQ_METER'), 2)),
    "GEOM" MDSYS.SDO_GEOMETRY NOT NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_GEO IS 'Table rassemblant les géométries des périmètres de chaque dossier créé dans GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.OBJECTID IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.CODE_INSEE IS 'Champ calculé permettant d''identifier le code INSEE de la commune d''appartenance du dossier via une requête spatiale sélectionnant la commune comportant le centroïde du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.SURFACE IS 'Champ calculé permettant de calculer la surface de chaque objet de la table en m².';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.GEOM IS 'Champ géométrique de la table, de type multipolygone.';

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
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 5. Les indexes
-- Index spatial
CREATE INDEX TA_GG_GEO_SIDX
ON G_GESTIONGEO.TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_SURFACE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("SURFACE") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_CODE_INSEE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("CODE_INSEE") 
    TABLESPACE G_ADT_INDX;
/*
CREATE INDEX TA_GG_GEO_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO("ID_DOSSIER")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_GEO("ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_DOS_NUM_IDX ON G_GESTIONGEO.TA_GG_GEO("DOS_NUM")
    TABLESPACE G_ADT_INDX;
*/    
-- 6. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_DOSSIER_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_DOSSIER
*/

CREATE SEQUENCE SEQ_TA_GG_DOSSIER_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_DOSSIER : Création de la table TA_GG_DOSSIER contenant les données attributaires des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOSSIER (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID.NEXTVAL NOT NULL,
	"FID_ETAT_AVANCEMENT" NUMBER(38,0),
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
	"DOS_VOIE" NUMBER(8,0),
	"MAITRE_OUVRAGE" VARCHAR2(200 BYTE),
	"RESPONSABLE_LEVE" VARCHAR2(200 BYTE),
    "ENTREPRISE_TRAVAUX" VARCHAR2(200 BYTE),
	"DOS_PRECISION" VARCHAR2(100 BYTE),
	"REMARQUE" VARCHAR2(2048 BYTE)
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
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DATE_COMMANDE_DOSSIER IS 'Date de commande ou de création de dossier';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_VOIE IS 'Identifiant de la voie d''appartenance du dossier (G_BASE_VOIE.TA_VOIE).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.MAITRE_OUVRAGE IS 'Nom du maître d''ouvrage.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.RESPONSABLE_LEVE IS 'Nom de l''entreprise responsable du levé';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.ENTREPRISE_TRAVAUX IS 'Entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.REMARQUE IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';

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

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_URL_FILE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_URL_FILE
*/

CREATE SEQUENCE SEQ_TA_GG_URL_FILE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_URL_FILE : Création de la table TA_GG_URL_FILE permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_URL_FILE (
    "OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_URL_FILE_OBJECTID.NEXTVAL NOT NULL,
    "FID_DOSSIER" NUMBER(38,0),
    "DOS_URL_FILE" VARCHAR2(250) NOT NULL,
    "INTEGRATION" NUMBER(1,0) NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_URL_FILE IS 'Table permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.OBJECTID IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque URL.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un l''URL de fichier (exemple : dwg, pdf, etc) à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.DOS_URL_FILE IS 'URL de chaque fichier.';
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
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("OBJECTID");

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("FID_DOSSIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_DOS_URL_FILE_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("DOS_URL_FILE") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_INTEGRATION_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("INTEGRATION") 
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_URL_FILE TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_DOS_NUM_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_DOS_NUM
*/

CREATE SEQUENCE SEQ_TA_GG_DOS_NUM_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_DOS_NUM : Création de la table TA_GG_DOS_NUM listant tous les DOS_NUM des dossiers créés dans GestionGeo. Cet identifiant de dossier est en cours d''abandon.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOS_NUM (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID.NEXTVAL NOT NULL,
	"FID_DOSSIER" NUMBER(38,0) NOT NULL,
	"DOS_NUM" NUMBER(38,0) NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOS_NUM IS 'Table listant tous les DOS_NUM des dossiers créés dans GestionGeo. Cet identifiant de dossier est en cours d''abandon.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.OBJECTID IS 'Clé primaire de la table (identifiant unique) auto-incrémentée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un DOS_NUM à son dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.DOS_NUM IS 'Champ rempli par le trigger A_IXX_TA_GG_GEO. Le DOS_NUM est un identifiant de dossier historique conservé uniquement pour certains utilisateurs qui ont l''habitude de travailler avec. Il se compose des 2 derniers chiffres de l''année en cours, des 3 chiffres du code commune, de 5 chiffres représentant le nombre de dossiers créés + 1 durant l''année en cours.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOS_NUM
ADD CONSTRAINT TA_GG_DOS_NUM_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contrainte de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_DOS_NUM
ADD CONSTRAINT TA_GG_DOS_NUM_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER("OBJECTID") ON DELETE CASCADE;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_DOS_NUM_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM ("DOS_NUM") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM("FID_DOSSIER")
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_ADMIN_SIG;

/

/*
SEQ_TA_GG_DOMAINE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_DOMAINE
*/

CREATE SEQUENCE SEQ_TA_GG_DOMAINE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_DOMAINE : Cette table a pour objectif de lister les differents domaines qui utilisent des classes d'objet.
*/

-- 1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_GG_DOMAINE(
    objectid NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID.NEXTVAL NOT NULL,
    domaine VARCHAR2(4000 BYTE)
);

-- 2. Commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOMAINE IS 'Liste des domaines regroupant les donnees geographiques';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOMAINE.OBJECTID IS 'Clé primaire auto-incrémentée de la table (identifiant interne du domaine).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOMAINE.DOMAINE IS 'Libelle du domaine';

-- 3. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOMAINE 
ADD CONSTRAINT TA_GG_DOMAINE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_RW;

/

/*
TA_GG_RELATION_CLASSE_DOMAINE : Cette table de relation permet d'associer une classe à ses domaines d'utilisation.
*/

-- 1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE(
    fid_classe NUMBER(38,0) NOT NULL,
    fid_domaine NUMBER(38,0) NOT NULL
);

-- 2. Commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE IS 'Table de relation permettant d''associer une classe à ses domaines d''utilisation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE.FID_CLASSE IS 'Clé étrangère vers la table TA_GG_CLASSE.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE.FID_DOMAINE IS 'Clé étrangère vers la table TA_GG_DOMAINE.';

-- 3. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE 
ADD CONSTRAINT TA_GG_RELATION_CLASSE_DOMAINE_PK 
PRIMARY KEY("FID_CLASSE","FID_DOMAINE") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des index
CREATE INDEX TA_GG_RELATION_CLASSE_DOMAINE_FID_CLASSE_IDX ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE(FID_CLASSE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_RELATION_CLASSE_DOMAINE_FID_DOMAINE_IDX ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE(FID_DOMAINE)
    TABLESPACE G_ADT_INDX;

-- 2.4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_RW;

/

/*
SEQ_TA_GG_FME_MESURE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_FME_GEO_MESURE
*/

CREATE SEQUENCE SEQ_TA_GG_FME_MESURE_OBJECTID START WITH 1 INCREMENT BY 1;

/


/*
TA_GG_FME_MESURE : La table TA_GG_FME_MESURE est utilisée pour attribuer génériquement une longueur et une largeur cartographique à des classes d''objets.
*/

-- 1. Création de la table TA_GG_FME_MESURE
CREATE TABLE G_GESTIONGEO.TA_GG_FME_MESURE (
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID.NEXTVAL NOT NULL,
	FID_CLASSE NUMBER(38,0) NOT NULL,
	LONGUEUR NUMBER(38,0) NOT NULL,
	LARGEUR NUMBER(38,0) NOT NULL,
	FID_TRAITEMENT NUMBER(8,0)
 );

 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FME_MESURE IS 'Table utilisée par la chaine d''intégration FME. Elle permet d''attribuer au symbole de chaque type de point une longueur et une largeur correspondant à la longueur et la largeur de leur classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.FID_CLASSE IS 'Clé étrangère vers la table TA_GG_CLASSE.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.LONGUEUR IS 'Valeur de la longueur attribuée au symbole de la classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.LARGEUR IS 'Valeur de la largeur attribuée au symbole de la classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.fid_traitement IS 'Clé étrangère vers la table TA_GG_TRAITEMENT_FME pour connaitre le signet des opérations FME utilisant les valeurs de la table.';

-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.2. Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_FID_CLASSE_FK
FOREIGN KEY("FID_CLASSE")
REFERENCES G_GESTIONGEO.TA_GG_CLASSE ("OBJECTID");

-- 4. Création des index sur les clés étrangères
CREATE INDEX TA_GG_FME_MESURE_FID_CLASSE_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (FID_CLASSE)
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_LONGUEUR_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (LONGUEUR) 
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_LARGEUR_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (LARGEUR) 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW;

/

/*
SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_FME_FILTRE_SUR_LIGNES.
*/

CREATE SEQUENCE SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_FME_FILTRE_SUR_LIGNE : La table TA_GG_FME_FILTRE_SUR_LIGNE est utilisée par la chaine de traitement FME pour corriger certains noms de couches autocad.
*/

-- 1. Création de la table TA_GG_FME_FILTRE_SUR_LIGNE
CREATE TABLE G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE (
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID.NEXTVAL NOT NULL,
	"FID_CLASSE" NUMBER(38,0) NOT NULL,
	"FID_CLASSE_SOURCE" NUMBER(38,0) NOT NULL
 );

 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE IS 'Table utilisée par la chaîne d''intégration FME pour modifier le nom de certains blocks autocad.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE.FID_CLASSE IS 'Clé étrangère vers la table TA_CLASSE. Afin de connaitre la classe à attribuer au block autocad renseigné dans la colonne VALEUR_SOURCE de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE.FID_CLASSE_SOURCE IS 'Valeur source à corriger dans les fichiers à intégrer.';

-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE
ADD CONSTRAINT TA_GG_FME_FILTRE_SUR_LIGNE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.2. Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE
ADD CONSTRAINT TA_GG_FME_FILTRE_SUR_LIGNE_FID_CLASSE_FK
FOREIGN KEY("FID_CLASSE")
REFERENCES G_GESTIONGEO.TA_GG_CLASSE ("OBJECTID");

-- 4. Création des index sur les clés étrangères
CREATE INDEX TA_GG_FME_FILTRE_SUR_LIGNE_FID_CLA_INU_IDX ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE(fid_classe)
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_RW;

/

/*
SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_FME_DECALAGE_ABSCISSE
*/

CREATE SEQUENCE SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_FME_DECALAGE_ABSCISSE : La table TA_GG_FME_DECALAGE_ABSCISSE est utilisée par la chaine de traitement FME pour attribuer un décalage d'abcisse à certain CLA_CODE.
*/

-- 1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE (
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID.NEXTVAL NOT NULL,
	FID_CLASSE NUMBER(38,0) NOT NULL,
	DECALAGE_ABSCISSE_D NUMBER(38,0) NOT NULL,
	DECALAGE_ABSCISSE_G NUMBER(38,0)
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE IS 'Table utilisée par la chaîne d''intégration FME. Cette table permet d''attribuer à chaque type de ligne son décalage d''abscisse correspondant.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE.OBJECTID IS 'Clé primaire de la table auto-incrémentée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE.FID_CLASSE IS 'Clé étrangère vers la table TA_GG_CLASSE afin de connaitre les classes des objets qui doivent être décalés.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE.DECALAGE_ABSCISSE_D IS 'Valeur du décalage d''abscisse vers la droite.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE.DECALAGE_ABSCISSE_G IS 'Valeur du décalage d''abscisse vers la gauche.';

-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE
ADD CONSTRAINT TA_GG_FME_DECALAGE_ABSCISSE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.2. Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE
ADD CONSTRAINT TA_GG_FME_DECALAGE_ABSCISSE_FID_CLASSE_FK
FOREIGN KEY("FID_CLASSE")
REFERENCES G_GESTIONGEO.TA_GG_CLASSE ("OBJECTID");

-- 4. Création des index sur les clés étrangères
CREATE INDEX G_GESTIONGEO."TA_GG_FME_DECALAGE_ABSCISSE_FID_CLASSE_IDX" ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE("FID_CLASSE")
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FME_DECALAGE_ABSCISSE_DECALAGE_ABSCISSE_D_IDX" ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE ("DECALAGE_ABSCISSE_D") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FME_DECALAGE_ABSCISSE_DECALAGE_ABSCISSE_G_IDX" ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE ("DECALAGE_ABSCISSE_G") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_RW;

/

/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère l'identifiant du dossier. Cela permet aux utilisateurs de faire des sélections dans QGIS à partir de l'identifiant de dossier.
*/

create or replace FUNCTION GET_ID_DOSSIER(v_perimetre NUMBER) RETURN NUMBER
/*
Cette fonction a pour objectif de récupérer l'identifiant du dossier de levés topo depuis celui de son périmètre.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_id_dossier NUMBER(38,0);
    BEGIN
        SELECT
            a.objectid
            INTO v_id_dossier 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_id_dossier);
    END GET_ID_DOSSIER;

/

/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère le DOS_NUM de chaque dossier. Cela permet aux utilisateurs de faire des sélections dans QGIS à partir du DOS_NUM des dossiers.
*/

create or replace FUNCTION GET_DOS_NUM(v_perimetre NUMBER) RETURN NUMBER
/*
Cette fonction a pour objectif de récupérer le DOS_NUM de chaque dossier.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_dos_num VARCHAR2(100);
    BEGIN
        SELECT
            b.dos_num
            INTO v_dos_num 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
            INNER JOIN G_GESTIONGEO.TA_GG_DOS_NUM b ON b.fid_dossier = a.objectid
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_dos_num);
    END GET_DOS_NUM;

/

/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère l'état d'avancement du dossier. 
Cela permet aux utilisateurs de faire des filtres dans QGIS à partir de l'état d'avancement des dossiers.
*/

create or replace FUNCTION GET_ETAT_AVANCEMENT(v_perimetre NUMBER) RETURN CHAR
/*
Cette fonction a pour objectif de récupérer l'identifiant de l'état d'avancement de chaque dossier.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_etat_avancement VARCHAR2(100);
    BEGIN
        SELECT
            b.libelle_long
            INTO v_etat_avancement 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
            INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b ON b.objectid = a.fid_etat_avancement
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_etat_avancement);
    END GET_ETAT_AVANCEMENT;

/

/*
Création de champs calculés dans la table TA_GG_GEO.
Ces champs sont créés afin de pouvoir faire des saisies dans QGIS uniquement.
*/

-- 1. Création des champs
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ID_DOSSIER NUMBER(38,0) AS(GET_ID_DOSSIER(objectid));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ETAT_AVANCEMENT VARCHAR2(4000) AS(GET_ETAT_AVANCEMENT(objectid));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD DOS_NUM NUMBER(38,0) AS(GET_DOS_NUM(objectid));

-- 2. Création des index
CREATE INDEX TA_GG_GEO_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO("ID_DOSSIER")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_GEO("ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_DOS_NUM_IDX ON G_GESTIONGEO.TA_GG_GEO("DOS_NUM")
    TABLESPACE G_ADT_INDX;

/

/*
B_UXX_TA_GG_DOSSIER : Création du trigger B_IUX_TA_GG_DOSSIER permettant la mise à jour automatique des FID_PNOM_MODIFICATION, DATE_MODIFICATION et DATE_CLOTURE
dans la table TA_GG_DOSSIER lors d'édition d'entités.
*/
create or replace TRIGGER B_UXX_TA_GG_DOSSIER
BEFORE UPDATE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_OBJECTID NUMBER(38,0);
    v_etat NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT OBJECTID INTO v_OBJECTID FROM G_GESTIONGEO.TA_GG_AGENT WHERE PNOM = username;

    -- On insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.fid_pnom_modification et on édite le champ date_modification
    :new.fid_pnom_modification := v_OBJECTID;
    :new.date_modification := sysdate;

    -- Sélection de l'identifiant de l'état indiquant qu'un dossier est clôturé
    SELECT
        objectid
        INTO v_etat
    FROM
        G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
    WHERE
        TRIM(LOWER(libelle_long)) = 'actif en base (dossier clôturé et donc visible en carto)';
    
    -- Si le dossier est clôturé, alors la date et l'heure de clôture sont enregistrées en base
    IF :new.fid_etat_avancement = v_etat THEN
        :new.date_cloture := sysdate;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_UXX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

/*
    A_IXX_TA_GG_GEO : Création du déclencheur A_IXX_TA_GG_GEO permettant de créer un dossier dans la table TA_GG_DOSSIER, suite à la création de son périmètre dans l'application.
*/

CREATE OR REPLACE TRIGGER A_IXX_TA_GG_GEO
AFTER INSERT ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);

BEGIN
    -- Note : ce trigger permet de créer un dossier une fois son périmètre créé dans l'application (qgis).
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;

    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT objectid INTO v_id_agent FROM G_GESTIONGEO.TA_GG_AGENT WHERE pnom = username;

    -- Création d'un nouveau dossier dans TA_GG_DOSSIER correspondant au périmètre dessiné
    INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER(fid_perimetre, fid_pnom_creation, date_saisie)
    VALUES(:new.objectid, v_id_agent, TO_DATE(sysdate, 'dd/mm/yy'));

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER A_IXX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;

/
/*
Affectation des droits de lecture, édition et suppression des tables et les séquences du schéma GestionGeo.
*/
-- G_GESTIONGEO_R :
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_URL_FILE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_URL_FILE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R;
--GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_R;
--GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_R;

-- G_GESTIONGEO_RW :
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_URL_FILE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_URL_FILE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_RW;