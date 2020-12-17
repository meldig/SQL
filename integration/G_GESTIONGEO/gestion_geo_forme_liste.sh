#!/bin/bash
# Ce script à pour objectif:
# 1. de rajouter une colonne OBJECTID a la liste CSV générer par le scipt batch commande_liste.bat.
# 2. importer le tableau dans ORACLE avec oger2ogr.
# Ce script est appelé par le fichier gestion_geo_import_liste.bat afin de mettre en forme le fichier liste_fichier_gestiongeo_test_incremente.csv pour qu'il puisse etre importé par ogr2ogr dans la base Oracle
#/!\ il faut placer le script à l'endroit ou le fichier liste_fichier_gestiongeo_test.csv est créé. Autrement dans le repertoire indiqué par la variable CHEMIN du fichier gestion_geo_import_liste.bat.

# incrémente le fichier CSV.
awk -F";" '{$1=++i FS $1;}1' OFS=, liste_fichier_gestiongeo_test.csv > liste_fichier_gestiongeo_test_incremente.csv

# ajout des titres des colonnes dans la premiere ligne du fichier
awk 'BEGIN{print "OBJECTID;LIEN"}{print}' liste_fichier_gestiongeo_test_incremente.csv > liste_fichier_gestiongeo_test_incremente_colonne.csv