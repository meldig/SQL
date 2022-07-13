DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'VM_RTGE_POINT';
DROP INDEX VM_RTGE_POINT_SIDX;
DROP INDEX VM_RTGE_POINT_IDENTIFIANT_TYPE_IDX;
DROP INDEX VM_RTGE_POINT_CODE_TYPE_IDX;
DROP INDEX VM_RTGE_POINT_LIBELLE_TYPE_IDX;
DROP MATERIALIZED VIEW VM_RTGE_POINT;

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------1. Création de la VM VM_RTGE_POINT-----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Creation d'une vue pour afficher les points contenus dans la table G_GEO.TA_POIN_TOPO_F avec l'altitude dans un nouveau champ.
--1. Creation
CREATE MATERIALIZED VIEW G_GEO.VM_RTGE_POINT
    (
    IDENTIFIANT_OBJET,
    IDENTIFIANT_TYPE,
    CODE_TYPE,
    LIBELLE_TYPE,
    LONGUEUR,
    LARGEUR,
    ORIENTATION,
    COORD_Z,
    DATE_MAJ,
    GEOM
    )
REFRESH ON DEMAND START WITH sysdate+0 NEXT TRUNC(sysdate)+43/24
FORCE
DISABLE QUERY REWRITE AS
SELECT
    a.IDENTIFIANT_OBJET AS IDENTIFIANT_OBJET,
    a.IDENTIFIANT_TYPE AS CODE_TYPE,
    a.CODE_TYPE  AS IDENTIFIANT_TYPE,
    a.LIBELLE_TYPE AS LIBELLE_TYPE,
    a.LONGUEUR AS LONGUEUR,
    a.LARGEUR AS LARGEUR,
    a.ORIENTATION AS ORIENTATION,
    CASE
        WHEN t.z > 0 AND t.z < 130 THEN ROUND(CAST(t.z AS NUMBER(5,2)),2)
        ELSE 0
    END COORD_Z,
    a.DATE_MAJ AS DATE_MAJ,
    SDO_GEOMETRY(
        2001, 2154,
        SDO_POINT_TYPE(t.X,t.Y,NULL),
        NULL, NULL) AS GEOM
FROM
    G_GEO.TA_POINT_TOPO_F a,
    TABLE
        (SDO_UTIL.GETVERTICES(a.geom)) t
;


-- 2. Commentaire
COMMENT ON MATERIALIZED VIEW G_GEO.VM_RTGE_POINT IS 'Vue qui présente les points contenus dans la table GEO@cudl.TA_POINT_TOPO_F (copié dans la table G_GEO.TA_POINT_TOPO_F) avec la coordonnée Z dans une colonne spécifique';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique - Cle primaire de la vue materialisee';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.LONGUEUR IS 'Longueur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.LARGEUR IS 'Largeur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.ORIENTATION IS 'Orientation de l''objet (en degre)';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.COORD_Z IS 'Altitude du point';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.DATE_MAJ IS 'Date de deniere modification de l''objet';
COMMENT ON COLUMN G_GEO.VM_RTGE_POINT.GEOM IS 'Geometrie de l''objet - type point';


-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW G_GEO.VM_RTGE_POINT
ADD CONSTRAINT VM_RTGE_POINT_IDENTIFIANT_OBJET_PK 
PRIMARY KEY (IDENTIFIANT_OBJET);

-- 4. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_RTGE_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041, 724322, 0.005),SDO_DIM_ELEMENT('Y', 7039713, 7082570, 0.005)),
    2154
);
COMMIT;


-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX G_GEO.VM_RTGE_POINT_SIDX
ON G_GEO.VM_RTGE_POINT(GEOM) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 6. INDEX
-- 6.1. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX VM_RTGE_POINT_IDENTIFIANT_TYPE_IDX ON G_GEO.VM_RTGE_POINT(IDENTIFIANT_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.2. Sur le champ CODE_TYPE.
CREATE INDEX VM_RTGE_POINT_CODE_TYPE_IDX ON G_GEO.VM_RTGE_POINT(CODE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.3. Sur le champ LIBELLE_TYPE.
CREATE INDEX VM_RTGE_POINT_LIBELLE_TYPE_IDX ON G_GEO.VM_RTGE_POINT(LIBELLE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 7. Droits
GRANT SELECT ON G_GEO.VM_RTGE_POINT TO G_GEO_MAJ;
GRANT SELECT ON G_GEO.VM_RTGE_POINT TO G_GEO_LEC;
GRANT SELECT ON G_GEO.VM_RTGE_POINT TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.VM_RTGE_POINT TO ISOGEO_LEC;