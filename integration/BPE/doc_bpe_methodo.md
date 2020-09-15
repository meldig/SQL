#  Méthodologie mise en place pour l'intégration de la Base Permanente des Equipements en base.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données issues de la Base Permanente des Equipements dans la base Oracle. Les requêtes ont été divisées dans 7 fichiers différents:
* <em>creation_structure_bpe.sql:</em> fichier regroupant les requêtes de création de la structure nécessaire à l'intégration des BPE.
* <em>import_donnees_bpe.bat:</em> fichier regroupant les commandes utilisées pour insérer les données brutes dans la base oracle.
* <em>insertion_nomenclature.sql:</em> fichier regroupant les instructions nécessaires à l'insertion de la nomenclature dans la base oracle.
* <em>normalisation_bpe.sql:</em> fichier regroupant les instructions nécessaires à la normalisation des données BPE dans la base oracle.
auxquelles on peut ajouter 3 fichiers qui regroupent des requêtes pour générer des vues restituant les nomenclatures BPE ainsi que les données BPE:
* <em>vue_libelle_variable_bpe.sql:</em> vue restituant la nomenclature des variables BPE (COUVERT/ECLAIRE...)
* <em>vue_libelle_equipement.sql:</em> vue restituant la nomenclature des types d'équipement (A101, B101...)
* <em>v_bpe_millesime.sql:</em> vue restituant les données BPE

## Phasage:

1. Création des tables du schéma nécessaire à l'insertion des données BPE.
2. Insertion de la nomenclature propre aux BPE.
3. Import des données brutes dans le schéma via ogr2ogr.
	* 3 couches sont importées:
		* la couche BPE ensemble.
		* la couche BPE enseignement.
		* la couche BPE sport et loisir.
4. Suppression dans la couche BPE ensemble des équipements dont la valeur dans le champ "TYPEQU"  est aussi présent dans la couche BPE enseignement ou BPE sport et loisir.
5. Création de la table <em>BPE_TOUT</em>, synthétisant l'ensemble des informations contenues dans les trois tables des équipements.
	* Ajout de la colonne *identite* dans la table <em>BPE_TOUT</em> pour créer un identifiant à chaque équipement. Pour cela nous utilisons la séquence de la colonne *objectid* de la table <em>TA_BPE</em> qui est de type *identity*. Cette méthode permet de créer pour chaque équipement de chaque millesime un identifiant unique. Dans les données brutes, les équipements n'ont pas d'identifiant unique.
	* Correction des codes IRIS.
	* Ajout des métadonnées spatiales à la table.
6. Normalisation des données dans le schéma.


## Description du phasage:

### 1. Création des tables du schéma.

Pour accueillir les données BPE, 11 tables sont utilisées:

#### 1.1. Description des tables spécialement créées

##### 1.1.1. TA_BPE

La table <em>TA_BPE</em> regroupe les equipements de la Base Permanente des Equipements.

|Colonne|Type|Description|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_BPE.|
|FID_METADONNEE|NUMBER|Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée.|

##### 1.1.2. TA_BPE_GEOM

La table <em>TA_BPE_GEOM</em> regroupe les positions géographiques des équipements de la Base Permanente des Equipements.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Identifiant de la position geographique. Clé primaire de la table TA_BPE_GEOM.|
|GEOM|SDO_GEOMETRY|Position géographique que peuvent prendre les équipements.|

##### 1.1.3. TA_BPE_CARACTERISTIQUE

La table <em>TA_BPE_CARACTERISTIQUE</em> est une table de relation entre les équipements et les libellés pour connaitre les caractéristiques des équipements

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|NUMBER|clé primaire de la table TA_BPE_CARACTERISTIQUE.|
|FID_BPE|NUMBER|fid_bpe clé étrangère vers la table TA_BPE.|
|FID_LIBELLE|NUMBER|Clé étrangère vers la table TA_LIBELLE pour connaitre la caracteristique de l'équipement.|

