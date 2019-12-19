/* Objectif : mettre à jour l'état d'avancement de la nouvelle grille par l'état d'avancement de l'ancienne grille et ce en fonction de la localisation -> mise à jour de tous les éléments de la grille compris dans un élément de la grille b avec le fid_lib_etat de l'élément de la grille b.

fid_thematique = 41 -> 'Vérification du bati issu du lidar et du plan de gestion' (valable pour la nouvelle grille 300*300)
fid_thematique = 61 -> 'grille en cours de transition' (valable pour l'ancienne grille 600*600)
*/

UPDATE ta_grille a
SET a.FID_LIB_ETAT = (SELECT b.fid_lib_etat FROM ta_grille b WHERE b.fid_thematique = 61 AND SDO_COVEREDBY (a.GEOM, b.GEOM) = 'TRUE')
WHERE 
    a.FID_THEMATIQUE = 41 
;

/*
Problème : cette requête permettrait la mise à jour sauf que lorsque je l'ai testée, j'obtiens le message d'erreur suivant : 

UPDATE ta_grille a
SET a.FID_LIB_ETAT = (SELECT b.fid_lib_etat FROM ta_grille b WHERE b.objectid = 7376 AND SDO_COVEREDBY (a.GEOM, b.GEOM) = 'TRUE')
WHERE 
    a.FID_THEMATIQUE = 41
Rapport d'erreur -
ORA-13226: interface non prise en charge sans index spatial
ORA-06512: à "MDSYS.MD", ligne 1723
ORA-06512: à "MDSYS.MDERR", ligne 8
ORA-06512: à "MDSYS.SDO_3GL", ligne 88
ORA-06512: à "MDSYS.SDO_3GL", ligne 643

*/