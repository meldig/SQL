-- 5. Sequence SEQ_TA_OCSMEL de la table TA_OCSMEL

SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le nom de la séquence de la table.
    NOMBRE_DEPART NUMBER(38,0);
-- corp de la procédure.
BEGIN
-- recupere le nom de la sequence
    BEGIN
      SELECT 
        MAX(OBJECTID) +1 INTO NOMBRE_DEPART
      FROM
        G_GESTIONGEO.TA_OCSMEL
      ;
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE SEQ_TA_OCSMEL INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE');
    END;
-- execution de la requete
    BEGIN
      EXECUTE IMMEDIATE
      'CREATE SEQUENCE SEQ_TA_OCSMEL INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE');
    END;
END;

/
