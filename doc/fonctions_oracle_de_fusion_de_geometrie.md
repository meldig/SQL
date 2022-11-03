# Les fonctions oracle de fusion de géométrie

## A savoir : 
Les fonctions oracle de fusion ou d'aggrégation se suivent aucun ordre ni aucun sens particulier.

## 1. Les fonctions d'aggrégation de lignes

|Fonctions 						  |Nombre d'arguments		  			  |Possibilité d'ordonner selon les valeurs d'un champ 				|Description |
|:--------------------------------|:--------------------------------------|:----------------------------------------------------------------|:-----------|
|SDO_LRS.CONCATENATE_GEOM_SEGMENTS|2 géométries de type LRS et 1 tolérance|Non												   				|Si le résultat est de type multiligne, alors le sens de chaque ligne est conservé. Si le résultat est de type polyligne, alors les sens des éléments de la ligne sont réorientés par rapport au sens du premier élément utilisé pour fusionner le résultat.|
|SDO_AGGR_LRS_CONCAT			  |1 objet de type SDOAGGRTYPE			  |Oui : *FROM (SELECT geom FROM MA_TABLE ORDER BY MA_CLE_PRIMAIRE)*|Si on ne spécifie aucun ordre de fusion, alors le résultat conserve, aussi bien pour une multiligne que pour une ligne simple, le sens des éléments ayant servis à la fusion. Par contre, si on fusionne les éléments suivant l'ordre d'un champ, le sens des éléments composant le résultat de la fusion suivra cet ordre.|
|SDO_AGGR_UNION					  |1 objet de type SDOAGGRTYPE			  |Oui : *FROM (SELECT geom FROM MA_TABLE ORDER BY MA_CLE_PRIMAIRE)*|Si on ne spécifie aucun ordre, la fusion se fait par ordre décroissant (de la clé primaire je suppose...), sinon elle se fait suivant l'ordre spécifié. Dans le cas d'une polyligne, tous les éléments sont réorientés pour prendre le sens du premier élément. Dans le cas d'une multiligne et sans spécifier d'ordre, les sens sont conservés, sinon ils dépendent de l'ordre indiqué.|
|SDO_AGGR_CONCAT_LINES			  |1 champ géométrique		  			  |Oui : *FROM (SELECT geom FROM MA_TABLE ORDER BY MA_CLE_PRIMAIRE)*|Si on ne spécifie aucun ordre, alors la fusion conserve le sens des éléments pour une multiligne et réoriente le sens des éléments pour une polyligne en suivant le sens du premier élément. Si on spécifie un ordre, alors le sens obtenu dépend de l'ordre indiqué.|
