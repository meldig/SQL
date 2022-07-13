/*
V_GG_PRIX_RELEVE_VOIE: La vue présente les coûts du relevé à l''hectometre de chaque type de voie selon la classe de traffic
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE (
    numero_du_libelle,
    classe_de_traffic,
    code_de_la_classe_de_traffic,
    prix_du_releve_à_l_hectometre,
    CONSTRAINT "V_GG_PRIX_RELEVE_VOIE_PK" PRIMARY KEY (numero_du_libelle) DISABLE
)
AS
SELECT
    c.objectid AS numero_du_libelle,
    i.valeur AS classe_de_traffic,
    upper(e.valeur) AS code_de_la_classe_de_traffic,
    j.prix AS prix_du_releve_à_l_hectometre
FROM
    G_GESTIONGEO.TA_GG_LIBELLE c
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE d ON d.fid_libelle = c.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT e ON e.objectid = d.fid_libelle_court
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE g ON g.fid_libelle = c.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE h ON h.objectid = g.fid_famille
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG i ON i.objectid = c.fid_libelle_long
    INNER JOIN G_GESTIONGEO.TA_GG_PRIX j ON j.fid_libelle = c.objectid
WHERE
    h.objectid = 25
ORDER BY
    e.valeur
;


-- 2.Création des commentaires de la vue
COMMENT ON TABLE G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE IS 'La vue V_GG_DOSSIER_DEVIS présente les coûts du relevé à l''hectometre de chaque type de voie selon la classe de traffic.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE.numero_du_libelle IS 'Identifiant du libelle dans la table TA_GG_LIBELLE - cle primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE.classe_de_traffic IS 'Classe du traffic considérée';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE.code_de_la_classe_de_traffic IS 'Code de la classe du traffic.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE.prix_du_releve_à_l_hectometre IS 'Prix du relevé à l''hectometre de voirie suivant son type de traffic.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_GESTIONGEO.V_GG_PRIX_RELEVE_VOIE TO G_GESTIONGEO_LEC;