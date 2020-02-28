/* Objectif : mettre à jour l'état d'avancement de la nouvelle grille par l'état d'avancement de l'ancienne grille et ce en fonction de la localisation -> mise à jour de tous les éléments de la grille compris dans un élément de la grille b avec le fid_lib_etat de l'élément de la grille b.

fid_thematique = 41 -> 'Vérification du bati issu du lidar et du plan de gestion' (valable pour la nouvelle grille 300*300)
fid_thematique = 61 -> 'grille en cours de transition' (valable pour l'ancienne grille 600*600)
*/

/*
OPERATION REALISEE EN DEUX TEMPS POUR LIMITER LA DUREE DU TRAITEMENT
INITIALISE DE LA VALEUR DE FID_LIB_ETAT A 1 POUR TOUTE LA GRILLE 300*300
*/

UPDATE ta_grille
SET FID_LIB_ETAT = 1
WHERE FID_THEMATIQUE = 41
;

/*
MISE A JOUR DE LA VALEUR SEULEMENT SUR LES CARREAUX DE LA GRILLE 300*300 CONTENUS DANS DES CARREAUX DE LA GRILLE 600*600 AYANT LE FID_LIB_ETAT A 3
*/

UPDATE ta_grille a
SET a.FID_LIB_ETAT = (SELECT b.fid_lib_etat FROM ta_grille b WHERE b.fid_thematique = 61 AND b.fid_lib_etat = 3 AND SDO_GEOM.RELATE(a.geom, 'coveredby', b.geom,0.05) = 'COVEREDBY')
WHERE 
    a.FID_THEMATIQUE = 41 
;

/*
ANCIENNE REQUETTE ET ERREUR

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