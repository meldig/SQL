/*
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TA_RTGE_LINEAIRE';
DROP INDEX TA_RTGE_LINEAIRE_SIDX;
DROP INDEX TA_RTGE_LINEAIRE_IDENTIFIANT_TYPE_IDX;
DROP INDEX TA_RTGE_LINEAIRE_CODE_TYPE_IDX;
DROP INDEX TA_RTGE_LINEAIRE_LIBELLE_TYPE_IDX;
DROP TABLE TA_RTGE_LINEAIRE CASCADE CONSTRAINTS;
*/

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------1. Création de la table TA_RTGE_LINEAIRE-----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Creation de la vue G_GEO.TA_RTGE_LINEAIRE qui présente les éléments contenus dans la table G_GEO.TA_LIG_TOPO_F_ARCS_LINEARISES
--1. Creation
CREATE TABLE G_GEO.TA_RTGE_LINEAIRE
    (
    IDENTIFIANT_OBJET NUMBER(38,0),
    IDENTIFIANT_TYPE NUMBER(8,0),
    CODE_TYPE VARCHAR2(6 BYTE),
    LIBELLE_TYPE VARCHAR2(100 BYTE),
    DECALAGE_DROITE NUMBER(8,0),
    DECALAGE_GAUCHE NUMBER(8,0),
    DATE_MAJ DATE,
    GEOM SDO_GEOMETRY
    )
;


-- 2. Commentaire
COMMENT ON TABLE G_GEO.TA_RTGE_LINEAIRE IS 'Table qui présente les éléments contenus dans la table GEO.TA_LIG_TOPO_F. Les arcs sont linéarisés';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique - Cle primaire de la vue materialisee';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.DECALAGE_DROITE IS 'Decallage a droite par rapport a la generatrice';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.DECALAGE_GAUCHE IS 'Decallage a gauche par rapport a la generatrice';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.DATE_MAJ IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_LINEAIRE.GEOM IS 'Geometrie de l''objet - type ligne';


-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_RTGE_LINEAIRE
ADD CONSTRAINT TA_RTGE_LINEAIRE_IDENTIFIANT_OBJET_PK 
PRIMARY KEY (IDENTIFIANT_OBJET);

-- 4. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_LINEAIRE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041, 724322, 0.005),SDO_DIM_ELEMENT('Y', 7039713, 7082570, 0.005),SDO_DIM_ELEMENT('Z', -1000, 10000, 0.005)),
    2154
);
COMMIT;


-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX G_GEO.TA_RTGE_LINEAIRE_SIDX
ON G_GEO.TA_RTGE_LINEAIRE(GEOM) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('sdo_indx_dims=2, layer_gtype=LINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 6. INDEX
-- 6.1. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_RTGE_LINEAIRE_IDENTIFIANT_TYPE_IDX ON G_GEO.TA_RTGE_LINEAIRE(IDENTIFIANT_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.2. Sur le champ CODE_TYPE.
CREATE INDEX TA_RTGE_LINEAIRE_CODE_TYPE_IDX ON G_GEO.TA_RTGE_LINEAIRE(CODE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.3. Sur le champ LIBELLE_TYPE.
CREATE INDEX TA_RTGE_LINEAIRE_LIBELLE_TYPE_IDX ON G_GEO.TA_RTGE_LINEAIRE(LIBELLE_TYPE)
    TABLESPACE G_ADT_INDX;


-- 8. Droits
GRANT SELECT, UPDATE, INSERT, DELETE ON G_GEO.TA_RTGE_LINEAIRE TO G_GEO_MAJ;
GRANT SELECT ON G_GEO.TA_RTGE_LINEAIRE TO G_GEO_LEC;
GRANT SELECT ON G_GEO.TA_RTGE_LINEAIRE TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.TA_RTGE_LINEAIRE TO ISOGEO_LEC;

COMMIT;

/
