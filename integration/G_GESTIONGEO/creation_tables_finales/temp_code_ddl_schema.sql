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
	VALEUR NUMBER(38,0) NOT NULL,
	FID_MESURE NUMBER(38,0) NOT NULL
 );

 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_FME_MESURE IS 'Table utilisée par la chaine d''intégration FME. Elle permet d''attribuer au symbole de chaque type de point une longueur et une largeur correspondant à la longueur et la largeur de leur classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.FID_CLASSE IS 'Clé étrangère vers la table TA_GG_CLASSE.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.VALEUR IS 'Valeur de la mesure attribuée au symbole de la classe.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FME_MESURE.FID_MESURE IS 'Clé étrangère vers la table G_GEO.TA_LIBELLE pour determiner la mesure caractérisée par la valeur attribuée au symbole de la classe.';

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

ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_FID_MESURE_FK
FOREIGN KEY("FID_MESURE")
REFERENCES G_GEO.TA_LIBELLE ("OBJECTID");

-- 4. Création des index sur les clés étrangères
CREATE INDEX TA_GG_FME_MESURE_FID_CLASSE_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (FID_CLASSE)
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_FID_MESURE_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (FID_MESURE) 
	TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_FME_MESURE_VALEUR_IDX ON G_GESTIONGEO.TA_GG_FME_MESURE (VALEUR) 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_ADMIN_SIG;

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
CREATE INDEX G_GESTIONGEO."TA_GG_GEO_SIDX"
ON G_GESTIONGEO.TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_SURFACE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("SURFACE") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_CODE_INSEE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("CODE_INSEE") 
    TABLESPACE G_ADT_INDX;
  
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
	"FID_ETAT_AVANCEMENT" NUMBER(38,0) DEFAULT 5,
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
	"REMARQUE_PHOTO_INTERPRETE" VARCHAR2(4000 BYTE)
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

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_ADMIN_SIG;

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
TA_GG_REPERTOIRE : Table qui présente les chemins d''accès aux fichiers des dossiers gestiongeo..
*/

-- 1. Création de la table TA_GG_REPERTOIRE
CREATE TABLE G_GESTIONGEO.TA_GG_REPERTOIRE (
	OBJECTID NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
	REPERTOIRE VARCHAR2(4000 BYTE) NOT NULL,
	PROTOCOLE VARCHAR2(4000 BYTE) NOT NULL
 );


 -- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_REPERTOIRE IS 'Table qui présente les chemins d''accès aux fichiers des dossiers de levés des géomètres, faits via l''application gestiongeo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.OBJECTID IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.REPERTOIRE IS 'Chemin des repertoires.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_REPERTOIRE.PROTOCOLE IS 'Type de protocole du chemin.';

-- 3. Les contraintesn
-- 3.1. Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_REPERTOIRE
ADD CONSTRAINT TA_GG_REPERTOIRE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;


-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_REPERTOIRE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("REPERTOIRE")
TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_REPERTOIRE_PROTOCOLE_IDX" ON G_GESTIONGEO.TA_GG_REPERTOIRE ("PROTOCOLE")
TABLESPACE G_ADT_INDX;
 
-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_ADMIN_SIG;

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
Création de la vue V_CREATION_DOS_NUM permettant de récupérer le DOS_NUM d'un dossier de levé quand il existe 
ou quand il n'existe pas, de le créer au format date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CREATION_DOS_NUM" ("ID_DOSSIER", "ID_PERIMETRE", "CODE_INSEE", "DATE_SAISIE", "DOS_NUM", 
 CONSTRAINT "V_CREATION_DOS_NUM_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
a.objectid AS id_dossier,
b.objectid AS id_perimetre,
b.code_insee,
a.date_saisie,
COALESCE(
            TO_CHAR(c.dos_num), 
            TO_CHAR(
                EXTRACT(year FROM a.date_saisie) || '_' || 
                SUBSTR(TO_CHAR(a.date_saisie), INSTR(TO_CHAR(a.date_saisie), '/')+1, 2) || '_' || 
                CASE WHEN EXTRACT(day FROM a.date_saisie) < 10 THEN '0' || TO_CHAR(EXTRACT(day FROM a.date_saisie)) ELSE TO_CHAR(EXTRACT(day FROM a.date_saisie)) END|| '_' || 
                b.code_insee || '_' || 
                a.objectid
            )
        )
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.objectid = a.fid_perimetre
    LEFT JOIN G_GESTIONGEO.TA_GG_DOS_NUM c ON c.fid_dossier = a.objectid;

