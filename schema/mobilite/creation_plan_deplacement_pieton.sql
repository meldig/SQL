/*
à intégrer au schéma g_mobilité
plan déplacement piéton (ta_pdp_*)
ajouter
- clé + séquence + trigger
- index spatiaux
- trigger de màj de vue
*/


-- table pour les libellés
id
type_libelle
valeur


-- table points d'intérêts
id
id_libelle
date_saisie
date_maj

-- table pour les tronçons
id
fid_ligtrc not null -- lien avec la table tronçon source g_sidu
fid_megatrc -- référence le méga tronçon
geom
date_saisie
date_maj

-- table pour les "mega" tronçons
id
valeur_temps
date_saisie
date_maj

-- vue fusionnant les géométries (= 1 polyligne, pas une multi) de tronçons par megatronçons
id_megatrc
valeur_temps
geom
