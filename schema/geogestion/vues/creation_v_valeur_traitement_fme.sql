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
    "FID_CLASSE_SOURCE"
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
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_ADMIN_SIG;

/

