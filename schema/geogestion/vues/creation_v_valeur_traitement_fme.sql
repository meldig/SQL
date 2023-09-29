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
