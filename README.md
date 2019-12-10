# SQL

Ce répertoire contient le code SQL pour l'administration des schémas de la direction, le code et ses fonctions sont adaptés à une base Oracle 11g et sa cartouche oracle Spatial.

## Directives

Chaque utilisateur doit travailler sur son fork et pousser les changements via le mécanisme des *pull requests*.

La nomenclature des fichiers doit être sans majuscule, accentuation ou espace. Le nom doit être parlant sans être à rallonge, toute documentation (hors commentaire intra-fichier) doit être réalisée en Markdown dans un fichier annexe portant le même nom et avec l'extension *.md*.

## Oganisation

* analyse : regroupe le code permettant d'obtenir des indicateurs statistiques sur les bases
* doc : documente les procédures et méthodes générales
* export : regroupe le code destiné à extraire les données
* modification : regroupe le code utilisant *update*
* schema : regroupe le code DDL permettant de créer l'intégralité d'un schéma
