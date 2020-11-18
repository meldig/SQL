#  Méthodologie mise en place pour l'intégration des données IRIS en base.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données IRIS dans la base Oracle. Les requêtes ont été divisées dans 4 fichiers différents:
* **iris_traitement.bat**: fichier permettant l'insertion des IRIS en base et le traitement des données.
* **format_date**: requete sql permettant de paramétrer le type de date de la session sqlplus afin d'insérer nos attributs dates en base.
* **iris_structure.sq**: fichier regroupant les requêtes de création de la structure nécessaire à l'intégration des IRIS.
* **iris_nomenclature.sq**: fichier regroupant les commandes utilisées pour insérer la nomenclature des données IRIS dans la base oracle.
* **iris_normalisation.sql**: fichier regroupant les instructions nécessaires à la normalisation des données IRIS dans la base oracle.
* **vm_admin_iris**: fichier bat permettant de créer la vue **admin_iris** par l'intermédiaire de sqlplus.(** pas utilisable pour l'instant**)
* **vm_admin_iris_structure.sql**:Fichier contenant les requêtes nécessaires à la création des tables utilisées pour générer la vue **admin_iris**
* **vm_admin_iris.sql**: Fichier contenant la requête de la vue matérialisée **admin_iris**.
* **vm_admin_iris_suppression.sql**: fichier contenant les requêtes qui supprime les tables temporaires utilisées pour insérer les données en base, les normaliser et créer la vue matérialisée **admin_iris**
* **vm_admin_iris_structure_vue_suppression.sql**: fichier regroupant l'ensemble des requêtes contenues dans les trois fichiers cités ci-dessus.

## Prérequis.

Nécessite les communes de la BDTOPO au même millesime dans la table oracle.

## Observation.

Certain IRIS sont des polygones multipartis:
Exemple: code_iris 024080801.

## Phasage:

1. Insertion des données IRIS dans une table d'import dans la base Oracle.
2. Création des tables du schéma nécessaire à l'insertion des données IRIS.
3. Insertion de la nomenclature propre aux IRIS.
4. Normalisation des données dans le schéma.
5. Création de la vue admin IRIS sur le schéma G_REFE...

## Description du phasage:

### 1. Insertion des données IRIS dans la base Oracle.

L'insertion des données IRIS se fait grâce à une commande ogr2ogr:

	ogr2ogr.exe -f OCI SCHEMA/MDP@USER \\volt\infogeo\Donnees\Externe\IGN\IRIS\2019\CONTOURS_IRIS.shp -nlt multipolygon -nln CONTOURS_IRIS -lco SRID=2154 -dim 2

* OCI: utilisation du driver Oracle
* SCHEMA/MDP@USER: connexion au schéma Oracle
* \\volt\infogeo\Donnees\Externe\IGN\IRIS\2019\CONTOURS_IRIS.shp: chemin de la couche à importer
* -nlt multipolygon: paramètre pour indiquer que la couche importée est une couche en multipolygon
* -nln CONTOURS_IRIS: paramètre pour indiquer le nom que prendra la couche dans la table en base
* -lco SRID=2154: paramètre du système de projection de la couche
* -dim 2: dimension de la couche

#### 2. Description des tables spécialement créées pour acceuillir les données IRIS

##### 2.1. TA_IRIS

La table **TA_IRIS** regroupe les zones IRIS des hauts de France et leurs attributs

|Colonne|Type|Description|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_IRIS.|
|FID_CODE|NUMBER|Clé étrangère vers la table TA_CODE pour connaitre le code IRIS de la zone IRIS.|
|FID_NOM|NUMBER|Clé étrangère vers la table TA_NOM pour connaitre le nom de la zone IRIS.|
|FID_LIBELLE|NUMBER|Clé étrangère vers la table TA_LIBELLE pour connaitre le type de zone IRIS.|
|FID_METADONNEE|NUMBER|Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée.|
|FID_GEOM|NUMBER|Clé étrangère vers la table TA_IRIS_GEOM pour connaitre la géométrie de la zone IRIS.|


##### 2.2. TA_IRIS_GEOM

La table **TA_IRIS_GEOM** regroupe les géométries des zones IRIS.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_IRIS_GEOM.|
|GEOM|SDO_GEOMETRY|Géométrie des zone IRIS.|


### 3. Insertion de la nomenclature 


L'insertion de la nomenclature IRIS s'effectue à partir des requêtes contenues dans le fichier: **iris_nomenclature.sql**.

##### 3.1. Insertion de la nomenclature IRIS

