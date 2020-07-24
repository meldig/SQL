/*
Cette requête permet de savoir si certains polygones sont concernés par des erreurs topologiques ou non.
*/

SET SERVEROUTPUT ON
DECLARE  
    Vmessage VARCHAR2(400);
    Vobjet1 NUMBER(38,0);
    Vobjet2 NUMBER(38,0);
BEGIN
        -- Vérification : y aurait-il des doublons géométriques ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_POLYGONE) LOOP
        BEGIN
                SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_POLYGONE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_RELATE(a.geom, i.geom, 'mask=EQUAL') = 'TRUE';                   
                --DBMS_OUTPUT.PUT_LINE(vobjet1);
                DBMS_OUTPUT.PUT_LINE('Le polygone ' || vobjet1 || ' est égal au polygone ' || vobjet2 || '.');
           
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;
        
        -- Vérification : des polygones recouvriraient_ils en partie d'autres polygones ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_POLYGONE) LOOP
        BEGIN
                SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_POLYGONE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_RELATE(a.geom, i.geom, 'mask=OVERLAPBDYINTERSECT') = 'TRUE';                   
                --DBMS_OUTPUT.PUT_LINE(vobjet1);
                DBMS_OUTPUT.PUT_LINE('Le polygone ' || vobjet1 || ' et le polygone ' || vobjet2 || ' se recouvrent en partie.');
           
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;
        
        -- Vérification : des polygones sont-ils disjoints de 1m alors qu'ils devraient être jointifs ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_POLYGONE) LOOP
        BEGIN
                SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_POLYGONE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < b.objectid
                    AND SDO_WITHIN_DISTANCE(a.geom, b.geom, 'distance=1 unit=m') = 'TRUE'
                    AND SDO_GEOM.RELATE(a.geom, 'DISJOINT', b.geom) = 'TRUE';                   
                --DBMS_OUTPUT.PUT_LINE(vobjet1);
                DBMS_OUTPUT.PUT_LINE('Le polygone ' || vobjet1 || ' est disjoint du polygone ' || vobjet2 || ' dans un rayon de 1m.');
           
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;
        
        /*-- Vérification : des polygones sont-ils jointifs sans se recouvrir ?
        FOR i IN (SELECT objectid, geom FROM TA_TEST_POLYGONE) LOOP
        BEGIN
                SELECT i.objectid, a.objectid
                    INTO Vobjet1, Vobjet2
                FROM
                    TA_TEST_POLYGONE a
                WHERE
                    a.objectid <> i.objectid
                    AND a.objectid < i.objectid
                    AND SDO_RELATE(a.geom, i.geom, 'mask=TOUCH') = 'TRUE';                   
                --DBMS_OUTPUT.PUT_LINE(vobjet1);
                DBMS_OUTPUT.PUT_LINE('Le polygone ' || vobjet1 || ' est joint au polygone ' || vobjet2 || ' sur les seuls contours extérieurs.');
           
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
                CONTINUE;
        END; 
        END LOOP;*/
END;

