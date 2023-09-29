--------------------------------------
-- CREATION_V_VALEUR_TRAITEMENT_FME --
--------------------------------------

-- Vue des valeurs utilisées dans le traitement FME.
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"
    (
    IDENTIFIANT,
    FID_IDENTIFIANT_TYPE,
    LIBELLE_COURT_TYPE,
    LARGEUR,
    LONGUEUR,
    DECALAGE_DROITE,
    DECALAGE_GAUCHE,
    FID_IDENTIFIANT_TYPE_SOURCE,
    LIBELLE_COURT_TYPE_SOURCE,
    IDENTIFIANT_DOMAINE,
    DOMAINE,
CONSTRAINT "V_VALEUR_TRAITEMENT_FME_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE)
AS WITH CTE AS
    (
    SELECT
        a.objectid as FID_IDENTIFIANT_TYPE,
        TRIM(a.libelle_court) as LIBELLE_COURT_TYPE
    FROM
        G_GESTIONGEO.TA_GG_CLASSE a
        INNER JOIN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE b ON b.FID_CLASSE = a.OBJECTID
        INNER JOIN G_GESTIONGEO.TA_GG_DOMAINE c ON c.OBJECTID = b.FID_DOMAINE
    WHERE
        c.DOMAINE = 'Classe intégrée en base par la chaine de traitement FME'
    ),
    CTE_TYPE_GEOMETRIE AS
    (
    SELECT
        a.OBJECTID AS FID_IDENTIFIANT_TYPE,
        c.OBJECTID AS FID_DOMAINE,
        c.DOMAINE AS DOMAINE
    FROM
        G_GESTIONGEO.TA_GG_CLASSE a
        INNER JOIN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE b ON b.fid_classe = a.OBJECTID
        INNER JOIN G_GESTIONGEO.TA_GG_DOMAINE c ON c.objectid = b.fid_domaine 
    WHERE
        c.OBJECTID IN (152,153,172)
    )
    SELECT
        ROWNUM AS IDENTIFIANT,
        a.FID_IDENTIFIANT_TYPE ,
        a.LIBELLE_COURT_TYPE,
        b.VALEUR AS LARGEUR,
        c.VALEUR AS LONGUEUR,
        d.VALEUR AS DECALAGE_DROITE,
        e.VALEUR AS DECALAGE_GAUCHE,
        f.FID_CLASSE_SOURCE AS FID_IDENTIFIANT_TYPE_SOURCE,
        g.LIBELLE_COURT AS LIBELLE_COURT_TYPE_SOURCE,
        h.FID_DOMAINE AS IDENTIFIANT_DOMAINE,
        h.DOMAINE AS DOMAINE
    FROM
        CTE a
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_mesure
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE d ON d.fid_libelle = b.objectid
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.objectid = d.fid_famille
            WHERE
                TRIM(LOWER(e.libelle)) = TRIM(LOWER('mesure'))
                AND
                TRIM(LOWER(c.valeur)) = TRIM(LOWER('largeur'))
            )b
            ON b.fid_classe = a.FID_IDENTIFIANT_TYPE
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_mesure
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE d ON d.fid_libelle = b.objectid
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.objectid = d.fid_famille
            WHERE
                TRIM(LOWER(e.libelle)) = TRIM(LOWER('mesure'))
                AND
                TRIM(LOWER(c.valeur)) = TRIM(LOWER('longueur'))
            )c
            ON c.fid_classe = a.FID_IDENTIFIANT_TYPE
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_mesure
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE d ON d.fid_libelle = b.objectid
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.objectid = d.fid_famille
            WHERE
                TRIM(LOWER(e.libelle)) = TRIM(LOWER('mesure'))
                AND
                TRIM(LOWER(c.valeur)) = TRIM(LOWER('decalage abscisse droit'))
            )d
            ON d.fid_classe = a.FID_IDENTIFIANT_TYPE
        LEFT JOIN 
            (
            SELECT
                a.fid_classe,
                a.valeur
            FROM
                G_GESTIONGEO.TA_GG_FME_MESURE a
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_mesure
                INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE d ON d.fid_libelle = b.objectid
                INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE e ON e.objectid = d.fid_famille
            WHERE
                TRIM(LOWER(e.libelle)) = TRIM(LOWER('mesure'))
                AND
                TRIM(LOWER(c.valeur)) = TRIM(LOWER('decalage abscisse gauche'))
            )e
            ON e.fid_classe = a.FID_IDENTIFIANT_TYPE
        LEFT JOIN G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE f ON f.FID_CLASSE = a.FID_IDENTIFIANT_TYPE
        LEFT JOIN G_GESTIONGEO.TA_GG_CLASSE g ON f.FID_CLASSE_SOURCE = g.OBJECTID
        LEFT JOIN CTE_TYPE_GEOMETRIE h ON h.FID_IDENTIFIANT_TYPE = a.FID_IDENTIFIANT_TYPE
;


-- 2. Création des commentaires de la vue
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_TRAITEMENT_FME"  IS 'Vue présentant les CLA_INU, VALEUR et TEXTE UTILISE PAR LES TRAITEMENTS FME. Cette table va permettre d''alimenter les TRANSFORMERS FME qui modifient ou catégorisent les informations se rapportant aux classes dans la chaîne de traitement FME.';


-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_ADMIN_SIG;


/
