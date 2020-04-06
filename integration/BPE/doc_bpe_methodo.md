#  Méthodologie pour l'intégration de la Base Permanente des Equipements:

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données issues de la Base Permanente des Equipements dans la base Oracle. Les codes ont été divisé dans 4 fichiers différents.
* creation_structure_bpe.sql: fichier regroupant les requêtes de création de la structure nécessaire à l'intégration des BPE.
* import_donnees_bpe.bat: fichier regroupant les commandes utilisés pour insérer les données brutes dans la base oracle
* insertion_nomenclature.sql: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature dans la base oracle
* normalisation_bpe.sql: fichier regroupant les instructions nécessaires à la normalisation des données BPE dans la base oracle

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
	* Ajout des métadonnées spatiales à la table.
6. Normalisation des données dans la table.


## Description du phasage:

### 1. Création des tables du schéma.

Pour accueillir les données BPE, 8 tables sont nécessaires:

#### 1.1. Description des tables nécessaire à l'acceuil des données BPE.

##### 1.2.1. Description des tables spécialement créées

* Table TA_BPE: Table regroupant les equipements de la Base Permanente des Equipements
	* colonne objectid: Identifiant du BPE, clé primaire de la table TA_BPE
	* colonne fid_metadonnee: Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée

* Table TA_BPE_GEOM: Table regroupant les positions que peuvent prendre les équipements de la Base Permanente des Equipements';
	* colonne objectid: Identifiant de la position.
	* colonne geom: Position géographique que peuvent prendre les équipements.

* Table TA_BPE_RELATION_GEOM: Table de liaison entre les équipements et leurs géométries
	* colonne fid_bpe: clé étrangère vers la table TA_BPE. Composante de la clé primaire.
	* colonne fid_bpe_geom: clé étrangère vers la table TA_BPE_GEOM. Composante de la clé primaire.

* Table TA_BPE_CARACTERISTIQUE: Table de relation entre les équipements et les libellés pour connaitre les caractéristiques des équipements
	* colonnes: objectid clé primaire de la table TA_BPE_CARACTERISTIQUE.
	* colonnes: fid_bpe clé étrangère vers la table TA_BPE.
	* colonnes: fid_libelle_fils clé étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l'équipement.
	* colonnes: fid_libelle_parent clé étrangère vers la table TA_LIBELLE pour connaitre la caractéristique parente de l'équipement.

* Table TA_BPE_CARACTERISTIQUE_NOMBRE: Table de relation entre les equipements et les libelles ou l'information est sous la forme d'un nombre et nom un libellé: exemple NB_SALLES: 4. L'équipement dispose de 4 salles.
	* colonne objectid: Clé primaire de la table TA_BPE_CARACTERISTIQUE_NOMBRE.
	* colonne fid_bpe: Clé étrangère vers la table TA_BPE pour connaitre l'équipement concerné.
	* colonne fid_libelle: Clé étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l'équipement.
	* colonne nombre: nombre de salles de théâtre par cinéma, théâtre ou nombre d'aires de pratique d'un même type au sein de l'équipement.

* Table TA_BPE_RELATION_CODE: Table de relation qui permet de connaitre l'IRIS et/ou la commune d'implantation du BPE. Nécessaire car certains BPE ne sont pas géolocalisés.
	* colonne fid_bpe: Clé étrangère vers la table TA_BPE. Composante de la clé primaire
	* colonne fid_code: Clé étrangère vers la table TA_CODE pour connaitre la commune ou IRIS d'implantation. Composante de la clé primaire

##### 1.2.2. Description des tables déjà présentes dans le schéma et utilisées pour l'insertion d'autres données.

* Table TA_FAMILLE Table contenant les familles de libellés.
	* colonne objectid: Identifiant de chaque famille de libellés.
	* colonne famille: Valeur de chaque famille de libellés.

