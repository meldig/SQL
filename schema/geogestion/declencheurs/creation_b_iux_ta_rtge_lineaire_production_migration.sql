----------------------------------------------------------
-- CREATION_B_IUX_TA_RTGE_LINEAIRE_PRODUCTION_MIGRATION --
----------------------------------------------------------

/*
creation trigger de migration: B_IUX_TA_RTGE_LINEAIRE_PRODUCTION_MIGRATION
*/

/*
le  but de ce trigger est de pouvoir permettre la migration des éléments contenus dans la table TA_RTGE_LINEAIRE_INTEGRATION
- les éléments ont par défaut la valeur 0. Si l'élément est mise à jour avec la valeur 1 l'élément doit être supprimé de la table TA_RTGE_LINEAIRE_INTEGRATION et être inséré dans la table TA_RTGE_LINEAIRE_PRODUCTION
*/


CREATE OR REPLACE TRIGGER B_IUX_TA_RTGE_LINEAIRE_PRODUCTION_MIGRATION
BEFORE INSERT OR UPDATE OF ETAT_INTEGRATION ON G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION FOR EACH ROW
DECLARE
USERNAME VARCHAR2(100 BYTE);
OBJET NUMBER(38,0);

BEGIN
SELECT SYS_CONTEXT('USERENV','OS_USER') INTO USERNAME FROM DUAL;
OBJET := :new.OBJECTID;

	IF :new.ETAT_INTEGRATION = 1 THEN
		-- Insertion de l''element à integrer dans la table TA_RTGE_LINEAIRE
		INSERT INTO G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION(GEOM, FID_NUMERO_DOSSIER, FID_IDENTIFIANT_TYPE, DECALAGE_DROITE, DECALAGE_GAUCHE, FID_IDENTIFIANT_OBJET_INTEGRATION)
		VALUES (
				:new.GEOM,
				:new.FID_NUMERO_DOSSIER,
				:new.FID_IDENTIFIANT_TYPE,
				:new.DECALAGE_DROITE,
				:new.DECALAGE_GAUCHE,
				:new.OBJECTID
				)
		;

		:new.ETAT_INTEGRATION:= 2;
		
	END IF;

	EXCEPTION
	WHEN OTHERS THEN
	    mail.sendmail('rjault@lillemetropole.fr',SQLERRM || ' Sur l''objet : ' || OBJET || ' modifié par ' || USERNAME,'ERREUR TRIGGER - G_GESTIONGEO.B_XUX_TA_RTGE_LINEAIRE_PRODUCTION_MIGRATION','rjault@lillemetropole.fr');
END;

/
