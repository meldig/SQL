# dynmap gestiongeo.

## Table des matières
1. [Historique](#historique)
2. [Utilisation de gestiongeo](#utilisationgestiongeo)
3. [Observation](#observation)

## 1. Historique. <a name="historique"></a>

L'outil gestiongeo a été mise en place par Serge Hombert avec l'aide d'un apprenti et la DSI dans le but de développer un outil qui permet de gérer les paramètres des dossiers et de mettre en relation un numéro de dossier avec son périmètre.

Il existe sur *dynmap* trois profils différents:
* consultant: utilisation de *dynmap* pour visualiser les dossiers existants.
* modificateur: utilisation de *dynmap* pour créer des dossiers et les mettre à jour.
* administateur: création de nouveaux profils.

*Dynmap* est utilisé par plusieurs agents de la MEL:
* l'équipe des géomètres: pour créer des nouveaux dossiers et mettre à jour les bases TA_LIG_TOPO_F et TA_POINT_TOPO_F.
* l'équipe des photos-interprète: pour créer des dossiers de vérification à l'attention des géomètres.
* il a été prévu de former les agents des UT à l'utilisation de *gestiongeo* pour leur permettre de créer des dossiers prévisionnels mais cela ne s'est pas concrétisé.

## 2. Utilisation de gestiongeo. <a name="utilisationgestiongeo"></a>

## 2.1. Ergonomie.

Avant toute création de dossier dans l'application, celle-ci prévoit plusieurs outil ergonomique pour faciliter son utilisation. 

dans la barre d'outil, il est possible:
1. d'indiquer un géosignet.
2. de bénificer d'information.
3. revenir à la vue d'origine.
4. effectuer un zoom rectangle.
5. zoom avant.
6. zoom arrière.
7. outil rêgle en mètre.
8. calcul de surface qui donne les informations:
	* la longueur du segment.
	* le périmètres.
	* la surface en hectare.
9. gestion des couches
	* **EST-IL POSSIBLE D'AVOIR UNE LISTE DES TABLES UTILISES**

###### Figure n°1: Présentation de la barre d'outil des fonctions ergonomiques
![Illustration de la définition](images_gestiongeo/Illustration_2_1.png)

### 2.2. Ouverture de gestiongeo.

Le démarrage de l'application *dynmap* peut être long car celle-ci  interroge les tables:
* **TA_LIG_TOPO_GPS**: géométrie ligne des éléments.
* **TA_POINT_TOPO_GPS**: géométrie point des éléments.
* **TA_GG_DOSSIER**: liste des dossiers en base et leurs attributs.
* **TA_GG_GEO**: table regroupant les périmètres des dossiers.

### 2.3. Fonction disponible sur *Dynmap*.

#### 2.3.1. Rechercher:

La fonction **RECHERCHER** permet aux utilisateurs de rechercher un dossier suivant les éléments contenus dans sa *fiche dossier*:
	* numéro: numéro **DOS_NUM**
	* detail levé:
	* état:
		* fiche prévisionnelle (travaux non terminé)
		* en attente de levé géomètre(dossier actif/fin de travaux)
		* contrôle précision prestation géomètre
		* en attente de validation (mode topo)
		* Actif en base topo ; attente de validation gestion
		* Actif en base (dossier clôturé et donc visible en carto)
		* Rejeté - En attente de rechargement
		* Non valide
		* En attente (robot GTF)
	* famille:
		* plan de recollement: plan qui décrit les travaux réellement effectués à la fin d'un chantier.
		* IC: Investigation complémentaire
		* MAJ carto: demande de modification par les consultants (les Unités Territoriales par exemple)
	* remarque: seuil, nom rue(pour les dossiers ruraux), type de batiment, edifice public, immeuble, lotissement, permis de construire, dans les remarques, estimé la surface du polygone créer > aller sur qgis et modifier le polygone
	* voie: voie sur laquelle s'étend le dossier.
	* commune: commune du dossier
	* maitrise d'ouvrage: qui est le maitre d'ouvrage des travaux (peut être différent du cabinet de géomètre)
	* entreprise: Entreprise ou cabinet des levés
	* date de création: date de création du dossier

###### Figure n°2: Interface de la fonction RECHERCHER
![Illustration de la définition](images_gestiongeo/Illustration_2_3_1.png)

#### 2.3.2. Création.

##### 2.3.2.1. Ouverture d'un dossier.

Deux actions principales qui déclenchent l'ouverture d'un dossier:
1. Les équipes du plan de gestion (photos-interprête) notifient après l'analyse des orthophotos une zone de fin de travaux. Un dossier prévisionnel est ouvert
2. L'équipe des géomètres réceptionne un fichier suite à la concrétisation de travaux publics engagé par la MEL
Le service à essayer de mettre en place un système d'alerte avec les UT pour lors de leurs travaux sur le terrain de relevé les zones en travaux afin de déclencher des ouvertures de dossier mais cette expérimentation ne s'est pas concrétisée.

###### Figure n°3: Interface de la fonction CREATION
![Illustration de la définition](images_gestiongeo/Illustration_2_3_2_1.png)

##### 2.3.2.2. Création d'un dossier.

L'onglet **création** permet de créer un dossier qui va servir à intégrer les fichiers autocad *dwg* des relevés. Les dossiers peuvent être créés en avance. L'obtention d'un fichier *dwg* n'est pas obligatoire pour créer un dossier. 
Plusieurs étapes sont nécessaires pour créer un dossier:
* indiquer un nom de rue: permet de localiser le dossier. Si une rue existe dans plusieurs communes, plusieurs choix sont disponibles. Les noms de rues sont gérés par la base  voie, répertoire des voies agrégées.
* dessiner: dessiner un périmètre à la zone d'étendue du dossier.
* remplir sa fiche dossier:
	* auteur
	* priorité (pas utilisé)
	* famille:
		* plan de recollement: plan qui décrit les travaux réellement effectués à la fin d'un chantier.
		* IC: Investigation complémentaire
		* MAJ carto: demande de modification par les consultants (les Unités Territoriales par exemple)
	* remarque: seuil, nom rue(pour les dossiers ruraux), type de batiment, edifice public, immeuble, lotissement, permis de construire, dans les remarques, estimé la surface du polygone créer > aller sur qgis et modifier le polygone
	* date travaux: si possible à partir du panneaux permis de construire
	* commune: commune du dossier
	* voie: voie sur laquelle s'étend le dossier.
	* maitrise d'ouvrage:
	* entreprise:
* créer le dossier: le dossier est créé.
Cela permet de créer des dossiers qui sont à des stades de recollements différents. Si les données prochainement intégrées dépassent le périmètre, celle-ci est redessinée.

La création du dossier permet de générer un numéro de dossier. Comme le but d'un dossier et d'intégrer en base un fichier **dwg** correspondant à une observation, a chaque dossier correspond un seul fichier, dans le cas ou le géomètre doit intégrer plusieurs levés, plusieurs dossiers seront créés.

##### 2.3.2.3. Les différents type des dossiers.


#### 2.3.3. Intégration

##### 2.3.3.1. Que permet de faire l'onglet intégration.

L'onglet intégration permet par l'intermédiaire de FME:
1. d'intégrer dans les tables **TA_LIG_TOPO_GPS**, **TA_POINT_TOPO_GPS** les éléments contenus dans les fichiers *dwg* des relevés.
2. créer un numéro de dossier (**ID_DOS**) dans la table **TA_GG_DOSSIER**
3. créer le périmètre contenant les éléments du dossier dans la table **TA_GG_GEO** et déterminer un code **DOS_NUM** au dossier.
	* le code **DOS_NUM** est égal à la concaténation des deux digits de l'année, du code INSEE sur 3 chiffres et d'une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l'année.
4. copie des fichiers *dwg* sur infogeo** à l'emplacement **infogeo/appli_gg/recol/**

##### 2.3.3.2. Comment intégrer le dossier.

Pour intégrer les fichiers dans la base Oracle il y a deux possiblités.
1. Intégrer les données dans un dossier existant à partir de l'onglet **récupérer un dossier existant** créé à partir de l'onget **CREATION**
2. Créer un dossier directement à cet étape pour intégrer les données *dwg*
3. Le choix opéré, la fiche du dossier va s'ouvrir et des informations vont être à compléter:
	* auteur du dossier
	* choisir le fichier *dwg* à intégrer,
	* renseigner la projection
	* famille
	* dossier associé
	* remarque
	* date travaux
	* renseigner un nom de rue pour attacher une localisation au dossier (plusieurs dossiers peuvent être attacher à une rue)
		* afin de determiner la localisation des fichiers *dwg* ces fichiers sont projetés sur **ELYX**
	* Maitrise d'ouvrage
	* Entreprise
4. Soumettre le dossier

###### Figure n°3: Interface de la fonction INTEGRATION
![Illustration de la définition](images_gestiongeo/Illustration_2_3_3_2.png)

##### 2.3.3.3. Soumettre le dossier.

Une fois le dossier soumis, une chaine de traitement **FME** va permettre d'intégrer en base les fichiers *dwg*. Les traitements sont réalisés sur la version 2016 de FME. Certains transformer ne sont plus compatibles avec la version 2018. Les traitements sont sur le serveur *lmcu-fme-02*. La visualisation de la progession des traitement est réalisée sur l'outil **GTF****(devellopé par Veremes?)**
Concrètement **FME** va:
* intégrer les objets ponctuels dans la table TA_POINT_TOPO_GPS.
* intégrer les objets linéraires dans la table TA_LIG_TOPO_GPS.
* copier les fichiers *dwg* sur infogeo (***infogeo/appli_gg/recol/***)
* **A noter que FME peut remplacer le point de l'extension fichier par un tiret-bas. Dans ce cas là, il est possible de remplacer Mais les *dwg* sont sauvegardeés sur infogeo/appli_gg/recol/ pour changer le _ en ..**

##### 2.3.3.4. Mise à jour d'un dossier.

Une fois le dossier créé, les dossiers sont vérifiés par les géomètres. Les nouvelles données sont intégrés par l'intermédiaire de l'ongle **intégration**. Les données sont liées au code du dossier cela signifie qu'à la mise à jour toutes les anciennes données sont supprimés. L'état du dossier est à modifier manuellement sur la fiche dossier. Les données sont alors insérées dans deux tables:
* **TA_LIG_TOPO_F**
* **TA_POINT_TOPO_F**

##### 2.3.3.5. Fiche dossier.

La fiche dossier recense toute les informations d'un dossier renseignées lors de la creation de celui-ci et de sa mise à jour. Cette fiche est accessible par l'intermédiaire de la fenetre de visualisation des dossiers, en cliquant sur son périmètre:

|CHAMP|SIGNIFICATION|EXEMPLE|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|Auteur|créateur du dossier|fnaerhuysen|
|Etat|état d'avancement du dossier|	Actif en base topo ; attente de validation gestion.|
|Famille|type de dossier|Plan de récolement|
|Dossier|indique le numéro d'un dossier si celui-ci à été relévé en meme temps que le dossier concerné par la fiche. Souvent ce dossier est indiqué dans le champ remarque.|144-146-148 rue du haut vinage
plus nouveaux batis - voirien de ALL MANET LIAISON HAUT VINAGE à RUE LEON JOUHAUX|
|Remarque|Observation liées au dossier|Clé étrangère vers la table TA_METADONNEE pour connaitre la source et le millésime de la donnée.|
|Date travaux|Date d'étendue des travaux|Du 12/02/2013 au 16/04/2014|
|Date commande|Date de création du dossier|22/01/2018|
|Détail levé|Remarque sur la levé|Issue de la base chantier|
|Date levé|Date du levé|--- au 07/06/2018|
|Voie|Rue sur laquelle s'étend le dossier|6460700 RUE DU HAUT VINAGE|
|Commune|Commune du dossier|59646 WASQUEHAL|
|Maitrise d'ouvrage|Responsable des travaux|MEL|
|Entreprise|bureau, cabinet qui a réalisé le levé|UF Cartographie des territoires|
|Ancien ID|ancien numéro du dossier|1385231|
|Etat GTF|état de l'intégration FME|Validé|
|Pièce(s) attaché(s) (8Mo max)|fichier ***dwg*** attaché au dossier|136460231.dwg|

##### 2.3.3.6. les différents état des dossiers.

|Etat|Couleur|Signification|
|:----------|:-----|:-------------------------------------------------------------------------------------------------------------|
|Fiche prévisionnelle (travaux non terminé)|jaune|
|En attente de levé géomètre(dossier actif/fin de travaux)|vert clair|
|Contrôle précision prestation géomètre|
|En attente de validation (mode topo)|violet|
|Actif en base topo ; attente de validation gestion|vert foncé|
|Actif en base (dossier clôturé et donc visible en carto)|bleu|
|Rejeté - En attente de rechargement|
|Non valide|
|En attente (robot GTF)|

##### 2.3.3.7. Cloture du dossier.

Suite à la vérification des géomêtres, les dossiers sont vérifiés par les photos-interprêtes pour vérifier leurs calages avec la table **TA_SUR_TOPO_G**. La table **TA_SUR_TOPO_G** s'appuie sur la table **TA_LIG_TOPO_F**. Après cette dernière phase de vérification les dossiers sont cloturés(dossier cloturé et donc visible en carto). La responsable de la cloture des dossiers est G.Dartois.

#### 2.3.4. Dossiers.

Cet icône, permet de paramétrer l'affichage des dossiers visible sur la fenètre. Deux champs sont aussi disponibles pour parametrer cet affichage:
* le premier pour fixer le nombre d'éléments qui s'affichent sur la fenètre.
* le second pour restreindre le nombre suivant une expression.

###### Figure n°4: Interface de la fonction DOSSIER
![Illustration de la définition](images_gestiongeo/Illustration_2_3_4.png)

#### 2.3.5. Validation.

Cette icone permet de connaitre les dossiers créer par les UT et à valider le cas échéant. Il permet aussi de connaitre les dossiers rejetés. Les UT peuvent créer des dossiers afin de mettre à jour des éléments qu'ils relèvent. Cette fonction n'est plus plus utilisés.

#### 2.3.6. Utilisateurs.

Cette onglets permet de connaitre les utilisateurs de ***gestiongeo*** et pour l'administrateur de l'application d'éditer ces profils.

### 2.4. Gestion des investigations complémentaires.


## 3. Observation. <a name="Observation"></a>

Plusieurs icone ne sont pas utilisé:
* Les fonctions proposées par l'onglet **DOSIER** ne sont pas utilisé.
* le champ **PRIORITE** proposé dans l'onglet **CREATION** et **INTEGRATION**