* Table TA_FAMILLE_LIBELLE: Table contenant les identifiant des tables TA_LIBELLE et TA_FAMILLE, permettant de joindre le libellé à sa famille de libellés.
	* colonne objectid: Identifiant de chaque ligne.
	* colonne fid_famille: Identifiant de chaque famille de libellés. Clé étrangère vers la table TA_FAMILLE.
	* colonne fid_libelle: Identifiant de chaque libellés. Clé étrangère vers la table TA_LIBELLE.

* Table TA_LIBELLE_COURT: Table regroupant les libellés courts utilisés par les données présentes dans le schéma. Par exemple A101 ou X.';
	* colonne objectid: Clé primaire de la table TA_BPE_LIBELLE_COURT.
	* colonne libelle_court: Valeur pouvant être prises par les attributs des données contenues dans le schéma. Exemple A101 ou 1 ou 0 ou x.';

* Table TA_LIBELLE: Table contenant les libellés utilisés dans la base pour définir un état.
	* colonne objectid: Identifiant de chaque libellé. Clé primaire de la table.
	* colonne libelle: Valeur de chaque libellé définissant l'état d'un objet ou d'une action.

* Table TA_RELATION_LIBELLE: Table qui sert à définir les relations entre les différents libellés de la nomenclature. Exemple A101/Police est un sous élément du libelle A1/Services Publics.X/Sans Objet peut être un sous élément de COUVERT/Equipement couvert ou non mais aussi de ECLAIRE/Equipement éclairé ou non.
	* fid_libelle_fils: Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE pour connaitre le libellé fils.
	* fid_libelle_parent: Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE pour connaitre le libellé parent.

* Table TA_CORRESPONDANCE_LIBELLE: Table indiquant les correspondances entre les libellés et les libellés court: Exemple Police = A101 ou Sans objet = 'X'.
	* colonne fid_libelle: Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE
	* colonne fid_libelle_court: Composante de la clé primaire. clé étrangère vers la table TA_LIBELLE_COURT.

### 2. Insertion de la nomenclature 

L'insertion de la nomenclature BPE se fait à partir des requètes contenues dans le fichier: insertion_nomenclature_bpe.sql. Celle-ci se fait en 6 étapes:
2.1. La première étape consiste à insérer les données dans la table TA_LIBELLE_COURT.
2.2. Ensuite il faut insérer les données dans la table TA_LIBELLE.
2.3. Etablir la correspondance entre les libellés courts et les libellés avec la table TA_CORRESPONDANCE_LIBELLE, car un libellé court peut avoir plusieurs signification
2.4. Définir la relation hiérarchique entre les libellés, car il existe des niveaux entre les libellés utilisé dans la nomenclature BPE. Mais aussi car un libellés peut avoir plusieurs significations suivant sa variables. Par exemple 0 peut signifier équipement non couvert ou équipement non éclairé.
2.5. Insertion de la valeur BPE dans la table TA_FAMILLE.
2.6. Insertion des correspondance famille-libelle dans la table TA_FAMILLE_LIBELLE.

### 3. Normalisation des donnée

La normalisation des données se fait à partir des données présentes dans le fichier :normalisation_bpe.sql. Celle ci se fait en plusieurs étapes.

#### 3.1. Suppression des équipements présents dans la couche BPE ensemble et dans les couches BPE enseignement ou sport loisir.

Les trois couches BPE comportent des équipements en commun afin d'éviter des vrais doublons il faut supprimer les équipements présents dans la couche ensemble qui ont des types d'équipements qui sont présents dans les deux autres couches. En effet les informations contenues dans les couches 'enseignement' et 'sport loisir' sont plus exhaustives.

La couche BPE Enseignement ne regroupe que des équipements avec un code type équipement: TYPEQU C104, C101, C201, C301, C302, C503, C601, C105, C303, C305, C603, C402, C403, C501, C502, C602, C605, C609, C701, C102, C401, C509, C304, C409, C604, C702, C504, C505

La couche BPE Sport loisir ne regroupe que des équipements avec un code type équipement: TYPEQU F102, F111, F113, F116, F101, F103, F106, F107, F109, F112, F114, F117,F121, F303, F120, F108, F118, F203, F305, F306, F201, F119, F304, F110, F105, F202, F104.

