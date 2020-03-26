::Methodologie pour l'insertion des données BPE dans la base

:: Import des données données BPE avec des commande OGR dans la base de données

:: couche BPE ensemble
ogr2ogr -f OCI OCI:IdentifianOracle C:\Users\Romain\Desktop\Programmation_cours\93_MEL\BPE_TEST\BPE_ENSEMBLE.shp -lco SRID=2154

:: BPE enseignement
ogr2ogr -f OCI OCI:IdentifianOracle C:\Users\Romain\Desktop\Programmation_cours\93_MEL\BPE_TEST\BPE_enseignement.shp -lco SRID=2154

:: couche BPE sport loiris
ogr2ogr -f OCI OCI:IdentifianOracle C:\Users\Romain\Desktop\Programmation_cours\93_MEL\BPE_TEST\BPE_SPORT_LOISIR.shp -lco SRID=2154