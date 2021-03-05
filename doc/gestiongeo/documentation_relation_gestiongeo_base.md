# Correspondance action - mise à jour des tables

## Creation d'un dossier,

### Etape réaliser par le client **GESTIONGEO**.

|CHAMP onglet DOSSIER		   |TABLE_RENSEIGNEE |CHAMP 						|Remarque 																										|
|:-----------------------------|:----------------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------|
|Auteur 					   |GEO.TA_GG_DOSSIER|SRC_ID 						|Clé étrangère vers la table TA_GG_SOURCE, indique le créateur du dossier.									    |
|Priorité					   |GEO.TA_GG_DOSSIER|DOS_PRIORITE 					|Clé étrangère pour indiquer une valeur de priorité à un dossier. BASSE/MOYENNE/HAUTE. Champ peu utilisé.		|
|Famille 					   |GEO.TA_GG_DOSSIER|FAM_ID 						|Clé étrangère vers la table TA_GG_FAMILLE, indique la famille du dossier.										|
|Remarque 					   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Date travaux				   |GEO.TA_GG_DOSSIER|DOS_DT_DEB_TR et DOS_DT_FIN_TR|Indique le debut et la fin des travaux. Apparait sous la forme d'une phrase dans la fiche du dossier.			|
|Commune 					   |GEO.TA_GG_DOSSIER|DOS_INSEE						|Clé étrangère.																									|
|Voie						   |GEO.TA_GG_DOSSIER|DOS_VOIE						|Clé étrangère.																									|
|Maitrise d'ouvrage			   |GEO.TA_GG_DOSSIER|DOS_MAO						|Maitre d'ouvrage.																								|
|Entreprise					   |GEO.TA_GG_DOSSIER|DOS_ENTR						|Entreprise responsable du levé.																				|

### Information mis à jour par **l'application**.

|TABLE_RENSEIGNEE |CHAMP 							|Remarque 																										|
|:----------------|:--------------------------------|:--------------------------------------------------------------------------------------------------------------|
|GEO.TA_GG_DOSSIER|ID_DOS							|Identifiant unique du dossier.																					|
|GEO.TA_GG_DOSSIER|ETAT_ID							|Clé étrangère vers la table TA_GG_ETAT, indique l'état du dossier.	Lors de la création ETAT_ID = 5				|

### Information si un périmètre est dessiné dans l'application Dynmap.

|TABLE_RENSEIGNEE |CHAMP 							|Remarque 																										|
|:----------------|:--------------------------------|:--------------------------------------------------------------------------------------------------------------|
|GEO.TA_GG_DOSSIER|DOS_NUM							|Numéro du dossier. Concatenation ANNEE + code INSEE + incrémentation du nombre de dossier créer depuis le début de l'année.|
|GEO.TA_GG_DOSSIER|DOS_NUM_SHORT					|Nombre de dossiers créés.	|
|GEO.TA_GG_GEO 	  |ID_GEOM							|Identifiant d'une géométrie dans la table TA_GG_GEO.															|
|GEO.TA_GG_GEO 	  |ID_DOS							|Clé étrangère vers la table parent TA_GG_DOSSIER, avec une option ON DELETE CASCADE permettant de supprimer le périmètre de TA_GG_GEO en cas de suppression de du dossier correspondant dans TA_GG_DOSSIER.|
|GEO.TA_GG_GEO 	  |GEOM 							|champ géométrique de la table contenant les périmètres des dossiers
|GEO.TA_GG_GEO 	  |ETAT_ID 							|Etat du dossier. Clé étrangère vers la table TA_GG_ETAT. 														|
|GEO.TA_GG_GEO 	  |DOS_NUM							|Numéro du dossier. Concatenation ANNEE + code INSEE + incrémentation du nombre de dossier créer depuis le début de l'année.|

### Observation

La délimitation d'un périmètre n'est pas obligatoire pour créer un dossier.

## Intégration d'un fichier *dwg*,

