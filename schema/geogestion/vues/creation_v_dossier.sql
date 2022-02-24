/*
Création de la vue V_DOSSIER regroupant les informations des dossiers de levés nécessaires à leur gestion par les géomètres et les photo-interprètes.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_DOSSIER(PNOM_AGENT,COMMUNE,FAMILLE,ETAT,NUMERO_DOSSIER,ANNEE_CREATION,ANNEE_MODIFICATION,REMARQUE_GEOMETRE,REMARQUE_PHOTO_INTERPRETE, GEOM,
CONSTRAINT "V_DOSSIER_NUMERO_DOSSIER_PK" PRIMARY KEY ("NUMERO_DOSSIER") DISABLE) AS
SELECT
    c.pnom AS pnom_agent,
    d.nom AS commune,
    f.libelle AS famille,
    e.libelle_long AS etat,
    b.objectid AS numero_dossier,
   EXTRACT(year FROM b.date_saisie) AS annee_creation,
    EXTRACT(year FROM b.date_modification) AS annee_modification,
    b.remarque_geometre,
    b.remarque_photo_interprete,
    SDO_GEOM.SDO_CENTROID(a.geom, 0.001)
FROM
    G_GESTIONGEO.TA_GG_GEO a
    INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_AGENT c ON c.objectid = b.fid_pnom_creation
    INNER JOIN G_REFERENTIEL.MEL_COMMUNE d ON d.code_insee = a.code_insee
    INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT e ON e.objectid = b.fid_etat_avancement
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE f ON f.objectid = b.fid_famille;
    
-- 2. Création des commentaires
COMMENT ON TABLE "G_GESTIONGEO"."V_DOSSIER" IS 'Vue regroupant les informations des dossiers de levés nécessaires à leur gestion par les géomètres et les photo-interprètes.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."PNOM_AGENT" IS 'Pnom de l''agent créateur du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."COMMUNE" IS 'Commune d''appartenance du centroïde du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."FAMILLE" IS 'Famille du dossier (récolement/IC).';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."ETAT" IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."NUMERO_DOSSIER" IS 'Identifiant du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."ANNEE_CREATION" IS 'Année de création du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."ANNEE_MODIFICATION" IS 'Année de modification du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."REMARQUE_GEOMETRE" IS 'Remarques des géomètres.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."REMARQUE_PHOTO_INTERPRETE" IS 'Remarques des photo-interprètes.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_DOSSIER"."GEOM" IS 'Centroïde de chaque dossier.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_DOSSIER',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

/

