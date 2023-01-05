-- 4. Sequence SEQ_TA_RTGE_LINEAIRE_FIN de la table TA_RTGE_LINEAIRE_FIN

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
        G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN
      ;
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_FIN INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' NOCACHE');
    END;
-- execution de la requete
    BEGIN
      EXECUTE IMMEDIATE
      'CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_FIN INCREMENT BY 1 START WITH ' || NOMBRE_DEPART || ' NOCACHE';
    END;
END;

/
