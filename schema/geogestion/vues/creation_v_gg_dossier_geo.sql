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

