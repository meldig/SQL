-----------------------------------------------------------------------------------------------
------------------- Pour connaitre les tablespaces accessibles à un schéma --------------------
-----------------------------------------------------------------------------------------------


SELECT * FROM USER_TABLESPACES;


-----------------------------------------------------------------------------------------------
------------------------------------------- Clé primaire --------------------------------------
-----------------------------------------------------------------------------------------------

  -- pour une table 
ALTER TABLE #TABLE# ADD CONSTRAINT #TABLE#_PK PRIMARY KEY("OBJECTID") USING INDEX TABLESPACE "INDX_#G_ADT#";

  -- pour une vue
ALTER VIEW #TABLE# ADD (CONSTRAINT #TABLE#_PK PRIMARY KEY (OBJECTID) DISABLE);


-----------------------------------------------------------------------------------------------
----------------------------------- Métadonnées spatiales -------------------------------------
-----------------------------------------------------------------------------------------------


--DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = '#TABLE#';

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('#TABLE#', 'GEOM', SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 2154);

COMMIT;

-----------------------------------------------------------------------------------------------
----------------------------------- Index spatial ---------------------------------------------
-----------------------------------------------------------------------------------------------

CREATE INDEX #TABLE#_SIDX
ON #TABLE#(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=#MULTIPOLYGON#, tablespace=INDX_#G_ADT#, work_tablespace=DATA_TEMP');

-----------------------------------------------------------------------------------------------
--------------------------------- Gestion des droits ------------------------------------------
-----------------------------------------------------------------------------------------------

GRANT SELECT ON #TABLE# TO G_ADT_DSIG_ADM;


-----------------------------------------------------------------------------------------------
----------------------------- Séquence pour clé primaire --------------------------------------
-----------------------------------------------------------------------------------------------

--SELECT MAX(OBJECTID) FROM #TABLE#;

CREATE SEQUENCE S_#TABLE# INCREMENT BY 1 START WITH #1# NOCACHE;

CREATE OR REPLACE TRIGGER B_IXX_#TABLE#
BEFORE INSERT ON #TABLE# FOR EACH ROW
BEGIN
  :new.OBJECTID := S_#TABLE#.nextval;
END;
/

-----------------------------------------------------------------------------------------------
----------------------------------- Création d'index ------------------------------------------
-----------------------------------------------------------------------------------------------

CREATE #UNIQUE# INDEX #TABLE#_#CHAMP#_IDX ON #TABLE#("#CHAMP#") TABLESPACE "INDX_#G_ADT#";


-----------------------------------------------------------------------------------------------
--------------------------------- Ajout d'un commentaire --------------------------------------
-----------------------------------------------------------------------------------------------


COMMENT ON TABLE #TABLE# IS '#COMMENT#';

-----------------------------------------------------------------------------------------------
----------------------------- Ajout d'un commentaire de champ ---------------------------------
-----------------------------------------------------------------------------------------------


COMMENT ON COLUMN #TABLE#.#COLUMN# IS '#COMMENT#';


-----------------------------------------------------------------------------------------------
------------------------------- Ajout d'une clé étrangère -------------------------------------
-----------------------------------------------------------------------------------------------

ALTER TABLE #TABLE# ADD CONSTRAINT #TABLE#_#CHAMP#_FK FOREIGN KEY ("#COL#") REFERENCES #TABLE_REF#("#COL#") /*ON DELETE CASCADE/SET NULL*/;


-----------------------------------------------------------------------------------------------
----------------------------- Ajout d'une contrainte unique -----------------------------------
-----------------------------------------------------------------------------------------------

ALTER TABLE #TABLE# ADD CONSTRAINT #TABLE#_#CHAMP#_UQ UNIQUE ("#COL#");

-----------------------------------------------------------------------------------------------
--------------------------------- Ajout d'une colonne -----------------------------------------
-----------------------------------------------------------------------------------------------

