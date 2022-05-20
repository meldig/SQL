/*
Cette fonction a pour objectif de récupérer la longeur d'un type de voie en metre (au sens du type de cirulation dans la table SIREO_LEC.OUT_CLAS_TRAF.) d'un dossier de l'application GestionGeo.
La variable v_dossier et le numéro du dossier pour lequel nous voulons obtenir le devis. Il s'agit de l'objectid de la table G_GESTIONGEO.TA_GG_DOSSIER
La variable v_voie et le type de voie au sens du code_clastrf de la table SIREO_LEC.OUT_CLAS_TRAF
Le référentiel utilisé pour récupérer les troncons et leur type de traffic qui determine le cout d'un relevé est la table SIREO_LEC.OUT_CLAS_TRAF.
ATTENTION : Cette fonction N'EST PAS A UTILISER pour des objets de types points.
*/

CREATE OR REPLACE FUNCTION GET_LONGUEUR_VOIE_HECTOMETRE(v_dossier NUMBER, v_voie char) RETURN NUMBER

DETERMINISTIC
AS
v_longeur NUMBER(38,2);
BEGIN
    SELECT
    -- Select des sommes des types de troncon par dossier, intersection du perimetre du dossier avec la table OUT_CLAS_TRAF
        ROUND(
            SUM(
                SDO_GEOM.SDO_LENGTH(
                                    SDO_GEOM.SDO_INTERSECTION(a.ora_geometry, b.geom ,0.005), 
                                    0.005, 'unit=M'
                                    )
                )/100,2
            ) into v_longeur
    FROM
        G_GESTIONGEO.OUT_CLAS_TRAF a,
        G_GESTIONGEO.TA_GG_GEO b
        INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER c ON c.fid_perimetre = b.objectid
    WHERE
        c.objectid = v_dossier
        AND UPPER(a.CODE_CLASTRF) = UPPER(v_voie)
        AND SDO_ANYINTERACT(a.ora_geometry,b.geom)='TRUE'
        GROUP BY a.CODE_CLASTRF, c.objectid
        ORDER BY a.CODE_CLASTRF
        ;
RETURN v_longeur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '00000';
END GET_LONGUEUR_VOIE_HECTOMETRE;
/