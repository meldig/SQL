/*
Objectif : 
    - vérifier qu'aucune valeur nulle ne se situe dans un champ ayant une contrainte de clé étrangère ;
    - vérifier que chaque clé étrangère dispose bien d'une clé parente ;
    - La procédure suivante est générique et fonctionne sur tous les schémas sans modification préalable du code ;
*/

SET SERVEROUTPUT ON
DECLARE
    v_schema_enfant VARCHAR2(400 byte);
    v_table_enfant VARCHAR2(400 byte);
    v_champ_enfant VARCHAR2(400 byte);
    v_schema_parent VARCHAR2(400 byte);
    v_table_parent VARCHAR2(400 byte);
    v_champ_parent VARCHAR2(400 byte);
    v_contrainte VARCHAR2(400 byte);
    v_decompte1 NUMBER(38,0);
    v_decompte2 NUMBER(38,0);
    v_requete VARCHAR2(1000 byte);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('SCHEMA ENFANT ; TABLE ENFANT ; CHAMP ENFANT ; NBR FK ORPHELINE ; NBR VALEUR NULL FK ; NOM CONTRAINTE ; SCHEMA PARENT ; TABLE PARENT ; CHAMP PARENT');
    FOR i IN(
        SELECT
           a.owner AS schema_enfant,
           a.table_name AS table_enfant,
           d.column_name AS champ_enfant,   
           a.constraint_name AS nom_contrainte,
           b.owner AS schema_parent,
           b.table_name AS table_parent,
           b.column_name AS champ_parent
        FROM
            USER_CONSTRAINTS a
            INNER JOIN ALL_CONS_COLUMNS b ON b.constraint_name = a.r_constraint_name,
            ALL_CONS_COLUMNS d
        WHERE
            a.CONSTRAINT_TYPE = 'R'
            AND a.R_CONSTRAINT_NAME IS NOT NULL
            AND d.constraint_name = a.constraint_name
    ) LOOP
        v_schema_enfant := i.schema_enfant;
        v_table_enfant := i.table_enfant;
        v_champ_enfant := i.champ_enfant;
        v_contrainte := i.nom_contrainte;
        v_schema_parent := i.schema_parent;
        v_table_parent := i.table_parent;
        v_champ_parent := i.champ_parent;
        
        -- Décompte des valeurs NULL pour chaque clé étrangère
        v_requete := 'SELECT COUNT(*) FROM ' || v_schema_enfant || '.' || v_table_enfant || ' WHERE ' || v_champ_enfant || ' IS NULL';
        -- Stockage du nombre de valeurs null par clé étrangère dans v_decompte1
        EXECUTE IMMEDIATE v_requete INTO v_decompte1;

        -- Sélection du nombre de clés étrangères orphelines de clés parentes
        v_requete := 'SELECT COUNT(a.' || v_champ_enfant || ') FROM ' || v_schema_enfant || '.' || v_table_enfant || ' a WHERE a.' || v_champ_enfant || ' NOT IN (SELECT ' || v_champ_parent || ' FROM ' || v_schema_parent || '.' || v_table_parent || ')';
        -- Stockage du nombre de clés orphelines dans v_decompte2
        EXECUTE IMMEDIATE v_requete INTO v_decompte2;

        DBMS_OUTPUT.PUT_LINE(v_schema_enfant || ' ; ' || v_table_enfant || ' ; ' || v_champ_enfant || ' ; ' || v_decompte2 || ' ; ' || v_decompte1 || ' ; ' || v_contrainte || ' ; ' || v_schema_parent || ' ; ' || v_table_parent || ' ; ' || v_champ_parent);

    END LOOP;
END;