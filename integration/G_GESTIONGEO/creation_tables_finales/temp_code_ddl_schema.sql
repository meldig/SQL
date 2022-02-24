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
    --"DOS_NUM" NUMBER(38,0) AS (GET_DOS_NUM(OBJECTID)),
	"SURFACE" NUMBER(38,0) AS (ROUND(SDO_GEOM.SDO_AREA(geom, 0.005, 'UNIT=SQ_METER'))),
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
    
CREATE INDEX TA_GG_DOSSIER_FID_PNOM_DATE_CREATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_CREATION", "DATE_SAISIE")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_FID_PNOM_DATE_MODIFICATION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("FID_PNOM_MODIFICATION", "DATE_MODIFICATION")
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

/*
SEQ_TA_GG_FICHIER_OBJECTID : création de la séquence d'auto-incrémentation de la clé primaire de la table TA_GG_FICHIER
*/

CREATE SEQUENCE SEQ_TA_GG_FICHIER_OBJECTID START WITH 1 INCREMENT BY 1;

/

/*
TA_GG_FICHIER : Création de la table TA_GG_FICHIER permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FICHIER (
    "OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID.NEXTVAL NOT NULL,
    "FID_DOSSIER" NUMBER(38,0),
    "FICHIER" VARCHAR2(250) NOT NULL,
    "INTEGRATION" NUMBER(1,0) NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FICHIER IS 'Table permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.OBJECTID IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque URL.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un l''URL de fichier (exemple : dwg, pdf, etc) à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.FICHIER IS 'Nom de chaque fichier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.INTEGRATION IS 'Champ permettant de savoir si le fichier a été utilisé lors de l''intégration du fichier dwg par FME pour déterminer le périmètre du dossier. : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FICHIER
ADD CONSTRAINT TA_GG_FICHIER_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 3.2. Contraintes de clé étrangère
-- vers la table TA_GG_DOSSIER
-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FICHIER
ADD CONSTRAINT TA_GG_FICHIER_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("OBJECTID");


-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("FID_DOSSIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_FICHIER_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("FICHIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_INTEGRATION_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("INTEGRATION") 
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_ADMIN_SIG;

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
	LARGEUR NUMBER(38,0) NOT NULL
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
TA_GG_REPERTOIRE : Table qui présente les chemins d''accès aux fichiers des dossiers gestiongeo..
*/

-- 1. Création de la table TA_GG_REPERTOIRE
CREATE TABLE G_GESTIONGEO.TA_GG_REPERTOIRE (
    OBJECTID NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    REPERTOIRE VARCHAR2(4000 BYTE) NOT NULL,
    PROTOCOLE VARCHAR2(4000 BYTE) NOT NULL
 );


 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_REPERTOIRE IS 'Table qui présente les chemins d''accès aux fichiers des dossiers gestiongeo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.REPERTOIRE IS 'Chemin des repertoires.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.PROTOCOLE IS 'Type de protocole du chemin.';


-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_REPERTOIRE
ADD CONSTRAINT TA_GG_REPERTOIRE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;


-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_REPERTOIRE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("REPERTOIRE") 
    TABLESPACE G_ADT_INDX;

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
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ID_DOSSIER NUMBER(38,0) AS(CAST(GET_ID_DOSSIER(objectid)AS NUMBER(38,0)));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ETAT_AVANCEMENT VARCHAR2(4000) AS(CAST(GET_ETAT_AVANCEMENT(objectid) AS VARCHAR2(4000)));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD DOS_NUM NUMBER(38,0) AS(CAST(GET_DOS_NUM(objectid)AS NUMBER(38,0)));
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER ADD DOS_NUM NUMBER(38,0)  AS (GET_DOS_NUM(objectid));

