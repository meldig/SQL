---------------------------------------
-- CREATION_B_IXX_TA_RTGE_SURFACE_PK --
---------------------------------------

-- Creation du trigger B_IXX_TA_RTGE_SURFACE_PK d'incrematation de clé primaire de la table TA_RTGE_SURFACE
CREATE OR REPLACE TRIGGER B_IXX_TA_RTGE_SURFACE_PK
BEFORE INSERT ON TA_RTGE_SURFACE FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_RTGE_SURFACE_OBJECTID.nextval;
END;

/
