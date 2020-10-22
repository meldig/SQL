# Méthodologie mise en place pour l'intégration des données de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données de la base historique des populations 1876 à 2017 calculées avec la géographie des communes de 2019.
Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.
Trois fichiers de requêtes ont été écrit:
* <em>creation_structure_recensement.sql</em>: fichier contenant la requête de création de la table TA_RECENSEMENT
* <em>insertion_nomenclature_recensement_donnees_historique.sql</em>: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature liée aux donnéesdans la base oracle
* <em>normalisation_recensement_donnees_historique.sql</em>: fichier contenant la requête d'insertion des données contenues dans la base historique des populations 1876 à 2017 avec la géographie de 2019 dans la table TA_RECENSEMENT.

## Phasage:

1. Création de la table nécessaire à l'insertion des données du recensement.
2. Insertion de la nomenclature propre aux données du recensement.
3. Import des données brutes dans le schéma via ogr2ogr.
4. Normalisation des données dans la table.

## Description du phasage:

### 1. Création de la table TA_RECENSEMENT.

|Colonne|Type|Description|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|OBJECTID|IDENTITY|Clé primaire de la table TA_RECENSEMENT.|
|FID_CODE|NUMBER|Clé étrangère vers la table TA_CODE pour connaitre la commune concernée par la valeur du recensement.|
|FID_LIB_RECENSEMENT|NUMBER|Clé étrangère vers la table TA_LIBELLE pour connaitre le recensement concerné par la valeur.|
|population|NUMBER|Nombre d'habitant recensé dans la commune considérée au recensement donné.|
|FID_METADONNEE|NUMBER|Clé étrangère vers la table TA_METADONNEE pour connaitre les informations sur les données contenues dans la table.|


### 2. Insertion de la nomenclature de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Les données de la base historique des populations 1876 à 2017 avec la géographie de 2019 se présentent sous la forme d'un tableau contenant en ligne les communes et en colonnes le nombre d'habitants suivant le recensement concerné.
Une attention particulière a été apportée à l'insertion des métadonnées. Pour chaque recensement, un millésime a été ajouté à la table TA_DATE_ACQUISITION.
Les différents libelles que peuvent prendre les recensements ont été ajoutés dans la table TA_LIBELLE_COURT. 31 lignes sont ajoutées dans la table TA_METADONNEE.

L'ensemble des requêtes servant à insérer la nomenclature et les métadonnées de la base historique des populations 1876 à 2017 avec la géographie de 2019 sont dans le fichier : <em>insertion_nomenclature_recensement_donnees_historique.sql</em>.
Cette insertion se fait en 6 étapes:
1. La première étape consiste à insérer les données dans la table TA_SOURCE.
2. Insertion de l'URL et de la méthode d'acquisition dans la table TA_PROVENANCE.
3. Insertion de la date d'acquisition du millesime et de l'obtenteur dans TA_DATE_ACQUISITION. Utilisation des variables SYSDATE et SYS_CONTEXT('USERENV', 'OS_USER') pour automatiquement définir la date d'acquisition et l'obtenteur.
4. Insertion de l'organisme producteur dans la table TA_ORGANISME.
5. Insertion des métadonnées dans la table TA_METADONNEE.
6. Insertion des relation entre les métadonnées et l'organisme producteur dans la table TA_METADONNEE_RELATION_ORGANISME.
7. Insertion des codes et des fid_libelle dans la table TA_CODE, des communes à partir des données brutes. La requête utilisée est un MERGE. Si le code insee est déjà présent dans la table, il ne sera pas ajouté.
8. Insertion des libellés courts des recensements dans TA_LIBELLE_COURT.
* Exemple:
** PMUN17,
** PSDC82,
** PTOT1876
9. Insertion des libellés longs des recensements dans TA_LIBELLE_LONG.
* Exemple:
** Population municipale en 2017,
** Population sans double compte en 1982
** Population totale en 1876
10. Insertion de la famille 'recensement' dans la table TA_FAMILLE.
11. Insertion des correspondances famille - libelle long dans la table TA_FAMILLE_LIBELLE.
12. Insertion des libelles des recensements dans la table TA_LIBELLE.
13. Insertion des correspondances libelle - libelle court dans la table TA_CORRESPONDANCE_LIBELLE.

### 3. Normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019

La requête permettant la normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019 et leur insertion dans la table TA_RECENSEMENT est contenue dans le fichier <em>normalisation_recensement_donnees_historique.sql</em>