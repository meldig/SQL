/*
Cette fonction a pour objectif de récupérer le devis estimé du relevé d'un dossier suivant un type de voie (au sens du type de cirulation dans la table SIREO_LEC.OUT_CLAS_TRAF) de l'application GestionGeo.
La variable v_dossier et le numéro du dossier pour lequel nous voulons obtenir le devis. Il s'agit de l'objectid de la table G_GESTIONGEO.TA_GG_DOSSIER
Le référentiel utilisé pour récupérer les troncons et leur type de traffic qui determine le cout d'un relevé est la table SIREO_LEC.OUT_CLAS_TRAF.
La variable v_voie et le type de voie au sens du code_clastrf de la table SIREO_LEC.OUT_CLAS_TRAF
ATTENTION : Cette fonction N'EST PAS A UTILISER pour des objets de types points.
*/

CREATE OR REPLACE FUNCTION GET_DEVIS_VOIE(v_dossier NUMBER, v_voie char) RETURN NUMBER

DETERMINISTIC
AS
v_devis NUMBER(38,2);
BEGIN
WITH CTE AS
    (
    SELECT
    -- Select des sommes des types de troncon par dossier, intersection du perimetre du dossier avec la table OUT_CLAS_TRAF
        ROUND(
            SUM(
                SDO_GEOM.SDO_LENGTH(
                                    SDO_GEOM.SDO_INTERSECTION(a.ora_geometry, b.geom ,0.005), 
                                    0.005, 'unit=M'
                                    )
                ),2
            ) as L,
        a.CODE_CLASTRF AS type_voie
    FROM
        G_GESTIONGEO.OUT_CLAS_TRAF a,
        G_GESTIONGEO.TA_GG_GEO b
        INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER c ON c.fid_perimetre = b.objectid
    WHERE
        c.objectid = v_dossier
        AND a.CODE_CLASTRF = v_voie
        AND SDO_ANYINTERACT(a.ora_geometry,b.geom)='TRUE'
        GROUP BY a.CODE_CLASTRF, c.objectid
        ORDER BY a.CODE_CLASTRF
    ),
    CTE_2 AS
    -- Selection du prix du releve par type de voie et longueur
    (
    SELECT
        CTE.NUMERO_DOSSIER,
        CTE.L,
        CTE.type_voie,
        CTE.L*100/a.prix AS DEVIS
    FROM
        G_GESTIONGEO.TA_GG_PRIX a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_libelle
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE c ON c.fid_libelle = b.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT d ON d.objectid = c.fid_libelle_court
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE e ON e.fid_libelle = b.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE f ON f.objectid = e.fid_famille
        INNER JOIN CTE ON UPPER(CTE.TYPE_VOIE) = UPPER(d.valeur)
    WHERE
        f.objectid = 25
    )
    -- Somme des devis par type de voie et longuer pour un dossier.
SELECT
    ROUND(SUM(CTE_2.DEVIS)) INTO v_devis
FROM
    CTE_2
GROUP BY
    CTE_2.NUMERO_DOSSIER
;
RETURN v_devis;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '00000';
END GET_DEVIS_VOIE;
/