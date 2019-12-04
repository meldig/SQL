# LE REGISTRE PARCELLAIRE GRAPHIQUE

## INFORMATION GENERALE

Le registre parcellaire graphique est une base de données géographiques servant de référence à l'instruction des aides de la politique agricole commune (PAC).

Le système de projection utilisé est en métropole : (RGF93) projection Lambert-93

### Diffusion et droits

Le RPG est une œuvre collective dont la propriété intellectuelle est partagée entre l’ASP et le ministère de l’Agriculture, de l’Agroalimentaire et de la Forêt (MAAF). Dans le cadre de l’application de la directive européenne INSPIRE, la diffusion par l’ASP des données du RPG peut être réalisée suivant 4 niveaux d’information et d’anonymisation. Source ASP

* Niveau 1: Données graphiques avec un identifiant numérique et non significatif (anonyme) par îlot.
* Niveau 2: Données du niveau 1 avec la commune de localisation de l’îlot, les cultures déclarées et leurs surfaces décrites en 28 groupes de cultures (occupation du sol).
* Niveau 3: Données du niveau 2 avec pour chaque îlot, sa surface de référence, s’il y au moins une parcelle irriguée ou non, et les caractéristiques de l’exploitation (anonymisées) : forme juridique, classe d’âge pour les exploitants individuels, surface déclarée, département de rattachement administratif.
* Niveau 4: Données du niveau 3 avec par exploitation un identifiant numérique et non significatif.

### Format des données

Les données sont délivrées au format *shapefile*

## ARCHITECTURE DES DONNEES AU SEIN DE LA BASE

### Information sur la localisation des données du RPG dans la base de données.

Les données de la base sont présentes dans plusieurs schémas de la base de données

* G_ADT_AGRI sur le serveur CUDLT
* G_ADT_AGRI sur le serveur CUDL

### Présentation des données disponibles

Plusieurs millésimes du RPG sont déjà disponibles sur la base de données:

* *RPG_2011_059* avec les colonnes: _OBJECTID_, _NUM_ILOT_, _CULT_MAJ_, _GEOM_
* *RPG_2012_059* avec les colonnes: _OBJECTID_, _NUM_ILOT_, _CULT_MAJ_, _GEOM_
* *RPG_2016_MEL_ENUM* avec les colonnes: _CODE_CULT_, _LIB_CULT_, _CODE_GRP_CULT_, _LIB_GRP_CULT_
* *RPG_MEL_2016* avec les colonnes: _OBJECTID_, _ID_PARCEL_, _SURF_PARC_, CODE_CULTU, _CODE_GROUP_, _CULTURE_D1_, CULTURE_D2, GEOM
* *RPG_2014_MEL_2016* avec les colonnes: _ID_0_, _NUM_ILOT_, _CDE_EXPL_, _ODS_SIMPL_, _PROXI_, _DRAINAGE_, _IRRIGATION_, _OP_, _ENJ_PROD_, _LIB_PROD_, _EPCI_, _AREA_, _OBJECTID_, _GEOM_

OBSERVATION: pourquoi y-a-t-il deux dates dans le nom du fichiers *RPG_2014_MEL_2016*?