------------------------------------
-- CREATION_B_IXX_TA_RTGE_ALTI_PK --
------------------------------------

-- Creation du trigger B_IXX_TA_RTGE_ALTI_PK d'incrematation de clé primaire de la table TA_RTGE_ALTI
CREATE OR REPLACE TRIGGER B_IXX_TA_RTGE_ALTI_PK
BEFORE INSERT ON TA_RTGE_ALTI FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_RTGE_ALTI_OBJECTID.nextval;
END;

/
