-- 4. Sequence SEQ_TA_RTGE_LINEAIRE_OBJECTID de la table TA_RTGE_LINEAIRE

SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le nom de la séquence de la table.
    NOMBRE_DEPART NUMBER(38,0);
-- corp de la procédure.
BEGIN
-- recupere le nom de la sequence
    BEGIN
        SELECT
            MAX(objectid) INTO NOMBRE_DEPART
        FROM
          (
          SELECT
            MAX(objectid) as objectid 
          FROM 
            TA_RTGE_LINEAIRE_INTEGRATION
          UNION ALL 
          SELECT 
            MAX(objectid) as objectid
          FROM
            TA_RTGE_LINEAIRE
            )
      ;
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_OBJECTID START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE';
    END;
-- execution de la requete
    BEGIN
      EXECUTE IMMEDIATE
      'CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_OBJECTID START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE';
    END;
END;

/
