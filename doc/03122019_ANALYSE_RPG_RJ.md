# LE REGISTRE PARCELLAIRE GRAPHIQUE

## INFORMATION GENERALE

Le registre parcellaire graphique est une base de données géographiques servant de référence à l'instruction des aides de la politique agricole commune (PAC).

Le système de projection utilisé est en métropole : (RGF93) projection Lambert-93

### Diffusion et droits

Le RPG est une œuvre collective dont la propriété intellectuelle est partagée entre l’ASP et le ministère de l’Agriculture, de l’Agroalimentaire et de la Forêt (MAAF). Dans le cadre de l’application de la directive européenne INSPIRE, la diffusion par l’ASP des données du RPG peut être réalisée suivant 3 niveaux d’information et d’anonymisation. Source ASP

* Niveau 1: ANONYME. Les données ne sont accompagnées d’aucun identifiant. Il n’est pas
possible d’assembler les îlots d’une même exploitation. Ce niveau est accessible au grand
public pour toute réutilisation.
* Niveau 2: NON ANONYME parce que comportant, pour chaque îlot, l’identifiant PACAGE de
l’exploitation ainsi que la forme juridique de celle-ci. Il est alors possible de regrouper les îlots d’une même exploitation. Le niveau 2 est accessible aux administrations visées au titre de
l'article L 300-2 du CRPA (État, collectivités, établissements publics et à toute structure privée chargée d’une mission de service public, pour l’exercice de cette mission).
* Niveau 2+: NON ANONYME AVEC DONNÉES INDIVIDUELLES, il s’agit du niveau 2 auquel
est ajouté une fiche comportant tous les éléments personnels de l’exploitant. La liste de ces
informations est fournie en annexe. Le niveau 2+ n’est accessible qu’aux services de
l’État.

#### Article L 300-2 du CRPA
Sont considérés comme documents administratifs, au sens des titres Ier, III et IV du présent livre, quels que soient leur date, leur lieu de conservation, leur forme et leur support, les documents produits ou reçus, dans le cadre de leur mission de service public, par l'Etat, les collectivités territoriales ainsi que par les autres personnes de droit public ou les personnes de droit privé chargées d'une telle mission. Constituent de tels documents notamment les dossiers, rapports, études, comptes rendus, procès-verbaux, statistiques, instructions, circulaires, notes et réponses ministérielles, correspondances, avis, prévisions, codes sources et décisions.

### Numéro PACAGE

Il s'agit de l'identifiant de l'exploitation. Associée à ce numéro se trouve la fiche d’identité de l'exploitation (Nom, Adresses, Téléphones, Références bancaires, Associés dans le cadre de société…). Il est indispensable dans toutes les démarches auprès de la DDT.

### Format des données

Les données sont délivrées au format *shapefile*
Les données sont délivrées au format *shapefile* et *excel*

## ARCHITECTURE DES DONNEES AU SEIN DE LA BASE

### Information sur la localisation des données du RPG dans la base de données.

Les données de la base sont présentes dans plusieurs schémas de la base de données

* G_ADT_AGRI sur le serveur CUDLT
* G_ADT_AGRI sur le serveur CUDL

### Présentation des données disponibles sur le schéma G_ADT_AGRI

Plusieurs millésimes du RPG sont déjà disponibles sur la base de données:

* *RPG_2011_059* avec les colonnes: _OBJECTID_, _NUM_ILOT_, _CULT_MAJ_, _GEOM_
* *RPG_2012_059* avec les colonnes: _OBJECTID_, _NUM_ILOT_, _CULT_MAJ_, _GEOM_
* *RPG_2016_MEL_ENUM* avec les colonnes: _CODE_CULT_, _LIB_CULT_, _CODE_GRP_CULT_, _LIB_GRP_CULT_
* *RPG_MEL_2016* avec les colonnes: _OBJECTID_, _ID_PARCEL_, _SURF_PARC_, CODE_CULTU, _CODE_GROUP_, _CULTURE_D1_, CULTURE_D2, GEOM
* *RPG_2014_MEL_2016* avec les colonnes: _ID_0_, _NUM_ILOT_, _CDE_EXPL_, _ODS_SIMPL_, _PROXI_, _DRAINAGE_, _IRRIGATION_, _OP_, _ENJ_PROD_, _LIB_PROD_, _EPCI_, _AREA_, _OBJECTID_, _GEOM_

