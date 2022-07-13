/*
V_GG_DOSSIER_DEVIS: création de la vue V_GG_DOSSIER_DEVIS qui propose les coûts des relevés des dossiers.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_DOSSIER_DEVIS (
	numero_dossier,
	devis_dossier,
	CONSTRAINT "V_GG_DOSSIER_DEVIS_PK" PRIMARY KEY (numero_dossier) DISABLE
)
AS
SELECT 
    numero_dossier,
    SUM(devis) AS devis_dossier
FROM
    ta_gg_dossier_devis
GROUP BY
    numero_dossier
;


-- 2.Création des commentaires de la vue
COMMENT ON TABLE G_GESTIONGEO.V_GG_DOSSIER_DEVIS IS 'La vue V_GG_DOSSIER_DEVIS propose les coûts des relevés des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_DEVIS.numero_dossier IS 'Numéro du dossier dans l''application GESTIONGEO';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_DOSSIER_DEVIS.devis_dossier IS 'Cout du relevé du dossier estimé';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_DEVIS TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_DEVIS TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_DEVIS TO G_GESTIONGEO_LEC;

/