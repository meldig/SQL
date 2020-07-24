#  Méthodologie pour l'intégration de la Base Permanente des Equipements:

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données issues de la Base Permanente des Equipements dans la base Oracle. Les requêtes ont été divisées dans 7 fichiers différents.
* creation_structure_bpe.sql: fichier regroupant les requêtes de création de la structure nécessaire à l'intégration des BPE.
* import_donnees_bpe.bat: fichier regroupant les commandes utilisés pour insérer les données brutes dans la base oracle
* insertion_nomenclature.sql: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature dans la base oracle
* normalisation_bpe.sql: fichier regroupant les instructions nécessaires à la normalisation des données BPE dans la base oracle
Auxquelles on peut ajouter 3 fichiers qui regroupent des requêtes pour générer des vues restituant les nomenclatures BPE ainsi que les données BPE:
* vue_libelle_variable_bpe.sql: vue restituant la nomenclature des variables BPE (COUVERT/ECLAIRE...)
* vue_libelle_equipement.sql: vue restituant la nomenclature des types d'equipement (A101, B101...)
* v_bpe_millesime.sql: vue restituant les données BPE

## Phasage:

1. Création des tables du schéma nécessaire à l'insertion des données BPE.
2. Insertion de la nomenclature propre aux BPE.
3. Import des données brutes dans le schéma via ogr2ogr.
	* 3 couches sont importées:
		* la couche BPE ensembles.
		* la couche BPE enseignement.
		* la couche BPE sport et loisir.
4. Suppression dans la couche BPE ensemble des équipements dont la valeur dans le champ "TYPEQU"  est aussi présent dans la couche BPE enseignement ou BPE sport et loisir.
5. Création d'une table synthétisant l'ensemble des informations contenues dans les trois tables des équipements.
	* Ajout d'une colonne identity dans la table précédemment créée pour affecter des identifiants uniques aux équipements.
	* Correction des codes IRIS.
	* Ajout des géométries sur les données sans géométrie calculé sur le centroide de l'IRIS si possible ou sinon la commune. Cela permet d'apporter une précision minimale sur la géolocalisée de toutes les BPE.
	* Mise à jour des metadonnés suivant la qualité XY des position géographique.
	* Ajout des métadonnées spatiales à la table.
6. Normalisation des données dans la table.


## Description du phasage:

### 1. Création des tables du schéma.

Pour accueillir les données BPE, 11 tables sont nécessaires:

#### 1.1. Description des tables spécialement créées

##### 1.1.1. TA_BPE

Table TA_BPE: Table regroupant les equipements de la Base Permanente des Equipements

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_BPE | objectid | Clé primaire de la table TA_BPE |
|| fid_metadonnee | Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée |
|| fid_geom | Clé étrangère vers la table TA_BPE_GEOM pour connaitre la position de l'équipement |

##### 1.1.2. TA_BPE_GEOM

La table TA_BPE_GEOM Table regroupant les positions que peuvent prendre les équipements de la Base Permanente des Equipements.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_BPE_GEOM | objectid | Identifiant de la position geographique. Clé primaire de la table TA_BPE_GEOM. |
|| geom | Position géographique que peuvent prendre les équipements. |

##### 1.1.3. TA_BPE_CARACTERISTIQUE

Table TA_BPE_CARACTERISTIQUE: Table de relation entre les équipements et les libellés pour connaitre les caractéristiques des équipements

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_BPE_CARACTERISTIQUE | objectid | clé primaire de la table TA_BPE_CARACTERISTIQUE |
|| fid_bpe | fid_bpe clé étrangère vers la table TA_BPE |
|| fid_libelle | Clé étrangère vers la table TA_LIBELLE pour connaitre la caracteristique de l'équipement |

##### 1.1.4. TA_BPE_CARACTERISTIQUE_NOMBRE

Table TA_BPE_CARACTERISTIQUE_NOMBRE: Table de relation entre les equipements et les libelles ou l'information est sous la forme d'un nombre et nom un libellé: exemple NB_SALLES: 4. L'équipement dispose de 4 salles.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_BPE_CARACTERISTIQUE_NOMBRE | objectid | clé primaire de la table TA_BPE_CARACTERISTIQUE_NOMBRE |
|| fid_bpe | fid_bpe clé étrangère vers la table TA_BPE |
|| fid_libelle | Clé étrangère vers la table TA_LIBELLE pour connaitre la caracteristique de l'équipement |
|| nombre | nombre de salles de théâtre par cinéma, théâtre ou nombre d'aires de pratique d'un même type au sein de l'équipement |

