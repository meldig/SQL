/*
Création de champs calculés dans la table TA_GG_GEO.
Ces champs sont créés afin de pouvoir faire des saisies dans QGIS uniquement.
*/

-- 1. Création des champs
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ID_DOSSIER NUMBER(38,0) AS(GET_ID_DOSSIER(objectid));
ALTER TABLE G_GESTIONGEO.TA_GG_GEO ADD ETAT_AVANCEMENT VARCHAR2(4000) AS(GET_ETAT_AVANCEMENT(objectid));

-- 2. Création des index
CREATE INDEX TA_GG_GEO_ID_DOSSIER_IDX ON G_GESTIONGEO.TA_GG_GEO("ID_DOSSIER")
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_GEO_ETAT_AVANCEMENT_IDX ON G_GESTIONGEO.TA_GG_GEO("ETAT_AVANCEMENT")
    TABLESPACE G_ADT_INDX;

-- 3. Création de commentaires sur ces champs calculés
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ID_DOSSIER IS 'Champ calculé récupérant le numéro de dossier correspondant à chaque périmètre.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.ETAT_AVANCEMENT IS 'Champ calculé permettant de récupérer l''état d''avancement de chaque dossier.';

-- 4. Désactivation des triggers
ALTER TRIGGER A_IUD_TA_GG_DOSSIER_LOG DISABLE;
ALTER TRIGGER A_IUD_TA_GG_GEO_LOG DISABLE;
ALTER TRIGGER A_IXX_TA_GG_GEO DISABLE;
ALTER TRIGGER B_UXX_TA_GG_DOSSIER DISABLE;

/

