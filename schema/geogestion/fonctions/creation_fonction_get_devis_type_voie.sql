/*
La fonction GET_DEVIS_TYPE_VOIE a pour objectif de fournir le cout d'un relevé d'un type de voie sur un dossier de l'application GestionGeo.
deux parametres:
v_dossier : le numéro de dossier
v_voie : le type de voie (clé primaire de la table TA_GG_LIBELLE)
*/

create or replace FUNCTION GET_DEVIS_TYPE_VOIE(v_dossier NUMBER, v_voie char) RETURN NUMBER

DETERMINISTIC
AS
v_devis NUMBER(38,2);
BEGIN
WITH CTE AS
    (
    SELECT
    -- Selection de la sommes des longueurs des troncons contenus dans la table SIREO_LEC.OUT_CLAS_TRAF, intersectés par le perimetre d'un dossier contenu dans la table G_GESTIONGEO.TA_GG_GEO.        c.objectid AS NUMERO_DOSSIER,
        ROUND(
            SUM(
                SDO_GEOM.SDO_LENGTH(
                                    SDO_GEOM.SDO_INTERSECTION(SDO_LRS.CONVERT_TO_STD_GEOM(a.geom), j.geom ,0.005), 
                                    0.005, 'unit=M'
                                    )
                ),2
            ) as L,
        d.objectid AS type_voie
    FROM
        SIREO_LEC.OUT_CLAS_TRAF a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT b ON upper(b.valeur) = upper(a.CODE_CLASTRF)
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE c ON c.fid_libelle_court = b.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE d ON d.objectid = c.fid_libelle,
        G_GESTIONGEO.TA_GG_GEO j
        INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER k ON k.fid_perimetre = j.objectid
    WHERE
    -- Restriction suivant les paramètres indiqués lors de l'appel de la fonction.
        k.objectid = v_dossier
        AND d.objectid = v_voie
        AND SDO_ANYINTERACT(a.geom,j.geom)='TRUE'
    -- Regroupement des longueurs suivant le type de voie et le dossier
        GROUP BY a.CODE_CLASTRF, c.objectid, d.objectid
        ORDER BY a.CODE_CLASTRF
    )
    -- Calcul du devis pour le type de voie considéré sur le dossier considéré à l'aide des prix contenu dans la table G_GESTIONGEO.TA_GG_PRIX.
SELECT
    l*a.prix/100 into v_devis
FROM
    G_GESTIONGEO.TA_GG_PRIX a
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE b ON b.objectid = a.fid_libelle
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE c ON c.fid_libelle = b.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT d ON d.objectid = c.fid_libelle_court
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE e ON e.fid_libelle = b.objectid
    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE f ON f.objectid = e.fid_famille
    INNER JOIN CTE ON CTE.type_voie = a.fid_libelle
WHERE
    f.objectid = 25
;

RETURN v_devis;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '0';
END GET_DEVIS_TYPE_VOIE;
