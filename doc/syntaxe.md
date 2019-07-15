# Syntaxe du code SQL

## Indentation générale

* Il faut faire un retour à la ligne par élément
 * cela facilite le débogage et la lecture des logs
* L'indentation par ligne se fait par tabulation et non par espace
* Les commentaires doit être en ligne quand ils font moins de 80 caractères et ne nécessitent pas de retour à la ligne
 * En cas de dépassement, il faut passer en commentaire de bloc
 * Si la documentation commence à être longue, il faut privilégier un fichier annexe en markdown ayant le même nom que le fichier SQL
* En cas de sous-requête ou d'imbrication de plusieurs niveaux, il faut incrémenter l'indentation en conséquence

```SQL
-- invalide
SELECT a.cla_inu, count(a.objectid)
-- valide
SELECT 
	a.cla_inu,
	count(a.objectid)
```

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

## Nommage

### Règles générales

* Les noms ne doivent pas être proches de mots-clés réservés par le système ou la norme ANSI SQL (binary, type, action)
* La longueur totale de la chaîne de caractère ne doit pas dépasser 30 signes (limite dure d'Oracle < 12.2g)
* Il ne doit pas y avoir d'espace, d'accent ou de caractères spéciaux
* Un nom doit commencer par une lettre et ne pas finir avec un underscore
* La séparation entre mots doit être faite avec un caractère underscore *_*
 * Il ne doit pas y avoir d'underscores successifs

### Tables et Vues

* Il faut préfixer
 * les tables avec *TA_*
 * les vues avec *V_*
 * les vues matérialisées avec *VM_*

### Noms réservés

Tous les noms réservés doivent être en majuscule se fait en majuscule.

```SQL
-- invalide
select valeur 
from table_a 
where table_a.valeur > 1
-- valide
SELECT valeur 
FROM table_a 
WHERE table_a.valeur > 1
```

### Colonnes

* Utilisez un nom au singulier
* Aucun champ ne peut avoir le même intitulé que celui de la table
* Toujours en minuscule
* Préfixez
	* une clé primaire par *id_*
	* une clé étrangère par *fid_*

### Jointures

Les jointures doivent être matérialisées et non pas apparaître dans la clause WHERE.

```SQL
-- invalide
WHERE table_a.id = table_b.id
-- valide
JOIN table_b ON table_a.id = table_b.id
```

### Restreindre un ensemble

* Privilégiez l'usage de BETWEEN plutôt que de AND pour une plage de valeurs numériques
	```SQL
	-- invalide
	valeur >= 1 AND valeur <= 100
	-- valide
	valeur BETWEEN 1 AND 100
	```
* Privilégiez l'usage de IN plutôt que de OR pour une plage de valeurs alphanumériques
	```SQL
	-- invalide
	valeur = 'AAA' AND valeur = 'BBB' AND valeur = 'CCC'
	-- valide
	valeur IN ('AAA', 'BBB', 'CCC')
	```

### Sous-requête et CTE

```SQL
-- invalide
SELECT
 valeurs
FROM table_a
WHERE
	table_a.id = (SELECT valeur_b FROM table_b)
-- valide
WITH
	cte AS (
	SELECT
		valeur_b
	FROM table_b
	)
	SELECT
	 valeur_a
	FROM table_a
	WHERE
		table_a.id = cte.
```

## Création

## Clés

## Contraintes

## Types

### Mise à jour

merge ... using
