# Analyse des bases BPE, LPU et OSM:

## Problématique:

Lors de la réunion de travail sur les référentiels du 19/11/2019, il a été remarqué que la gestion des "équipements" ou "points d'intérêt" n'est pas optimale. il n'y a aucune garantie d'homogénéité ni de complétude.

La Base Permanente des Equipements proposée par l'INSEE, rassemble et consolide des données issues d'administrations officielles. Les sources, la précision, les manques et les méthodes de collectes des données sont décrits et quantifiées.

Il existe d'autres sources de données des équipements présentes sur le territoire de la Métropôle Européenne de Lille, notamment OpenStreetMap(OSM).

Avant de revoir notre mode de collecte des équipements, il serait intéressant de comparer ces trois sources dans leurs valeurs et structures.

## Base Permanente des Equipements:

La base permanente des équipements (BPE) est une source statistique qui fournit le niveau d'équipements et de services rendus à la population sur un territoire. Les résultats sont proposés sous forme de bases de données dans différents formats et pour deux niveaux géographiques : les communes et les Iris. L'offre comprend également des bases de données où de nombreux équipements sont géolocalisés.

* [Source de la donnée](https://www.insee.fr/fr/statistiques/3568629?sommaire=3568656#consulter) 

* Forme de la donnée:
  
  * 3 fichiers de points sous format CSV
  
  * ensemble des équipements: rassemble la totalité des équipements.
  
  * Enseignement: propose en complément à la liste des équipements, la présence ou non de caractéristiques complémentaires spécifiques à ces deux domaines (voir la liste des caractéristiques complémentaires).
  
  * Sport-loisir:propose en complément à la liste des équipements, la présence ou non de caractéristiques complémentaires spécifiques à ces deux domaines (voir la liste des caractéristiques complémentaires).

* Nomenclature: 187 codes 

* Système de projection: EPSG 2154 – RGF93 / Lambert – 93 Projeté

* Echelle: commune et/ou à l'IRIS

* 32185 enregistrements sur le territoire de la métropole (determiné par une sélection par localisation)

### Source des données:

La BPE de l'INSEE est alimenté par:

* L'ADELI: Automatisation DEs LIstes des paramédicaux du ministère chargé de la santé.
* L'ARTCENA: Liste des théâtres-pôles cirques-arts de rue gérés par ARTCENA.
* CAMPING: enquêtes INSEE h^^otellerie de plein air.
* CNAF:Etablissement d'accueil du jeune enfant.
* CNC: Centre National du Cinéma.
* CULTURE : Ministère de la culture et de la communication.
* DGAC : Direction Générale de l'Aviation Civile.
* ENSEIGNEMENT AGRICOLE : DGER, Direction Générale de l'Enseignement et de la Recherche du ministère de l'Agriculture et de l'Alimentation.
* FINESS : FIchier National des Établissements Sanitaires et Sociaux du ministère chargé de la santé.
* GENDARMERIE : système d’information des unités de gendarmerie.
* HÔTEL : enquête Insee hôtellerie.
* JUSTICE : SRJ, Système de Référence Justice du ministère de la Justice.
* LA POSTE
* PÔLE EMPLOI
* PREFECTURE DE POLICE 75
* RAMSESE : Répertoire Académique et Ministériel Sur les Établissements du Système Éducatif du ministère chargé de l'Éducation.
* RES : Recensement des Équipements Sportifs du ministère de la Jeunesse et des Sports.
* RPPS : Répertoire Partagé des Professionnels de Santé.
* SIRENE : Système Informatisé du Répertoire des ENtreprises et des Établissements géré par l'Insee.
* SNCF : gares ferroviaires de voyageurs.
* STATIONS SERVICE : fichier extrait du data.gouv.fr du ministère de l'Économie et des finances.

### Qualité géographique de l'information:

la géolocalisation des équipements est réalisée par l'INSSE et repose sur les informations contenues:

* dans le répertoire d'adresses (RIL : répertoire d'immeubles localisés) utilisé pour le recensement de la population essentiellement pour les communes de 10 000 habitants ou plus ;
* dans les fichiers fiscaux (référentiels d'adresses « cadastraux ») pour les communes de moins de 10 000 habitants.

Afin de mieux apprécier la qualité des données, l'INSEE propose un indicateur de qualité des coordonnées(x,y) pour chaque équipement. Il comporte 5 modalités:

* bonne : l'écart des coordonnées (x,y) fournies avec la réalité du terrain est inférieur à 100 m ;
* acceptable : l'écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est compris entre 100 et 500 m ;
* mauvaise : l'écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées ;
* non géolocalisé : pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l'Insee ;
* type_équipement_non_géolocalisé_cette_année : pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d'équipements dont la géolocalisation n'est pas mise à disposition cette année.

Les taux de cet indicateur qualité pour la BPE 2018 sur les domaines diffusés sont les suivants :

* qualité bonne : 86,4 %
* qualité acceptable : 3,9 %
* qualité mauvaise : 9,3 %
* équipement non géolocalisé : 0,4 %.

### Exhaustivite des données:

Des contrôles sont menés par l'Insee soit en comparant deux sources entre elles, soient en comparant la source BPE avec un fichier externe. Ils ne portent que sur la présomption d'absence ou de présence à tort d'un équipement dans la base.

De plus, chaque année, une mesure de la qualité portant sur une quinzaine d'équipements est effectuée par interrogation des communes de plus de 400 habitants et moins de 10 000 habitants concernées par la campagne de recensement de la population.

Le but de cette enquête qualité est de mesurer d'éventuels excédents ou déficits d'équipements.

* Excédent d'équipements : équipements présents dans la BPE et absents lors de la dernière enquête qualité en mairie.
* Déficit d'équipements : équipements absents de la BPE et présents lors de la dernière enquête qualité en mairie.

## Lieux Publics (LPU), Points d'Intérêts (POI):

Les POI est une source de données créée, renseignée et mise à jour par les équipes de la métropole.

### Informations générales:

La données se présente sous la forme de table de points renseignés géométriquement nommée *iltalpu* sur le schéma *G_SIDU* :

* 9539 enregistrements (le 27/11/2019)
* 57 *CDSFAMILLE*
* 6 *ORIGINE*

### Informations sur l'intégrité de la données:

Il existe une table de correspondance *ADMBV_liste_famille_POI* afin de connaitre la signification des CDSFAMILLE,  cependant 9 CDSFAMILLE ne sont pas renseignés da la table *ADMBV_liste_famille_POI* (CO100, CO101, CO102, CO103, CO104, CO105, CO106, CO107, CO108 et CO109).

Les codes familles(CDSFAMILLE) proviennent de 6 origines différentes :

* NULL
* LPU
* COM
* HEB
* TRA
* SCO
* POL

Remarques :

* Un même CDSFAMILLE peut provenir de plusieurs ORIGINE
* la géométrie est homogène. Seul un point n'a pas de géométrie: *CNUMLPU 18121*

* 10 point se superposent
	* 661	SECUR	5885	SECUR
	* 5439	ADMIN	6564	SCOL0
	* 5208	MEDSO	6572	MEDSO
	* 15248	CO103	15272	CO104
	* 22947	BVOIE	22948	BVOIE

* 197 éléments n'ont pas de *CDSFAMILLE* soit 2.06% du total des enregistrements.
* 1 point n'a pas d'ORIGINE
* 61 points ne sont pas renseigné (pas de CDSFAMILLE, ni ORIGINE, ni aucun libellé) * Pic de création des points en 1997 et 2007
* Pic de mise à jour: entre 2015 et 2018 

## OpenSreetMap(OSM):

OpenStreetMap (OSM) est un projet de cartographie qui vise à constituer une base de données géographique libre du monde (permettant par exemple de créer des cartes sous licence libre), en utilisant le système GPS et d'autres données libres.

Le téléchargement des données s’est fait sur le site de geofabrik: http://download.geofabrik.de/europe/france/nord-pas-de-calais.html

Geofabrik est une entreprise allemande proposant des données OpenStreetMap couvrant toute la surface du monde.

Geofabrik propose deux types de données : gratuites qui contiennent l’ensemble des routes, des points d’intérêts et des polygones. Ainsi que des données payantes plus complètes, corrigées et plus 
facilement utilisables.

Il va peut être nécessaire d'utiliser une autre source de donnée OSM.
