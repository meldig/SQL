------------------------------------
-- SUPPRESSION_GEOMETRIE_OBSOLETE --
------------------------------------

-- Suppression des elements obsoletes de la table TA_RTGE_POINT_INTEGRATION
DELETE FROM G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION
WHERE FID_NUMERO_DOSSIER = 1
AND TO_DATE(DATE_CREATION, 'dd/mm/yy') < TO_DATE('01/01/22', 'dd/mm/yy')
;


-- Suppression des elements obsoletes de la table TA_RTGE_LINEAIRE_INTEGRATION
DELETE FROM G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION
WHERE FID_NUMERO_DOSSIER = 1
AND TO_DATE(DATE_CREATION, 'dd/mm/yy') < TO_DATE('01/01/22', 'dd/mm/yy')
;

/
