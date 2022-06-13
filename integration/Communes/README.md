# COMMUNES

Dossier contenant le code et la documentation concernant l'insertion des communes des différents millésimes de la BdTopo.

## Détails

* Documentation -> *maj_communes_nouveau_millesime_bdtopo.mdown* ;
* Import des communes dans une table temporaire en base -> *import_communes_en_base.bat* ;  

* Suppression des données des communes dans les tables correspondantes -> *suppression_donnees_communes.sql* ;
* Modification de l'index de la table d'import temporaire des communes -> *traitement_table_import_communes.sql* ;  

* Première insertion des communes et de leur nomenclature en base (le code est à améliorer) -> *insertion_des_communes_des_hauts_de_france.sql* ;
* Première insertion des municipalité belges et leur nomenclature. Le code n'est pas à jour et n'a jamais été passé en production -> *insertion_des_municipalites_belges.sql* ;

### Production

#### Les lanceurs de code (.bat) :
* Insertion des communes de la nouvelle BdTopo dans les tables correspondantes -> *lanceur_maj_communes_simples_nouvelle_bdtopo.bat* ;

#### Les codes sql :
* Insertion des communes simples dans les tables correspondantes -> maj_communes_simples_nouvelle_bdtopo.sql ;

### Test

#### Les lanceurs de code (.bat) :
* lanceur_creation_tables_test_communes.bat ;
* lanceur_insertion_tables_test_communes.bat ;

#### Les codes sql :
* creation_tables_test_communes.sql
* maj_communes_simples_nouvelle_bdtopo.sql
