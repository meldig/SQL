# Syntaxe du code SQL

## Indentation

Il faut faire un retour à la ligne par élément.

```SQL
-- invalide
SELECT a.cla_inu, count(a.objectid)
-- valide
SELECT 
	a.cla_inu,
	count(a.objectid)
```

L'indentation par ligne se fait par tabulation et non par espace.

```SQL
-- invalide
SELECT 
 a.cla_inu,
 count(a.objectid)
-- valide
SELECT 
	a.cla_inu,
	count(a.objectid)
```

Les commentaires doivent être en ligne quand ils font moins de 80 caractères et ne nécessitent pas de retour à la ligne. En cas de dépassement, il faut passer en commentaire de bloc. Si la documentation commence à être longue, il faut privilégier un fichier annexe en markdown ayant le même nom que le fichier SQL.

```SQL
-- Commentaire en ligne - invalide
-- 1. Chargement des données de plans d'eau valides (filtrage des données);
-- 2. Création d'un identifiant unique par objet qui se mettra à jour automatiquement en cas d'insertion ou de modification d'objet ;
-- 3. Comblement des espaces de 40 cm maximum entre les polygones adjacents ;

-- Commentaire en ligne - valide
-- AND a.OBJECTID = 900114;

-- Commentaire en bloc - invalide
/*AND a.OBJECTID = 900114;*/

-- Commentaire en bloc - valide
/*
1. Chargement des données de plans d'eau valides (filtrage des données);
2. Création d'un identifiant unique par objet qui se mettra à jour automatiquement en cas d'insertion ou de modification d'objet ;
3. Comblement des espaces de 40 cm maximum entre les polygones adjacents ;
*/
```

En cas de sous-requête ou d'imbrication de plusieurs niveaux, il faut incrémenter l'indentation en conséquence.
```SQL
-- invalide
SELECT
	COUNT(SDO_LRS.CONNECTED_GEOM_SEGMENTS(SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom), SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom), 0.005)) AS connecte
-- valide
SELECT
	COUNT(
		SDO_LRS.CONNECTED_GEOM_SEGMENTS(
			SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom),
			SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom), 
			0.005
		)
	) AS connecte
```

## Fonctions

L'appel aux noms des fonctions se fait en majuscule.
```SQL
-- invalide
select sdo_lrs.convert_to_lrs_geom(a.geom)
-- valide
SELECT SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom)
```

## Colonnes et champs

L'appel aux colonnes et champs se fait en minuscule. Pareil pour les alias.

```SQL
-- invalide
SELECT
	a.OBJECTID AS IDENTIFIANT,
	a.CLA_INU AS REF_CLASSE
-- valide
SELECT
	a.objectid AS identifiant,
	a.cla_inu AS ref_classe
```

Les noms ne doivent pas être proche de noms système, c-à-d pas de noms *type*.
```SQL
-- invalide
SELECT
	a.objectid AS identifiant,
	a.geo_type AS type
-- valide
SELECT
	a.objectid AS identifiant,
	a.geo_type AS categorie
```
Il ne doit pas y avoir d'espace, d'accent, de caractères spéciaux ou de majuscules.
La séparation entre mots doit être faite avec un caractère underscore _.

```SQL
-- invalide
SELECT
	a.objectid AS identifiant,
	a.cla_inu AS ref de classe
-- valide
SELECT
	a.objectid AS identifiant,
	a.cla_inu AS ref_classe
```

## Jointures

Les jointures doivent être matérialisées et non pas apparaître dans la clause WHERE.

```SQL
-- invalide
WHERE table_a.id = table_b.id
-- valide
JOIN table_b ON table_a.id = table_b.id
```


