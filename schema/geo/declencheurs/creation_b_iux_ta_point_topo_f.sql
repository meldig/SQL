/*
    B_IUX_TA_POINT_TOPO_F : Création du déclencheur B_IUX_TA_POINT_TOPO_F permettant d'associer l'ID_DOS du dossier à chaque objet qui le compose
*/

CREATE OR REPLACE TRIGGER B_IUX_TA_POINT_TOPO_F
AFTER INSERT ON GEO.TA_POINT_TOPO_F
FOR EACH ROW
DECLARE
    v_id_dos NUMBER(38,0);

BEGIN
    /*
        Objectif : ce trigger permet d'associer l'identifiant d'un dossier à chaque objet qui le compose et ce à partir du champ GEO_REF 
        de la table TA_LIG_TOPO_GPS qui se compose de la concaténation des préfixes "REC_" ou "IC_" et de l'identifiant du dossier.
    */
    IF INSERTING THEN
        -- Sélection de l'id_dos
        SELECT
            CAST(
                SUBSTR(
                        a.GEO_REF, 
                        INSTR(a.GEO_REF, '_') +1, 
                        LENGTH(a.GEO_REF)
                ) 
                AS NUMBER
            ) INTO v_id_dos
        FROM
            GEO.TA_POINT_TOPO_GPS a
        WHERE
            a.objectid = :new.objectid;

        -- Insertion de l'id_dos dans TA_POINT_TOPO_F
        :new.id_dos := v_id_dos;
        
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_POINT_TOPO_F','bjacq@lillemetropole.fr');
END;

/

