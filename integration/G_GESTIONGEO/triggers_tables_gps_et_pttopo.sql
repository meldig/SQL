/*
Création des triggers nécessaire à l'incrémentation des clés primaires dans les tables TA_POINT_TOPO_GPS, TA_LIG_TOPO_GPS, PTTOPO.
La création d'un fichier spécifique à ces triggers est dû au fait qu'ils se situent dans l'instance d'oracle 11g et non dans celle d'oracle 12c où se trouvent les tables TA_GG_GEO et TA_GG_DOSSIER.
*/

-- 1. Table GEO.TA_POINT_TOPO_GPS
create or replace TRIGGER "GEO"."BEF_TA_POINT_TOPO_GPS" 
BEFORE INSERT ON GEO.TA_POINT_TOPO_GPS
FOR EACH ROW

BEGIN
  :new.OBJECTID := TA_POINT_TOPO_F_SEQ.nextval;
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER BEF_TA_POINT_TOPO_GPS','trigger@lillemetropole.fr');
END;

-- 2. Table GEO.TA_LIG_TOPO_GPS
create or replace TRIGGER "GEO"."BEF_TA_LIG_TOPO_GPS" 
BEFORE INSERT ON GEO.TA_LIG_TOPO_GPS
FOR EACH ROW

BEGIN
  :new.OBJECTID := TA_LIG_TOPO_F_SEQ.nextval;
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER BEF_TA_LIG_TOPO_GPS','trigger@lillemetropole.fr');
END;

-- 3. Table GEO.PTTOPO
create or replace TRIGGER "GEO"."BEF_PTTOPO" 
BEFORE INSERT ON GEO.PTTOPO
FOR EACH ROW

BEGIN
  :new.OBJECTID := PTTOPO_SEQ.nextval;
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER BEF_PTTOPO','trigger@lillemetropole.fr');
END;