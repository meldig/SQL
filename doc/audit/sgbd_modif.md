# Généralités

- des vues avec le prefix TA_
- des tables similaires mais pas tout à fait (ex de 7 tables de communes de la mel, pas toujours le même nombre)
- historique dans une table plutôt que LM_87, LM_92
- ajouter des contraintes sur la topologie pour un insert/update
- passer au type IDENTITY avec Oracle 12c pour ne plus multiplier les trigger/séquences
- mettre toutes les contraintes des clés étrangères en dur

# TA_GG_GEO

- les géométries
  - présence de géométrie NULL
  - présence de géométrie avec des erreurs de topologie
  - type varié (ligne, polygone, multipolygone) et index de type collection
  - erreur 13028 à corriger + un trigger

# TA_SUR_TOPO_G

- analyse des champs
  - GEO_TYPE
    - Présence de 47126 NULL
    - Un seul type de geom (S)
  - GEO_INSEE
    - 8% de NULL
- partionnement GEO_ON_VALIDE
  - 6.5% d'enregistrements marqués comme valide
  - 335473 pourraient être mis dans une partition non-active
	- historique des insert/delete mais pas des update
- les géométries
  - matérialisation de champs surface et longueur pour les utiliser dans la symbologie sans recalcul
  - faire une passe globale pour uniformiser le sens de saisie
  - présence de géométrie NULL
  - présence de géométrie avec des erreurs de topologie
  - stockage geom3d mais sans 3d
- création d'index (un btree geo_on_valide et cla_inu)
- la séquence SEQ_SUR_TOPO_G_INU a un LAST_NUMBER	595041 alors q'un SELECT MAX(OBJECTID) est à 370206
  - la procédure P_SUR_TOPO_G utilise ta_sur_planche ?
- aucune clé étrangère

#• TA_LIG_TOPO_G

- les 3/4 des classes d'objets en actifs ne sont pas exposés dans Elyx
  - faire un update sur geo_on_valide pour les mettre de côté ?

# TA_CLASSE

- traquer et remplacer les codes doublons dans les tables utilisatrices
- les clés étrangères ne sont pas explicites !
- pas de séquence pour cla_inu

# TA_GG_DOSSIER

- problème de date 2017 ou 17 ?
