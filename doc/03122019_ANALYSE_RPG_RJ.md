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

### Format des données

Les données sont délivrées au format *shapefile*

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
* niveau 2: IGN
* niveau 2 et niveau 2+: DRAAF (direction régionale de l'agriculture, de l'alimentation et de la forêt)

La demande est a réalisé à l'aide d'un formulaire de demande d'une extraction du registre parcellaire graphique (RPG).

### Remarque sur le responsabilité quand à l'utilisation de la données

Plusieurs remarques peuvent être faites suite à la lecture de ce document:
* Le demandeur est le responsable du traitement au sens du RGPD. Le responsable du
traitement doit identifier et classer les données à caractère personnel qu’il détient et respecter
toutes les obligations qui lui incombent en vertu du RGPD, et notamment :
** obligation d'information des personnes concernées sur les traitements réalisés (article
14)
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