-- 2. Création des commentaires
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."ID_DOSSIER" IS 'Identifiant du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."ID_PERIMETRE" IS 'Identifiant du périmètre du dossier issu de TA_GG_GEO.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."CODE_INSEE" IS 'Code INSEE du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."DATE_SAISIE" IS 'Date de saisie du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."DOS_NUM" IS 'Champ rassemblant les DOS_NUM historiques existant dans la table TA_GG_DOS_NUM et ceux qui sont recréés automatiquement au format date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier.';
COMMENT ON TABLE "G_GESTIONGEO"."V_CREATION_DOS_NUM"  IS 'Vue proposant les DOS_NUM des dossiers de levés : s''il existe dans TA_GG_DOS_NUM alors il est récupéré, sinon il est créé via la concaténation date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_ADMIN_SIG;

/

/*
La table TA_GG_GEO_LOG  permet d''avoir l''historique de toutes les évolutions des périmètres des dossiers des géomètres (GestionGeo).
*/

-- 1. Création de la table TA_GG_GEO_LOG
CREATE TABLE G_GESTIONGEO.TA_GG_GEO_LOG(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    id_perimetre NUMBER(38,0) NOT NULL,
    geom SDO_GEOMETRY NOT NULL,
    code_insee VARCHAR2(5),
    surface NUMBER(38,0),
    id_dossier NUMBER(38,0),
    etat_avancement VARCHAR2(4000 BYTE),
    date_action DATE NOT NULL,
    fid_type_action NUMBER(38,0) NOT NULL,
    fid_pnom NUMBER(38,0) NOT NULL
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE G_GESTIONGEO.TA_GG_GEO_LOG IS 'Table de log de la table TA_GG_GEO permettant d''avoir l''historique de toutes les évolutions des périmètres de dossiers des levés des géomètres. Précision : cette table contient au maximum l''état n-1 de chaque entité.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.id_perimetre IS 'Identifiant de la table TA_GG_GEO permettant de savoir sur quel périmètre de dossier les actions ont été entreprises.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.geom IS 'Géométrie de type multipolygone de chaque dossier présent dans la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.code_insee IS 'Code INSEE de la commune d''appartenance du centroïde du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.surface IS 'Surface de chaque périmètre de chaque dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.date_action IS 'Date de création, modification ou suppression de la géométrie d''un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.fid_type_action IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir quelle action a été effectuée sur le périmètre du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO_LOG.fid_pnom IS 'Clé étrangère vers la table TA_GG_AGENT permettant d''associer le pnom d''un agent au périmètre du dossier qu''il a créé, modifié ou supprimé.';

-- 3. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_GEO_LOG 
ADD CONSTRAINT TA_GG_GEO_LOG_PK 
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
    'TA_GG_GEO_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX TA_GG_GEO_LOG_SIDX
ON G_GESTIONGEO.TA_GG_GEO_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE G_GESTIONGEO.TA_GG_GEO_LOG
ADD CONSTRAINT TA_GG_GEO_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (fid_type_action)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_GEO_LOG
ADD CONSTRAINT TA_GG_GEO_LOG_FID_PNOM_FK
FOREIGN KEY (fid_pnom)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 7. Création des index sur les clés étrangères et autres
CREATE INDEX TA_GG_GEO_LOG_FID_PERIMETRE_IDX ON G_GESTIONGEO.TA_GG_GEO_LOG(id_perimetre)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_GEO_LOG_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO_LOG(id_dossier)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_GEO_LOG_FID_TYPE_ACTION_IDX ON G_GESTIONGEO.TA_GG_GEO_LOG(fid_type_action)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_LOG_FID_PNOM_IDX ON G_GESTIONGEO.TA_GG_GEO_LOG(fid_pnom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_LOG_CODE_INSEE_IDX ON G_GESTIONGEO.TA_GG_GEO_LOG(code_insee)
    TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO_LOG TO G_ADMIN_SIG;

/

/*
La table TA_GG_DOSSIER_LOG  permet d''avoir l''historique de toutes les évolutions des périmètres des dossiers des géomètres (GestionGeo).
*/

-- 1. Création de la table TA_GG_DOSSIER_LOG
CREATE TABLE G_GESTIONGEO.TA_GG_DOSSIER_LOG(
    "OBJECTID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    "ID_DOSSIER" NUMBER(38,0) NOT NULL,
    "ID_ETAT_AVANCEMENT" NUMBER(38,0),
    "ID_FAMILLE" NUMBER(38,0),
    "ID_PERIMETRE" NUMBER(38,0),
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
    "DATE_ACTION" DATE NOT NULL,
    "FID_TYPE_ACTION" NUMBER(38,0) NOT NULL,
    "FID_PNOM" NUMBER(38,0) NOT NULL
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOSSIER_LOG IS 'Table de log de la table TA_GG_DOSSIER permettant d''avoir l''historique de toutes les évolutions des dossiers des levés des géomètres. Précision : cette table contient au maximum l''état n-1 de chaque entité.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.id_dossier IS 'Identifiant de la table TA_GG_DOSSIER permettant de savoir sur quel dossier les actions ont été entreprises.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.id_etat_avancement IS 'Identifiants de la table TA_GG_ETAT_AVANCEMENT dans laquelle se trouve tous les états d''avancement que peuvent prendre les dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.id_famille IS 'Identifiant de la table TA_GG_FAMILLE permettant de savoir à quelle famille appartient chaque dossier : plan de récolement, investigation complémentaire, maj carto.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.id_perimetre IS 'Identifiant de la table TA_GG_GEO, permettant d''associer un périmètre à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_debut_leve IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_fin_leve IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_debut_travaux IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_fin_travaux IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_commande_dossier IS 'Date de commande ou de création de dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.maitre_ouvrage IS 'Nom du maître d''ouvrage.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.responsable_leve IS 'Nom de l''entreprise responsable du levé.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.entreprise_travaux IS 'Entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.remarque_geometre IS 'Précision apportée au dossier par le géomètre telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.remarque_photo_interprete IS 'Remarque du photo-interprète lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.date_action IS 'Date de création, modification ou suppression de la géométrie d''un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.fid_type_action IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir quelle action a été effectuée sur le périmètre du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOSSIER_LOG.fid_pnom IS 'Clé étrangère vers la table TA_GG_AGENT permettant d''associer le pnom d''un agent au périmètre du dossier qu''il a créé, modifié ou supprimé.';

-- 3. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER_LOG 
ADD CONSTRAINT TA_GG_DOSSIER_LOG_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER_LOG
ADD CONSTRAINT TA_GG_DOSSIER_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (fid_type_action)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER_LOG
ADD CONSTRAINT TA_GG_DOSSIER_LOG_FID_PNOM_FK
FOREIGN KEY (fid_pnom)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 5. Création des index sur les clés étrangères et autres
CREATE INDEX TA_GG_DOSSIER_LOG_FID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_LOG_FID_PERIMETRE_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_perimetre)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_DOSSIER_LOG_FID_TYPE_ACTION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(fid_type_action)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_LOG_FID_PNOM_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(fid_pnom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_LOG_ACTION_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(fid_type_action, fid_pnom, date_action)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_DOSSIER_LOG_ID_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_etat_avancement)
    TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER_LOG TO G_ADMIN_SIG;

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
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."ID_DOSSIER" IS 'Clé primaire de la vue, correspondant à l''identifiant de chaque dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."REPERTOIRE" IS 'Chemin d''acès au répertoire contenant les fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."CHEMIN_FICHIER" IS 'Chemin d''accès complet des fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."INTEGRATION" IS 'Champ booléen permettant de savoir si le fichier a été utilisé pour recalculer l''emprise du dossier : 1 = oui ; 0 = non ; null = ne sait pas car plusieurs .dwg dans le répertoire.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."PROTOCOLE" IS 'Type de protocole du chemin d''accès.';
COMMENT ON TABLE "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"  IS 'Vue permettant d''associer une URL à un nom de fichier afin de créer le chemin d''accès complet au fichier.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO TO G_ADMIN_SIG;
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
/*
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
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
            VALUES(
                    :new.geom,
                    :new.code_insee, 
                    :new.surface, 
                    sysdate, 
                    v_id_insertion, 
                    :new.objectid, 
                    v_id_agent
                );                    
    ELSE
        IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
            INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
            VALUES(
                    :old.geom,
                    :old.code_insee,
                    :old.surface,
                    sysdate,
                    v_id_modification,
                    :old.objectid,
                    v_id_agent);
        END IF;
    END IF;
    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
        VALUES(
                :old.geom,
                :old.code_insee,
                :old.surface,
                sysdate,
                v_id_suppression,
                :old.objectid,
                v_id_agent);
    END IF;
END;

/

/*
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
END;

/

-- Création de la vue V_VALEUR_TRAITEMENT_FME regroupant les valeurs utilisées dans le traitement FME.
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME" ("IDENTIFIANT", "CLA_INU", "CLA_CODE", "GEO_POI_LN", "GEO_POI_LA", "GEO_LIG_OFFSET_D", "GEO_LIG_OFFSET_G", "FID_CLASSE_SOURCE", "CLA_CODE_SOURCE", 
     CONSTRAINT "V_VALEUR_TRAITEMENT_FME_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS 
  WITH CTE AS
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
        ROWNUM AS IDENTIFIANT,
        a.CLA_INU ,
        a.CLA_CODE,
        b.VALEUR AS GEO_POI_LA,
        c.VALEUR AS GEO_POI_LN,
        d.VALEUR AS GEO_LIG_OFFSET_D,
        e.VALEUR AS GEO_LIG_OFFSET_G,
        f.FID_CLASSE_SOURCE AS FID_CLASSE_SOURCE,
        g.LIBELLE_COURT AS CLA_CODE_SOURCE
    FROM
        CTE a
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
            WHERE
                a.fid_mesure = 1432
            )b
            ON b.fid_classe = a.cla_inu
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
            WHERE
                a.fid_mesure = 1434
            )c
            ON c.fid_classe = a.cla_inu
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
            WHERE
                a.fid_mesure = 1433
            )d
            ON d.fid_classe = a.cla_inu
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
            WHERE
                a.fid_mesure = 1435
            )e
            ON e.fid_classe = a.cla_inu
        LEFT JOIN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE f ON f.FID_CLASSE = a.CLA_INU
        LEFT JOIN G_GESTIONGEO.TA_GG_CLASSE g ON f.FID_CLASSE_SOURCE = g.OBJECTID;

-- 2. Création des commentaires de la vue
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME" IS 'Vue présentant les CLA_INU, VALEUR et TEXTE UTILISE PAR LES TRAITEMENTS FME. Cette table va permettre d''alimenter les TRANSFORMERS FME qui modifient ou catégorisent les informations se rapportant aux classes dans la chaîne de traitement FME.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".identifiant IS 'Clé primaire de la vue';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".cla_inu IS 'Identifiant interne de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".cla_code IS 'Nom court de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".geo_poi_ln IS 'Longueur par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".geo_poi_la IS 'Largeur par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".geo_lig_offset_d IS 'Décalage d''abscisse droit par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".geo_lig_offset_g IS 'Décalage d''abscisse gauche par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME".fid_classe_source IS 'Identifiant interne de la classe source. Jointure avec le champ LAYER AUTOCAD pour les renommer selon le CLA_CODE';

-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_ADMIN_SIG;

/

-- Création de la vue V_VALEUR_GESTION_TRAITEMENT_FME regroupant les valeurs utilisées dans la gestion des dossiers dans le traitement FME.
-- 1. Création de la vue
  CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME" ("IDENTIFIANT", "REPERTOIRE", "ETAT_ID_FINAL_RECOL", "ETAT_ID_FINAL_IC", "ETAT_ID_MAJ", 
     CONSTRAINT "V_VALEUR_GESTION_TRAITEMENT_FME_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS 
  SELECT
  ROWNUM AS IDENTIFIANT,
  a.repertoire AS REPERTOIRE,
  b.objectid AS ETAT_ID_FINAL_RECOL,
  c.objectid AS ETAT_ID_FINAL_IC,
  d.objectid AS ETAT_ID_MAJ
FROM
  G_GESTIONGEO.TA_GG_REPERTOIRE a,
  G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b,
  G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c,
  G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT d
WHERE
  UPPER(a.protocole) = UPPER('serveur')
  AND
  TRIM(UPPER(b.libelle_court)) = TRIM(UPPER('Attente Validation (Topo)'))
  AND
  TRIM(UPPER(c.libelle_court)) = TRIM(UPPER('Actif en base'))
  AND
  TRIM(UPPER(d.libelle_court)) = TRIM(UPPER('Attente levé géomètre'));

-- 2. Création des commentaires de la vue
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME" IS 'Vue présentant les valeurs necessaires à la gestion des dossiers: le REPERTOIRE dans lequel les fichiers associés seront déplacer et les valeurs d''état des dossier suivant le type de dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".identifiant IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à la suppression de ses éléments topographiques';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".repertoire IS 'Répertoire qui contient les dossiers de l''application GESTIONGEO';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_final_recol IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à l''intégration d''un fichier DWG d''un dossier de recolement.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_final_ic IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à l''intégration d''un fichier DWG d''un dossier d''Investigation Complémentaire.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_maj IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à la suppression de ses éléments topographiques'; 

-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_GESTION_TRAITEMENT_FME TO G_ADMIN_SIG;

/

/*
Création de la vue V_STAT_DOSSIER regroupant les informations des dossiers de levés nécessaires à leur gestion par les géomètres et les photo-interprètes.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_STAT_DOSSIER(PNOM_AGENT,COMMUNE,FAMILLE,ETAT,NUMERO_DOSSIER,ANNEE_CREATION,ANNEE_MODIFICATION,REMARQUE_GEOMETRE,REMARQUE_PHOTO_INTERPRETE,
CONSTRAINT "V_STAT_DOSSIER_NUMERO_DOSSIER_PK" PRIMARY KEY ("NUMERO_DOSSIER") DISABLE) AS
SELECT
    c.pnom AS pnom_agent,
    d.nom AS commune,
    f.libelle AS famille,
    e.libelle_long AS etat,
    b.objectid AS numero_dossier,
   EXTRACT(year FROM b.date_saisie) AS annee_creation,
    EXTRACT(year FROM b.date_modification) AS annee_modification,
    b.remarque_geometre,
    b.remarque_photo_interprete
FROM
    G_GESTIONGEO.TA_GG_GEO a
    INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_AGENT c ON c.objectid = b.fid_pnom_creation
    INNER JOIN G_REFERENTIEL.MEL_COMMUNE d ON d.code_insee = a.code_insee
    INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT e ON e.objectid = b.fid_etat_avancement
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE f ON f.objectid = b.fid_famille;
    
-- 2. Création des commentaires
COMMENT ON TABLE "G_GESTIONGEO"."V_STAT_DOSSIER" IS 'Vue regroupant les informations des dossiers de levés nécessaires à leur gestion par les géomètres et les photo-interprètes.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."PNOM_AGENT" IS 'Pnom de l''agent créateur du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."COMMUNE" IS 'Commune d''appartenance du centroïde du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."FAMILLE" IS 'Famille du dossier (récolement/IC).';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."ETAT" IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."NUMERO_DOSSIER" IS 'Identifiant du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."ANNEE_CREATION" IS 'Année de création du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."ANNEE_MODIFICATION" IS 'Année de modification du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."REMARQUE_GEOMETRE" IS 'Remarques des géomètres.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER"."REMARQUE_PHOTO_INTERPRETE" IS 'Remarques des photo-interprètes.';

-- 4. Création du droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_ADMIN_SIG;

/

/*
Création de la vue V_STAT_DOSSIER_PAR_AGENT_ANNEE comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_AGENT_ANNEE" ("OBJECTID", "PNOM_AGENT", "ANNEE", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_AGENT_ANNEE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            fid_pnom_creation,
            EXTRACT(year FROM date_saisie) AS annee,
            COUNT(objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER           
        GROUP BY
            fid_pnom_creation,
            EXTRACT(year FROM date_saisie)
    )
    
    SELECT
        rownum,
        b.pnom,
        a.annee,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom_creation;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE IS 'Vue statistique comptant le nombre de dossiers créés par agent, année et commune.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.pnom_agent IS 'Pnom des agents ayant créés des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.annee IS 'Année de saisie des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.nombre_dossier IS 'Nombre de dossiers créés par agent, année et commune.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_ADMIN_SIG;

/

/*
Création de la vue V_STAT_DOSSIER_PAR_ETAT_ANNEE comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_ANNEE" ("OBJECTID", "ANNEE", "ETAT_AVANCEMENT", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_ETAT_ANNEE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            EXTRACT(year FROM b.date_saisie) AS annee,
            b.fid_etat_avancement,
            COUNT(b.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_GEO a
            INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid           
        GROUP BY
            EXTRACT(year FROM b.date_saisie),
            b.fid_etat_avancement
    )
    
    SELECT
        rownum,
        a.annee,
        c.libelle_abrege AS etat_avancement,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE IS 'Vue statistique comptant le nombre de dossiers par état d''avancement et année.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.annee IS 'Année de saisie des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.etat_avancement IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.nombre_dossier IS 'Nombre de dossiers créés par état d''avancement et année.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_ADMIN_SIG;

/

/*
Création de la vue V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT dénombrant les dossiers par état d'avancement.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT" ("OBJECTID", "ETAT_AVANCEMENT", "NOMBRE_DOSSIER",
	 CONSTRAINT "V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            a.fid_etat_avancement,
            COUNT(a.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        GROUP BY
            a.fid_etat_avancement
    )
    SELECT
        rownum,
        b.libelle_long,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b ON b.objectid = a.fid_etat_avancement;

-- 2. Création des commentaires
COMMENT ON TABLE "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"  IS 'Vue dénombrant les dossiers par état d''avancement.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."OBJECTID" IS 'Clé primaire de la vue.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."ETAT_AVANCEMENT" IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."NOMBRE_DOSSIER" IS 'Nombre de dossiers.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_ADMIN_SIG;

/

/*
Création de la vue V_STAT_DOSSIER_PAR_TERRITOIRE dénombrant les dossiers de levés topo par agent et état d'avancement.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE("OBJECTID", "PNOM_AGENT","ETAT","NOMBRE_DOSSIER",
CONSTRAINT "V_STAT_DOSSIER_PAR_TERRITOIRE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS
WITH
    C_1 AS(
        SELECT
            a.fid_pnom_creation,
            a.fid_etat_avancement,
            COUNT(a.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        GROUP BY
            a.fid_pnom_creation,
            a.fid_etat_avancement
    )
    
    SELECT
        rownum,
        b.pnom,
        c.libelle_long,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom_creation
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement;

-- 2. Création des commentaires
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".objectid IS 'Clé primaire de la Vue.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".pnom_agent IS 'Pnom des agents créateurs des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".etat IS 'Etats d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".nombre_dossier IS 'Nombre de dossiers.';
COMMENT ON TABLE "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE"  IS 'Vue statistique dénombrant les dossiers de levés topo par agent et état d''avancement.';

-- 3. Création du droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_ADMIN_SIG;

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
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO_LOG TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER_LOG TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_GESTION_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.VM_STAT_DOSSIER_PAR_COMMUNE TO G_GESTIONGEO_R;

-- G_GESTIONGEO_RW :
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO_LOG TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_RW;
GRANT UPDATE(GEOM) ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER_LOG TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_RW;

/

/*
Désactivation de toutes les contraintes, index, triggers
*/

-- Désactivation des triggers
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_DOSSIER_LOG DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IUD_TA_GG_GEO_LOG DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER A_IXX_TA_GG_GEO DISABLE';
EXECUTE IMMEDIATE 'ALTER TRIGGER B_UXX_TA_GG_DOSSIER DISABLE';

-- Désactivation des contraintes et suppression des index
EXECUTE IMMEDIATE 'ALTER TABLE G_GESTIONGEO.TA_GG_DOSSIER DISABLE CONSTRAINT TA_GG_DOSSIER_FID_PERIMETRE_FK';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_SIDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_SURFACE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_GEO_CODE_INSEE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_ETAT_AVANCEMENT_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_FAMILLE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PERIMETRE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PNOM_DATE_CREATION_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_FID_PNOM_DATE_MODIFICATION_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_MAITRE_OUVRAGE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_RESPONSABLE_LEVE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOSSIER_ENTREPRISE_TRAVAUX_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_REPERTOIRE_REPERTOIRE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_REPERTOIRE_PROTOCOLE_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOS_NUM_DOS_NUM_IDX';
EXECUTE IMMEDIATE 'DROP INDEX TA_GG_DOS_NUM_FID_DOSSIER_IDX';

/

