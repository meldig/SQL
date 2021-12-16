/*
V_GG_DOSSIER_GEO : Création de la vue V_GG_DOSSIER_GEO qui propose les informations attributaires et géométriques des dossiers. 
Utile pour la visualisation des dossiers.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_GEO (
    id_dossier,
    id_perimetre,
    numero_dossier,
    famille,
    etat_avancement,
    code_insee,
    pnom_creation,
    date_creation,
    pnom_modification,
    date_modification,
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
    CONSTRAINT "V_GG_DOSSIER_GEO_PK" PRIMARY KEY (objectid) DISABLE
)
AS
SELECT
    a.objectid,
    --b.objectid,
    --b.numero_dossier,   
    e.libelle,
    
    --d.libelle_long,
    a.code_insee,
    --c.pnom AS PNOM_CREATION,    
    a.date_creation,
    --f.pnom AS PNOM_MODIFICATION,
    a.date_modification,
    a.maitre_ouvrage,
    a.responsable_leve,
    a.entreprise_travaux,
    g.dos_url_file,
    a.date_debut_travaux,
    a.date_fin_travaux,
    a.date_debut_leve,
    a.date_fin_leve,
    --b.surface,
    a.dos_precision,
    a.remarque,    
    b.geom
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.fid_dossier = a.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_AGENT c ON c.objectid = a.fid_pnom_creation
    INNER JOIN G_GESTIONGEO.TA_GG_ETAT d ON d.objectid = a.fid_etat_avancement
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.objectid = a.fid_famille
    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT f ON f.objectid = a.fid_pnom_modification
    INNER JOIN G_GESTIONGEO.TA_GG_URL_FILE g ON g.objectid = a.objectid
 ;

-- 2. Création des commentaires de la vue et des colonnes
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_GEO IS 'Vue proposant toutes les informations des dossiers (périmètre inclu) créé via GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.objectid IS 'Clé primaire du dossier issu de TA_GG_DOSSIER (il s''agit donc du numéo valide de chaque dossier).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.objectid IS 'Clé primaire du périmètre issu de TA_GG_GEO et associé au dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.numero_dossier IS 'Numéro du dossier obsolète issu de TA_GG_DOSSIER (ce numéro n''est plus mis à jour et est abandonné).';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.objectid IS 'Familles des données issues de TA_GG_FAMILLE.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.objectid IS 'Etat d''avancement des dossiers issu de TA_GG_ETAT.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_GEO.code_insee IS 'Code INSEE issu de TA_GG_DOSSIER.';
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

