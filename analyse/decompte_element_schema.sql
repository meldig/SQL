--Décompte des tables du schéma :
SELECT count(*)
FROM USERS_TABLES;

------------------------------

--Décompte des contraintes dans le schéma GEO :
SELECT count(*)
FROM USER_CONSTRAINTS ;

------------------------------
-- Décompte des contraintes d'une table donnée :
SELECT COUNT(*)
FROM dba_constraints
WHERE OWNER = 'GEO' AND TABLE_NAME='TA_GG_DOC';

------------------------------
-- Sélection des contraintes d'une table donnée
SELECT *
FROM dba_constraints
WHERE OWNER = 'GEO' AND TABLE_NAME = 'TA_GG_DOC';

------------------------------

-- Sélection de tous les types de contrainte d'une table donnée

SELECT DISTINCT a.constraint_type
FROM dba_constraints a
WHERE OWNER = 'GEO' AND TABLE_NAME='TA_GG_DOC';

------------------------------

--Sélection d'une contrainte pour toutes les tables d'un schéma
SELECT *
FROM dba_constraints a
WHERE OWNER = 'GEO' AND a.constraint_type ='U'
ORDER BY a.TABLE_NAME;

------------------------------

--Décompte d'un type de géométrie particulier (polygone) :
SELECT COUNT(a.GEOM.sdo_gtype) 
FROM GEO.TA_SUR_TOPO_G a 
WHERE a.GEOM.sdo_gtype = 2003 ;

------------------------------

--Décompte de tous les types de géométrie d'un table donnée
SELECT DISTINCT a.GEOM.sdo_gtype, COUNT(a.GEOM.sdo_gtype) 
FROM GEO.TA_LIG_TOPO_G a 
GROUP BY a.GEOM.sdo_gtype
ORDER BY a.GEOM.sdo_gtype;

