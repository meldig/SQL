/*
Création de la vue V_CHEMIN_FICHIER_GESTIONGEO permettant d''associer une URL à un nom de fichier afin de créer le chemin d''accès complet au fichier.
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO" ("ID_DOSSIER", "REPERTOIRE", "CHEMIN_FICHIER", "INTEGRATION", "PROTOCOLE", 
 CONSTRAINT "V_CHEMIN_FICHIER_GESTIONGEO_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
  a.objectid,
  c.repertoire || a.objectid || '/',
  c.repertoire || b.fichier,
  b.integration,
  c.protocole
FROM
  G_GESTIONGEO.TA_GG_DOSSIER a
  INNER JOIN G_GESTIONGEO.TA_GG_FICHIER b ON b.fid_dossier = a.objectid,
  G_GESTIONGEO.TA_GG_REPERTOIRE c;

-- 2. Création des commentaires
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."ID_DOSSIER" IS 'Clé primaire de la vue, correspondant à l''identifiant de chaque dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."REPERTOIRE" IS 'Chemin d''acès au répertoire contenant les fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."CHEMIN_FICHIER" IS 'Chemin d''accès complet des fichiers de chaque dossier GestionGeo.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."INTEGRATION" IS 'Champ booléen permettant de savoir si le fichier a été utilisé pour recalculer l''emprise du dossier : 1 = oui ; 0 = non ; null = ne sait pas car plusieurs .dwg dans le répertoire.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"."PROTOCOLE" IS 'Type de protocole du chemin d''accès.';
COMMENT ON TABLE "G_GESTIONGEO"."V_CHEMIN_FICHIER_GESTIONGEO"  IS 'Vue permettant d''associer une URL à un nom de fichier afin de créer le chemin d''accès complet au fichier.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO TO G_ADMIN_SIG;

/

