@echo off
echo Bienvenu dans l insertion des donnees des communes simples et associees en base !
:: Import des communes reçues de l'IGN en base.

:: Déclaration et valorisation des variables
SET /p chemin_insertion="Veuillez saisir le chemin d'acces du dossier contenant TOUTES les communes de TOUS les departements : "  
SET /p USER="Veuillez saisir l utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l instance Oracle :"     

:: 2. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.16\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

:: 5. Import des communes simples en base
ogr2ogr -f OCI -sql "SELECT INSEE_COM, INSEE_DEP, NOM FROM COMMUNE WHERE INSEE_DEP = '02'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\02\donnees\ADMINISTRATIF\COMMUNE.shp -nln TEMP_COMMUNES -nlt multipolygon -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, INSEE_DEP, NOM FROM COMMUNE WHERE INSEE_DEP = '59'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\59\donnees\ADMINISTRATIF\COMMUNE.shp -nln TEMP_COMMUNES -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, INSEE_DEP, NOM FROM COMMUNE WHERE INSEE_DEP = '60'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\60\donnees\ADMINISTRATIF\COMMUNE.shp -nln TEMP_COMMUNES -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, INSEE_DEP, NOM FROM COMMUNE WHERE INSEE_DEP = '62'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\62\donnees\ADMINISTRATIF\COMMUNE.shp -nln TEMP_COMMUNES -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, INSEE_DEP, NOM FROM COMMUNE WHERE INSEE_DEP = '80'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\80\donnees\ADMINISTRATIF\COMMUNE.shp -nln TEMP_COMMUNES -lco SRID=2154 -dim 2

:: 6. Import des communes associées/déléguées en base
ogr2ogr -f OCI -sql "SELECT INSEE_COM, NATURE, NOM FROM COMMUNE_ASSOCIEE_OU_DELEGUEE WHERE SUBSTR(INSEE_COM,0,2) = '02'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\02\donnees\ADMINISTRATIF\COMMUNE_ASSOCIEE_OU_DELEGUEE.shp -nln TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE -nlt multipolygon -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, NATURE, NOM FROM COMMUNE_ASSOCIEE_OU_DELEGUEE WHERE SUBSTR(INSEE_COM,0,2) = '59'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\59\donnees\ADMINISTRATIF\COMUNE_ASSOCIEE_OU_DELEGUEE.shp -nln TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, NATURE, NOM FROM COMMUNE_ASSOCIEE_OU_DELEGUEE WHERE SUBSTR(INSEE_COM,0,2) = '60'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\60\donnees\ADMINISTRATIF\COMMUNE_ASSOCIEE_OU_DELEGUEE.shp -nln TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, NATURE, NOM FROM COMMUNE_ASSOCIEE_OU_DELEGUEE WHERE SUBSTR(INSEE_COM,0,2) = '62'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\62\donnees\ADMINISTRATIF\COMMUNE_ASSOCIEE_OU_DELEGUEE.shp -nln TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append -sql "SELECT INSEE_COM, NATURE, NOM FROM COMMUNE_ASSOCIEE_OU_DELEGUEE WHERE SUBSTR(INSEE_COM,0,2) = '80'" OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\80\donnees\ADMINISTRATIF\COMMUNE_ASSOCIEE_OU_DELEGUEE.shp -nln TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE -lco SRID=2154 -dim 2

pause