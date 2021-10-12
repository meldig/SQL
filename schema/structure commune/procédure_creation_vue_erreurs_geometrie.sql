SET SERVEROUTPUT ON
DECLARE
	v_saut_ligne VARCHAR2(50);
	v_requete VARCHAR2(4000);
	v_user VARCHAR2(50);
BEGIN
	/*
		Code permettant de créer la vue recensant les erreurs de géométrie par type de géométrie et par table
	*/

	SELECT
		USER INTO v_user
	FROM
		DUAL;

    DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE FORCE VIEW "' || v_user || '"."V_ERREURS_GEOMETRIES" ("NOM_TABLE", "ERREUR", "NOMBRE", CONSTRAINT V_ERREURS_GEOMETRIES_PK" PRIMARY KEY ("NOM_TABLE") DISABLE) AS ');
    
    FOR I IN (
        SELECT
            'SELECT ''' || a.table_name || ''' AS NOM_TABLE, SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.005), 0, 5) AS ERREUR, COUNT(a.' || c.column_name || ') AS NOMBRE FROM ' || USER || '.' || a.table_name || ' a WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.005)<>''TRUE'' GROUP BY SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.005), 0, 5), ''' || a.table_name || '''' AS requete
        FROM
            USER_TAB_COLUMNS a
            INNER JOIN USER_OBJECTS b ON b.object_name = a.table_name
            INNER JOIN USER_CONS_COLUMNS c ON c.table_name = a.table_name
            INNER JOIN USER_CONSTRAINTS d ON d.table_name = a.table_name AND d.constraint_name = c.constraint_name
        WHERE
            a.data_type = 'SDO_GEOMETRY'
            AND b.object_type = 'TABLE'
            AND d.constraint_type = 'P'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(i.requete || ' UNION ALL ');
    END LOOP;   
    DBMS_OUTPUT.PUT_LINE(';');
END;