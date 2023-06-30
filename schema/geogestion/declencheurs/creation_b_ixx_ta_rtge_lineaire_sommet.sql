--------------------------------------
-- B_IXX_TA_RTGE_LINEAIRE_SOMMET_PK --
--------------------------------------

-- Creation du trigger B_IXX_TA_RTGE_LINEAIRE_SOMMET_PK d'incrematation de clé primaire de la table TA_RTGE_LINEAIRE_SOMMET
CREATE OR REPLACE TRIGGER B_IXX_TA_RTGE_LINEAIRE_SOMMET_PK
BEFORE INSERT ON TA_RTGE_LINEAIRE_SOMMET FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TA_RTGE_LINEAIRE_SOMMET_OBJECTID.nextval;
END;

/
