-- Creation de la vue V_GG_POINT_VIGILANCE afin de restituer les informations des points de vigilance du projet GESTIONGEO

-- 1. Creation de la vue.
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_GG_POINT_VIGILANCE (IDENTIFIANT_POINT,TYPE_SIGNALEMENT,VERIFICATION_EFFECTUE, STATUT_TRAITEMENT,OBJET_SIGNALE,DATE_CREATION,PNOM_CREATION,DATE_MODIFICATION,PNOM_MODIFICATION,DATE_PREVISIONNELLE,COMMENTAIRE,GEOM,
CONSTRAINT "V_GG_POINT_VIGILANCE_PK" PRIMARY KEY ("IDENTIFIANT_POINT") DISABLE) 
AS
SELECT
	a.OBJECTID AS IDENTIFIANT_POINT,
	c.valeur AS TYPE_SIGNALEMENT,
	e.valeur AS VERIFICATION_EFFECTUE,
	g.valeur AS STATUT_TRAITEMENT,
	i.valeur AS OBJET_SIGNALE,
	j.date_creation AS DATE_CREATION,
	k.pnom AS PNOM_CREATION,
	j.date_modification AS DATE_MODIFICATION,
	l.pnom AS PNOM_MODIFICATION,
	a.DATE_PREVISIONNELLE AS DATE_PREVISIONNELLE,
	a.COMMENTAIRE AS COMMENTAIRE,
	a.GEOM AS GEOM
FROM
	G_GESTIONGEO.TA_GG_POINT_VIGILANCE a
	INNER JOIN G_GEO.TA_LIBELLE b ON b.objectid = a.fid_type_signalement
	INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
	INNER JOIN G_GEO.TA_LIBELLE d ON d.objectid = a.fid_verification
	INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long
	INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = a.fid_lib_statut
	INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
	INNER JOIN G_GEO.TA_LIBELLE h ON h.objectid = a.fid_libelle
	INNER JOIN G_GEO.TA_LIBELLE_LONG i ON i.objectid = h.fid_libelle_long
	INNER JOIN G_GEO.TA_LIBELLE m ON m.objectid = a.fid_type_point
	INNER JOIN G_GEO.TA_LIBELLE_LONG n ON n.objectid = m.fid_libelle_long
	INNER JOIN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT j ON j.fid_point_vigilance = a.objectid
	INNER JOIN G_GESTIONGEO.TA_GG_AGENT k ON k.objectid = j.fid_pnom_creation
	LEFT JOIN G_GESTIONGEO.TA_GG_AGENT l ON l.objectid = j.fid_pnom_modification
WHERE
	m.objectid = 363
;


-- 2. Commentaire de la vue.
COMMENT ON TABLE G_GESTIONGEO.V_GG_POINT_VIGILANCE IS 'Vue qui présente les points de vigilance créés par les photointerprètes dans le cadre de l''application GESETIONGEO';

-- 3. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.IDENTIFIANT_POINT IS 'Identifiant du point clé primaire de la vue';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.TYPE_SIGNALEMENT IS 'Indique le type de signalement du point : création, modification manuelle ou vérification';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.VERIFICATION_EFFECTUE IS 'Champ qui permet de connaître la réponse envisagée au signalement fait lors de la création du point.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.STATUT_TRAITEMENT IS 'Statut permettant de savoir si le point a été traité ou non.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.OBJET_SIGNALE IS 'Type d''objet sur lequel porte le point de vigilance';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.DATE_CREATION IS 'Date de création du point';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.PNOM_CREATION IS 'Agent qui a créé le point';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.DATE_MODIFICATION IS 'Date de dernière modification du point';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.PNOM_MODIFICATION IS 'Dernier agent qui a modifié le point';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.DATE_PREVISIONNELLE IS 'Date prévisionnelle à partir de laquelle il faudra recontrôler le point.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.COMMENTAIRE IS 'Champ dans lequel l''auteur/modificateur du point de vigilance peut inscrire l''interrogation qu''il avait lors de la création/modification du point ou écrire une question à destination de l''UF TOPO.';
COMMENT ON COLUMN G_GESTIONGEO.V_GG_POINT_VIGILANCE.GEOM IS 'Géométrie du point - type point';


-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_GG_POINT_VIGILANCE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;


-- 5. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT_VIGILANCE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT_VIGILANCE TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT_VIGILANCE TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT_VIGILANCE TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT_VIGILANCE TO G_GESTIONGEO_MAJ;


/