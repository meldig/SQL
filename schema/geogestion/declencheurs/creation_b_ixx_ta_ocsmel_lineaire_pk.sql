------------------------------------------
-- CREATION_B_IXX_TA_OCSMEL_LINEAIRE_PK --
------------------------------------------

-- Creation du trigger d'incrementaion B_IXX_TA_OCSMEL_LINEAIRE_PK de clé primaire de la table TA_OCSMEL_LINEAIRE
CREATE OR REPLACE TRIGGER B_IXX_TA_OCSMEL_LINEAIRE_PK
BEFORE INSERT ON TA_OCSMEL_LINEAIRE FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_OCSMEL_LINEAIRE_OBJECTID.nextval;
END;

/