-- 2. Création des index
CREATE INDEX TA_GG_GEO_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO("ID_DOSSIER")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_GEO("ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_DOS_NUM_IDX ON G_GESTIONGEO.TA_GG_DOSSIER("DOS_NUM")
    TABLESPACE G_ADT_INDX;

-- 3. Création de commentaires sur ces champs calculés
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_DOSSIER IS 'Champ calculé récupérant le numéro de dossier correspondant à chaque périmètre.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ETAT_AVANCEMENT IS 'Champ calculé permettant de récupérer l''état d''avancement de chaque dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER.DOS_NUM IS 'champ calculé permettant de récupérer le DOS_NUM d''un s''il existe ou sinon d''en créer au format suivant : date(aaaammjj) + code insee (5 caractères) + identifiant du dossier.';

/

/*
TA_GG_REPERTOIRE : Table qui présente les chemins d''accès aux fichiers des dossiers gestiongeo..
*/

-- 1. Création de la table TA_GG_REPERTOIRE
CREATE TABLE G_GESTIONGEO.TA_GG_REPERTOIRE (
    OBJECTID NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    REPERTOIRE VARCHAR2(4000 BYTE) NOT NULL,
    PROTOCOLE VARCHAR2(4000 BYTE) NOT NULL
 );


 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_REPERTOIRE IS 'Table qui présente les chemins d''accès aux fichiers des dossiers gestiongeo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.REPERTOIRE IS 'Chemin des repertoires.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.PROTOCOLE IS 'Type de protocole du chemin.';


-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_REPERTOIRE
ADD CONSTRAINT TA_GG_REPERTOIRE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;


-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_REPERTOIRE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("REPERTOIRE") 
    TABLESPACE G_ADT_INDX;


-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_RW;

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
Création du trigger B_IXX_TA_GG_DOSSIER permettant de créer une nouvelle entité en cas de création d'un nouveau dossier.
*/
create or replace TRIGGER B_IXX_TA_GG_DOSSIER
BEFORE INSERT ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
BEGIN
    /*
    Objectif : ce trigger insère l'identifiant de chaque nouveau dossier dans TA_GG_DOS_NUM.FID_DOSSIER afin de pouvoir créer un DOS_NUM. Ce trigger est nécessaire car la fonction COALESCE qui créé le DOS_NUM ne fonctionne que sur des champs dont la valeur est soit existante soit nulle.
    En l'occurrence c'est cette dernière option qui nous intéresse.
    */
    -- Création d'une nouvelle entité dans TA_GG_DOS_NUM, sans DOS_NUM
    INSERT INTO G_GESTIONGEO.TA_GG_DOS_NUM(fid_dossier)
    VALUES(:new.objectid);

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IXX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

/*
A_IXX_TA_GG_GEO : Création du déclencheur A_IXX_TA_GG_GEO permettant de créer un dossier dans la table TA_GG_DOSSIER, suite à la création de son périmètre dans l'application.
Ce trigger permet aussi de récupérer le code insee de la commune d'appartenance du périmètre du dossier afin de créer son DOS_NUM.
*/

CREATE OR REPLACE TRIGGER A_IXX_TA_GG_GEO
AFTER INSERT ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);

BEGIN
    /*
    Objectif : ce trigger permet de créer un dossier une fois son périmètre créé dans l'application (qgis)
    et de récupérer son code INSEE qui sera ensuite utilisé pour créer le DOS_NUM.
    */
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
create or replace TRIGGER B_IUX_TA_GG_GEO
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    v_annee VARCHAR2(2);
    v_commune VARCHAR2(3);
    v_incrementation VARCHAR2(4);
    
BEGIN
     IF INSERTING THEN -- En cas d'insertion on calcule la surface du périmètr et le dos_num
        -- 1. Calcul du DOS_NUM - PRECISION : le DOS_NUM est EN COURS D'ABANDON, merci de ne créer aucun nouveau traitement à partir de ce champ
        -- Extraction des deux derniers chiffres de l'année en cours
        SELECT
            SUBSTR(EXTRACT(year FROM sysdate), -2) 
            INTO v_annee
        FROM
            DUAL;

        -- Sélection du code commune (sur 3 chiffres) dans la laquelle se trouve le centroïde du périmètre du dossier 
        v_commune := SUBSTR(GET_CODE_INSEE_POLYGON(:new.geom), -3);

        -- Sélection d'un identifiant de dossier virtuel sur quatre chiffres :  incrémentation de 1 à partir du nombre de dossiers créés depuis le début de l'année
        SELECT
            CASE
                WHEN COUNT(id_dos)+1< 10
                    THEN
                        '000' || CAST(COUNT(id_dos)+1 AS VARCHAR2(1))
                WHEN COUNT(id_dos)+1<100
                    THEN
                        '00' || CAST(COUNT(id_dos)+1 AS VARCHAR2(2))
                WHEN COUNT(id_dos)+1<1000
                    THEN
                        '0' || CAST(COUNT(id_dos)+1 AS VARCHAR2(3))
                WHEN COUNT(id_dos)+1>=10000
                    THEN
                        CAST(COUNT(id_dos)+1 AS VARCHAR2(4))
                WHEN COUNT(id_dos)+1>=100000
                    THEN
                        'pb'
                ELSE
                    'error'
            END 
            INTO v_incrementation
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER
        WHERE
            EXTRACT(year FROM dos_dc) = EXTRACT(year FROM sysdate);

        -- Concaténation du DOS_NUM
        :new.dos_num := v_annee||v_commune||v_incrementation;

        -- On insère la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

    IF UPDATING THEN -- En cas d'édition on édite la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;/*
