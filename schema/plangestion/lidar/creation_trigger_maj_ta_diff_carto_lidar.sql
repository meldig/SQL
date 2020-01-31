/*
	Objectif du trigger : à chaque fois qu'un élément de la grille (Vérification du bati issu du lidar et du plan de gestion) est mis en "terminé", alors le statut de tous les objets bâtis issus soit du lidar, soit du plan de gestion passent en "terminé" également.

*/

CREATE OR REPLACE TRIGGER maj_ta_diff_carto_lidar
AFTER UPDATE ON TA_GRILLE
FOR EACH ROW

BEGIN
	-- Si l'élément de la grille est tagué en "terminé" (fid_lib_etat) et s'il s'agit d'un élément appartenant à la grille qui nous intéresse (fid_thematique) alors...
    IF :new.fid_lib_etat = '3' AND :new.fid_thematique = '41' THEN
       -- Tous les objets bâtis se trouvant à l'intérieur de l'élément de la grille voient leur statut passer à '1', c'est-à-dire "traité".
       UPDATE GEO.ta_diff_carto_lidar a
       SET a.STATUT = 1
       WHERE
            SDO_ANYINTERACT(a.geom, :new.geom) = 'TRUE';
    END IF;
    
        EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail(
            'geotrigger@lillemetropole.fr',
            SQLERRM,'ERREUR TRIGGER ta_diff_carto_lidar',
            'bjacq@lillemetropole.fr', 'sysdig@lillemetropole.fr'
        );
END;