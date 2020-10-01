#  Méthodologie mise en place pour l'intégration des données IRIS en base.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données IRIS dans la base Oracle. Les requêtes ont été divisées dans 4 fichiers différents:
* <em>iris_structure.sql:</em> fichier regroupant les requêtes de création de la structure nécessaire à l'intégration des IRIS.
* <em>iris_nomenclature.sql:</em> fichier regroupant les commandes utilisées pour insérer la nomenclature des données IRIS dans la base oracle.
* <em>iris_normalisation.sql:</em> fichier regroupant les instructions nécessaires à la normalisation des données IRIS dans la base oracle.
* <em>admin_iris.sql:</em> vue restituant les données IRIS.
* <em>iris_traitement.bat:</em> fichier permettant l'insertion des IRIS en base et le traitement des données.

## Prérequis.

Nécessite les communes de la BDTOPO au même millesime dans la table oracle.

## Observation.

Certain IRIS sont des polygones multipartis:
Exemple: code_iris 024080801.

## Phasage:

1. Insertion des données IRIS dans une table d'import dans la base Oracle
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

La table <em>TA_IRIS</em> regroupe les equipements de la Base Permanente des Equipements.

|Colonne|Type|Description|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_IRIS.|
|FID_CODE|NUMBER|Clé étrangère vers la table TA_CODE pour connaitre le code IRIS de la zone IRIS.|
|FID_NOM|NUMBER|Clé étrangère vers la table TA_NOM pour connaitre le nom de la zone IRIS.|
|FID_LIBELLE|NUMBER|Clé étrangère vers la table TA_LIBELLE pour connaitre le type de zone IRIS.|
|FID_METADONNEE|NUMBER|Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée.|
|FID_GEOM|NUMBER|Clé étrangère vers la table TA_IRIS_GEOM pour connaitre la géométrie de la zone IRIS.|


##### 2.2. TA_IRIS_GEOM

La table <em>TA_IRIS_GEOM</em> regroupe les géométries des zones IRIS.

| Colonne | Type | Description |
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_IRIS_GEOM.|
|GEOM|SDO_GEOMETRY|Géométrie des zone IRIS.|


### 3. Insertion de la nomenclature 


L'insertion de la nomenclature IRIS s'effectue à partir des requêtes contenues dans le fichier: <em>iris_nomenclature.sql</em>.

##### 3.1. Insertion de la nomenclature IRIS

1. Insertion de la source et de la description dans <em>TA_SOURCE</em>.
2. Insertion de l'url et de la méthode d'acquisition dans <em>TA_PROVENANCE</em>.
3. Insertion de la date d'acquisition du millesime et de l'obtenteur dans <em>TA_DATE_ACQUISITION</em>. Utilisation des variables SYSDATE et SYS_CONTEXT('USERENV', 'OS_USER')  pour automatiquement définir la date d'acquisition et l'obtenteur
4. Insertion des organisme producteur de la donnée dans <em>TA_ORGANISME</em>.
5. Insertion de l'échelle d'utilisation de la donnée  dans <em>TA_ECHELLE</em>.
6. Insertion des données dans <em>TA_METADONNEE</em>.
7. Insertion des données dans la table <em>TA_METADONNEE_RELATION_ORGANISME</em>.
8. Insertion des données dans la table <em>TA_METADONNEE_RELATION_ECHELLE</em>
9. Insertion des libellés courts dans <em>TA_LIBELLE_COURT</em>.
10. Insertion des libellés longs dans <em>TA_LIBELLE_LONG</em>.
11. Insertion des familles 'type de zone IRIS' et 'identifiants de zone statistique' dans la table <em>TA_FAMILLE</em>.
12. Insertion des relations familles-libellés dans <em>TA_FAMILLE_LIBELLE</em>.
13. Insertion des libelles dans <em>TA_LIBELLE</em>.
13. Insertion des données dans <em>TA_LIBELLE_CORRESPONDANCE</em> grâce à la table temporaire <em>BPE_FUSION</em>(voir 13., 14.).


### 4. Normalisation des données

La normalisation des données se fait à partir des requêtes présentes dans le fichier :<em>normalisation_iris.sql</em>. Celle-ci se fait en plusieurs étapes.

1. Suppression des IRIS qui ne sont pas présents dans les Hauts-de-France
2. Insertion des noms IRIS dans G_GEO.TA_NOM
3. Insertion des codes IRIS G_GEO.TA_CODE
4. Insertion des géométrie des IRIS dans G_GEO.TA_IRIS_GEOM
5. Insertion des données IRIS dans G_GEO.TA_IRIS

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


#### 4.6. Suppression des données importées.

Suppression de la table IRIS_CONTOURS et de ses métadonnées spatiales.

### 5. Création de la vue admin_iris.

La requête permettant de créer la vue est contenue dans le fichier <em>admin_iris.sql</em>. A cause du temps de traitement des tables intermediaires sont créées. L'ensemble de ces tables seront supprimées à la fin du traitement.

#### 5.1. Creation de la table TEMP_COMMUNES_VM.

Insertion des communes du même millésime que les IRIS dans une table temporaire appelée TEMP_COMMUNES_VM. Les métadonnées de la table sont créées ainsi qu'un index sur la colonne GEOM

#### 5.2. Creation de la table TEMP_COMMUNES_SURFACES.

Cette table sert à calculer les surfaces d'intersection entre les communes et les IRIS. La commune avec laquelle l'IRIS obtient la plus grande surface d'intersection sera considérée comme la commune d'appartenance de l'IRIS.

#### 5.3. Detection des aires maximales dans la table G_GEO.TEMP_COMMUNES_SURFACES_MAX.

Table qui sert à distinguer la surface d'intersection maximale afin de distinguer la commune d'appartenance de l'IRIS. Ces requêtes spatiales sont nécessaires afin de recomposer le code IRIS complet de la zone IRIS.

#### 5.4. Création de la vue matérialisée.

1. Selection finale des éléments de la vue.
2. Création des commentaires de la vue.
3. Création des métadonnées spatiales de la vue.
4. Création de la clé primaire de la vue.
5. Création de l'index spatial de la vue.
6. Suppression des tables temporaire.
** Suppression de la table TEMP_COMMUNES_VM
** Suppression des metadonnées de la table TEMP_COMMUNES_VM
** Suppression de la table TEMP_COMMUNES_SURFACES
** Suppression de la table TEMP_COMMUNES_SURFACES_MAX
** Suppression de la table CONTOURS_IRIS