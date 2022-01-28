/*
Création du trigger DELETE_GPS_OBJ permettant de passer les points validés par les géomètres de la table TA_POINT_TOPO_GPS à la table TA_POINT_TOPO_F.
*/

CREATE OR REPLACE TRIGGER "ELYX_DATA"."DELETE_GPS_OBJ" 
  INSTEAD OF DELETE ON "ELYX_DATA"."V_GEO_GPS_OBJ"
  DECLARE
    username varchar(30);
    vmessage VARCHAR2(3200);
  BEGIN
      
    -- OBJECTIF DU TRIGGER : passer les lignes validées par les géomètres de la table TA_LIG_TOPO_GPS à la table TA_LIG_TOPO_F dans le schéma GEO.

    SELECT sys_context('USERENV','OS_USER') INTO username FROM DUAL;
    INSERT INTO GEO.ta_point_topo_f(
      objectid,
      id_dos,
      cla_inu,
      geom,
      geo_dv,
      geo_df,
      geo_on_valide,
      geo_texte,
      geo_poi_ln,
      geo_poi_la,
      GEO_POI_AG_ORIENTATION,
      GEO_TYPE,
      geo_nmn,
      geo_ds,
      geo_nms,
      geo_dm
    )
    VALUES (
      :old.objectid,
      :old.id_dos,
      :old.cla_inu,
      :old.geom,
      sysdate,
      '31/12/2099',
      0,
      :old.geo_texte,
      :old.geo_poi_ln,
      :old.geo_poi_la,
      :old.GEOM_ORIENT,
      'P',
      username,
      sysdate,
      username,
      sysdate
    );
    UPDATE GEO.ta_point_topo_gps 
    SET geo_on_valide=1 ,
        geo_df=sysdate ,
        geo_dm=sysdate ,
        GEO_NMN=username 
    WHERE 
      objectid=:old.objectid;
  EXCEPTION
   WHEN OTHERS THEN 
    vmessage := 'Le trigger instead of DELETE_GPS_OBJ de la vue V_GEO_GPS_OBJ rencontre des problèmes par '|| username || '. ';
    mail.sendmail('bjacq@lillemetropole.fr',vmessage || SQLERRM,'ERREUR TRIGGER - ELYX_DATA.DELETE_GPS_OBJ',
            'bjacq@lillemetropole.fr','bjacq@lillemetropole.fr');
END;

/