Déclencheur permettant de remplir la table de logs TA_GG_GEO_LOG dans laquelle sont enregistrés chaque insertion, 
modification et suppression des données de la table TA_GG_GEO avec leur date et le pnom de l'agent les ayant effectuées.
*/

CREATE OR REPLACE TRIGGER G_GESTIONGEO.A_IUD_TA_GG_GEO_LOG
AFTER INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);
    v_id_insertion NUMBER(38,0);
    v_id_modification NUMBER(38,0);
    v_id_suppression NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;

    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT objectid INTO v_id_agent FROM G_GESTIONGEO.TA_GG_AGENT WHERE pnom = username;

    -- Sélection des id des actions présentes dans la table TA_LIBELLE
    SELECT 
        a.objectid INTO v_id_insertion 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'insertion';

    SELECT 
        a.objectid INTO v_id_modification 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'édition';
            
    SELECT 
        a.objectid INTO v_id_suppression 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'suppression';

    IF INSERTING THEN -- En cas d'insertion on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de insertion et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, id_dossier, etat_avancement, date_action, fid_type_action, fid_perimetre, fid_pnom)
            VALUES(
                    :new.geom,
                    :new.code_insee, 
                    :new.surface, 
                    :new.id_dossier, 
                    :new.etat_avancement, 
                    sysdate, 
                    v_id_insertion, 
                    :new.objectid, 
                    v_id_agent
                );                    
    ELSE
        IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
            INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, id_dossier, etat_avancement, date_action, fid_type_action, fid_perimetre, fid_pnom)
            VALUES(
                    :old.geom,
                    :old.code_insee,
                    :old.surface,
                    :old.id_dossier,
                    :old.etat_avancement,
                    sysdate,
                    v_id_modification,
                    :old.objectid,
                    v_id_agent);
        END IF;
    END IF;
    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, id_dossier, etat_avancement, date_action, fid_type_action, fid_perimetre, fid_pnom)
        VALUES(
                :old.geom,
                :old.code_insee,
                :old.surface,
                :old.id_dossier,
                :old.etat_avancement,
                sysdate,
                v_id_suppression,
                :old.objectid,
                v_id_agent);
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.A_IUD_TA_GG_GEO_LOG','bjacq@lillemetropole.fr');
END;

//*
Déclencheur permettant de remplir la table de logs TA_GG_DOSSIER_LOG dans laquelle sont enregistrés chaque insertion, 
modification et suppression des données de la table TA_GG_GEO avec leur date et le pnom de l'agent les ayant effectuées.
*/

