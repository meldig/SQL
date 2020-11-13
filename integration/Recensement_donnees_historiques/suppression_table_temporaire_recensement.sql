/*
Fichier SQL regroupant les requetes nécessaire à la suppression des tables temporaire.
a excuter après une étape de vérifications de l'intégrité des données
*/

-- 1. Suppression de la table contenant les données brutes des données historique du recensement
DROP TABLE G_GEO.TEMP_RECENSEMENT CASCADE CONSTRAINTS;