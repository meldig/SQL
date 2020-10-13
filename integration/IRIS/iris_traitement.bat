::commande pour importer les données IRIS sur Oracle.
:: 1. indiquer le chemin d'emplacement des fichiers SQL
SET /p chemin=indiquez le repertoire de travail sans le dernier '\':

:: 2. Concatenation des fichiers SQL en un seul pour pour permettre l'execution des commandes par Oracle
type %chemin%\format_date.sql > iris_temp.sql | echo. >> iris_temp.sql ^
| type %chemin%\iris_structure.sql >> iris_temp.sql | echo. >> iris_temp.sql ^
| type %chemin%\iris_nomenclature.sql >> iris_temp.sql | echo. >> iris_temp.sql ^
| type %chemin%\iris_normalisation.sql >> iris_temp.sql | echo. >> iris_temp.sql


:: 3.. Deplacement de la commande dans le dossier de QGIS.
CD C:/Program Files/QGIS 3.10/bin

:: 4. Mise à jour de l'encodage en UTF-8.
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 5. Mise à jour de la variable PROJ_LIB pour indiquer le bon chemin vers le fichier proj.db
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 6. Import des données dans le schema.
:: ne pas oublier de changer les paramètre de connexion
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\IGN\IRIS\2019\CONTOURS_IRIS.shp -nlt multipolygon -nln CONTOURS_IRIS -lco SRID=2154 -dim 2

:: 5. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 6. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe USER/MDP@INSTANCE @C:\Users\rjault\Documents\06_TEST_IRIS_BAT\iris_temp.sql
