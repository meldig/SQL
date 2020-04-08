# Remarque sur l'intégration des données de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Ce document a pour but d'expliciter la méthode utilisée pour intégrer les données de la base historique des populations 1876 à 2017 avec la géographie de 2019. Trois fichiers de requêtes ont été écrit.
* creation_structure_recensement.sql: fichier contenant la requête de création de la table TA_RECENSEMENT
* insertion_nomenclature_recensement_donnees_historique.sql: fichier regroupant les instructions nécessaires à l'insertion de la nomenclature dans la base oracle
* normalisation_recensement_donnees_historique.sql: fichier contenant la requête d'insertion des données contenues dans la base historique des populations 1876 à 2017 avec la géographie de 2019 dans la table TA_RECENSEMENT.

## Phasage:

* 1. Création de la table nécessaire à l'insertion des données du recensement.
* 2. Insertion de la nomenclature propre aux données du recensement.
* 3. Import des données brutes dans le schéma via ogr2ogr.
* 4. Normalisation des données dans la table.

## Description du phasage:

### 1. Création de la table TA_RECENSEMENT.

La table accueillant les données du recensement est la table TA_RECENSEMENT
* Table TA_RECENSEMENT : Table accueillant les données du recensement
	* colonne objectid : clé primaire de la table TA_RECENSEMENT.
	* colonne fid_code : clé étrangère vers la table TA_CODE pour connaitre la commune concernée par la valeur du recensement
	* colonne fid_recensement : clé étrangère vers la table TA_LIBELLE_COURT pour connaitre le recensement concerné par la valeur
	* population : nombre d'habitant recensé dans la commune considérée au recensement considéré.
	* fid_metadonnee : clé étrangère vers la table TA_METADONNEE pour connaitre les informations sur les données contenues dans la table.

### 2. Insertion de la nomenclature de la base historique des populations 1876 à 2017 avec la géographie de 2019.

Les données de la base historique des populations 1876 à 2017 avec la géographie de 2019 se présentent sous la forme d'un tableau contenant en ligne les communes et en colonnes le nombre d'habitants suivant le recensement concerné.
Une attention particulière a été apportée à l'insertion des métadonnées. Pour chaque recensement, un millésime a été ajouté à la table TA_DATE_ACQUISITION.
Les différents libelles que peuvent prendrent les recensements ont été ajoutés dans la table TA_LIBELLE_COURT.

L'ensemble des requêtes servant à insérer la nomenclature et les métadonnées de la base historique des populations 1876 à 2017 avec la géographie de 2019 sont dans le fichier : insertion_nomclature_recensement_donnees_historique.sql.
Cette insertion se fait en 6 étapes:
* 2.1. La première étape consiste à insérer les données dans la table TA_SOURCE.
* 2.2. Ensuite il faut insérer les données dans la table TA_PROVENANCE.
* 2.3. Insertion des données dans la table TA_DATE_ACQUISITION.
* 2.4. Insertion de l'organisme producteur dans la table TA_ORGANISME.
* 2.5. Insertion des métadonnéesdans la table TA_METADONNEE.
* 2.6. Insertion des libellés courts des recensements dans TA_LIBELLE_COURT.
* 2.7. Insertion des libellés des recensements dans la table TA_LIBELLE.
* 2.8. Insertion de la famille 'recensement' dans la table TA_FAMILLE.
* 2.9. Insertion des correspondances famille - libelle dans la table TA_FAMILLE_LIBELLE.
* 2.10. Insertion des correspondance libelle - libelle court dans la table TA_CORRESPONDANCE_LIBELLE.

### 3. Normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019

La requête permettant la normalisation des données de la base historique des populations 1876 à 2017 avec la géographie de 2019 et leurs insertions dans la table TA_RECENSEMENT est contenue dans le fichier normalisation_recensement_donnees_historique.sql.