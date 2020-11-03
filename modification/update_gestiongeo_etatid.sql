-- validation des dossiers en attente
-- les deux updates doivenet être exécutés car l'application doublonne

UPDATE GEO.TA_GG_DOSSIER
SET ETAT_ID = 9
WHERE 
  DOS_NUM IN (16500651, 155120277, 173390528, 166500049)
  AND ETAT_ID = 0;

UPDATE GEO.TA_GG_GEO
SET ETAT_ID = 9
WHERE
  DOS_NUM IN (16500651, 155120277, 173390528, 166500049)
  AND ETAT_ID = 0;