1. Insertion de la source et de la description des données IRIS dans **TA_SOURCE**.
2. Insertion de l'url et de la méthode d'acquisition dans **TA_PROVENANCE**.
3. Insertion de la date d'acquisition du millésime et de l'obtenteur dans **TA_DATE_ACQUISITION**. Utilisation des variables SYSDATE et SYS_CONTEXT('USERENV', 'OS_USER')  pour automatiquement définir la date d'acquisition et l'obtenteur
4. Insertion des organismes producteurs de la donnée dans **TA_ORGANISME**.
5. Insertion de l'échelle d'utilisation de la donnée  dans **TA_ECHELLE**.
6. Insertion des métadonnées dans **TA_METADONNEE**.
7. Insertion des données dans la table **TA_METADONNEE_RELATION_ORGANISME**.
8. Insertion des données dans la table **TA_METADONNEE_RELATION_ECHELLE**
9. Insertion des libellés courts de la nomenclature des données IRIS dans **TA_LIBELLE_COURT**.
10. Insertion des libellés longs de la nomenclature des données IRIS dans **TA_LIBELLE_LONG**.
11. Insertion des familles 'type de zone IRIS' et 'identifiants de zone statistique' dans la table **TA_FAMILLE**.
12. Insertion des relations familles-libellés dans **TA_FAMILLE_LIBELLE**.
13. Insertion des libelles dans **TA_LIBELLE**.
13. Insertion des données dans **TA_LIBELLE_CORRESPONDANCE** grâce à la table temporaire **BPE_FUSION**(voir 13., 14.).


### 4. Normalisation des données

La normalisation des données se fait à partir des requêtes présentes dans le fichier :**normalisation_iris.sql**. Celle-ci se fait en plusieurs étapes.

1. Suppression des IRIS qui ne sont pas présents dans les Hauts-de-France
2. Insertion des noms des zones IRIS dans G_GEO.TA_NOM
3. Insertion des codes des zones IRIS G_GEO.TA_CODE
4. Insertion des géométrie des zones IRIS dans G_GEO.TA_IRIS_GEOM
5. Insertion des données qui caractérisent les IRIS dans la table G_GEO.TA_IRIS

#### 4.1. Suppression des zones IRIS qui ne sont pas dans les Hauts-de-France.

Suppression des zones IRIS qui ne sont pas dans les Hauts-de-France. Autrement dit, tous les IRIS dont le code insee ne commence pas par les deux digits: '02','59','60','62','80'

#### 4.2 Insertion des noms IRIS dans le table G_GEO.TA_NOM

Certain IRIS, ont pour nom les noms de leurs communes (IRIS du type Z: Communes non découpées en IRIS). Il est donc préférable d'utiliser une commande MERGE plutôt que la commande INSERT pour éviter des doublons de valeurs dans la table.

#### 4.3. Insertion des codes IRIS dans la table G_GEO.TA_CODE.

Chaque IRIS a un code en 4 chiffres ainsi qu'un code complet en 9 chiffres(concaténation du code INSEE et du code IRIS). Comme il est possible par requête spatiale de reconstituer le code IRIS complet le parti pris a été de n'insérer en base que le code IRIS.

#### 4.4. Insertion des géométries des IRIS dans la table G_GEO.TA_IRIS_GEOM.

Insertion avec une clause WHERE pour éviter d'inserer dans la table des géométries déja présentes. Utilisation des commandes HASH et SDOGEOM.SDO_CENTROID pour diminuer le temps de calcul.

#### 4.5. Normalisation des données IRIS dans la table G_GEO.TA_IRIS

Requête qui reconstitue les IRIS et leurs attributs dans la table TA_IRIS. La sous-requête présente dans le troisième AND permet de sélectionner le fid_metadonnee pour les IRIS au millésime le plus récent. En cas d'insertion d'un millésime antérieur, il faudra adapter la requête. 

	        -- sous requete AND pour insérer le fid_métadonnee au millesime le plus récent pour la donnée considérée
        AND 
            n.objectid IN
                (
                SELECT
                    a.objectid AS id_mtd
                FROM
                    ta_metadonnee a
                    INNER JOIN ta_source b ON a.fid_source = b.objectid
                    INNER JOIN ta_date_acquisition c ON c.objectid = a.fid_acquisition
                WHERE
                    c.millesime IN(
                                SELECT
                                    MAX(b.millesime) as MILLESIME
                                FROM
                                    ta_metadonnee a
                                INNER JOIN ta_date_acquisition  b ON a.fid_acquisition = b.objectid 
                                INNER JOIN ta_source c ON c.objectid = a.fid_source
                                WHERE c.nom_source = 'Contours...IRIS'
                                )
                AND
                    b.nom_source = 'Contours...IRIS'
                )



### 5. Création de la vue admin_iris.

