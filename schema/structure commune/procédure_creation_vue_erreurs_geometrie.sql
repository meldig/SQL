create or replace Procedure creation_vue_v_erreurs_geometries
    IS
        v_requete VARCHAR2(4000);
        v_user VARCHAR2(50);
    BEGIN
        SAVEPOINT POINT_SAUVERGARDE_CREATION_V_ERREURS_GEOMETRIES;
        /*
            Code permettant de créer la vue recensant les erreurs de géométrie par type de géométrie et par table pour tout le schéma.
        */

        SELECT
            USER INTO v_user
        FROM
            DUAL;

        DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE FORCE VIEW "' || v_user || '"."V_ERREURS_GEOMETRIES" ("IDENTIFIANT", "NOM_TABLE", "ERREUR", "NOMBRE", CONSTRAINT "V_ERREURS_GEOMETRIES_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS WITH C_1 AS( ');

        FOR I IN (
            SELECT -- Cette requête créé le code de sélection des erreurs de géométrie par type et par table (les VM sont donc incluses) pour toutes les tables du schéma disposant d'un champ géométrique
                rownum AS compteur, -- Ce compteur sera utilisé uniquement pour créer la requête de création de la vue
                'SELECT ''' || a.table_name || ''' AS NOM_TABLE, SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.001), 0, 5) AS ERREUR, COUNT(a.' || c.column_name || ') AS NOMBRE FROM ' || USER || '.' || a.table_name || ' a WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.001)<>''TRUE'' GROUP BY SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.' || a.column_name || ', 0.001), 0, 5), ''' || a.table_name || '''' AS requete
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
            IF i.compteur = 1 THEN -- Cette condition nous d'écrire correctement le code DDL de la vue dans le "résultat" de la procédure
                DBMS_OUTPUT.PUT_LINE(i.requete);
            ELSE
                DBMS_OUTPUT.PUT_LINE(' UNION ALL ' || i.requete);
            END IF;
        END LOOP;   
        -- Une fois le code DDL de la vue affiché, les codes suivants permettent d'écrire les commentaires de chaque champ
        DBMS_OUTPUT.PUT_LINE(') SELECT ROWNUM AS identifiant, a.nom_table, a.erreur, a.nombre FROM C_1 a;');
        DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN V_ERREURS_GEOMETRIES.IDENTIFIANT IS ''Clé primaire de la vue recensant le nombre d''''erreurs de géométrie par table et par type au sein du schéma.'';');
        DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN V_ERREURS_GEOMETRIES.NOM_TABLE IS ''Nom des tables contenant des erreurs de géométrie.'';');
        DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN V_ERREURS_GEOMETRIES.ERREUR IS ''Type d''''erreur de géométrie.'';');
        DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN V_ERREURS_GEOMETRIES.NOMBRE IS ''Nombre d''''erreurs de géométrie par type et par table.'';');

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_CREATION_V_ERREURS_GEOMETRIES;
END creation_vue_v_erreurs_geometries;