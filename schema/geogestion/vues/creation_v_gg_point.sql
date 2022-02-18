/*
V_GG_POINT : Création de la vue V_GG_POINT qui proposent les centroïdes de chaque dossier.
Utile pour localiser rapidement un dossier.
*/

-- 1. La vue
CREATE OR REPLACE FORCE VIEW V_GG_POINT(
    ID_GEOM,
    ID_DOS,
    GEOM,
    CONSTRAINT "V_GG_POINT_PK" PRIMARY KEY (ID_GEOM, ID_DOS) DISABLE
)
AS
SELECT
    a.ID_GEOM,
    a.ID_DOS,
    SDO_GEOM.SDO_CENTROID(a.geom, 0.005) AS GEOM
FROM
    G_GESTIONGEO.V_GG_DOSSIER_GEO a;
    
-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.V_GG_POINT IS 'Vue rassemblant les centroïdes de chaque périmètre de dossier de GestionGeo. Les sélections se font sur la vue V_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.ID_DOS IS 'Clé primaire de la VM avec le champ ID_GEOM';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.ID_GEOM IS 'Clé primaire de la VM avec le champ ID_DOS';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT.GEOM IS 'Champ géométrique de type point représentant le centroïde du périmètre de chaque dossier de GestionGeo.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_GG_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. Affectation des droits
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_ADMIN_SIG;

/

