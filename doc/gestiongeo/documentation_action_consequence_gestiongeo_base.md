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

|GEO.TA_GG_DOSSIER|DOS_NUM							|Identifiant du dossier. Champ de jointure entre le dossier et sa géométrie contenue dans la table TA_GG_GEO.	|
|GEO.TA_GG_GEO 	  |ID_GEOM							|Identifiant d'une géométrie dans la table TA_GG_GEO.															|
|GEO.TA_GG_GEO 	  |ID_DOS							|Identifiant du dossier
|GEO.TA_GG_GEO 	  |GEOM 							|Périmètre du dossier
|GEO.TA_GG_GEO 	  |ETAT_ID 							|Etat du dossier. Clé étrangère vers la table TA_GG_ETAT. 														|
|GEO.TA_GG_GEO 	  |DOS_NUM							|Identifiant du dossier. Champ de jointure entre une géométrie et son dossier contenu dans la table TA_GG_DOSSIER|

### Observation

La délimitation d'un périmètre n'est pas obligatoire pour créer un dossier.

## Intégration d'un fichier *dwg*,

### Intégration avec création d'un nouveau dossier
|CHAMP onglet DOSSIER		   |TABLE_RENSEIGNEE |CHAMP 						|Remarque 																										|
|:-----------------------------|:----------------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------|
|Auteur 					   |GEO.TA_GG_DOSSIER|SRC_ID 						|Clé étrangère vers la table TA_GG_SOURCE, indique le créateur du dossier.									    |
|Famille 					   |GEO.TA_GG_DOSSIER|FAM_ID 						|Clé étrangère vers la table TA_GG_FAMILLE, indique la famille du dossier.										|
|Dossier associé			   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Remarque 					   |GEO.TA_GG_DOSSIER|DOS_RQ 						|Remaque générale sur le dossier.																				|
|Date travaux				   |GEO.TA_GG_DOSSIER|DOS_DT_DEB_TR et DOS_DT_FIN_TR|Indique le debut et la fin des travaux. Apparait sous la forme d'une phrase dans la fiche du dossier.			|
|Voie						   |GEO.TA_GG_DOSSIER|DOS_VOIE						|Clé étrangère.																									|
|Commune 					   |GEO.TA_GG_DOSSIER|DOS_INSEE						|Clé étrangère.																									|
|Maitrise d'ouvrage			   |GEO.TA_GG_DOSSIER|DOS_MAO						|Maitre d'ouvrage.																								|
|Entreprise					   |GEO.TA_GG_DOSSIER|DOS_ENTR						|Entreprise responsable du levé.																				|

### Calcul du périmètre.
Le périmètre est automatiquement dessiné par la chaine de traitement FME à partir des éléments contenus dans les fichiers *dwg* renseigné dans l'onglet **Fichier DWG**. 

