-- 1. Sequence SEQ_TA_RTGE_LINEAIRE_PRODUCTION_LOG_OBJECTID de la table TA_RTGE_LINEAIRE_PRODUCTION_LOG. 

SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le dernier numero de la colonne de clé primaire
    NOMBRE_DEPART NUMBER(38,0);
-- corp de la procédure.
BEGIN
-- recupere le dernier numero de la colonne de clé primaire +1 pour determiner le nouveau point de départ de la séquence.
    BEGIN
      SELECT 
        MAX(OBJECTID) +1 INTO NOMBRE_DEPART
      FROM
        G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION_LOG
      ;
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_PRODUCTION_LOG_OBJECTID START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE');
    END;
-- execution de la requete
    BEGIN
      EXECUTE IMMEDIATE
      'CREATE SEQUENCE SEQ_TA_RTGE_LINEAIRE_PRODUCTION_LOG_OBJECTID START WITH ' || NOMBRE_DEPART || ' INCREMENT BY 1 NOCACHE';
    END;
END;

/
