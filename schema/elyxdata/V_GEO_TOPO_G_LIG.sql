
  CREATE OR REPLACE FORCE VIEW "ELYX_DATA"."V_GEO_TOPO_G_LIG" ("OBJECTID", "CLA_INU", "GEOM", "GEO_DV", "GEO_DF", "GEO_ON_VALIDE", "GEO_NMN", "GEO_DS", "GEO_NMS", "GEO_DM") AS
  select
ta_lig_topo_g.objectid,
ta_lig_topo_g.CLA_INU,
ta_lig_topo_g.GEOM,
ta_lig_topo_g.GEO_DV,
ta_lig_topo_g.GEO_DF,
ta_lig_topo_g.GEO_ON_VALIDE,
ta_lig_topo_g.GEO_NMN,
ta_lig_topo_g.GEO_DS,
ta_lig_topo_g.GEO_NMS,
ta_lig_topo_g.GEO_DM
from geo.ta_lig_topo_g
where
ta_lig_topo_g.geo_on_valide=0 and
(
  cla_inu = 196 OR
  cla_inu = 199 OR
  cla_inu = 711 OR
  cla_inu = 827 OR
  cla_inu = 828 OR
  cla_inu = 829 OR
  cla_inu = 833 OR
  cla_inu = 847
);

  CREATE OR REPLACE TRIGGER "ELYX_DATA"."DELETE_TOPO_G"
instead of delete ON "ELYX_DATA"."V_GEO_TOPO_G_LIG"
declare
username varchar(30);
vMessage varchar2(32000);
BEGIN
select sys_context('USERENV','OS_USER') into username from dual;
vmessage:='phase delete de '||:old.objectid;
update GEO.ta_lig_topo_g set geo_on_valide=1 ,geo_df=sysdate ,geo_dm=sysdate ,GEO_NMN=username where objectid=:old.objectid;
EXCEPTION
WHEN OTHERS THEN
vMessage := vMessage || chr(10) || 'Le trigger instead of V_GEO_TOPO_G rencontre des problèmes par '||username;
mail.sendmail('fvoet@lillemetropole.fr',vMessage,'Souci Le trigger instead of V_GEO_TOPO_G',
			'fvoet@lillemetropole.fr','fvoet@lillemetropole.fr') ;
END;
/
ALTER TRIGGER "ELYX_DATA"."DELETE_TOPO_G" ENABLE;
