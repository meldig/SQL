/*
Création de champs calculés dans la table TA_GG_GEO.
Ces champs sont créés afin de pouvoir faire des saisies dans QGIS uniquement.
*/

-- 1. Création des champs
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ID_DOSSIER NUMBER(38,0) AS(CAST(GET_ID_DOSSIER(objectid)AS NUMBER(38,0)));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ETAT_AVANCEMENT VARCHAR2(4000) AS(CAST(GET_ETAT_AVANCEMENT(objectid) AS VARCHAR2(4000)));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD DOS_NUM NUMBER(38,0) AS(CAST(GET_DOS_NUM(objectid)AS NUMBER(38,0)));

-- 2. Création des index
CREATE INDEX TA_GG_GEO_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO("ID_DOSSIER")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_GEO("ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_DOS_NUM_IDX ON G_GESTIONGEO.TA_GG_GEO("DOS_NUM")
    TABLESPACE G_ADT_INDX;

-- 3. Création de commentaires sur ces champs calculés
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_DOSSIER IS 'Champ calculé récupérant le numéro de dossier correspondant à chaque périmètre.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ETAT_AVANCEMENT IS 'Champ calculé permettant de récupérer l''état d''avancement de chaque dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.DOS_NUM IS 'champ calculé permettant de récupérer le DOS_NUM de chaque dossier, s''il existe.';

/