Les equipements de la table BPE ensemble ayant un code présent dans l'une des ces deux listes seront supprimés.

#### 3.2 Création d'une table temporaire synthétique.

Afin de normaliser les données issues de la Base Permanente des Equipements une table synthétisant les informations est créée. Cette table permet aussi d'insérer un identifiant unique à chaque équipement. Cette clé est défini pour l'insertion des prochaines données comme une incrémentation où le premier chiffre est égal au dernier identifiant entré dans la colonne 'objectid' de la table TA_BPE +1. Les métadonnées spatiales de cette tables sont aussi créées.
Les codes IRIS sont corrigés. Les codes IRIS sont en deux formats dans la base BPE:
* Alors que dans les données IRIS le format est sous forme INSEEIRIS, dans la table BPE les IRIS sont sous la forme INSEE_IRIS.
* De plus quand une commune n'est pas sub-divisée en IRIS alors dans les données IRIS son code est sous la forme INSEE0000,mais dans les données BPE il n'y a que son numéro INSEE
Une requête permet de corriger les codes IRIS dans la base BPE et de tout mettre en INSEEIRIS.

#### 3.4 Normalisation des données.


A parir de cette table, plusieurs requêtes (présentes dans le fichier normalisation_bpe) sont executés pour insérer les données dans les tables:
3.4.1. TA_BPE_GEOM (requête 4)
	* Cette requête permet d'insérer dans la table TA_BPE_GEOM les géométries unique des BPE qui ne sont pas déja présente dans la table
3.4.2. TA_BPE (requête 5)
	* Cette requête permet de mettre le fid_metadonnées de la donnée considéré au dernier millésime.
3.4.3. TA_BPE_RELATION_GEOM (requête 6)
3.4.4. TA_BPE_CARACTERISTIQUE_NOMBRE (requête 7)
	* Deux requêtes sont à éxecuter car deux variables ont pour caractéristique d'attribuer un attribut numérique
		* NB_AIREJEU: Nombre d'aires de pratique d'un meme type au sein de l'equipement
		* NB_SALLES: nombre de salles par theatre ou cinema
3.4.5. TA_BPE_CARACTERISTIQUE (requête 8)
	* un total de 11 requêtes pour inserer les données liées:
		* TYPEQU: nature de l'équipement.
		* CANT: présence ou absence d'une cantine.
		* CL_PELEM: présence ou absence d'une classe pre-élementaire en école primaire
		* CL_PGE: présence ou absence d'une clASse preparatoire aux grandes ecoles en lycee
		* EP: Appartenance ou non à un dispositif d'education prioritaire
		* INT: présence ou absence d'un internat
		* QUALITE XY: qualite d'attribution pour un equipement de ses coordonnees XY
		* RPIC: Presence ou absence d'un regroupement pedagogique intercommunal concentre
		* SECT: appartenance au secteur public ou prive d'enseignement
		* COUVERT: equipement couvert ou non
		* ECLAIRE: equipement couvert ou non
	* Ces requêtes possèdent plusieurs sous requête car afin d'identifier la nature de la variable il faut connaitre son libellé parent car un libellé peut définir plusieur état. Par exemple, 0 peut signifier aussi bien équipement non éclairé que non couvert.
	* dans la première sous requête nous selectionnons l'ensemble des objectids et des libellés ainsi que ceux des libéllés parents.
	* dans la seconde nous sélectionnons les libellés et leurs equivalences courts.
	* dans la troisième sous requête, nous selectionnons l'ensemble des codes des libellés fils et parent avec un filtre sur l'attribut à renseigner dans la table.
	* et enfin dans le SELECT de fin on sélectionne les BPE qui ont cette attribut.
3.4.6. TA_BPE_RELATION_CODE (requête 9)
	* il a été décidé de faire une table de relation entres les BPEs et les codes IRIS car certain BPE ne sont pas géolocalisés cette relation permet à minima d'identifier leurs communes d'implantation et si possible leurs IRIS.
	* Cette insertion se fait en deux fois:
		* pour les codes IRIS
		* et les codes INSEE