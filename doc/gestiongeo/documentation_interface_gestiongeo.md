# Doc sur l'utilisation de gestiongeo

## Table des matières

1. [Historique](#historique)
2. [Utilisation de gestiongeo](#utilisationgestiongeo)
3. [Observation](#observation)

## Historique. <a name="historique"></a>

L'outil GestionGeo a été mis en place par Serge Hombert avec l'aide de Jérémy Renard (apprenti à la DSI) dans le but de gérer les paramètres des dossiers de l'UF Topographie et de mettre en relation un numéro de dossier avec son périmètre géographique.

## Utilisation <a name="utilisationgestiongeo"></a>

### Groupes d'utilisateurs

Il existe sur *dynmap* trois profils différents :

- consultant : utilisation pour visualiser les dossiers existants
- modificateur : utilisation pour créer des dossiers et les mettre à jour
- administateur : création de nouveaux comptes d'utilisateurs

GestionGeo est utilisé par plusieurs agents de la MEL :

- l'équipe des géomètres
  
  - pour créer des nouveaux dossiers suite à la réception de levés
  - pour pouvoir mettre à jour les tables **TA_LIG_TOPO_F** et **TA_POINT_TOPO_F**

- l'équipe des photos-interprète
  
  - pour créer des dossiers à l'intention des géomètres signalant des périmètres d'interventions
  - pour assurer un suivi de ces dossiers

Il avait été prévu de former les agents des UT à l'utilisation de gestiongeo pour leur permettre de créer des dossiers prévisionnels mais cela ne s'est pas concrétisé.

- structures extérieures:

  - EDF, GRDF par exemple, afin de vérifier la présence d'investigations complémentaires sur les zones couvertes par le territoire métropolitain.


## Application Dynmap

Le démarrage de l'application *dynmap* peut être long car celle-ci interroge les tables :

* **TA_LIG_TOPO_F**: géométrie ligne des éléments.
* **TA_POINT_TOPO_F**: géométrie point des éléments.
* **TA_GG_DOSSIER**: liste des dossiers en base et leurs attributs.
* **TA_GG_GEO**: table regroupant les périmètres des dossiers.
* **TA_POINT_TOPO_IC**: Table contenant les éléments ponctuels des investigations complémentaires (trappe à vantaux par exemple).
* **TA_LIG_TOPO_IC**: Table contenant les éléments linéaires des investigations complémentaires.

Les autres sources de lenteur sont :

- le téléchargement de la totalité des enregistrements pour ensuite convertir la géométrie en SVG

- Le passage par un niveau de requêtes MySQL traduites en requêtes Oracle

### 2.3. Fonction disponible sur *Dynmap*.

### Outils dans l'interface

Avant toute création de dossiers dans l'application, celle-ci prévoit plusieurs outils ergonomiques pour faciliter son utilisation.

Dans la barre d'outil, il est possible:

1. d'indiquer un géosignet.
2. de bénéficier d'informations.
3. revenir à la vue d'origine.
4. effectuer un zoom rectangle.
5. zoom avant.
6. zoom arrière.
7. outil règle en mètres.
8. calcul de surface qui donne les informations suivantes:
   - la longueur du segment.
   - le périmètres.
   - la surface en hectare.
9. gestion des couches visibles
   - **EST-IL POSSIBLE D'AVOIR UNE LISTE DES TABLES UTILISEES**

> Note : plutôt se concentrer ici sur quelles couches sont utilisées

![Illustration de la définition](images_gestiongeo/illustration_2_1.PNG)
*Figure n°1: Présentation de la barre d'outil des fonctions ergonomiques*

### Démarrage

#### Rechercher

La fonction **RECHERCHER** permet aux utilisateurs de rechercher un dossier suivant les éléments contenus dans sa *fiche dossier*:

* numéro: numéro **DOS_NUM**
* detail levé
* état
  * fiche prévisionnelle (travaux non terminé)
  * en attente du levé des géomètres(dossier actif/fin de travaux)
  * contrôle précision prestation géomètre
  * en attente de validation (mode topo)
  * Actif en base topo ; attente de validation gestion
  * Actif en base (dossier clôturé et donc visible en carto)
  * Rejeté - En attente de rechargement
  * Non valide
  * En attente (robot GTF)
* famille:
  * plan de recollement: plan qui décrit les travaux réellement effectués à la fin d'un chantier.
  * IC : Investigation complémentaire pour connaitre avec précision la localisation et la nature des réseaux souterrains situés sur la parcelle où des travaux s'effectuent.
  * MAJ carto : demande de modification par les utilisateurs (les photos-interprètes par exemple).
* remarque : seuil, nom rue (pour les dossiers ruraux), type de batiment, édifice public, immeuble, lotissement, permis de construire, dans les remarques, estimé la surface du polygone créer > aller sur qgis et modifier le polygone.
* voie: voie sur laquelle s'étend le dossier.
* commune: commune du dossier.
* maitrise d'ouvrage: maitre d'ouvrage des travaux (peut être différent du cabinet de géomètre).
* entreprise: Entreprise ou cabinet responsable des levés.
* date de création: date de création du dossier.

![Illustration de la définition](images_gestiongeo/illustration_2_3_1.PNG)
*Figure n°2: Interface de la fonction RECHERCHER*

#### Création

##### Ouverture d'un dossier

Trois actions principales déclenchent l'ouverture d'un dossier :

1. Les équipes du plan de gestion (photo-interprêtes) notifient après l'analyse des orthophotos une zone de fin de travaux. Un dossier prévisionnel est ouvert.
2. L'équipe des géomètres réceptionne un fichier suite à la concrétisation de travaux publics engagé par la MEL
3. Un autre service de la MEL demande un levé pour répondre à un besoin.

Le service a essayé de mettre en place un système d'alerte avec les UT pour que celles-ci puissent ouvrir de nouveaux dossiers prévisionnels quand des travaux ont lieux sur leurs territoires. Mais cette expérimentation ne s'est pas concrétisée.

![Illustration de la définition](images_gestiongeo/illustration_2_3_2_1.PNG)
*Figure n°3: Interface de la fonction CREATION*

##### Création d'un dossier

L'onglet **création** permet de créer un dossier qui va servir à intégrer les fichiers autocad *dwg* des relevés. Les dossiers peuvent être créés en avance. L'obtention d'un fichier *dwg* n'est pas obligatoire pour créer un dossier.

Plusieurs étapes sont nécessaires pour créer un dossier:

* indiquer un nom de rue : permet de localiser le dossier.
  * Si une rue existe dans plusieurs communes, plusieurs choix sont disponibles. Les noms des rues sont gérés par les données contenues dans la base voie, répertoire des voies agrégées.
* dessiner : dessiner un périmètre à la zone d'étendue du dossier.
* remplir sa fiche dossier :
  * auteur : acteur qui ouvre le dossier.
  * priorité : **PAS UTILISE**
  * famille :
    * plan de recolement : plan qui décrit les travaux réellement effectués à la fin d'un chantier.
    * IC : Investigation complémentaire
    * MAJ carto : demande de modification par les consultants (les photos-interprètes par exemple)
  * remarque : seuil, nom de la rue (pour les dossiers ruraux), type de batiment, edifice public, immeuble, lotissement, permis de construire, dans les remarques, estimé la surface du polygone créer
  * date travaux : si possible à partir du panneaux permis de construire.
  * commune: commune du dossier.
  * voie : voie sur laquelle s'étend le dossier.
  * maitrise d'ouvrage: maitre d'ouvrage des travaux (peut être différent du cabinet de géomètre).
  * entreprise : entreprise ayant fait le levé.
* créer le dossier : le dossier est créé.

Cet onglet permet de créer des dossiers qui sont à des stades de récolements différents. Si les données prochainement intégrées dépassent le périmètre, celui-ci est redessiné.

La création du dossier permet de générer un numéro de dossier. Comme le but d'un dossier est, à terme, d'intégrer en base un fichier *dwg* correspondant à un périmètre d'intervention, à chaque dossier correspond un seul fichier *dwg*. Dans le cas ou le géomètre doit intégrer plusieurs levés, plusieurs dossiers seront créés.

La création d'un dossier entraine la création d'un numéro de dossier (**ID_DOS ou DOS_ID**) dans la table **TA_GG_DOSSIER** et d'un **DOS_NUM** (champ de jointure dans les tables **TA_GG_DOSSIER** et **TA_GG_GEO**).

##### Les différents familles des dossiers

Chaque dossier peut être affecté à une famille thématique à sa création :

* plan de recolement: plan qui décrit les travaux réellement effectués à la fin d'un chantier.
* IC: une investigation complémentaire permet de connaitre avec précision la localisation et la nature des réseaux soutterains situés sur la parcelle ou des travaux s'effectuent.
* MAJ carto: demande de modification par les consultants (les photos-interprètes par exemple), pas utiliser, dossier dans lesquels il n'y aura pas d'intervention des géomètres.

Il n'est pas possible de modifier la famille d'un dossier via l'interface dynmap.

#### Intégration

##### Usage de l'onglet intégration

L'onglet intégration permet par l'intermédiaire d'un appel à GTF/FME :

1. d'importer dans les tables **TA_LIG_TOPO_GPS**, **TA_POINT_TOPO_GPS** les éléments contenus dans les fichiers *dwg* des relevés.
2. de créer le périmètre contenant les éléments du dossier dans la table **TA_GG_GEO** et déterminer un code **DOS_NUM** au dossier.
   * le code **DOS_NUM** est égal à la concaténation des deux derniers chiffres de l'année (sauf pour les années antérieures à 2010), du code INSEE sur 3 chiffres et d'une incrémentation sur quatre chiffres du nombre de dossier créé depuis le début de l'année. Ce code sert de champ de jointure entre les tables **TA_GG_GEO** et **TA_GG_DOSSIER**
   * le périmétre créé est un polygone résultant d'une enveloppe concave englobant les objets présents dans le fichier importé
3. copie les fichiers *dwg* sur infogeo aux emplacements
   * \\volt\infogeo\appli_gg\recol
   * \\volt\infogeo\IC

##### Comment intégrer le dossier

Pour intégrer les fichiers dans la base Oracle, il y a deux possiblités.

1. Intégrer les données dans un dossier existant à partir de l'onglet **récupérer un dossier existant** créé à partir de l'onget **CREATION**
2. Créer un dossier directement à cette étape pour intégrer les données *dwg*
3. Le choix opéré, la fiche du dossier va s'ouvrir et des informations vont être à compléter:
   * auteur du dossier.
   * choisir le fichier *dwg* à intégrer.
   * renseigner la projection.
   * famille.
   * dossier associé.
   * remarque.
   * date travaux.
   * renseigner un nom de rue pour attacher une localisation au dossier (plusieurs dossiers peuvent être attacher à une rue)
     * afin de determiner la localisation des fichiers *dwg* ces fichiers peuvent être chargés sur **ELYX**
   * Maitrise d'ouvrage
   * Entreprise
4. Soumettre le dossier

![Illustration de la définition](images_gestiongeo/illustration_2_3_3_2.PNG)
Figure n°4: Interface de la fonction INTEGRATION

##### Soumettre le dossier

Une fois le fichier du dossier soumis, une chaine de traitement **FME** va permettre d'intégrer en base les fichiers *dwg*. Les traitements sont réalisés sur la version 2016 de FME. Certains *transformers* ne sont plus compatibles avec la version 2018 du logiciel. Les traitements s'effectuent sur le serveur ***lmcu-fme-02***. La visualisation de la progession des traitement se fait par l'outil **GTF**.

Concrètement **FME** va:

* intégrer les objets ponctuels dans la table TA_POINT_TOPO_GPS.
* intégrer les objets linéraires dans la table TA_LIG_TOPO_GPS.
* copier les fichiers *dwg* renseignés dans le champ *choisir le fichier dwg à intégrer* sur infogeo (***infogeo/appli_gg/recol/***)

> A noter que FME peut remplacer le point de l'extension fichier par un tiret-bas. Dans ce cas là, il est possible de corriger cette erreur en modifiant l'extension des fichiers directement dans le répertoire infogeo/appli_gg/recol/XXX_dwg

##### Mise à jour d'un dossier

Une fois le dossier créé, les dossiers sont vérifiés par les géomètres. Les données sont vérifiées sur **ELYX** par les géométres. Si les données contenues dans les tables **TA_LIG_TOPO_GPS** et **TA_POINT_TOPO_GPS** après vérification sont bonnes, leurs attributs ***GEO_ON_VALIDE*** est mis à 0 et sont ainsi copiées dans les tables **TA_LIG_TOPO_F** et **TA_POINT_TOPO_F**.

##### Fiche dossier

La fiche dossier recense toutes les informations d'un dossier renseignées lors de la création de celui-ci et de ses mise à jour.

Cette fiche est accessible par l'intermédiaire de la fenêtre de visualisation des dossiers, en cliquant sur son périmètre:

| CHAMP                         | SIGNIFICATION                                                                                                                                                      | EXEMPLE                                                                                                          |
|:----------------------------- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------ |:---------------------------------------------------------------------------------------------------------------- |
| Auteur                        | créateur du dossier                                                                                                                                                | fnaerhuysen                                                                                                      |
| Etat                          | état d'avancement du dossier                                                                                                                                       | Actif en base topo ; attente de validation gestion.                                                              |
| Famille                       | type de dossier                                                                                                                                                    | Plan de recolement                                                                                               |
| Dossier associé               | indique le numéro d'un dossier si celui-ci a été relevé en même temps que le dossier concerné par la fiche. Souvent ce dossier est indiqué dans le champ remarque. |                                                                                                                  |
| Remarque                      | Observation liées au dossier                                                                                                                                       | 144-146-148 rue du haut vinage plus nouveaux batis - voirien de ALL MANET LIAISON HAUT VINAGE à RUE LEON JOUHAUX |
| Date travaux                  | Date d'étendue des travaux                                                                                                                                         | Du 12/02/2013 au 16/04/2014                                                                                      |
| Date commande                 | Date de création du dossier                                                                                                                                        | 22/01/2018                                                                                                       |
| Détail levé                   | Remarque sur la levé                                                                                                                                               | Issue de la base chantier                                                                                        |
| Date levé                     | Date du levé                                                                                                                                                       | --- au 07/06/2018                                                                                                |
| Voie                          | Rue sur laquelle s'étend le dossier                                                                                                                                | 6460700 RUE DU HAUT VINAGE                                                                                       |
| Commune                       | Commune du dossier                                                                                                                                                 | 59646 WASQUEHAL                                                                                                  |
| Maitrise d'ouvrage            | Responsable des travaux                                                                                                                                            | MEL                                                                                                              |
| Entreprise                    | bureau, cabinet qui a réalisé le levé                                                                                                                              | UF Cartographie des territoires                                                                                  |
| Ancien ID                     | ancien numéro du dossier                                                                                                                                           | 1385231                                                                                                          |
| Etat GTF                      | état de l'intégration FME                                                                                                                                          | Validé                                                                                                           |
| Pièce(s) attaché(s) (8Mo max) | fichier ***dwg*** attaché au dossier                                                                                                                               | 136460231.dwg                                                                                                    |

![Illustration de la définition](images_gestiongeo/illustration_2_3_3_5.PNG)
*Figure n°5: Interface de la fiche dossier*

##### Les outils disponibles

L'interface de la fiche du dossier permet plusieurs actions :

1. localiser le dossier sur la carte
2. editer les informations du dossier
3. invalider le dossier
4. estimer le cout d'un levé: outil utilisable seulement quand le dossier est de type: *en attente de levé géomètre*.

##### 2.3.3.6. les différents état des dossiers. (voir les codes dans TA_GG_ETAT

| Etat                                                      | Etat id | Couleur    | Signification                                                                                                                                                              |
|:--------------------------------------------------------- |:------- |:---------- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fiche prévisionnelle (travaux non terminé)                | 5       | jaune      | Etat à l'ouverture du dossier                                                                                                                                              |
| En attente de levé géomètre(dossier actif/fin de travaux) | 2       | vert clair | Les travaux sont terminés pret à être relevés                                                                                                                              |
| Contrôle précision prestation géomètre                    | 3       |            | Controle de prestation                                                                                                                                                     |
| En attente de validation (mode topo)                      | 7       | violet     | Il y a un plan dans les tables GPS, mais il faut vérifier ce qui a été levé. Une fois cette vérification faite, les éléménts sont copiés dans les tables des éléments fin. |
| Actif en base topo ; attente de validation gestion        | 0       | vert foncé | L'es 'équipes du plan de gestion va modifier les couches **TA_SUR_TOPO_G** en fonction de l'état de la table niveau fin mise à jour                                        |
| Actif en base (dossier clôturé et donc visible en carto)  | 9       | bleu       | Les tables sont mises à jour                                                                                                                                               |
| Rejeté - En attente de rechargement                       | 8       |            | Les éléments n'ont pas été chargé en base. FME envoit à dynmap un code erreur. il va également modifier le code état des tables GPS.                                       |
| Non valide                                                |         |            | orange                                                                                                                                                                     |
| En attente (robot GTF)                                    |         |            | en cours de traitement par FME                                                                                                                                             |

Les trois derniers états ne sont pas utilisés, ils ne sont pas implémentés dans l'application.

##### Clôture du dossier.

Suite à la vérification des géomètres, les dossiers et les données intégrées sont vérifiés par les photos-interprêtes pour s'assurer de leurs calages avec la table **TA_SUR_TOPO_G**. La table **TA_SUR_TOPO_G** s'appuie sur la table **TA_LIG_TOPO_F**.

Après cette dernière phase de vérification les dossiers sont clôturés (l'état *"dossier clôturé et donc visible en carto"*). La responsable de la clôture des dossiers pour l'UF est G.Dartois. Clôturer un dossier signifie le passer à l'état **Actif en base (dossier clôturé et donc visible en carto)**

#### Dossiers

Cet icône, permet de paramétrer l'affichage des dossiers que l'on a soi-même créés et qui ne sont pas en état "*Actif en base (dossier clôturé et donc visible en carto)*". Deux champs sont aussi disponibles pour paramétrer cet affichage :

* le premier pour fixer le nombre d'éléments qui s'affichent sur la fenêtre.
* le second pour restreindre le nombre suivant une expression.

![Illustration de la définition](images_gestiongeo/illustration_2_3_4.PNG)
*Figure n°6: Interface de la fonction DOSSIER*

#### Validation

Tableau de bord des dossiers à valider.

> Note : pas plus de détails ?

#### Utilisateurs

Cet onglet permet de connaitre les utilisateurs de GestionGeo et pour les administrateurs de l'application d'éditer les profils.

### Gestion des investigations complémentaires.

Une investigation complémentaire est réalisée pour tous les travaux réalisés sur une surface de plus de 100m² s'il y a un terrassement de la chaussée sur plus de 10cm. Le but d'une investigation complémentaire est de connaitre avec précision la localisation des réseaux enfouis(éléctricité, eau, assainissement, métro, télécommunication...)

Une première configuration des réseaux est donnée lors de la DICT. Cependant si la précision des plans n'est pas satisfaisant une IC est demandée. L'IC permet d'obtenir les emplacements des réseaux avec une précision de catégorie A(précision inférieur à 40 cm)

La MEL est dans l'obligation de fournir à chaque entreprise réalisant des travaux, la localisation précise des réseaux sensibles. Mais il y a un interêt de faire ces IC sur les autres réseaux

> par exemple : bouche d'égout. cuvette qui descent et aucun reseau ne peut la traverser. Donc il y a un interêt à connaitre les reseaux alentours.

#### Ouverture d'un dossier IC

L'ouverture d'un dossier est réalisé suite à l'obtention de la part du maitre d'ouvrage: La MEL, par l'intermédiaire des services qui réalisent des travaux: assainissement, voirie, energie, d'une copie des IC réalisées dans le cadre de leur travaux.

#### Utilisation d'autocad pour contrôler les plans

Avant d'intégrer les plans par l'intermédiaire de GestionGeo les plans sont controlés sur *Autocad* pour vérifier :

* que chaque réseau est dans son propre calque autocad 
* que chaque réseau à un identifiant présent dans la liste des réseaux contenues dans la ***charte topographique et réseaux de la DSIG***.
* que les polylignes des réseaux de classe **A** doivent avoir une donnée **Z**. Les seuls réseaux qui n'ont pas de réseaux Z sont les réseaux AR(déjà connus)
* Vérifier la projection du dossier:
  * LAMBERT 1 (27561)
  * LAMBERT 93 CC50 (3950)
  * LAMBERT 93 FRANCE (2154)
  * LAMBERT 2 (27572)
  * WGS84 - GPS (4326)

En cas de correction, un nouveau fichier *dwg* va devoir être créé. C'est ce fichier qui faudra intégrer en base.

#### Intégration des investigations complémentaire

L'intégration des IC se fait à partir de l'onglet **INTEGRATION** sur le même principe que pour les plans de recolements. A la différence que pour les IC il faut sélectionner la famille **INVESTIGATION COMPLEMENTAIRE**.

Pour un nouveau dossier :

* auteur: Créateur du dossier
* choix du fichier: choisir le fichier *dwg* à intégrer
* le champ Pièce(s) jointe(s) **ne fonctionne pas**
* famille: investigation complémentaire
* dossier associé: **PEU UTILISE**
* remarque: Informations diverses sur le dossier, rue, seuil, type de batîment...
* date des travaux: date des travaux qui ont nécessité la création de l'investigation
* voie: voie sur laquelle s'étend l'IC
* commune: commune sur laquelle s'étend l'IC
* maitrise d'ouvrage: maitre d'ouvrage. La MEL
* entreprise: entreprise responsable du levé.

Il est également possible de récupérer un dossier existant.

#### Soumettre le dossier

La soumission du dossier entraine plusieurs conséquences :

* un messsage validant la soumission apparait dans une fenêtre
* un numéro de ID_DOS est créer dans la table **TA_GG_DOSSIER**
* un DOS_NUM est également associé au dossier. Ce numéro fait le lien entres les tables **TA_GG_DOSSIER** et **TA_GG_GEO**
* un traitement FME intègre les éléments en base
* le fichier*dwg* est copié dans le dossier **infogeo/appli_gg/ic**

#### Vérification.

Il s'agit de vérifier visuellement que l'intégration s'est bien déroulée, que l'outil a intégré tous les réseaux du fichier *dwg* dans la bonne charte graphique determinée dans le document ***charte topographique et réseaux de la DSIG***..

#### Mise à jour.

Une fois la vérification réalisée, il faut revenir sur la fiche du dossier afin de mettre à jour des éléments que l'on ne peut pas renseigner lors de la création du dossier:

* ajout de la date du levé (pas importante, il est juste nécessaire d'avoir une date approximative).
* modifier l'état du dossier de *en attente de validation(mode topo)* à *actif en base(dossier cloturé et donc visible en carto).*
* le champ *piece(s) jointe(s)* de l'onglet **DOSSIER** ne fonctionne pas. Il est nécessaire de copier manuellement le rapport du dossier dans le dossier **infogeo/appli_gg/ic**. A la livraison les plans *dwg* peuvent être accompagné de plusieurs fichiers. Seul le rapport est gardé.
* Copier les fichiers *dwg* d'origines dans **infogeo/IC/** pour garder une trace des données livrées par l'entreprise.

#### Demande

Une demande a été formulée pour améliorer l'intégration des IC:

* Est il possible de créer un outil pour controler les réseaux intégrer et vérifier qu'il soit dans la ***charte topographique et réseaux de la DSIG***.

## Observation. <a name="Observation"></a>

Plusieurs icônes ne sont pas utilisé :

* Les fonctions proposées par l'onglet **DOSSIERS** ne sont pas utilisées.
* le champ **PRIORITE** proposé dans l'onglet **CREATION** et **INTEGRATION**