ALTER TABLE #TABLE# ADD #COL# #TYPECOL#;

-----------------------------------------------------------------------------------------------
------------------------------ Suppression d'une colonne --------------------------------------
-----------------------------------------------------------------------------------------------

ALTER TABLE #TABLE# DROP COLUMN #COL#;

-----------------------------------------------------------------------------------------------
------------------------------- Suppression d'une table ---------------------------------------
-----------------------------------------------------------------------------------------------

DROP TABLE #TABLE# CASCADE CONSTRAINTS;
DROP SEQUENCE S_#TABLE#;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = '#TABLE#';

-----------------------------------------------------------------------------------------------
<<<<<<< Updated upstream
------------------------------- Création de  Trigger-------------------------------------------
-----------------------------------------------------------------------------------------------

--Règles de nommage :
	-- Si le trigger se déclenche avant l'insertion (BEFORE INSERT), alors utilisez le préfixe 'B_' ;
	CREATE OR REPLACE TRIGGER NOM_SCHEMA.A_IXX_TABLE_NAME
=======
------------------------------- Création de vue -----------------------------------------------
-----------------------------------------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW #nom_schema#.#nom_vue# (
    #champ1#,
    #champ2#,
    #champ3#,
    CONSTRAINT #"nom_vue_PK"# PRIMARY KEY("CHAMP1") DISABLE
)
AS
/*
SELECT
	champ1,
	champ2,
	champ3
FROM
	nom_schema.table_name;
*/

COMMENT ON TABLE #nom_vue# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ1# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ2# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ3# IS '...';

-----------------------------------------------------------------------------------------------
------------------------------- Création de vue matérialisée ----------------------------------
-----------------------------------------------------------------------------------------------

CREATE MATERIALIZED VIEW #nom_schema#.#vm_nom_vue_materialisee# 
USING INDEX 
TABLESPACE #nom_tablespace# 
REFRESH ON DEMAND 
FORCE  
DISABLE QUERY REWRITE 
AS
/*
SELECT
	champ1,
	champ2,
	champ3
FROM
	nom_schema.table_name;
*/

COMMENT ON MATERIALIZED VIEW #nom_vue# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ1# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ2# IS '...';
COMMENT ON COLUMN #nom_vue#.#champ3# IS '...';

-----------------------------------------------------------------------------------------------
------------------------------- Création de  Trigger-------------------------------------------
-----------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_XXX_TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME
    FOR EACH ROW

	DECLARE
		...

	BEGIN
	    ...
	END;

--Règles de nommage :
	-- Si le trigger se déclenche avant l'insertion (BEFORE INSERT), alors utilisez le préfixe 'B_' ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_..._TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME

	-- Si le trigger se déclenche après l'insertion (AFTER INSERT), alors utilisez le préfixe 'A_' ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#A_..._TABLE_NAME#
    AFTER INSERT ON TABLE_NAME
	
	-- S'il s'agit d'une insertion seule, rajoutez 'IXX' -> 'B_IXX_TABLE_NAME' ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_IXX_TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME

	-- S'il s'agit d'une mise à jour seule, rajoutez 'UXX' -> 'B_UXX_' ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_UXX_TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME

	-- S'il s'agit d'une Suppression seule, rajoutez 'DXX' -> 'B_DXX_' ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_DXX_TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME

	--> Les deux 'XX' placés derrière l'initiale d'insertion/mise à jour/suppression signifie que le trigger marche UNIQUEMENT pour une action ;
	
	-- Si un trigger peut être déclenché par deux actions, alors, vous pouvez mélanger les préfixes -> 'B_IUX_TABLE_NAME' signifie que le trigger se déclenche avant l'insertion ou la mise de la table dont le nom figure dans le nom du trigger ;
	CREATE OR REPLACE TRIGGER #NOM_SCHEMA#.#B_IUX_TABLE_NAME#
    BEFORE INSERT ON TABLE_NAME