### Intégration avec création d'un nouveau dossier
|CHAMP onglet DOSSIER		   |TABLE_RENSEIGNEE |CHAMP 						|Remarque 																										|
|:-----------------------------|:----------------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------|
|Auteur 					   |GEO.TA_GG_DOSSIER|SRC_ID 						|Clé étrangère vers la table TA_GG_SOURCE, indique le créateur du dossier.									    |
|Famille 					   |GEO.TA_GG_DOSSIER|FAM_ID 						|Clé étrangère vers la table TA_GG_FAMILLE, indique la famille du dossier.										|
|Dossier associé			   |GEO.TA_GG_DOSSIER|ID_PERE 						|Numéro de dossier associé au dossier. N'est plus utilisé														|
|Remarque 					   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Date travaux				   |GEO.TA_GG_DOSSIER|DOS_DT_DEB_TR et DOS_DT_FIN_TR|Indique le debut et la fin des travaux. Apparait sous la forme d'une phrase dans la fiche du dossier.			|
|Voie						   |GEO.TA_GG_DOSSIER|DOS_VOIE						|Clé étrangère.																									|
|Commune 					   |GEO.TA_GG_DOSSIER|DOS_INSEE						|Clé étrangère.																									|
|Maitrise d'ouvrage			   |GEO.TA_GG_DOSSIER|DOS_MAO						|Maitre d'ouvrage.																								|
|Entreprise					   |GEO.TA_GG_DOSSIER|DOS_ENTR						|Entreprise responsable du levé.																				|

### Information mis à jour par **l'application**.

|TABLE_RENSEIGNEE |CHAMP 							|Remarque 																										|
|:----------------|:--------------------------------|:--------------------------------------------------------------------------------------------------------------|
|GEO.TA_GG_DOSSIER|ID_DOS							|Identifiant unique du dossier.																					|
|GEO.TA_GG_DOSSIER|ETAT_ID							|Clé étrangère vers la table TA_GG_ETAT, indique l'état du dossier.	Lors de la création ETAT_ID = 6, En attente (robot GTF)				|
|GEO.TA_GG_DOSSIER|DOS_URL_FILE						|Lien vers le fichier *dwg* intégré par **DYNMAP**																|

### Calcul du périmètre dans le cadre d'une opération d'intégration avec création d'un nouveau dossier.

Le périmètre est automatiquement dessiné par la chaine de traitement FME à partir des éléments contenus dans les fichiers *dwg* renseignés dans l'onglet **Fichier DWG**. 

|TABLE_RENSEIGNEE |CHAMP 							|Remarque 																										|
|:----------------|:--------------------------------|:--------------------------------------------------------------------------------------------------------------|
|GEO.TA_GG_DOSSIER|ID_DOS							|Identifiant unique du dossier.																					|
|GEO.TA_GG_DOSSIER|DOS_NUM							|Numéro du dossier. Concatenation ANNEE + code INSEE + incrémentation du nombre de dossier créer depuis le début de l'année.|
|GEO.TA_GG_DOSSIER|DOS_NUM_SHORT					|Il s'agit des trois derniers digits du DOS_NUM. Nombre de dossier créer depuis le début de l'année en cours.	|
|GEO.TA_GG_GEO 	  |ID_DOS							|Clé étrangère vers la table parent TA_GG_DOSSIER, avec une option ON DELETE CASCADE permettant de supprimer le périmètre de TA_GG_GEO en cas de suppression de du dossier correspondant dans TA_GG_DOSSIER.|
|GEO.TA_GG_GEO 	  |ID_GEOM							|Identifiant d'une géométrie dans la table TA_GG_GEO.															|
|GEO.TA_GG_GEO 	  |ID_DOS							|Identifiant du dossier
|GEO.TA_GG_GEO 	  |GEOM 							|Périmètre du dossier
|GEO.TA_GG_GEO 	  |ETAT_ID 							|Etat du dossier. Clé étrangère vers la table TA_GG_ETAT. 														|
|GEO.TA_GG_GEO 	  |DOS_NUM							|Identifiant du dossier. Champ de jointure entre une géométrie et son dossier contenu dans la table TA_GG_DOSSIER|

### Intégration avec récupération d'un ancien dossier.

Dans le cas d'une intégration à partir d'un dossier existant, les informations mises à jour sont les mêmes que pour une intégration avec la création d'un dossier.

|CHAMP onglet DOSSIER		   |TABLE_RENSEIGNEE |CHAMP 						|Remarque 																										|
|:-----------------------------|:----------------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------|
|Auteur 					   |GEO.TA_GG_DOSSIER|SRC_ID 						|Clé étrangère vers la table TA_GG_SOURCE, indique le créateur du dossier.									    |
|Famille 					   |GEO.TA_GG_DOSSIER|FAM_ID 						|Clé étrangère vers la table TA_GG_FAMILLE, indique la famille du dossier.										|
|Dossier associé			   |GEO.TA_GG_DOSSIER|ID_PERE 						|Numéro de dossier associé au dossier. N'est plus utilisé																|
|Remarque 					   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Date travaux				   |GEO.TA_GG_DOSSIER|DOS_DT_DEB_TR et DOS_DT_FIN_TR|Indique le debut et la fin des travaux. Apparait sous la forme d'une phrase dans la fiche du dossier.			|
|Voie						   |GEO.TA_GG_DOSSIER|DOS_VOIE						|Clé étrangère.																									|
|Commune 					   |GEO.TA_GG_DOSSIER|DOS_INSEE						|Clé étrangère.																									|
|Maitrise d'ouvrage			   |GEO.TA_GG_DOSSIER|DOS_MAO						|Maitre d'ouvrage.																								|
|Entreprise					   |GEO.TA_GG_DOSSIER|DOS_ENTR						|Entreprise responsable du levé.																				|

