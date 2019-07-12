# Syntaxe du code SQL

## Indentation

Il faut faire un retour à la ligne par élément.

L'indentation par ligne se fait par tabulation et non par espace.

Les commentaires doit être en ligne quand ils font moins de 80 caractères et ne nécessitent pas de retour à la ligne. En cas de dépassement, il faut passer en commentaire de bloc. Si la documentation commence à être longue, il faut privilégier un fichier annexe en markdown ayant le même nom que le fichier SQL.

En cas de sous-requête ou d'imbrication de plusieurs niveaux, il faut incrémenter l'indentation en conséquence.

## Fonctions

L'appel aux noms des fonctions se fait en majuscule.

## Colonnes et champs

L'appel aux colonnes et champs se fait en minuscule. Pareil pour les alias.

Les noms ne doivent pas être proche de noms système, c-à-d pas de noms *type*.

Il ne doit pas y avoir d'espace, d'accent, de caractères spéciaux ou de majuscules.

La séparation entre mots doit être faite avec un caractère underscore _.

## Jointures

Les jointures doivent être matérialisées et non pas apparaître dans la clause WHERE.

```SQL
-- invalide
WHERE table_a.id = table_b.id
-- valide
JOIN table_b ON table_a.id = table_b.id
```