OBSERVATION: pourquoi y-a-t-il deux dates dans le nom du fichiers *RPG_2014_MEL_2016*?

## Demande du RPG

Suivant le niveau demandé, la demande du RPG ne se fait pas auprès de la même structure:
* niveau 1: IGN
* niveau 2 et niveau 2+: DRAAF (direction régionale de l'agriculture, de l'alimentation et de la forêt)

La demande est a réalisé à l'aide d'un formulaire de demande d'une extraction du registre parcellaire graphique (RPG).

### Responsabilité de l'utilisateur de la données

Plusieurs remarques peuvent être faites suite à la lecture de ce document:
* Le demandeur est le responsable du traitement au sens du RGPD. Le responsable du
traitement doit identifier et classer les données à caractère personnel qu’il détient et respecter
toutes les obligations qui lui incombent en vertu du RGPD, et notamment :
** obligation d'information des personnes concernées sur les traitements réalisés (article 14)
** sous-traitance encadrée (article 38)
** tenue d'un registre de traitement (article 28).
* Le périmètre géographique de communication des données du RPG doit correspondre strictement au périmètre sur lequel le demandeur est compétent pour l’exercice de la mission de service public motivant la demande. En cas de nécessité, une zone tampon pourra être ajoutée à la zone demandée. Le demandeur donnera un descriptif textuel (liste de départements ou de communes au format CSV) ou géographique (format SIG) de la zone géographique correspondant à sa demande.
* Seules les données relatives à une campagne PAC achevée (au sens où les décisions sur les
montants d’aide sont prises) peuvent être diffusées. Concrètement, le RPG d’une année N ne
sera disponible que dans le courant de l’année N+1.
* Le RPG est composé d’éléments graphiques (îlots, parcelles culturales,...). Ces éléments
graphiques sont accompagnés de données attributaires, extraites du SIGC, sous forme de
tables alphanumériques décrites en annexe. L’ensemble sera désigné, dans la suite de la
présente note, sous le sigle RPG.
* Le demandeur s’engage à n’utiliser les données du RPG que dans le cadre et pour l’exécution
d’une mission de service public. Le demandeur s’engage à inscrire les traitements réalisés
avec les données du RPG dans son registre des traitements de données à caractère
personnel.

### Réserves d'utilisation

Le RPG permet de connaître la localisation et certaines caractéristiques des parcelles et îlots des exploitants agricôles ayant déposé une déclaration en vue d'une aide de la PAC (Politique Agricole Commune).

Limite d'usage: Le RPG doit être manié avec prudence pour les analyses du foncier agricole (évolution, morcellement, accessibilité, etc.) car l'image donnée par le RPG est approximative:
* il manque des surfaces agricoles (surface des exploitations non aidées par exemple);
* ces manques ne sont pas les mêmes d'une année sur l'autre (évolution des aides, surfaces non déclarées pour une raison relative à la vie d'une exploitation, projet d'aménagement commencé puis différé,...);
* le dessin d'un îlot donné peut être modifié par l'exploitant alors même qu'il n'y a aucun changement sur le terrain.

## Reception des données

Les données ont été réceptionnées le 3 janvier 2020.

