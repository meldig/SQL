/*
Création du trigger B_IXX_TA_GG_DOSSIER permettant de créer une nouvelle entité en cas de création d'un nouveau dossier.
*/
create or replace TRIGGER B_IXX_TA_GG_DOSSIER
BEFORE INSERT ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
BEGIN
    /*
    Objectif : ce trigger insère l'identifiant de chaque nouveau dossier dans TA_GG_DOS_NUM.FID_DOSSIER afin de pouvoir créer un DOS_NUM. Ce trigger est nécessaire car la fonction COALESCE qui créé le DOS_NUM ne fonctionne que sur des champs dont la valeur est soit existante soit nulle.
    En l'occurrence c'est cette dernière option qui nous intéresse.
    */
    -- Création d'une nouvelle entité dans TA_GG_DOS_NUM, sans DOS_NUM
    INSERT INTO G_GESTIONGEO.TA_GG_DOS_NUM(fid_dossier)
    VALUES(:new.objectid);

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IXX_TA_GG_DOSSIER','bjacq@lillemetropole.fr');
END;

/

