-------------------------------------
-- CREATION_B_IXX_TA_OCSMEL_LOG_PK --
-------------------------------------

-- Creation du trigger B_IXX_TA_OCSMEL_LOG_PK d'incrémentation de clé primaire de la table TA_OCSMEL_LOG
CREATE OR REPLACE TRIGGER B_IXX_TA_OCSMEL_LOG_PK
BEFORE INSERT ON TA_OCSMEL_LOG FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_OCSMEL_LOG_OBJECTID.nextval;
END;

/

