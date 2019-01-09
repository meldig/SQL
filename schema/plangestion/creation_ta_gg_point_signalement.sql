-- suppression pour un rollback brut manuel si besoin
DROP TABLE GEO.TA_POINT_WARNING;
DROP SEQUENCE GEO.TA_POINT_WARNING_pk_seq;
DROP TRIGGER GEO.TA_POINT_WARNING_tg_pk_seq;

-- création de la table et des contraintes associées
CREATE TABLE GEO."TA_POINT_WARNING" (
	OBJECTID NUMBER(38,0) NOT NULL ENABLE,
	CLA_INU_FK NUMBER(38,0) NOT NULL,
	MATRICULE_AUTEUR_FK NUMBER(38,0) NOT NULL,
	DATE_CREATION DATE DEFAULT SYSDATE NOT NULL,
	DATE_CLOTURE DATE,
	VALIDE NUMBER(1,0) DEFAULT 1 NOT NULL,
	EXPLICATION VARCHAR2(500) NOT NULL,
	GEOM MDSYS.SDO_GEOMETRY NOT NULL,
	CONSTRAINT "TA_POINT_WARNING_PK"
	 PRIMARY KEY ("OBJECTID")
	 USING INDEX TABLESPACE "INDX_GEO" ENABLE
);

-- documentation de la table et des colonnes
COMMENT ON TABLE "GEO"."TA_POINT_WARNING" IS 'Table permettant de signaler des problèmes sur les couches carto ou topo';
COMMENT ON COLUMN TA_POINT_WARNING.CLA_INU_FK IS 'clé étrangère vers le libellé de la catégorie d''avertissement';
COMMENT ON COLUMN TA_POINT_WARNING.MATRICULE_AUTEUR_FK IS 'liste des utilisateurs enregistré dans l''appli geogestion" ';
COMMENT ON COLUMN TA_POINT_WARNING.DATE_CREATION IS 'date de création de ce signalement';
COMMENT ON COLUMN TA_POINT_WARNING.DATE_CLOTURE IS 'date à laquel un signalement est clôturé';
COMMENT ON COLUMN TA_POINT_WARNING.VALIDE IS 'indique si ce signalement est actif (1) ou clôturé (0)';

-- ajouts de contraintes référentielles pour les clés étrangères
ALTER TABLE GEO.TA_POINT_WARNING
  ADD CONSTRAINT CLA_INU_FK FOREIGN KEY("CLA_INU_FK") REFERENCES GEO.TA_CLASSE ("CLA_INU");

ALTER TABLE GEO.TA_POINT_WARNING
  ADD CONSTRAINT MATRICULE_AUTEUR_FK FOREIGN KEY("MATRICULE_AUTEUR_FK") REFERENCES GEO.TA_GG_SOURCE ("SRC_ID");

-- séquences et trigger pour l'auto-incrémentation de la clé primaire
CREATE SEQUENCE GEO.TA_POINT_WARNING_pk_seq MINVALUE 1 INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE TRIGGER GEO.TA_POINT_WARNING_tg_pk_seq
  BEFORE INSERT ON TA_POINT_WARNING
  FOR EACH ROW
BEGIN
  SELECT TA_POINT_WARNING_pk_seq.nextval
  INTO :new.OBJECTID
  FROM dual;
END;

-- création manuelle des métadonnées spatiales
INSERT INTO user_sdo_geom_metadata (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) VALUES
(
  'TA_POINT_WARNING',
  'GEOM',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('X', 594000, 964000, 0.01),
    SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.01)
  ),
  2154
);

-- index spatial limitant la saisie à des points 2d
CREATE INDEX GEO.TA_POINT_WARNING_sidx
  ON GEO.TA_POINT_WARNING(GEOM)
	INDEXTYPE IS MDSYS.SPATIAL_INDEX
	PARAMETERS ('sdo_indx_dims=2, layer_gtype=MULTIPOINT, tablespace=ISPA_GEO, work_tablespace=DATA_TEMP');

-- affectation de droits
GRANT SELECT ON GEO.TA_POINT_WARNING TO ELYX_DATA WITH GRANT OPTION;
GRANT SELECT ON GEO.TA_POINT_WARNING TO G_ADT_DSIG_ADM;

/*
-- insertion manuelle des valeurs de catégories de signalements
INSERT INTO GEO.TA_CLASSE (DOM_INU, CLA_LI) VALUES
	(7, 'topo - levé'),
	(7, 'topo - encodage'),
	(7, 'carto - encodage'),
	(7, 'carto - géométrie');
*/

-- trigger sur un update quand valide = 0 TODO !

-- Test d'insertion
INSERT INTO GEO.TA_POINT_WARNING (CLA_INU_FK, MATRICULE_AUTEUR_FK, EXPLICATION, GEOM) VALUES
  (7, 4862, 'test', SDO_UTIL.FROM_WKTGEOMETRYMultiPoint ((713417 7053657), (713418 7053658)));
