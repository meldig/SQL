:: 1.  Deplacement de la commande dans le dossier de QGIS.
SET /p chemin_vm_admin="Veuillez saisir le chemin d'accès du dossier contenant les requêtes sql qui serviront à la création de la vue : "  
SET /p chemin_concatenation_sql="Veuillez saisir le chemin d'accès du dossier qui contiendra l'ensembre des requetes sql: "
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 1. Concatenation des fichiers SQL en un seul pour pour permettre l'execution des commandes par Oracle
type %chemin_vm_admin%\vm_admin_iris_structure.sql > %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql | echo. >> %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql ^
| type %chemin_vm_admin%\vm_admin_iris.sql >> %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql | echo. >> %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql ^
| type %chemin_vm_admin%\vm_admin_iris_suppression.sql >> %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql | echo. >> %chemin_concatenation_sql%\vue_materialisee_admin_iris.sql

:: 4. Lancement de SQL plus
CD C:/ora12c/R1/BIN

:: 5. Lancement des traitements sous sqlplus (clé primaire, indexes...)
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_concatenation_sql%\vue_materialisee_admin_iris.sql