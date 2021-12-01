/*
B_IUX_TA_GG_DOSSIER : Création du trigger B_IUX_TA_GG_DOSSIER permettant l'insertion automatique des USER_ID et DOS_DMAJ 
dans la table TA_GG_DOSSIER, lors d'insertion ou d'édition d'entités.
*/
create or replace TRIGGER B_IUX_TA_GG_DOSSIER
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_OBJECTID NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT OBJECTID INTO v_OBJECTID FROM G_GESTIONGEO.TA_GG_AGENT WHERE PNOM = username;

    IF INSERTING THEN -- En cas d'insertion on insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.USER_ID et on insère la date du jour dans le champ DOS_DC   
        :new.USER_ID := v_OBJECTID;
        :new.DOS_DC := TO_DATE(sysdate, 'dd/mm/yy');
    END IF;

    IF UPDATING THEN -- En cas d'édition on insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.USER_ID et on édite le champ DOS_DMAJ
        :new.USER_ID := v_OBJECTID;
        :new.DOS_DMAJ := sysdate;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

