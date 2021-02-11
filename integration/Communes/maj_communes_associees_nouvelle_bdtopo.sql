/*
Objectif : insérer le nouveau millésime de la BdTopo des communes associées ou déléguées.
*/

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAVE_MAJ_COMMUNES_ASSOCIEES;

-- 1. Insertion des code INSEE des communes associées ou déléguées dans la table TA_CODE ;
MERGE INTO G_GEO.TA_CODE a
    USING (
        SELECT
            b.INSEE_COM,
            c.objectid AS fid_libelle
        FROM
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE  b, 
            G_GEO.TA_LIBELLE c 
            INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long
        WHERE
            UPPER(d.valeur) = UPPER('code insee')
    ) t
    ON (a.valeur = t.INSEE_COM AND a.fid_libelle = t.fid_libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.INSEE_COM, t.fid_libelle);

-- 2. Insertion des éométries des communes associées ou déléguées dans la table TA_COMMUNE ;
MERGE INTO G_GEO.TA_COMMUNE a
    USING(
        SELECT 
            CASE
                WHEN UPPER(a.NATURE) = UPPER(c.valeur) AND UPPER(c.valeur) = UPPER('commune associée')
                    THEN a.ORA_GEOMETRY
                WHEN UPPER(a.NATURE) = UPPER(c.valeur) AND UPPER(c.valeur) = UPPER('commune déléguée')
                    THEN a.ORA_GEOMETRY
            END AS geom, 
            b.objectid AS fid_lib_type_commune, 
            d.objectid AS fid_nom, 
            a.INSEE_COM, 
            f.objectid AS fid_metadonnee
        FROM 
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE a
            INNER JOIN G_GEO.TA_NOM d ON d.valeur = a.nom,
            G_GEO.TA_LIBELLE b
            INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid,
            G_GEO.TA_METADONNEE f 
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = f.fid_acquisition
            INNER JOIN G_GEO.TA_SOURCE h ON h.objectid = f.fid_source
        WHERE 
            INSEE_DEP IN('02', '59', '60', '62', '80')
            AND g.millesime = TO_DATE((SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL), 'dd/mm/yy')
            AND g.nom_obtenteur = (SELECT sys_context('USERENV','OS_USER') FROM DUAL)
            AND UPPER(h.nom_source) = UPPER('BdTopo')
    )t
    ON(
        a.fid_lib_type_commune = t.fid_lib_type_commune
        AND a.fid_nom = t.fid_nom
        AND a.fid_metadonnee = t.fid_metadonnee
    )
WHEN NOT MATCHED THEN
    INSERT(a.geom, a.fid_lib_type_commune, a.fid_nom, a.fid_metadonnee)
    VALUES(t.geom, t.fid_lib_type_commune, t.fid_nom, t.fid_metadonnee);

-- 7.1. Association des codes INSEE et des géométries des communes associées ou déléguées dans la table TA_IDENTIFIANT_COMMUNE ;
MERGE INTO G_GEO.TA_IDENTIFIANT_COMMUNE a
    USING(
        SELECT
            b.OBJECTID AS fid_commune,
            a.INSEE_COM AS temp_code_insee,
            h.objectid AS fid_identifiant,
            h.valeur AS prod_code_insee
        FROM
            -- Sélection des géométries de communes et de leur code INSEE dans la table d'import
            G_GEO.TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE a,
            -- Sélection des géométries de communes de TA_COMMUNE que l'on vient d'insérer
            G_GEO.TA_COMMUNE b
            INNER JOIN G_GEO.TA_METADONNEE e ON e.objectid = b.fid_metadonnee
            INNER JOIN G_GEO.TA_SOURCE f ON f.objectid = e.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = e.fid_acquisition,
            -- Sélection des codes communaux de TA_CODE que l'on vient d'insérer (merger)
            G_GEO.TA_CODE h
            INNER JOIN G_GEO.TA_LIBELLE i ON i.objectid = h.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
        WHERE
            -- Condition d'égalité de géométrie entre la table d'import et TA_COMMUNE
            SDO_EQUAL(a.ORA_GEOMETRY, b.GEOM) = 'TRUE'
            AND UPPER(f.nom_source) = UPPER('BdTopo')
            AND g.millesime = TO_DATE((SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL), 'dd/mm/yy')
            AND UPPER(j.valeur) = UPPER('Code INSEE')
            AND h.valeur = a.INSEE_COM
    ) t
    ON (a.fid_identifiant = t.fid_identifiant AND a.fid_commune = t.fid_commune)
WHEN NOT MATCHED THEN
    INSERT(FID_COMMUNE, FID_IDENTIFIANT)
    VALUES(t.fid_commune, t.fid_identifiant);
COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAVE_MAJ_COMMUNES_ASSOCIEES;
END;