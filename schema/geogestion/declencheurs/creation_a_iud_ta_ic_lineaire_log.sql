-- 2. Creation du trigger A_IUD_TA_IC_LINEAIRE_LOG

/*
Déclencheur permettant de remplir la table de logs TA_IC_LINEAIRE_LOG dans laquelle sont enregistrés chaque insertion, 
modification et suppression des données de la table TA_RTGE_LINEAIRE_INTEGRATION avec leur date et le pnom de l'agent les ayant effectuées.
*/

CREATE OR REPLACE TRIGGER G_GESTIONGEO.A_IUD_TA_IC_LINEAIRE_LOG
AFTER INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_IC_LINEAIRE
FOR EACH ROW
DECLARE
V_OBJECTID NUMBER(38,0);
USERNAME VARCHAR(30);
USERNUMBER NUMBER(38,0);
NUMBER_INSERTION NUMBER(38,0);
NUMBER_MODIFICATION NUMBER(38,0);
NUMBER_SUPPRESSION NUMBER(38,0);

BEGIN
-- selection du nom de l''agent dans la variable USERNAME
SELECT 	SYS_CONTEXT('USERENV','OS_USER') INTO USERNAME 	FROM DUAL;

-- selection du numero de l''agent dans la variable USERNUMBER
SELECT OBJECTID INTO USERNUMBER FROM G_GESTIONGEO.TA_GG_AGENT WHERE	TRIM(LOWER(USERNAME)) = TRIM(LOWER(PNOM));


-- selection de l'objectid du libelle modification dans la variable NUMBER_INSERTION
SELECT 
	a.OBJECTID INTO NUMBER_INSERTION
FROM 
	G_GESTIONGEO.TA_GG_LIBELLE a
	INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON b.OBJECTID = a.FID_LIBELLE_LONG
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.FID_LIBELLE = a.OBJECTID
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.OBJECTID = c.FID_FAMILLE
WHERE
	TRIM(LOWER(b.valeur)) = TRIM(LOWER('insertion'))
	AND
	TRIM(LOWER(d.libelle)) = TRIM(LOWER('type d''action'));


-- selection de l'objectid du libelle modification dans la variable NUMBER_MODIFICATION
SELECT 
	a.OBJECTID INTO NUMBER_MODIFICATION 
FROM 
	G_GESTIONGEO.TA_GG_LIBELLE a
	INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON b.OBJECTID = a.FID_LIBELLE_LONG
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.FID_LIBELLE = a.OBJECTID
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.OBJECTID = c.FID_FAMILLE
WHERE
	TRIM(LOWER(b.valeur)) = TRIM(LOWER('modification'))
	AND
	TRIM(LOWER(d.libelle)) = TRIM(LOWER('type d''action'));

-- selection de l'objectid du libelle modification dans la variable NUMBER_SUPPRESSION
SELECT 
	a.OBJECTID INTO NUMBER_SUPPRESSION 
FROM 
	G_GESTIONGEO.TA_GG_LIBELLE a
	INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON b.OBJECTID = a.FID_LIBELLE_LONG
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.FID_LIBELLE = a.OBJECTID
	INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.OBJECTID = c.FID_FAMILLE
WHERE
	TRIM(LOWER(b.valeur)) = TRIM(LOWER('suppression'))
	AND
	TRIM(LOWER(d.libelle)) = TRIM(LOWER('type d''action'));


-- TRIGGER
    IF INSERTING THEN -- En cas de modification on insère les valeurs de la table TA_IC_LINEAIRE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_IC_LINEAIRE_LOG(GEOM, IDENTIFIANT_OBJET, FID_NUMERO_DOSSIER, FID_IDENTIFIANT_TYPE, FID_PNOM_ACTION, DATE_ACTION, FID_TYPE_ACTION)
            VALUES(
            		:new.GEOM,
					:new.objectid,
					:new.FID_NUMERO_DOSSIER,
					:new.FID_IDENTIFIANT_TYPE,
					USERNUMBER,
					SYSDATE,
					NUMBER_INSERTION
				);
    ELSE   

    IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_IC_LINEAIRE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_IC_LINEAIRE_LOG(GEOM, IDENTIFIANT_OBJET, FID_NUMERO_DOSSIER, FID_IDENTIFIANT_TYPE, FID_PNOM_ACTION, DATE_ACTION, FID_TYPE_ACTION)
            VALUES(
            		:old.GEOM,
					:old.objectid,
					:old.FID_NUMERO_DOSSIER,
					:old.FID_IDENTIFIANT_TYPE,
					USERNUMBER,
					SYSDATE,
					NUMBER_MODIFICATION
				);

	    END IF;
    END IF;  

    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_IC_LINEAIRE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_IC_LINEAIRE_LOG(GEOM, IDENTIFIANT_OBJET, FID_NUMERO_DOSSIER, FID_IDENTIFIANT_TYPE, FID_PNOM_ACTION, DATE_ACTION, FID_TYPE_ACTION)
            VALUES(
            		:old.GEOM,
					:old.objectid,
					:old.FID_NUMERO_DOSSIER,
					:old.FID_IDENTIFIANT_TYPE,
					USERNUMBER,
					SYSDATE,
					NUMBER_SUPPRESSION
				);
    END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('rjault@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.A_IUD_TA_IC_LINEAIRE_LOG','rjault@lillemetropole.fr');
END;

/
