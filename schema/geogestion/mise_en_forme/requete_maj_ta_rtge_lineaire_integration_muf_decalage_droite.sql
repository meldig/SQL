-- Mise à jour de la table TA_RTGE_LINEAIRE
MERGE INTO TA_RTGE_LINEAIRE_INTEGRATION_MUF a
USING
	(
	WITH CTE AS
	    (
	    SELECT
	        DISTINCT
	        a.OBJECTID,
	        a.fid_numero_dossier,
	        ROUND(SDO_LRS.GEOM_SEGMENT_LENGTH(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(b.geom))),3) AS mesure
	    FROM
	        TA_RTGE_LINEAIRE_INTEGRATION a 
	        INNER JOIN TA_RTGE_MUF_STATUT mb ON a.OBJECTID = mb.OBJECTID
	        INNER JOIN TA_RTGE_LINEAIRE_INTEGRATION b ON SDO_RELATE(a.GEOM, b.GEOM, 'mask = touch') ='TRUE'
	        AND b.FID_IDENTIFIANT_TYPE = 703
	        AND a.fid_numero_dossier = b.fid_numero_dossier
	        INNER JOIN TA_RTGE_MUF_STATUT n ON N.OBJECTID = b.OBJECTID
	    WHERE
	    	mb.statut = 2
	    	AND
	    	n.statut = 1
	    )
	SELECT
	    cte.OBJECTID,
	    cte.FID_NUMERO_DOSSIER,
	    MIN(MESURE) AS MESURE
	FROM
	    CTE
	GROUP BY cte.OBJECTID, cte.FID_NUMERO_DOSSIER
	)b
ON(a.OBJECTID = b.OBJECTID
AND a.FID_NUMERO_DOSSIER = b.FID_NUMERO_DOSSIER)
WHEN MATCHED THEN UPDATE
SET a.DECALAGE_DROITE = b.MESURE;


/*
Mise à zero des largeurs des petits murs qui croisent deux points topo
*/
MERGE INTO TA_RTGE_LINEAIRE_INTEGRATION_MUF a
USING
    (
	WITH CTE AS
	    (
	    SELECT
	        DISTINCT
	        a.OBJECTID,
	        a.fid_numero_dossier,
	        ROUND(SDO_LRS.GEOM_SEGMENT_LENGTH(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(b.geom))),3) AS mesure
	    FROM
	        TA_RTGE_LINEAIRE_INTEGRATION a 
	        INNER JOIN TA_RTGE_MUF_STATUT mb ON a.OBJECTID = mb.OBJECTID
	        INNER JOIN TA_RTGE_LINEAIRE_INTEGRATION b ON SDO_RELATE(a.GEOM, b.GEOM, 'mask = touch') ='TRUE'
	        AND b.FID_IDENTIFIANT_TYPE = 703
	        AND a.fid_numero_dossier = b.fid_numero_dossier
	        INNER JOIN TA_RTGE_MUF_STATUT n ON N.OBJECTID = b.OBJECTID
	    WHERE
	    	mb.statut = 2
	    	AND
	    	n.statut = 1
	    )
    SELECT
        a.objectid AS OBJECTID_A,
        a.mesure AS MESURE_A,
        c.objectid AS OBJECTID_CORR,
        null AS MESURE_CORR
    FROM 
        CTE a
        INNER JOIN ta_rtge_lineaire_integration b on a.objectid = b.objectid,
        CTE c
        INNER JOIN ta_rtge_lineaire_integration d on c.objectid = d.objectid
    WHERE
        a.objectid <> c.objectid
        AND
        a.fid_numero_dossier = c.fid_numero_dossier
        AND
        SDO_RELATE(b.geom,d.geom,'mask = touch') = 'TRUE'
        AND 
        SDO_LRS.GEOM_SEGMENT_LENGTH(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(b.geom))) > SDO_LRS.GEOM_SEGMENT_LENGTH(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(d.geom)))
        AND
        SDO_LRS.GEOM_SEGMENT_LENGTH(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(d.geom))) <0.5
    )b
ON(a.OBJECTID = b.OBJECTID_CORR)
WHEN MATCHED THEN UPDATE
SET a.DECALAGE_GAUCHE = b.MESURE_CORR;

/
