----------------------------------------------
-- CREATION_B_IXX_TA_OCSMEL_LINEAIRE_LOG_PK --
----------------------------------------------

-- Creation du trigger d'incrementaion B_IXX_TA_OCSMEL_LINEAIRE_LOG_PK de clé primaire de la table TA_OCSMEL_LINEAIRE_LOG
CREATE OR REPLACE TRIGGER B_IXX_TA_OCSMEL_LINEAIRE_LOG_PK
BEFORE INSERT ON TA_OCSMEL_LINEAIRE_LOG FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_OCSMEL_LINEAIRE_LOG_OBJECTID.nextval;
END;

/
