# Remarque sur l'intégration des données de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données de la base historique des populations 1876 à 2017 avec la géographie de 2019.
Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.
Trois fichiers de requêtes ont été écrit:
* creation_structure_recensement.sql: fichier contenant la requête de création de la table TA_RECENSEMENT
* insertion_nomenclature_recensement_donnees_historique.sql: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature dans la base oracle
* normalisation_recensement_donnees_historique.sql: fichier contenant la requête d'insertion des données contenues dans la base historique des populations 1876 à 2017 avec la géographie de 2019 dans la table TA_RECENSEMENT.

## Phasage:

1. Création de la table nécessaire à l'insertion des données du recensement.
2. Insertion de la nomenclature propre aux données du recensement.
3. Import des données brutes dans le schéma via ogr2ogr.
4. Normalisation des données dans la table.

## Description du phasage:

### 1. Création de la table TA_RECENSEMENT.

| Table | Colonne | Description
| ------ | ------ | ----- |
| TA_RECENSEMENT | objectid | Clé primaire de la table TA_RECENSEMENT |
|| fid_code | Clé étrangère vers la table TA_CODE pour connaitre la commune concernée par la valeur du recensement |
|| fid_lib_recensement | Clé étrangère vers la table TA_LIBELLE pour connaitre le recensement concerné par la valeur | 
|| population | Nombre d'habitant recensé dans la commune considérée au recensement donné |
|| fid_metadonnee | Clé étrangère vers la table TA_METADONNEE pour connaitre les informations sur les données contenues dans la table |


### 2. Insertion de la nomenclature de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Les données de la base historique des populations 1876 à 2017 avec la géographie de 2019 se présentent sous la forme d'un tableau contenant en ligne les communes et en colonnes le nombre d'habitants suivant le recensement concerné.
Une attention particulière a été apportée à l'insertion des métadonnées. Pour chaque recensement, un millésime a été ajouté à la table TA_DATE_ACQUISITION.
Les différents libelles que peuvent prendrent les recensements ont été ajoutés dans la table TA_LIBELLE_COURT.

L'ensemble des requêtes servant à insérer la nomenclature et les métadonnées de la base historique des populations 1876 à 2017 avec la géographie de 2019 sont dans le fichier : insertion_nomenclature_recensement_donnees_historique.sql.
Cette insertion se fait en 6 étapes:
1. La première étape consiste à insérer les données dans la table TA_SOURCE.
2. Ensuite il faut insérer les données dans la table TA_PROVENANCE.
3. Insertion des données dans la table TA_DATE_ACQUISITION.
4. Insertion de l'organisme producteur dans la table TA_ORGANISME.
5. Insertion des métadonnées dans la table TA_METADONNEE.
6. Insertion des relation entre les métadonnées et l'organisme producteur
7. Insertion des codes et des fid_codes dans la table TA_CODE des communes à partir des données brutes. La requête utilisée est un MERGE. Si le code insee est déjà présent dans la table, il ne sera pas ajouté.
8. Création de la vue nomenclature_recensement pour simplifier l'insertion des libelles.
9. Insertion des libellés courts des recensements dans TA_LIBELLE_COURT.
10. Insertion des libellés courts des recensements dans TA_LIBELLE_LONG.
11. Insertion de la famille 'Recensement' dans la table TA_FAMILLE.
12. Insertion des correspondances famille - libelle dans la table TA_FAMILLE_LIBELLE.
13. Création de la table temporaire fusion_nomenclature_recensement nécessaire pour simplifier l'insertion de la nomenclature. Cette table utilise la séquence de la table TA_LIBELLE pour générer des objectid unique aux éléments de la nomenclature.
14. Insertion des libelles des recensements dans la table TA_LIBELLE.
15. Insertion des correspondances libelle - libelle court dans la table TA_CORRESPONDANCE_LIBELLE.
16. Suppresion de la table temporaire fusion_nomenclature_recensement et de la vue nomenclature_recensement.

### 3. Normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019

La requête permettant la normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019 et leurs insertions dans la table TA_RECENSEMENT est contenue dans le fichier normalisation_recensement_donnees_historique.sql.