##### 1.1.5. TA_BPE_RELATION_CODE

Table TA_BPE_RELATION_CODE: Table regroupant les equipements de la Base Permanente des Equipements et leurs code d'INSEE et IRIS.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_BPE_RELATION_CODE | objectid | clé primaire de la table TA_BPE_CARACTERISTIQUE_NOMBRE |
|| fid_bpe | Clé primaire de la table TA_BPE pour connaitre l'identifiant de l'équipement BPE. |
|| fid_code | Clé étrangère vers la table TA_CODE pour connaitre les codes insee des communes ainsi que les codes IRIS des zones IRIS d'implantation de l'équipement |

#### 1.2. Description des tables déjà présentes dans le schéma et utilisées pour l'insertion d'autres données.

##### 1.2.1. TA_FAMILLE

La table TA_FAMILLE Table contenant les familles de libellés.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_FAMILLE | objectid | clé primaire de la table TA_FAMILLE |
|| valeur | Valeur de chaque famille de libellés |

##### 1.2.2. TA_FAMILLE_LIBELLE

La table TA_FAMILLE_LIBELLE est une table de relation qui met en correspondance les libelles et leurs famille.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_FAMILLE_LIBELLE | objectid | clé primaire de la table TA_FAMILLE_LIBELLE |
|| fid_famille | Identifiant de chaque famille de libellés. Clé étrangère vers la table TA_FAMILLE |
|| fid_libelle | Identifiant de chaque famille de libellés. Clé étrangère vers la table TA_LIBELLE_LONG |

##### 1.2.3. TA_LIBELLE_LONG

Table contenant les libellées longs utilisés dans la base pour définir un état.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_LIBELLE_LONG | objectid | Identifiant de chaque libelle long. Clé primaire de la table |
|| valeur | Valeur de chaque libellé définissant l'état d'un objet ou d'une action |

##### 1.2.3. TA_LIBELLE

Table attribuant des identifiants aux libelles. Cette table permet d'attribuer des identifiants à des mêmes libelles utilisés à des niveaux différents mais aussi utilisés par des variables différentes.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_LIBELLE | objectid | Identifiant de chaque libelle. Clé primaire de la table |
|| FID_LIBELLE_LONG | Clé étrangère vers la table TA_LIBELLE_LONG |

##### 1.2.4. TA_LIBELLE_COURT

Table regroupant les libellés courts utilisés par les données présentes dans le schéma. Par exemple A101 ou X.';

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_LIBELLE_COURT | objectid | Identifiant de chaque libelle court. Clé primaire de la table |
|| valeur | Valeur pouvant être prises par les attributs des données contenues dans le schéma. Exemple A101 ou 1 ou 0 ou x. |

##### 1.2.5. TA_RELATION_LIBELLE

Table qui sert à définir les relations entre les différents libellés de la nomenclature. Exemple A101/Police est un sous élément du libelle A1/Services Publics.X/Sans Objet peut être un sous élément de COUVERT/Equipement couvert ou non mais aussi de ECLAIRE/Equipement éclairé ou non.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_RELATION_LIBELLE | fid_libelle_fils | Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE pour connaitre le libellé fils |
|| fid_libelle_parent | Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE pour connaitre le libellé parent |

##### 1.2.6. TA_CORRESPONDANCE_LIBELLE

Table indiquant les correspondances entre les libellés et les libellés court: Exemple Police = A101 ou Sans objet = 'X'.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_CORRESPONDANCE_LIBELLE | fid_libelle | Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE |
|| fid_libelle_court | Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE_COURT |

### 2. Insertion de la nomenclature 

L'insertion de la nomenclature BPE s'effectue à partir des requètes contenues dans le fichier: insertion_nomenclature_bpe.sql. Celle-ci se fait en 2 étapes. Dans un premier temps, on insère les libelles liés au type d'équipement et dans un second temps les libelles liés aux variables.

#### 2.1. Insertion des libelles des types équipements