Celles-ci sont composées de plusieurs tables:
* aides1erpilier2018: table excel sans clé primaire qui nous renseigne sur les droits de paiement de base ainsi que le montant unitaire des des paiement de base par année. Par rapport au formulaire de demande des données de la DRAAF il manque le montant net payé total numérique.
* aides2018_2ndpilier: table excel sans clé primaire nous renseignant sur le financeur de l'aide, le montant net payé dans le cadre de l'assurance récolte,
et le montant net total. Contrairement au formulaire de demande des données de la DRAAF il manque les montants nets payés des ICHN(indemnité compensatoire de handicaps naturels)
* ilots2018_description: table excel sans clé primaire conforme au formulaire de demande de la DRAAF. Table excel contenant les colonnes *pacage*, *num_ilot* et *COMMUNE_ILOT*
* pacage2018_formejuridique: table excel sans clé primaire qui nous renseigne sur la forme juridique de l'exploitation par numéro de pacage. Conforme à la table *exploitants* du formulaire de demande des données de la DRAAF.
* parcelles_instruites_2018: table excel sans clé primaire. Contrairement au formulaire de demande des données de la DRAAF il manque les deux colonnes *catégorie culture principale* et la colonne *commercialisation culture*.
* rpg2018_mel: reprend les informations de la table parcelles_instruites_2018. Ajoute la géométrie à ces informations. Une différence est à notée dans cette table nous avons dep_ilot alors que dans la table parcelles_instruites_2018 nous avons commune_ilot.
* maec2018_graphiques_surfaciques: manque le référentiel national et les caractéristiques des mesures agro-environnementales et climatiques et le montant des aides correspondantes.

## Analyse des données

sont liés entre eux par la clé pacage. Cepentant celle-ci ne peut pas servir de clef primaire. La clé pacage est en effet redondante dans les différentes tables et il n'y a pas le même nombre de pacages suivant les tables.

### Analyse des numéros de pacage

* aides1erpilier2018: 750 numéros de pacage différents
* aides2018_2ndpilier: 154 numéros de pacage différents
* ilots2018_description: 756 numéros de pacage différents
* maec2018_graphiques_surfaciques: 6 numéros de pacage différents
* pacage2018_formejuridique: 750 numéros de pacage différents
* parcelles_instruites_2018: 756 parcelles_instruites_2018
* rpg2018_mel: 756 parcelles_instruites_2018

il n'y a pas de différence de numéro de pacage entre les tables parcelles_instruites_2018 et rpg2018_mel.
6 numéro de pacage ne sont pas concernés par les aides 1er pilier.
pacage
059023425
059023605
059161659
059165925
059165928
059166518

6 numéro de pacage n'ont pas de forme juridique
pacage
059023425
059023605
059161659
059165925
059165928
059166518

ces 6 numéros de pacage totalisent 55 ilots réparties sur 29 parcelles réparties sur 7 communes:59339,59611,59090,59352,59482,59317,59252

### Reflexion sur les tables des aides piliers

#### Aides premier pilier:

Les aides liées au premier pilier sont depuis 2014 versée en trois parties:  le paiement de base, appelé DPB (droit au
paiement de base), le paiement vert et le paiement redistributif.

* Le paiement "de base" est versé en fonction des surfaces détenues pas les agriculteurs.
* Le «  paiement vert  », ou verdissement, est un paiement
direct aux exploitants agricoles de métropole* qui vise à
rémunérer des actions spéciȴques en faveur de l’environnement et contribue à soutenir leurs revenus. Il impose
le respect par un grand nombre d’exploitants de mesures
similaires, contribuant par leur e΍ort de masse globale à
améliorer la performance environnementale de l’agriculture
en termes de biodiversité, de protection de la ressource en
eau et de lutte contre le changement climatique.
* Le paiement redistributif est un paiement découplé, d’un
montant ȴxe au niveau national, payé en complément
des DPB de l’exploitation, dans la limite de 52 hectares
par exploitation.
Il permet de valoriser les productions à forte valeur ajoutée
ou génératrices d’emploi, qui se font sur des exploitations
de taille inférieure à la moyenne (typiquement l’élevage en
général et en particulier l’élevage laitier, ou encore les fruits
et légumes).
* 750 pacages différents dans la table.
* Certain pacage apparaisse plusieurs fois dans la table.

#### Aides deuxième pilier

* 154 pacages

#### Mesures agro-environnementales et climatiques (MAEC) et aides pour l'agriculture biologique

Il s’agit de mesures permettant d’accompagner les exploitations agricoles qui s’engagent dans le développement de
pratiques combinant performance économique et performance environnementale ou dans le maintien de telles pratiques lorsqu’elles sont menacées de disparition. C’est un
outil clé pour la mise en œuvre du projet agro-écologique
pour la France.