/*
Cette requête permet de savoir si certaines lignes simples sont concernées par des erreurs topologiques ou non.
*/

SET SERVEROUTPUT ON
DECLARE  
    Vmessage VARCHAR2(400);
    Vobjet1 NUMBER(38,0);
    Vobjet2 NUMBER(38,0);

BEGIN
        -- Vérification : des lignes s'intersectent-elles hors start/endPoint ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_LIGNE) LOOP
        BEGIN
            -- Vérification de l'intersection entre deux lignes
                SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_LIGNE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_RELATE(a.geom, i.geom, 'mask=OVERLAPBDYDISJOINT') = 'TRUE';                   
                DBMS_OUTPUT.PUT_LINE('La ligne ' || vobjet1 || ' intersecte la ligne ' || vobjet2 || ' en dehors des start/endPoints.');
           
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;
        
        -- Vérification : des lignes s'intersectent-elles sur leurs start/endPoints ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_LIGNE) LOOP
        BEGIN
        SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_LIGNE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_RELATE(a.geom, i.geom, 'mask=TOUCH') = 'TRUE';
                DBMS_OUTPUT.PUT_LINE('La ligne ' || vobjet1 || ' est connecté à la ligne ' || vobjet2 || ' au niveau des start/endPoints.');
       EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;
        
         -- Vérification : des lignes sont-elles disjointent dans un périmètre de 25m  autours de chacune d'elle ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_LIGNE) LOOP
        BEGIN
        SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_LIGNE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_WITHIN_DISTANCE(a.geom, i.geom, 'distance=25 unit=m') = 'TRUE'
                    AND SDO_FILTER(a.geom, i.geom) <> 'TRUE';
                DBMS_OUTPUT.PUT_LINE('La ligne ' || vobjet1 || ' est disjointe de la ligne ' || vobjet2 || '.');
       EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP; 
END;