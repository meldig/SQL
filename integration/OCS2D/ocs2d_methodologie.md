#  Documentation de la méthodologie utilisée pour l'intégration des données de la Base OCS2D:

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données issues de la base OCS2D dans la base Oracle. Les commandes ont été divisés dans 5 fichiers différents.
* ocs2d_structure.sql: fichier regroupant les requêtes permettant de créer les tables accueillant les données OCS2D.
* ocs2d_nomenclature.sql: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature OCS2D dans la base oracle.
* ocs2d_normalisation.sql: fichier regroupant les instructions nécessaires à la normalisation des données OCS2D.
* ocs2d_vue_nomenclature.sql: requêtes générant deux vues presentant les nomenclatures OCS2D usage et couvert du sol. Ces vues simplifient la normalisation des données.
* admin_ocs2d.sql: Vue proposée pour la restitution des données OCS2D.

## 1. Phasage:

1. Import du fichier brut de la nomenclature.
2. Insertion de la nomenclature propre aux données OCS2D.
3. Génération des vues restituant la nomenclature OCS2D.
4. Création de la structure OCS2D.
5. Import du fichier de données brutes OCS2D.
7. Normalisation des données OCS2D.
8. Génération de la vue OCS2D.

## 2. Description du phasage:

### 2.1. Importation du fichier brut de la nomenclature.

Pour insérer les données brutes dans les tables. il faut d'abord importer au sein de la base la nomenclature. Celle-ci est composée d'un fichier csv. Pour importer la nomenclature il est possible d'utiliser les outils *ogr2ogr* ou l'import de table Oracle.

### 2.2. Insertion de la nomenclature OCS2D

Les requêtes qui insèrent la nomenclature dans la base sont contenues dans le fichier ocs2d_nomenclature.sql. Lors de cette insertion, une table temporaire est créée. Celle-ci permet d'attribuer des identifiants a priori à chaque libelle qui va être inséré dans la table TA_LIBELLE. Cela est nécessaire pour gérer les différents niveaux hiérarchiques des libellés de la nomenclature surtout dans le cas où des niveaux hiérarchiques différents ont le même libelle.

### 2.2.1 phasage

L'insertion de la nomenclature OCS2D se fait à partir des requêtes contenues dans le fichier: ocs2d_nomenclature.sql. Celle-ci se fait en 18 étapes:
1. Insertion de la source dans TA_SOURCE.
2. Insertion de la provenance dans TA_PROVENANCE.
3. Insertion des données dans TA_DATE_ACQUISITION.
4. Insertion des données dans TA_ORGANISME.
5. Insertion des données dans TA_ECHELLE.
6. Insertion des données dans TA_METADONNEE.
7. Vue simplifiant la nomenclature OCS2D pour faciliter sa normalisation.
8. Insertion des libelles courts dans TA_LIBELLE_COURT.
9. Insertion des libelles longs dans TA_LIBELLE_LONG.
10. Insertion de la famille dans TA_FAMILLE.
11. Insertion des relations dans TA_FAMILLE_LIBELLE.
12. Création de la vue des relations des libelles.
13. Création de la table FUSION_OCS2D_COUVERT_USAGE pour normaliser les données.
14. Insertion des données dans la table temporaire fusion avec l'utilisation de la séquence de la table TA_LIBELLE.
15. Insertion des données dans TA_LIBELLE.
16. Insertion des données dans TA_CORRESPONDANCE_LIBELLE.
17. Insertion des données dans TA_RELATION_LIBELLE.
18. Suppression des tables et des vues utilisés seulement pour l'insertion de la nomenclature.

### 2.3. Génération des vues restituant les nomenclatures.

Le fichier *ocs2d_vue_nomenclature* contient deux requêtes qui vont créer deux vues. La première restitue la nomenclature *couvert* qui nous renseigne sur le couvert du sol et la deuxième sur son usage. Ces deux vues permettent d'une part de nous restituer les deux nomenclatures mais aussi de simplifier la normalisation des données OCS2D.