##### 1.1.4. TA_BPE_CARACTERISTIQUE_QUANTITATIVE

La table <em>TA_BPE_CARACTERISTIQUE_NOMBRE</em> est une table de relation entre les equipements et les libellés ou l'information est sous la forme d'un nombre et nom un libellé: exemple NB_SALLES: 4. L'équipement dispose de 4 salles.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table ta_bpe_caracteristique_quantitative.|
|FID_BPE|NUMBER|clé étrangère vers la table TA_BPE.|
|FID_LIBELLE|NUMBER|Clé étrangère vers la table TA_LIBELLE pour connaitre la caracteristique de l'équipement.|
|NOMBRE|NUMBER|nombre de salles par cinéma ou théâtre ou nombre d'aires de pratique d'un même type au sein de l'équipement.|

##### 1.1.5. TA_BPE_RELATION_CODE

La table <em>TA_BPE_RELATION_CODE</em> est une table de relation entre <em>TA_BPE</em> et <em>TA_CODE</em> regroupant les equipements de la Base Permanente des Equipements et le code INSEE et IRIS d'implantation.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|FID_BPE|NUMBER|Clé primaire de la table TA_BPE pour connaitre l'identifiant de l'équipement BPE.|
|FID_CODE|NUMBER|Clé étrangère vers la table TA_CODE pour connaitre les codes insee des communes ainsi que les codes IRIS des zones IRIS d'implantation de l'équipement.|

#### 1.2. Description des tables déjà présentes dans le schéma et utilisées pour l'insertion d'autres données.

Pour insérer les données BPE dans la base, plusieurs tables déjà présente dans le schéma sont nécessaires.

* <em>TA_FAMILLE:</em> Pour inserer la classe des libellés.
* <em>TA_FAMILLE_LIBELLE:</em> Table de relation entre la classe des libellés et les libellés.
* <em>TA_LIBELLE_LONG:</em> Table qui regroupe les libellés qui caractérisent les objects contenus dans la base.
* <em>TA_LIBELLE:</em> Cette table permet d'attribuer des identifiants à des mêmes libellés utilisés à des niveaux différents mais aussi utilisés par des variables différentes.
* <em>TA_LIBELLE_COURT:</em> Table regroupant les libellés courts utilisés par les données présentes dans le schéma. Par exemple A101 ou X.'
* <em>TA_RELATION_LIBELLE:</em> Table qui sert à définir les relations entre les différents libellés de la nomenclature. Exemple A101/Police est un sous élément du libelle A1/Services Publics.X/Sans Objet peut être un sous élément de COUVERT/Equipement couvert ou non mais aussi de ECLAIRE/Equipement éclairé ou non.
* <em>TA_CORRESPONDANCE_LIBELLE:</em> Table indiquant les correspondances entre les libellés et les libellés court: Exemple Police = A101 ou Sans objet = 'X'.

#### 1.3. Exemple d'insertion d'un équipement dans la base.

Prenons par exemple un equipement présent dans la Base Permanente des Equipements:
| REG | DEP | DEPCOM | DCIRIS | AN | TYPEQU | COUVERT | ECLAIRE | LAMBERT_X | LAMBERT_Y | QUALITE_XY | NB_AIREJEU | NB_SALLES|
|:----|:----|:-------|:-------|:---|:-------|:--------|:--------|:----------|:----------|:-----------|:-----------|:----------
|84|1|01004|01004_0201|2018|F303|X|X|882471.95|6542895.51|Bonne|0|3|

