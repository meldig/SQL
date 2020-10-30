:: Fichier bat d'insertion des données du RPG sur le schéma CUDL

:: 1.  Deplacement de la commande dans le dossier de QGIS.
CD C:/Program Files/QGIS 3.10/bin

:: 2. Mise à jour de l'encodage en UTF-8.
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 3. Mise à jour de la variable PROJ_LIB pour indiquer le bon chemin vers le fichier proj.db
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 4. Import des donnees.
:: 4.1. rpg2019_mel.shp
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\rpg2019_mel.shp -nlt multipolygon -nln RPG_2019_MEL  -lco SRID=2154 -dim 2

:: 4.2. parcelles_instruites_2019_mel
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\parcelles_instruites_2019_mel.xlsx -nln RPG_PARCELLE_INSTRUITES_2019_MEL

:: 4.3. pacage_formejuridique_mel
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\pacage_formejuridique_mel.xlsx -nln RPG_PACAGE_FORMEJURIDIQUE_2019_MEL

:: 4.4. ilots2019_description
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\ilots2019_description.xlsx -nln RPG_ILOTS_DESCRIPTION_2019_MEL

:: 4.5. aides_2ndpilier
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\aides_2ndpilier.xlsx -nln RPG_AIDES_2ND_PILIER_2019_MEL

:: 4.6. aides_1erpilier
ogr2ogr.exe -f OCI OCI:USER/MDP@INSTANCE \\volt\infogeo\Donnees\Externe\DRAAF\RPG_2019\RPG\aides_1erpilier.xlsx -nln RPG_AIDES_1ER_PILIER_2019_MEL

:: 5. Lancement de SQL plus
CD C:/ora12c/R1/BIN

:: 6. Lancement des traitements sous sqlplus (clé primaire, indexes...)
sqlplus.exe USER/MDP@INSTANCE @C:\Users\rjault\Documents\06_TEST_IRIS_BAT\iris_temp.sql