### 2.4. import des fichiers brutes

Pour normaliser les données, il faut d'abord importer au sein de la base les données brutes OCS2D. Pour importer les données il est possible d'utiliser *ogr2ogr*.

Ci dessous la commande ogr2ogr utilisé:
<code><pre>ogr2ogr -f OCI OCI:USER/MDP@HOST/SCHEMA CHEMIN DU FICHIER -lco SRID=2154</code></pre>

### 2.5. Création de la structure OCS2D

#### 2.5.1. TA_OCS2D

La table TA_OCS2D sert à acceuillir les informations provenant des données OCS2D.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D | objectid | Clé primaire de la table TA_OCS2D |
|| fid_lib_cs | Clé étrangère vers la table TA_LIBELLE pour connaire le couvert du sol |
|| fid_lib_us | Clé étrangère vers la table TA_LIBELLE pour connaitre l'usage du sol |
|| fid_ocs2d_indice | Clé étrangère vers la table TA_OCS2D_INDICE |
|| fid_ocs2d_source | Clé étrangère vers la table TA_OCS2D_SOURCE |
|| fid_metadonnee | Clé étrangère vers la table TA_METADONNEE |
|| fid_geom | Clé étrangère vers la table TA_OCS2D_GEOM |

#### 2.5.2. TA_OCS2D_GEOM

La table TA_OCS2D_GEOM sert à acceuillir les géométries pouvant être pris par les zones OCS2D.

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D_GEOM | objectid | Clé primaire de la table TA_OCS2D_GEOM |
|| geom | Géométrie des zones OCS2D |

#### 2.5.3. TA_OCS2D_INDICE

La table TA_OCS2D_INDICE contient les indices que peuvent avoir les surfaces OCS2D

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D_INDICE | objectid | Clé primaire de la table TA_OCS2D_INDICE |
|| valeur | Valeur de l'indice |

#### 2.5.4. TA_OCS2D_SOURCE

La table TA_OCS2D_SOURCE contient les sources que peuvent avoir les surfaces OCS2D

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D_SOURCE | objectid | Clé primaire de la table TA_OCS2D_SOURCE |
|| valeur | Valeur de la source |

#### 2.5.5. TA_OCS2D_COMMENTAIRE

LA table TA_OCS2D_COMMENTAIRE contient les commentaires que peuvent avoir les surfaces OCS2D

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D_COMMENTAIRE | objectid | Clé primaire de la table TA_OCS2D_COMMENTAIRE |
|| valeur | Commentaire |

#### 2.5.6. TA_OCS2D_RELATION_COMMENTAIRE

La table TA_OCS2D_RELATION_COMMENTAIRE est une table qui relie les zones OCS2D avec les commentaires qu'elles peuvent avoir

| Table | Colonne | Description |
|---|---|---|---|---|---|
| TA_OCS2D_RELATION_COMMENTAIRE | fid_ocs2d | Clé étrangère vers la table TA_OCS2D pour connaire la zone OCS2D concernée par le commentaire |
|| fid_ocs2d_commentaire | Clé étrangère vers la table TA_OCS2D_COMMENTAIRE pour connaitre le commentaire de la zone OCS2D concernée |


### 3. Normalisation des donnée

La normalisation des données se fait à partir des requêtes présentes dans le fichier: ocs2d_normalisation.sql. Celle-ci se fait en 7 étapes.

1. Ajout de la colonne identité à la table des données brutes pour avoir des identifiant unique par polygone afin de permettre la normalisation des données.
2. insertion des identifiants dans la colonne *identite* grâce à la séquence de la table TA_OCS2D.
3. Insertion des géométries dans la table TA_OCS2D_GEOM.
4. Insertion des commentaires dans la table TA_OCS2D_COMMENTAIRE.
5. Insertion des sources dans la table TA_OCS2D_SOURCE.
6. Insertion des données dans la table TA_OCS2D
7. Insertion des données dans la table TA_RELATION_COMMENTAIRE.