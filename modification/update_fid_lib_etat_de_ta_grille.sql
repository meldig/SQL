/* Objectif : mettre à jour l'état d'avancement de la nouvelle grille par l'état d'avancement de l'ancienne grille et ce en fonction de la localisation -> mise à jour de tous les éléments de la grille compris dans un élément de la grille b avec le fid_lib_etat de l'élément de la grille b.

fid_thematique = 41 -> 'Vérification du bati issu du lidar et du plan de gestion' (valable pour la nouvelle grille 300*300)
fid_thematique = 61 -> 'grille en cours de transition' (valable pour l'ancienne grille 600*600)
*/


--OPERATION REALISEE EN DEUX TEMPS POUR LIMITER LA DUREE DU TRAITEMENT
--1. INITIALISATION DE LA VALEUR DE FID_LIB_ETAT A 1 POUR TOUTE LA GRILLE 300*300(FID_THEMATIQUE 41)

UPDATE ta_grille
SET FID_LIB_ETAT = 1
WHERE FID_THEMATIQUE = 41
;

--2. MISE A JOUR DE LA VALEUR SEULEMENT SUR LES CARREAUX DE LA GRILLE 300*300 CONTENUS DANS DES CARREAUX DE LA GRILLE 600*600(FID_THEMATIQUE 61) AYANT LE FID_LIB_ETAT A 3

UPDATE ta_grille a
SET a.FID_LIB_ETAT = 
	(SELECT b.fid_lib_etat
	FROM ta_grille b
	WHERE b.fid_thematique = 61
	AND b.fid_lib_etat = 3
	AND SDO_GEOM.RELATE(a.geom, 'coveredby', b.geom,0.05) = 'COVEREDBY')
WHERE 
    a.FID_THEMATIQUE = 41 
;