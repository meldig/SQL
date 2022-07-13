/*
V_GG_DOSSIER_LONGUEUR_VOIE : Création de la vue V_GG_DOSSIER_LONGUEUR_VOIE qui propose pour chaque dossier la somme des longueurs intersectées pour chaque du de voie suivant la nomenclature CLAS_TRAF. 
Utile pour la visualisation des dossiers.
*/


-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE (
    numero_dossier,
    code_classe_traffic_a,
    code_classe_traffic_b,
    code_classe_traffic_c,
    code_classe_traffic_d,
    code_classe_traffic_e,
    code_classe_traffic_x,
    CONSTRAINT "V_GG_DOSSIER_LONGUEUR_VOIE_PK" PRIMARY KEY (numero_dossier) DISABLE
    )
AS
SELECT
    * 
FROM
    (
    SELECT
        a.numero_dossier AS numero_dossier,
        a.longueur_voie AS LONGUEUR_VOIE,
        e.valeur AS TYPE_VOIE
    FROM
        G_GESTIONGEO.TA_GG_DOSSIER_DEVIS a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE c ON c.objectid = a.type_voie
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE d ON d.fid_libelle = c.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT e ON e.objectid = d.fid_libelle_court
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE g ON g.fid_libelle = c.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE h ON h.objectid = g.fid_famille
    WHERE
        h.objectid = 25
        AND a.numero_dossier = 1000
    )
PIVOT
    (
    max(longueur_voie)
    FOR (type_voie) IN (
                        'a' AS code_classe_traffic_a,
                        'b' AS code_classe_traffic_b,
                        'c' AS code_classe_traffic_c,
                        'd' AS code_classe_traffic_d,
                        'e' AS code_classe_traffic_e,
                        'x' AS code_classe_traffic_x
                        )
    )
    ;


-- 2. Création des commentaires de la vue et des colonnes
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE IS 'la vue V_GG_DOSSIER_LONGUEUR_VOIE qui propose pour chaque dossier la somme des longueurs intersectées pour chaque du de voie suivant la nomenclature CLAS_TRAF';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.NUMERO_DOSSIER IS 'Numéro du dossier, clé primaire de la vue';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_A IS 'Somme des longueur de linéaire de type a intersectée par la géométrie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_B IS 'Somme des longueur de linéaire de type b intersectée par la géométrie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_C IS 'Somme des longueur de linéaire de type c intersectée par la géométrie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_D IS 'Somme des longueur de linéaire de type d intersectée par la géométrie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_E IS 'Somme des longueur de linéaire de type e intersectée par la géométrie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE.CODE_CLASSE_TRAFFIC_X IS 'Somme des longueur de linéaire de type f intersectée par la géométrie du dossier.';

-- 3. Droit
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIETO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_LONGUEUR_VOIETO G_GESTIONGEO_LEC;
