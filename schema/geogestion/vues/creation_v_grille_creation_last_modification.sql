/*
Création de la vue permettant de connaître les date de création, dernière modification, pnom, état d'avancement, thème de grille pour chaque grille
*/
-- 1. Création de la vue
  CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION" ("ID_GRILLE", "ACTION", "ACTION_PNOM", "DATE_ACTION", "GESTIONNAIRE", "THEME_GRILLE", "ETAT_AVANCEMENT", 
     CONSTRAINT "V_GRILLE_CREATION_LAST_MODIFICATION_PK" PRIMARY KEY ("ID_GRILLE") DISABLE) AS 
  WITH
        C_1 AS(
            SELECT
                a.id_grille,
                c.valeur AS action,
                MAX(a.date_action) AS date_action,
                e.valeur AS theme_grille
            FROM
                G_GESTIONGEO.TA_GRILLE_LOG a
                INNER JOIN G_GEO.TA_LIBELLE b ON b.objectid = a.fid_type_action
                INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                INNER JOIN G_GEO.TA_LIBELLE d ON d.objectid = a.id_usage
                INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long
            WHERE
                c.valeur = 'édition'
            GROUP BY
                a.id_grille,
                c.valeur,
                e.valeur
        )
        SELECT
            a.id_grille,
            a.action,
            c.pnom AS action_pnom,
            a.date_action,
            f.pnom AS gestionnaire,
            a.theme_grille,
            e.valeur AS etat_avancement
        FROM
            C_1 a
            INNER JOIN G_GESTIONGEO.TA_GRILLE_LOG b ON b.id_grille = a.id_grille AND b.date_action = a.date_action
            INNER JOIN G_GESTIONGEO.TA_GG_AGENT c ON c.objectid = b.fid_pnom
            INNER JOIN G_GEO.TA_LIBELLE d ON d.objectid = b.id_etat
            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long
            INNER JOIN G_GESTIONGEO.TA_GG_AGENT f ON f.objectid = b.id_gestionnaire
    UNION ALL
    SELECT
        a.id_grille,
        d.valeur AS action,
        b.pnom AS action_pnom,
        a.date_action,
        e.pnom AS gestionnaire,
        g.valeur AS theme_grille,
        i.valeur AS etat_avancement
    FROM
        G_GESTIONGEO.TA_GRILLE_LOG a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom
        INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = a.fid_type_action
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT e ON e.objectid = a.id_gestionnaire
        INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = a.id_usage
        INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
        INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = a.id_etat
        INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long
    WHERE
        d.valeur = 'insertion';

-- 2. Création des commentaires
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."ID_GRILLE" IS 'Identifiant d''un élément d''une grille présent dans la table TA_GRILLE.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."ACTION" IS 'Type de l''action effectué sur un élément d''une grille.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."ACTION_PNOM" IS 'Pnom de l''agent ayant effectué une action sur un élément d''une grille.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."DATE_ACTION" IS 'Date de création et de la dernière modification d''un élément d''une grille.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."GESTIONNAIRE" IS 'Pnom du gestionnaire de l''élément de la grille.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."THEME_GRILLE" IS 'Thème de la grille à laquelle appartient l''élément.';
   COMMENT ON COLUMN "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"."ETAT_AVANCEMENT" IS 'Etat d''avancement de l''élément de la grille (permet à son gestionnaire de savoir où il en est).';
   COMMENT ON TABLE "G_GESTIONGEO"."V_GRILLE_CREATION_LAST_MODIFICATION"  IS 'Vue proposant la date de création et la date de la dernière modification d''un élément de la grille de TA_GRILLE. Cette vue est utilisée pour visualiser l''évolution des grilles dans les projets qgis.';


-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_GRILLE_CREATION_LAST_MODIFICATION',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);

-- 2. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GESTIONGEO.V_GRILLE_CREATION_LAST_MODIFICATION TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GRILLE_CREATION_LAST_MODIFICATION TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_GRILLE_CREATION_LAST_MODIFICATION TO G_GESTIONGEO_MAJ;