Les requêtes permettant de créer la vue **admin_iris** sont contenues dans 4 fichiers SQL:
* **vm_admin_iris_structure.sql**:Fichier contenant les requêtes nécessaires à la création des tables utilisées pour générer la vue **admin_iris**
* **vm_admin_iris.sql**: Fichier contenant la requête de la vue matérialisée **admin_iris**.
* **vm_admin_iris_suppression.sql**: fichier contenant les requêtes qui supprime les tables temporaires utilisées pour insérer les données en base, les normaliser et créer la vue matérialisée **admin_iris**
* **vm_admin_iris_structure_vue_suppression.sql**: fichier regroupant l'ensemble des requêtes contenues dans les trois fichiers cités ci-dessus.

#### 5.1 Phasage de la création de la vue matérialisée admin_iris

* Création de tables temporaires pour diminuer le temps de calcul (**vm_admin_iris_structure.sql**)
	* Création de la table temporaire TEMP_COMMUNES_VM pour sélectionner les communes au dernier millesime.
	* Création des métadonnées spatiales.
	* Création de l'index spatial
	* Insertion des communes dans la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM
	* Création de la table temporaire TEMP_COMMUNES_SURFACES pour sélectionner les aires d'intersection entre les communes et les IRIS
	* insertion des données dans la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES
	* Création de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX pour séléctionner la commune ou l'aire d'intersection avec l'IRIS est maximale. 
	* Insertion des aires maximales dans la table G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX.
* Création de la vue matérialisée (**vm_admin_iris.sql**)
	* Suppression de la vue G_REFERENTIEL.ADMIN_IRIS, et des métadonnées si elle existe déjà.
	* Suppression des métadonnées de la vue si elles existent déjà.
	* Création de la vue matérialisée
	* Création des commentaires de la table et des colonnes
	* Création des métadonnées spatiales
	* Création de la clé primaire
	* Création de l'index spatial
* suppression des tables temporaire (**vm_admin_iris_suppression.sql**)
	* Suppresion de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM.
	* Suppression des métadonnées de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM.
	* Suppression de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES.
	* Suppression de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX.

#### 5.2 Création des tables temporaires nécessaires à la création de la vue admin_iris

##### 5.2.1. Creation de la table G_REFERENTIEL.TEMP_COMMUNES_VM.

Insertion des communes du même millésime que les IRIS dans une table temporaire appelée TEMP_COMMUNES_VM. Les métadonnées de la table sont créées ainsi qu'un index sur la colonne GEOM

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|CODE_INSEE|VARCHAR(4000 BYTE)|Code INSEE de la commune.|
|NOM_COMMUNE|VARCHAR(4000 BYTE)|Nom de la commune|
|GEOM|SDO_GEOMETRY|Géométrie de la commune.|

##### 5.2.2. Creation de la table G_REFERENTIEL.TEMP_COMMUNES_SURFACES.

Cette table sert à calculer les surfaces d'intersection entre les communes et les IRIS. La commune avec laquelle l'IRIS obtient la plus grande surface d'intersection sera considérée comme la commune d'appartenance de l'IRIS.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|CODE_INSEE|VARCHAR(4000 BYTE)|Code INSEE de la commune.|
|NOM_COMMUNE|VARCHAR(4000 BYTE)|Nom de la commune|
|iris_objectid|NUMBER|Identifiant de la zone IRIS.|
|AREA|NUMBER|Surface d'une commune recouverte par une zone IRIS.|

##### 5.2.3. Detection des aires maximales dans la table G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX.

Table qui sert à distinguer la surface d'intersection maximale afin de distinguer la commune d'appartenance de l'IRIS. Ces requêtes spatiales sont nécessaires afin de recomposer le code IRIS complet de la zone IRIS.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|CODE_INSEE|VARCHAR(4000 BYTE)|Code INSEE de la commune.|
|NOM_COMMUNE|VARCHAR(4000 BYTE)|Nom de la commune|
|iris_objectid|NUMBER|Identifiant de la zone IRIS.|

#### 5.3 Création de la vue matérialisée **admin_iris**.

La requête permettant de créer la vue matérialisée **admin_iris**. Se déroule en plusieurs étape:
* Suppression de la vue G_REFERENTIEL.ADMIN_IRIS, et des métadonnées si elle existe déjà.
* Suppression des métadonnées si elles existent déjà.
* Création de la vue.
	* Sous requête pour selectionner le millésime le plus récent.
	* Sous requête pour selectionner les organismes producteurs sur une seule ligne.
	* Sous requete pour séléctionner les éléments finaux.
* Création des commentaires de table et de colonnes.
* Création des métadonnées spatiales.
* Création de la clé primaire.
* Création de l'index spatial.

#### 5.4 Création de la vue matérialisée **admin_iris**.

* Suppression de la table TEMP_COMMUNES_VM
	* Suppression des metadonnées de la table TEMP_COMMUNES_VM
* Suppression de la table TEMP_COMMUNES_SURFACES
* Suppression de la table TEMP_COMMUNES_SURFACES_MAX
* Suppression de la table CONTOURS_IRIS (table contenant les IRIS brutes qu'il a fallut normaliser)