Les données issues des colonnes REG et DEP ne sont pas insérer en base car ces informations peuvent être retrouvé grâce aux informations déjà présentes en base et à la position géométrique de l'équipement. Les valeurs dans les colonnes LAMBERT_X et LAMBERT_Y non plus.
Les codes IRIS et INSEE sont préalablement insérés dans la table TA_CODE. 
![exemple de normalisation d'un equipement](\exemple_normalisation_bpe.png)


### 2. Insertion de la nomenclature 

L'insertion de la nomenclature BPE s'effectue à partir des requêtes contenues dans le fichier: <em>insertion_nomenclature_bpe.sql</em>. Celle-ci se fait en 2 étapes: 
* Dans un premier temps, on insère les libellés liés au type d'équipement(POLICE/TRIBUNAL)
* dans un second temps les libellés liés aux variables des équipements de type enseignement et sport et loisir initialement contenu dans les tables(COUVERT/ECLAIRE...):
	* BPE enseignement.
	* BPE sport et loisir.

#### 2.1. Insertion de la nomenclature des BPE

1. Insertion de la source dans <em>TA_SOURCE</em>.
2. Insertion de la provenance dans <em>TA_PROVENANCE</em>.
3. Insertion des données dans <em>TA_DATE_ACQUISITION</em>.
4. Insertion des données dans <em>TA_ORGANISME</em>.
5. Insertion des échelles dans <em>TA_ECHELLE</em>.
6. Insertion des données dans <em>TA_METADONNEE</em>.
7. Insertion des données dans la table <em>TA_METADONNEE_RELATION_ORGANISME</em>.
8. Insertion des données dans la table <em>TA_METADONNEE_RELATION_ECHELLE</em>
9. Création de la vue <em>bpe_nomenclature_liste</em> pour simplifier son insertion. grâce à cette requete nous mettons la nomenclature sous la forme de trois colonne:
* libellés court.
* libellés long.
* et son niveau.
Cela permet de plus facilement insérer la nomenclature dans la base avec des requetes simple de type 'SELECT DISTINCT' pour le reste de l'insertion.
10. Insertion des libellés courts dans <em>TA_LIBELLE_COURT</em>.
11. Insertion des libellés longs dans <em>TA_LIBELLE_LONG</em>.
12. Insertion de la famille 'BPE' dans la table <em>TA_FAMILLE</em>.
13. Insertion des relations familles-libellés dans <em>TA_FAMILLE_LIBELLE</em>.
14. Creation d'une vue des relations entre les libellés 'BPE' pour faciliter l'insertion des libellés.
15. creation de la table <em>BPE_FUSION</em> pour normaliser les données.
16. Insertion des données dans la table temporaire <em>BPE_FUSION</em>. Utilisation de la séquence de la table <em>TA_LIBELLE</em>.
17. Insertion des 'objectid' et des 'fid_libelle_long' grâce à la table temporaire <em>BPE_FUSION</em>(voir 13., 14.).
18. Insertion des données dans <em>TA_LIBELLE_CORRESPONDANCE</em> grâce à la table temporaire <em>BPE_FUSION</em>(voir 13., 14.).
19. Insertion des données dans <em>TA_LIBELLE_RELATION</em> (hiérarchie des libellés comme par exemple A1(services publics > A101(police)) grâce à la table temporaire <em>BPE_FUSION</em>(voir 13., 14.)

#### 2.2. Insertion des libellés liés aux variables propres aux équipements enseignement et sportif

20. Ajout d'une colonne dans la table temporaire d'import des libellés pour ajouter les identifians des libellés de niveau 1 (COUVERT/ECLAIRE...).
21. Création et insertion des libellés et des identifiants à partir de la sequence de la table <em>TA_LIBELLE</em> dans une table temporaire pour pouvoir attribuer des identifiants uniques à des libellés utilisés par plusieurs variables (le libellés *Sans object* utilisé par les variables COUVERT ou ECLAIRE par exemple).
22. Insertion des identifiants uniques dans la table temporaire <em>FUSION_BPE_VARIABLE</em> pour attribuer les identifiants aux libellés en utilisant la séquence de la table <em>TA_LIBELLE</em>.
23. Insertion des identifiants de niveau 1 dans la table d'import des libellés.
24. Ajout de la colonne lo_2 dans la table temporaire d'import des libellés pour ajouter les identifiants uniques aux libellés de niveau 2. Cela permet d'attibuer des identifiants différents à un même libelle utilisé par des états différents (exemple *Sans objet*).
25. Insertion des identifiants de niveau 2 en utilisant la séquence de la table <em>TA_LIBELLE</em>.
26. Création de la vue <em>BPE_VARIABLE_LISTE</em> pour insérer les libellés longs et courts.
27. Insertion des libellés courts dans <em>TA_LIBELLE_COURT</em>.
28. Insertion des libellés longs dans <em>TA_LIBELLE_LONG</em>.
29. Insertion de la famille dans <em>TA_FAMILLE</em>.
30. Insertion des relations dans <em>TA_FAMILLE_LIBELLE</em>.
31. Insertion dans <em>TA_LIBELLE</em> des libellés de niveau 1.
32. Insertion dans <em>TA_LIBELLE</em> des libellés de niveau 2.
33. Insertion des correspondance dans la table <em>TA_CORRESPONDANCE_LIBELLE</em>.
34. Insertion des relations dans la table <em>TA_RELATION_LIBELLE</em>(voir 1.2.).
35. Insertion des relations entre les équipments et les codes INSEE et code IRIS des communes et zones IRIS d'implantation.
36. Suppression des tables temporaires non utiles à la normalisation des données BPE:
* BPE_NOMCLATURE_LISTE
* BPE_REALTION
* BPE_FUSION
* FUSION_BPE_VARIABLE
* BPE_NOMENCLATURE
* BPE_VARIABLE

### 3. Normalisation des donnée

La normalisation des données se fait à partir des requêtes présentes dans le fichier :<em>normalisation_bpe.sql</em>. Celle-ci se fait en plusieurs étapes.

#### 3.1. Suppression des équipements présents dans la couche BPE ensemble et dans les couches BPE enseignement ou sport loisir.

Les trois couches BPE comportent des équipements en commun afin d'éviter des vrais doublons il faut supprimer les équipements présents dans la couche ensemble qui ont des types d'équipement qui sont présents dans les deux autres couches. En effet les informations contenues dans les couches *enseignement* et *sport loisir* sont plus exhaustives.

La couche BPE Enseignement ne regroupe que des équipements avec un code type équipement: TYPEQU C104, C101, C201, C301, C302, C503, C601, C105, C303, C305, C603, C402, C403, C501, C502, C602, C605, C609, C701, C102, C401, C509, C304, C409, C604, C702, C504, C505

La couche BPE Sport loisir ne regroupe que des équipements avec un code type équipement: TYPEQU F102, F111, F113, F116, F101, F103, F106, F107, F109, F112, F114, F117,F121, F303, F120, F108, F118, F203, F305, F306, F201, F119, F304, F110, F105, F202, F104.

Les équipements de la table BPE ensemble ayant un code présent dans l'une de ces deux listes seront supprimés.

#### 3.2 Création d'une table temporaire synthétique.

Afin de normaliser les données issues de la Base Permanente des Equipements une table synthétisant les informations est créée, nommé <em>BPE_TOUT</em>.
Plusieurs requêtes sont effectuées sur cette table afin de permettre de corriger des attributs.

##### 3.2.1. Ajout d'une colonne identite à la table BPE_TOUT.

Mise à jour de la colonne *identite* pour avoir des clés uniques qui suivent l'incrémentation de la séquence de la table <em>TA_BPE</em>.

##### 3.2.2. Correction des codes IRIS pour mettre à jour la géométrie des BPE non géolocalisés.

Les codes IRIS sont en deux formats dans la base BPE:
* Alors que dans les données IRIS le format est sous forme INSEEIRIS, dans la table BPE les IRIS sont sous la forme INSEE_IRIS.
* De plus quand une commune n'est pas subdivisée en IRIS, son code est sous la forme INSEE0000, mais dans les données BPE celui-ci est alors égale à son code INSEE.
Une requête permet de corriger les codes IRIS dans la base BPE et de tout mettre au format INSEEIRIS.

#### 3.2.3. Ajout de la colonne geom de type géométrique pour calculé les géométries des BPE

Les données BPE ne sont pas géolocalisées. Il faut donc calculer la géométrie à partir des colonnes *LAMBERT_X* et *LAMBERT_Y* de la table.

#### 3.2.4. Calcul de la géométrie

Utilisation de la commande SDO_GEOMETRY, SDO_POINT pour calculer la géométrie des BPE.

    SDO_GEOMETRY
            (
            2001,
            2154,
            SDO_POINT_TYPE(LAMBERT_X, LAMBERT_Y, NULL),
            NULL,
            NULL
            )

#### Ajout de la colonne fid_metadonnee.

Ajout du *fid_metadonnee* correspondant.

#### 3.4 Normalisation des données.

A partir de la table <em>BPE_TOUT</em>, plusieurs requêtes (présentes dans le fichier <em>normalisation_bpe.sql</em>) sont executées pour insérer les données dans les tables:
* 3.4.1. <em>TA_BPE_GEOM</em> (requête 3):
	* Cette requête permet d'insérer dans la table <em>TA_BPE_GEOM</em> les géométries uniques des BPE qui ne sont pas déja présentes dans la table.
* 3.4.2. <em>TA_BPE</em> (requête 4):
	* Cette requête permet d'insérer dans la table <em>TA_BPE</em>, l'identifiant de l'équipement et son fid_metadonnées considéré au dernier millésime inséré dans la base.
* 3.4.3. <em>TA_BPE_CARACTERISTIQUE_QUANTITATIVE</em> (requête 6):
	* Deux requêtes sont à éxecuter car deux variables ont pour caractéristique d'attribuer un attribut numérique
		* NB_AIREJEU: Nombre d'aires de pratique d'un meme type d'activité au sein de l'equipement
		* NB_SALLES: nombre de salles par theatre ou cinema
* 3.4.4. <em>TA_BPE_CARACTERISTIQUE</em> (requête 7):
	* un total de 3 requêtes sont necessaires pour inserer les données liées aux variables:
		* la requetes 6.1 utilise la vue <em>V_NOMENCLATURE_EQUIPEMENT_BPE</em> pour inserer les attibuts type equipement.
		* la requete 7.2, permet de creer la vue <em>BPE_VARIABLE_NOMENCLATURE</em>, simplifiant l'insertion des attributs variables.
		* la requete 7.3 permet d'insérer les BPEs concernés par les attributs de type variable.
			* CL_PELEM: présence ou absence d'une classe pre-élementaire en école primaire.
			* CL_PGE: présence ou absence d'une classe preparatoire aux grandes ecoles en lycee.
			* EP: Appartenance ou non à un dispositif d'education prioritaire.
			* INT: présence ou absence d'un internat.
			* QUALITE XY: qualite d'attribution pour un equipement de ses coordonnees XY.
			* RPIC: Presence ou absence d'un regroupement pedagogique intercommunal concentre.
			* SECT: appartenance au secteur public ou prive d'enseignement.
			* COUVERT: equipement couvert ou non.
			* ECLAIRE: equipement couvert ou non.
* 3.4.5. <em>TA_BPE_RELATION_CODE</em>
	* Deux requêtes dont utilisées pour insérer les relations entre les équipements et les codes des communes et des zones IRIS d'implantation.
		* La premiere requête (9.1) permet de mettre en relation l'équipement avec sa commune d'implantation,
		* la deuxième (9.2) permet de mettre en relation l'équipement avec sa zone IRIS d'implantation.

### 4. Suppression de la table sythétisant les informations des BPE et des metadonnées de celle-ci.

* 4.1. Suppression de la table synthétisant les données BPE, <em>BPE_TOUT</em>.
* 4.2. Suppresion des metadonnées spatiales de la table synthétisant les données BPE.
* 4.3. Suppresion de la vue <em>BPE_VARIABLE_NORMALISATION</em>.
* 4.5. Suppression de la vue <em>BPE_VARIABLE_LISTE</em>.