-- Creation du trigger d'incrementaion B_IXX_TA_RTGE_POINT_PRODUCTION_LOG_PK de clé primaire de la table TA_RTGE_POINT_PRODUCTION_LOG
CREATE OR REPLACE TRIGGER B_IXX_TA_RTGE_POINT_PRODUCTION_LOG_PK
BEFORE INSERT ON TA_RTGE_POINT_PRODUCTION_LOG FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_RTGE_POINT_PRODUCTION_LOG_OBJECTID.nextval;
END;

/