### Calcul du périmètre dans le cadre d'une opération d'intégration avec récupération d'un dossier existant.

Le périmètre est automatiquement redéssiné par la chaine de traitement FME à partir des éléments contenus dans les fichiers *dwg* renseigné dans l'onglet **Fichier DWG**. Si un périmètre existait déjà, celui-ci est redessiné dans la table **TA_GG_GEO**.

|TABLE_RENSEIGNEE |CHAMP 							|Remarque 																										|
|:----------------|:--------------------------------|:--------------------------------------------------------------------------------------------------------------|
|GEO.TA_GG_GEO 	  |GEOM 							|Périmètre du dossier																							|

### Copie du fichier *dwg* 

L'application **gestiongeo** copie les fichiers à intégrer dans le dossier **\\volt\infogeo\appli_gg\recol\DOS_NUM_CODE_INSEE_NOM_DE_LA_VOE\DOS_NUM.dwg**.

### Insertion des éléménents géométriques dans les tables TA_POINT_TOPO_GPS et TA_LIG_TOPO_GPS.

Les données issues des fichiers *dwg* sont insérées dans les tables suivantes grâce à la chaine FME:
* TA_POINT_TOPO_GPS
* TA_LIG_TOPO_GPS
* PTTOPO

## Mise à jour d'un dossier à partir de la fiche d'un dossier.

La fiche d'un dossier est accessible par l'interface de **gestiongeo** en sélectionnant un dossier sur la carte de l'application. Les attributs d'un dossier sont modifiables par l'intermédiaire de l'icône de mise à jour(Voir ![documentation_interface_gestiongeo.md](/documentation_interface_gestiongeo.md))

Les attribut modifiables sont:
|CHAMP onglet DOSSIER		   |TABLE_RENSEIGNEE |CHAMP 						|Remarque 																										|
|:-----------------------------|:----------------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------|
|Auteur 					   |GEO.TA_GG_DOSSIER|SRC_ID 						|Clé étrangère vers la table TA_GG_SOURCE, indique le créateur du dossier.									    |
|Etat 						   |GEO.TA_GG_DOSSIER|ETAT_ID 						|Clé étrangère vers la table TA_GG_ETAT, indique le l'état du dossier.										    |
|Famille 					   |GEO.TA_GG_DOSSIER|FAM_ID 						|Clé étrangère vers la table TA_GG_FAMILLE, indique la famille du dossier.										|
|Dossier associé			   |GEO.TA_GG_DOSSIER|								|Y a t'il un lien avec le champ DOS_IDPERE																		|
|Remarque 					   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Date travaux				   |GEO.TA_GG_DOSSIER|DOS_DT_DEB_TR et DOS_DT_FIN_TR|Indique le debut et la fin des travaux. Apparait sous la forme d'une phrase dans la fiche du dossier.			|
|Date commande				   |GEO.TA_GG_DOSSIER|DOS_DT_CMD_SAI				|**PAS SÛR A VERIFIER**																							|
|Détail levé				   |GEO.TA_GG_DOSSIER|DOS_PRECISION					|Information sur la levé																						|
|Date de clôture			   |GEO.TA_GG_DOSSIER|DOS_DT_FIN					|Date de cloture du dossier (passage à l'état 0 ou 9?)															|
|Voie						   |GEO.TA_GG_DOSSIER|DOS_VOIE						|Clé étrangère.																									|
|Commune 					   |GEO.TA_GG_DOSSIER|DOS_INSEE						|Clé étrangère.																									|
|Maitrise d'ouvrage			   |GEO.TA_GG_DOSSIER|DOS_MAO						|Maitre d'ouvrage.																								|
|Entreprise					   |GEO.TA_GG_DOSSIER|DOS_ENTR						|Entreprise responsable du levé.																				|
|Ancien ID 					   |GEO.TA_GG_DOSSIER|DOS_OLD_ID					|Ancien identifiant du dossier.																					|
|Etat GTF
|Pièce(s) attaché(s)(8Mo max): |GEO.TA_GG_DOSSIER|DOS_URL_FILE					|Affiche t'il dans la fenetre de l'application le dossier situé au bout de ce lien?


## Mise à jour d'un dossier lié à une Investigation Complémentaire.

