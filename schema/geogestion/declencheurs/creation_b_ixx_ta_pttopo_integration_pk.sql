---------------------------------------------
-- CREATION_B_IXX_TA_PTTOPO_INTEGRATION_PK --
---------------------------------------------

-- Creation du trigger d'incrementaion B_IXX_TA_PTTOPO_INTEGRATION_PK de clé primaire de la table TA_PTTOPO_INTEGRATION
CREATE OR REPLACE TRIGGER B_IXX_TA_PTTOPO_INTEGRATION_PK
BEFORE INSERT ON TA_PTTOPO_INTEGRATION FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_PTTOPO_INTEGRATION_OBJECTID.nextval;
END;

/
