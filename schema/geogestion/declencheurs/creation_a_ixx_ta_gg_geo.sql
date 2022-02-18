/*
    A_IXX_TA_GG_GEO : Création du déclencheur A_IXX_TA_GG_GEO permettant de créer un dossier dans la table TA_GG_DOSSIER, suite à la création de son périmètre dans l'application.
*/

CREATE OR REPLACE TRIGGER A_IXX_TA_GG_GEO
AFTER INSERT ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);

BEGIN
    -- Note : ce trigger permet de créer un dossier une fois son périmètre créé dans l'application (qgis).
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;

    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT objectid INTO v_id_agent FROM G_GESTIONGEO.TA_GG_AGENT WHERE pnom = username;

    -- Création d'un nouveau dossier dans TA_GG_DOSSIER correspondant au périmètre dessiné
    INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER(fid_perimetre, fid_pnom_creation, date_saisie)
    VALUES(:new.objectid, v_id_agent, TO_DATE(sysdate, 'dd/mm/yy'));

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER A_IXX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;

/
