-- 1. Sequence TA_OCSMEL_LOG de la table SEQ_TA_OCSMEL_LOG. 

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
        G_GESTIONGEO.TA_OCSMEL_LOG
      ;
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE SEQ_TA_OCSMEL_LOG INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' NOCACHE');
    END;
-- execution de la requete
    BEGIN
      EXECUTE IMMEDIATE
      'CREATE SEQUENCE SEQ_TA_OCSMEL_LOG INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' NOCACHE';
    END;
END;
/
