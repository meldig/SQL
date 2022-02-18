/*
B_UXX_TA_GG_DOSSIER : Création du trigger B_IUX_TA_GG_DOSSIER permettant la mise à jour automatique des FID_PNOM_MODIFICATION, DATE_MODIFICATION et DATE_CLOTURE
dans la table TA_GG_DOSSIER lors d'édition d'entités.
*/
create or replace TRIGGER B_UXX_TA_GG_DOSSIER
BEFORE UPDATE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_OBJECTID NUMBER(38,0);
    v_etat NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT OBJECTID INTO v_OBJECTID FROM G_GESTIONGEO.TA_GG_AGENT WHERE PNOM = username;

    -- On insère l'OBJECTID correspondant à l'utilisateur dans TA_GG_DOSSIER.fid_pnom_modification et on édite le champ date_modification
    :new.fid_pnom_modification := v_OBJECTID;
    :new.date_modification := sysdate;

    -- Sélection de l'identifiant de l'état indiquant qu'un dossier est clôturé
    SELECT
        objectid
        INTO v_etat
    FROM
        G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT
    WHERE
        TRIM(LOWER(libelle_long)) = 'actif en base (dossier clôturé et donc visible en carto)';
    
    -- Si le dossier est clôturé, alors la date et l'heure de clôture sont enregistrées en base
    IF :new.fid_etat_avancement = v_etat THEN
        :new.date_cloture := sysdate;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_UXX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

