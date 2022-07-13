-- Trigger de mise à jour de la table TA_GG_DOSSIER_DEVIS

/*
A_I_TA_GG_DOSSIER_DEVIS : Création du déclencheur TA_GG_DOSSIER_DEVIS permettant d'insérer dans la table les longueurs de voies par type intersecté par un dossier
après la création d'un dossier et de sa géométrie dans les tables TA_GG_DOSSIER et TA_GG_GEO.
supprimer également les lignes concernant un dossier si celui-ci est supprimé.
*/

CREATE OR REPLACE TRIGGER A_I_TA_GG_DOSSIER_DEVIS
AFTER INSERT OR DELETE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
BEGIN
    /*
    Objectif : ce trigger à pour objectif d'insérer dans la table TA_GG_DOSSIER_DEVIS les longueurs totales des voies intersectées par un dossier
    */
    IF INSERTING THEN
        -- insertion des longueurs des voies de type A
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,13);

        -- insertion des longueurs des voies de type B
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,14);

        -- insertion des longueurs des voies de type C
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,15);

        -- insertion des longueurs des voies de type D
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,16);

        -- insertion des longueurs des voies de type E
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,17);

        -- insertion des longueurs des voies de type X
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_DEVIS(numero_dossier,type_voie)
        VALUES(:new.objectid,18);

    END IF;

    IF DELETING THEN
        DELETE FROM G_GESTIONGEO.TA_GG_DOSSIER_DEVIS WHERE numero_dossier = :old.objectid;

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('rjault@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER G_GESTIONGEO.A_I_TA_GG_DOSSIER_DEVIS','rjault@lillemetropole.fr');
END;

/