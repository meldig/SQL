/*
La fonction GET_LONGUEUR_TYPE_VOIE a pour objectif de calculer la somme des longueurs d'un type de voie intersecté par un dossier de l'application gestiongeo. Les types de voies considérés sont ceux définis dans la table SIREO.OUT_CLAS_TRAF
deux parametres:
v_dossier : le numéro de dossier
v_voie : le type de voie (clé primaire de la table TA_GG_LIBELLE)
*/

create or replace FUNCTION GET_LONGUEUR_TYPE_VOIE(v_dossier NUMBER, v_voie char) RETURN NUMBER

DETERMINISTIC
AS
v_longueur NUMBER(38,2);
BEGIN
    SELECT
    -- Selection de la sommes des longueurs des troncons contenus dans la table SIREO_LEC.OUT_CLAS_TRAF, intersectés par le perimetre d'un dossier contenu dans la table G_GESTIONGEO.TA_GG_GEO.
        ROUND(
            SUM(
                SDO_GEOM.SDO_LENGTH(
                                    SDO_GEOM.SDO_INTERSECTION(SDO_LRS.CONVERT_TO_STD_GEOM(a.geom), j.geom ,0.005), 
                                    0.005, 'unit=M'
                                    )
                ),2
            )INTO V_LONGUEUR
    FROM
        SIREO_LEC.OUT_CLAS_TRAF a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_COURT b ON upper(b.valeur) = upper(a.CODE_CLASTRF)
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_CORRESPONDANCE c ON c.fid_libelle_court = b.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE d ON d.objectid = c.fid_libelle,
        G_GESTIONGEO.TA_GG_GEO j
        INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER k ON k.fid_perimetre = j.objectid
    -- Restriction suivant les paramètres indiqués lors de l'appel de la fonction.
    WHERE
        k.objectid = v_dossier
        AND d.objectid = v_voie
        AND SDO_ANYINTERACT(a.geom,j.geom)='TRUE'
    -- Regroupement des longueurs suivant le type de voie et le dossier
        GROUP BY a.CODE_CLASTRF, k.objectid
        ORDER BY a.CODE_CLASTRF
        ;
RETURN v_longueur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '00000';
END GET_LONGUEUR_TYPE_VOIE;