1. Insertion de la source dans TA_SOURCE.
2. Insertion de la provenance dans TA_PROVENANCE.
3. Insertion des données dans TA_DATE_ACQUISITION.
4. Insertion des données dans TA_ORGANISME.
5. Insertion des échelles dans TA_ECHELLE.
6. Insertion des données dans TA_METADONNEE.
7. Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME
8. Insertion des données dans la table TA_METADONNEE_RELATION_ECHELLE
9. Création de la vue bpe_nomenclature_liste pour simplifier son insertion.
10. Insertion des libelles courts dans TA_LIBELLE_COURT.
11. Insertion des libelles longs dans TA_LIBELLE_LONG.
12. Insertion de la famille 'BPE' dans la table TA_FAMILLE.
13. Insertion des relations familles-libelles dans TA_FAMILLE_LIBELLE.
14. Creation d'une vue des relations entre les libelles 'BPE' pour faciliter l'insertion des libelles.
15. creation de la table BPE_FUSION pour normaliser les données.
16. Insertion des données dans la table temporaire BPE_FUSION. Utilisation de la séquence de la table ta_libelle.
17. Insertion des 'objectid' et des 'fid_libelle_long' grâce à la table temporaire BPE_FUSION(voir 13., 14.).
18. Insertion des données dans ta_correspondance_libelle grâce à la table temporaire BPE_FUSION(voir 13., 14.).
19. Insertion des données dans ta_relation_libelle(hiérarchie des libelles comme par exemple A1(services publics > A101(police)) grâce à la table temporaire BPE_FUSION(voir 13., 14.)

#### 2.2. Insertion des libellés liés aux variables propres aux équipements enseignement et sportif

20. Ajout d'une colonne dans la table temporaire d'import des libelles pour ajouter les identifians des libelles de niveau 1 (COUVERT/ECLAIRE...).
21. Création et insertion des libelles et des identifiants à partir de la sequence de la table TA_LIBELLE dans une table temporaire pour pouvoir attribuer des identifiants unique à des libelles utilisés par plusieurs variables.
22. Insertion des identifiants unique dans la table temporaire fusion_bpe_variable pour attribuer les identifiants aux libelles en utilisant la séquence de la table TA_LIBELLE.
23. Insertion des identifiants de niveau 1 dans la table d'import des libelles.
24. Ajout de la colonne lo_2 dans la table temporaire d'import des libelles pour ajouter les identifiants unique aux libelles de niveau 2. Cela permet d'attibuer des identifiants différents à un même libelle utilisé par des états différents (exemple 'Sans objet').
25. Insertion des identifiants de niveau 2 en utilisant la séquence de la table TA_LIBELLE.
26. Création de la vue pour insérer les libelles longs et courts.
27. Insertion des libelles courts dans TA_LIBELLE_COURT.
28. Insertion des libelles longs dans TA_LIBELLE_LONG.
29. Insertion de la famille dans TA_FAMILLE.
30. Insertion des relations dans TA_FAMILLE_LIBELLE.
31. Insertion dans ta_libelle des libelles de niveau 1.
32. Insertion dans ta_libelle des libelles de niveau 2.
33. Insertion des correspondance dans la table TA_CORRESPONDANCE_LIBELLE.
34. Insertion des relations dans la table TA_RELATION_LIBELLE.
35. Insertion des relations entre les équipments et les codes INSEE et code IRIS des communes et zones IRIS d'implantation.
36. Suppression des données temporaires.

### 3. Normalisation des donnée

La normalisation des données se fait à partir des données présentes dans le fichier :normalisation_bpe.sql. Celle ci se fait en plusieurs étapes.

#### 3.1. Suppression des équipements présents dans la couche BPE ensemble et dans les couches BPE enseignement ou sport loisir.

Les trois couches BPE comportent des équipements en commun afin d'éviter des vrais doublons il faut supprimer les équipements présents dans la couche ensemble qui ont des types d'équipements qui sont présents dans les deux autres couches. En effet les informations contenues dans les couches 'enseignement' et 'sport loisir' sont plus exhaustives.

La couche BPE Enseignement ne regroupe que des équipements avec un code type équipement: TYPEQU C104, C101, C201, C301, C302, C503, C601, C105, C303, C305, C603, C402, C403, C501, C502, C602, C605, C609, C701, C102, C401, C509, C304, C409, C604, C702, C504, C505

La couche BPE Sport loisir ne regroupe que des équipements avec un code type équipement: TYPEQU F102, F111, F113, F116, F101, F103, F106, F107, F109, F112, F114, F117,F121, F303, F120, F108, F118, F203, F305, F306, F201, F119, F304, F110, F105, F202, F104.

Les equipements de la table BPE ensemble ayant un code présent dans l'une des ces deux listes seront supprimés.

#### 3.2 Création d'une table temporaire synthétique.

Afin de normaliser les données issues de la Base Permanente des Equipements une table synthétisant les informations est créée.
Plusieurs requêtes sont effectuées sur cette table afin de permettre de corriger des attributs.

##### 3.2.1. Ajout d'une colonne identite à la table synthétique.

Mise à jour de la colonne identite pour avoir des clé unique qui suivent l'incrémentation de la séquence de la table TA_BPE.

##### 3.2.2. Correction des codes IRIS pour mettre à jour la géométrie des BPE non géolocalisés.

Les codes IRIS sont en deux formats dans la base BPE:
* Alors que dans les données IRIS le format est sous forme INSEEIRIS, dans la table BPE les IRIS sont sous la forme INSEE_IRIS.
* De plus quand une commune n'est pas sub-divisée en IRIS alors dans les données IRIS son code est sous la forme INSEE0000,mais dans les données BPE il n'y a que son numéro INSEE
Une requête permet de corriger les codes IRIS dans la base BPE et de tout mettre en INSEEIRIS.

#### 3.2.3. Ajout de la colonne geom de type géométrique pour calculé les géométries des BPE

Les données BPE ne sont pas géolocalisées. Il faut donc calculer la géométrie à partir des colonnes X Y de la table.

#### 3.2.4. Calcul de la géométrie

Utilisation de la commande SDO_GEOM pour calculer la géométrie à partir des colonnes X Y de la table.

#### Ajout de la colonne fid_metadonnee.

ajout du fid_metadonnee correspondant.

#### 3.4 Normalisation des données.

A partir de cette table, plusieurs requêtes (présentes dans le fichier normalisation_bpe) sont executés pour insérer les données dans les tables:
3.4.1. TA_BPE_GEOM (requête 3):
	* Cette requête permet d'insérer dans la table TA_BPE_GEOM les géométries unique des BPE qui ne sont pas déja présente dans la table.
3.4.2. TA_BPE (requête 4):
	* Cette requête d'insérer dans la table TA_BPE, l'identifiant de l'équipement, son fid_metadonnées considéré au dernier millésime ainsi que son fid_geom pour connaitre sa position.
3.4.3. TA_BPE_CARACTERISTIQUE_NOMBRE (requête 5):
	* Deux requêtes sont à éxecuter car deux variables ont pour caractéristique d'attribuer un attribut numérique
		* NB_AIREJEU: Nombre d'aires de pratique d'un meme type au sein de l'equipement
		* NB_SALLES: nombre de salles par theatre ou cinema
3.4.4. TA_BPE_CARACTERISTIQUE (requête 6):
	* un total de 3 requêtes sont necessaires pour inserer les données liées aux variables:
		* la requetes 6.1 utilise la vue V_LIBELLE_EQUIPEMENT pour inserer les attibuts type equipement.
		* la requete 6.2, permet de creer une vue simplifiant l'insertion des attributs variables
		* la requete 6.3 permet d'insérer les BPEs concernés par les attributs de type variable.
			* CL_PELEM: présence ou absence d'une classe pre-élementaire en école primaire
			* CL_PGE: présence ou absence d'une clASse preparatoire aux grandes ecoles en lycee
			* EP: Appartenance ou non à un dispositif d'education prioritaire
			* INT: présence ou absence d'un internat
			* QUALITE XY: qualite d'attribution pour un equipement de ses coordonnees XY
			* RPIC: Presence ou absence d'un regroupement pedagogique intercommunal concentre
			* SECT: appartenance au secteur public ou prive d'enseignement
			* COUVERT: equipement couvert ou non
			* ECLAIRE: equipement couvert ou non

### 4. Suppression de la table sythétisant les informations des BPE et des metadonnées de celle-ci.

4.1. Suppression de la table synthétisant les données BPE.
4.2. Suppresion des metadonnées spatiales de la table synthétisant les données BPE.
4.3. Suppresion de la vue bpe_variable_normalisation.
4.5. Suppression de la vue bpe_variable_liste.