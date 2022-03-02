-- Vue des valeurs utilisées dans le traitement FME.
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME" ("CLA_INU", "CLA_CODE", "GEO_POI_LN", "GEO_POI_LA", "GEO_LIG_OFFSET_D", "GEO_LIG_OFFSET_G", "FID_CLASSE_SOURCE","CLA_CODE_SOURCE") AS 
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
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"  IS 'Vue présentant les CLA_INU, VALEUR et TEXTE UTILISE PAR LES TRAITEMENTS FME. Cette table va permettre d''alimenter les TRANSFORMERS FME qui modifient ou catégorisent les informations se rapportant aux classes dans la chaîne de traitement FME.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."CLA_INU" IS 'Identifiant interne de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."CLA_CODE" IS 'Nom court de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."GEO_POI_LN" IS 'Longueur par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."GEO_POI_LA" IS 'Largeur par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."GEO_LIG_OFFSET_D" IS 'Décalage d''abscisse droit par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."GEO_LIG_OFFSET_G" IS 'Décalage d''abscisse gauche par défaut de l''objet de la classe';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."FID_CLASSE_SOURCE" IS 'Identifiant interne de la classe source.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"."CLA_CODE_SOURCE" IS 'CLA_CODE de la classe source. Jointure avec le champ BLOCK_LAYER_AUTOCAD ou LAYER AUTOCAD pour les renommer selon le CLA_CODE';


-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_ADMIN_SIG;

/