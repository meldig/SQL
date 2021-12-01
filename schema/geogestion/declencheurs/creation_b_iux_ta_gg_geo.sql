/* 
B_IUX_TA_GG_GEO : Création du trigger B_IUX_TA_GG_GEO permettant de calculer les surface en m² des périmètres des dossiers de la table TA_GG_GEO
*/

create or replace TRIGGER B_IUX_TA_GG_GEO
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE 
BEGIN
    IF INSERTING THEN -- En cas d'insertion on insère la surface du polygone dans le champ surface(m2)       
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

    IF UPDATING THEN -- En cas d'édition on édite la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;

/