CREATE OR REPLACE TRIGGER G_GESTIONGEO.A_IUD_TA_GG_DOSSIER_LOG
AFTER INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);
    v_id_insertion NUMBER(38,0);
    v_id_modification NUMBER(38,0);
    v_id_suppression NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;

    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT objectid INTO v_id_agent FROM G_GESTIONGEO.TA_GG_AGENT WHERE pnom = username;

    -- Sélection des id des actions présentes dans la table TA_LIBELLE
    SELECT 
        a.objectid INTO v_id_insertion 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'insertion';

    SELECT 
        a.objectid INTO v_id_modification 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'édition';
            
    SELECT 
        a.objectid INTO v_id_suppression 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'suppression';

    IF INSERTING THEN -- En cas d'insertion on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de insertion et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
            VALUES( 
                    :new.objectid,
                    :new.fid_etat_avancement,
                    :new.fid_famille, 
                    :new.fid_perimetre, 
                    :new.date_debut_leve, 
                    :new.date_fin_leve, 
                    :new.date_debut_travaux,
                    :new.date_fin_travaux,
                    :new.date_commande_dossier,
                    :new.maitre_ouvrage,
                    :new.responsable_leve,
                    :new.entreprise_travaux,
                    :new.remarque_geometre,
                    :new.remarque_photo_interprete,
                    sysdate, 
                    v_id_insertion, 
                    v_id_agent
                );                    
    ELSE
        IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
            INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(fid_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
            VALUES(
                    :old.objectid,
                    :old.fid_etat_avancement,
                    :old.fid_famille, 
                    :old.fid_perimetre, 
                    :old.date_debut_leve, 
                    :old.date_fin_leve, 
                    :old.date_debut_travaux,
                    :old.date_fin_travaux,
                    :old.date_commande_dossier,
                    :old.maitre_ouvrage,
                    :old.responsable_leve,
                    :old.entreprise_travaux,
                    :old.remarque_geometre,
                    :old.remarque_photo_interprete,
                    sysdate,
                    v_id_modification,
                    v_id_agent);
        END IF;
    END IF;
    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
        VALUES(
                :old.objectid,
                :old.fid_etat_avancement,
                :old.fid_famille, 
                :old.fid_perimetre, 
                :old.date_debut_leve, 
                :old.date_fin_leve, 
                :old.date_debut_travaux,
                :old.date_fin_travaux,
                :old.date_commande_dossier,
                :old.maitre_ouvrage,
                :old.responsable_leve,
                :old.entreprise_travaux,
                :old.remarque_geometre,
                :old.remarque_photo_interprete,
                sysdate,
                v_id_suppression,
                v_id_agent);
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.A_IUD_TA_GG_DOSSIER_LOG','bjacq@lillemetropole.fr');
END;

/

/*
Création de la vue V_CREATION_DOS_NUM permettant de rassembler les informations permettant de générer les DOS_NUM via la fonction GET_DOS_NUM().
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CREATION_DOS_NUM" ("ID_DOSSIER", "ID_PERIMETRE", "CODE_INSEE", "DATE_SAISIE", "DOS_NUM", 
 CONSTRAINT "V_CREATION_DOS_NUM_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
    a.objectid AS id_dossier,
    b.objectid AS id_perimetre,
    b.code_insee,
    a.date_saisie,
    c.dos_num
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.objectid = a.fid_perimetre
    LEFT JOIN G_GESTIONGEO.TA_GG_DOS_NUM c ON c.fid_dossier = a.objectid;

-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_CREATION_DOS_NUM IS 'Vue de travail permettant de rassembler les informations permettant de générer les DOS_NUM via la fonction GET_DOS_NUM().';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.id_dossier IS 'Identifiant du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.id_perimetre IS 'Identifiant du périmètre du dossier issu de TA_GG_GEO.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.code_insee IS 'Code INSEE du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.date_saisie IS 'Date de saisie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.dos_num IS 'DOS_NUM historiques existant dans la table TA_GG_DOS_NUM. Ces DOS_NUM sont ceux créés AVANT la migration sur oracle 12c en 2022 et le changement de méthode de saisie qu''elle a occasionné.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_ADMIN_SIG;

/

/*
Objectif : créer un identifiant regroupant la date de création du dossier, sa commune d'appartenance et son identifiant. 
*/
CREATE OR REPLACE FUNCTION GET_DOS_NUM(v_id_perimetre NUMBER) RETURN VARCHAR
/*
Cette fonction a pour objectif de créer un DOS_NUM pour chaque dossier de levé des géomètres si celui n'existe pas déjà dans TA_GG_DOS_NUM.
Pour cela, veuillez renseigner en entrée l'identifiant du dossier (et non de sa géométrie) et son code INSEE
*/
    DETERMINISTIC
    As
    v_dos_num VARCHAR2(4000);
    BEGIN
        SELECT
            COALESCE(
                TO_CHAR(dos_num), 
                TO_CHAR(
                    TO_CHAR(EXTRACT(year FROM date_saisie)) || '_' || 
                    TO_CHAR(SUBSTR(TO_CHAR(date_saisie), INSTR(TO_CHAR(date_saisie), '/')+1, 2)) || '_' || 
                    CASE WHEN TO_NUMBER(EXTRACT(day FROM date_saisie)) < 10 THEN '0' || TO_CHAR(EXTRACT(day FROM date_saisie)) ELSE TO_CHAR(EXTRACT(day FROM date_saisie)) END|| '_' || 
                    TO_CHAR(code_insee) || '_' || 
                    TO_CHAR(id_dossier)
                )
            )
            INTO v_dos_num
        FROM
            G_GESTIONGEO.V_CREATION_DOS_NUM
        WHERE
            id_perimetre = v_id_perimetre;
        RETURN TRIM(v_dos_num);
    END GET_DOS_NUM;

/

/*
Création de la vue V_CHEMIN_FICHIER_GESTIONGEO permettant d''associer une URL à un nom de fichier afin de créer le chemin d''accès complet au fichier.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO" ("ID_DOSSIER", "REPERTOIRE", "CHEMIN_FICHIER", "INTEGRATION", "PROTOCOLE", 
 CONSTRAINT "V_CHEMIN_FICHIER_GESTIONGEO_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
  a.objectid,
  c.repertoire || a.objectid || '/',
  c.repertoire || b.fichier,
  b.integration,
  c.protocole
FROM
  G_GESTIONGEO.TA_GG_DOSSIER a
  INNER JOIN G_GESTIONGEO.TA_GG_FICHIER b ON b.fid_dossier = a.objectid,
  G_GESTIONGEO.TA_GG_REPERTOIRE c;

-- 2. Création des commentaires
COMMENT ON COLUMN G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO.id_dossier IS 'Clé primaire de la vue, correspondant à l''identifiant de chaque dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO.repertoire IS 'Chemin d''acès au répertoire contenant les fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO.chemin_fichier IS 'Chemin d''accès complet des fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO.integration IS 'Champ booléen permettant de savoir si le fichier a été utilisé pour recalculer l''emprise du dossier : 1 = oui ; 0 = non ; null = ne sait pas car plusieurs .dwg dans le répertoire.';
COMMENT ON COLUMN G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO.protocole IS 'Type de protocole du chemin d''accès.';
COMMENT ON TABLE G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO  IS 'Vue permettant d''associer une URL à un nom de fichier afin de créer le chemin d''accès complet au fichier.';

/

-- Vue des valeurs utilisées dans le traitement FME.
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"
    (
    "CLA_INU",
    "CLA_CODE",
    "GEO_POI_LN",
    "GEO_POI_LA",
    "GEO_LIG_OFFSET_D",
    "GEO_LIG_OFFSET_G",
    "FID_CLASSE_SOURCE",
    "TRAITEMENT"
    )
AS WITH CTE AS
    (
    SELECT
        a.objectid as CLA_INU,
        TRIM(a.libelle_court) as CLA_CODE
    FROM
        G_GESTIONGEO.TA_GG_CLASSE a
        INNER JOIN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE b ON b.FID_CLASSE = a.OBJECTID
        INNER JOIN G_GESTIONGEO.TA_GG_DOMAINE c ON c.OBJECTID = b.FID_DOMAINE
    WHERE
        c.DOMAINE = 'Classe intégrée en base par la chaine de traitement FME'
    )
    SELECT
        a.CLA_INU,
        a.CLA_CODE,
        b.LONGUEUR AS GEO_POI_LN,
        b.LARGEUR AS GEO_POI_LA,
        c.DECALAGE_ABSCISSE_D AS GEO_LIG_OFFSET_D,
        c.DECALAGE_ABSCISSE_G AS GEO_LIG_OFFSET_G,
        d.FID_CLASSE_SOURCE AS FID_CLASSE_SOURCE
    FROM
        CTE a
        LEFT JOIN TA_GG_FME_MESURE b ON b.FID_CLASSE = a.CLA_INU
        LEFT JOIN TA_GG_FME_DECALAGE_ABSCISSE c ON c.FID_CLASSE = a.CLA_INU
        LEFT JOIN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE d ON d.FID_CLASSE = a.CLA_INU
        ;

-- 2. Création des commentaires de la vue
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"  IS 'Vue présentant les CLA_INU, VALEUR et TEXTE UTILISE PAR LES TRAITEMENTS FME. Cette table va permettre d''alimenter les TRANSFORMERS FME qui modifient ou catégorisent les informations se rapportant aux classes dans la chaîne de traitement FME.';

-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_ADMIN_SIG;

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
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_R;
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
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_RW;


