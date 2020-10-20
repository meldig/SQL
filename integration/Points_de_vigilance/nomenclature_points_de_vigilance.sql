/*
1. Insertion des familles liées aux points de vigilance dans G_GEO.TA_FAMILLE ;
2. Insertion des libellés longs dans G_GEO.TA_LIBELLE_LONG ;
3. Insertion dans la table pivot G_GEO.TA_FAMILLE_LIBELLE ;
4. Insertion dans la table G_GEO.TA_LIBELLE ;
*/

-- 1. Insertion des familles liées aux points de vigilance dans G_GEO.TA_FAMILLE ;
MERGE INTO G_GEO.TA_FAMILLE a
    USING(
        SELECT
            'éléments de vigilance' AS valeur
        FROM DUAL UNION
        SELECT
            'type de signalement des points de vigilance' AS valeur
        FROM DUAL UNION
        SELECT
            'type de vérification des points de vigilance' AS valeur
        FROM DUAL UNION
        SELECT
            'statut du dossier' AS valeur
        FROM DUAL UNION
        SELECT
            'catégories des points de vigilance' AS valeur
        FROM DUAL UNION
        SELECT
            'type des actions des pnoms' AS valeur
        FROM DUAL UNION
        SELECT
            'type de dates' AS valeur
        FROM DUAL UNION
        SELECT
            'type de points de vigilance' AS valeur
        FROM DUAL
    )t
    ON (UPPER(a.valeur) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.valeur);

-- 2. Insertion des libellés longs dans G_GEO.TA_LIBELLE_LONG  
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(
        SELECT
            'bâti - gros chantier' AS valeur
        FROM DUAL UNION
        SELECT
            'bâti - petit chantier' AS valeur
        FROM DUAL UNION
        SELECT
            'voirie (clôture,fossé et bordure)' AS valeur
        FROM DUAL UNION
        SELECT
            'Création' AS valeur
        FROM DUAL UNION
        SELECT
            'Modification manuelle' AS valeur
        FROM DUAL UNION
        SELECT
            'Vérification terrain' AS valeur
        FROM DUAL UNION
        SELECT
            'Vérification ortho2020' AS valeur
        FROM DUAL UNION
        SELECT
            'chantier potentiel' AS valeur
        FROM DUAL UNION
        SELECT
            'chantier en cours' AS valeur
        FROM DUAL UNION
        SELECT
            'chantier terminé' AS valeur
        FROM DUAL UNION
        SELECT
            'démolition' AS valeur
        FROM DUAL UNION
        SELECT
            'permis de construire' AS valeur
        FROM DUAL UNION
        SELECT
            'erreur carto' AS valeur
        FROM DUAL UNION
        SELECT
            'erreur topo' AS valeur
        FROM DUAL UNION
        SELECT
            'point de vigilance' AS valeur
        FROM DUAL UNION
        SELECT
            'insertion' AS valeur
        FROM DUAL UNION
        SELECT
            'édition' AS valeur
        FROM DUAL UNION
        SELECT
            'clôture' AS valeur
        FROM DUAL UNION
        SELECT
            'prioritaire' AS valeur
        FROM DUAL UNION
        SELECT
            'non-prioritaire' AS valeur
        FROM DUAL UNION
        SELECT
            'traité' AS valeur
        FROM DUAL UNION
        SELECT
            'non-traité' AS valeur
        FROM DUAL
    )t
    ON (UPPER(a.valeur) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.valeur);
    
-- 3. Insertion dans la table pivot G_GEO.TA_FAMILLE_LIBELLE
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
    USING(
        SELECT *
            FROM
                (
                    SELECT
                        b.objectid AS fid_famille,
                        b.valeur AS famille,
                        CASE
                            WHEN UPPER(b.valeur) = UPPER('type de signalement des points de vigilance') 
                                    AND UPPER(c.valeur) IN (UPPER('Création'), UPPER('Modification manuelle'), UPPER('Vérification terrain'), UPPER('Vérification ortho2020'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('type de vérification des points de vigilance') 
                                    AND UPPER(c.valeur) IN (UPPER('chantier potentiel'), UPPER('chantier en cours'), UPPER('chantier terminé'), UPPER('permis de construire'), UPPER('démolition'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('catégories des points de vigilance') 
                                    AND UPPER(c.valeur) IN (UPPER('prioritaire'), UPPER('non-prioritaire'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('éléments de vigilance') 
                                    AND UPPER(c.valeur) IN (UPPER('bâti - gros chantier'), UPPER('bâti - petit chantier'), UPPER('voirie (clôture,fossé et bordure)'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('statut du dossier') 
                                    AND UPPER(c.valeur) IN (UPPER('traité'), UPPER('non-traité'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('type de points de vigilance') 
                                    AND UPPER(c.valeur) IN (UPPER('erreur carto'), UPPER('erreur topo'), UPPER('point de vigilance'))
                                THEN c.objectid
                            WHEN UPPER(b.valeur) = UPPER('type des actions des pnoms') 
                                    AND UPPER(c.valeur) IN (UPPER('insertion'), UPPER('édition'), UPPER('clôture'))
                                THEN c.objectid
                        END AS fid_libelle_long,
                        c.valeur AS libelle_long
                    FROM
                        G_GEO.TA_FAMILLE b,
                        G_GEO.TA_LIBELLE_LONG c
                )e
            WHERE
                e.fid_libelle_long IS NOT NULL
                AND  e.fid_famille IS NOT NULL
    )t
    ON(
        a.fid_famille = t.fid_famille
        AND a.fid_libelle_long = t.fid_libelle_long
    )
WHEN NOT MATCHED THEN
    INSERT(a.fid_famille, a.fid_libelle_long)
    VALUES(t.fid_famille, t.fid_libelle_long);

-- 4. Insertion dans la table G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
    USING(
        SELECT
            b.objectid AS fid_libelle_long
        FROM
            G_GEO.TA_LIBELLE_LONG b
        WHERE
            UPPER(b.valeur) IN(
                UPPER('bâti - gros chantier'), 
                UPPER('bâti - petit chantier'), 
                UPPER('voirie (clôture,fossé et bordure)'), 
                UPPER('Création'), 
                UPPER('Modification manuelle'),
                UPPER('Vérification terrain'), 
                UPPER('Vérification ortho2020'),
                UPPER('chantier potentiel'),
                UPPER('chantier en cours'),
                UPPER('chantier terminé'),
                UPPER('démolition'),
                UPPER('permis de construire'),
                UPPER('erreur carto'),
                UPPER('erreur topo'),
                UPPER('point de vigilance'),
                UPPER('insertion'),
                UPPER('édition'),
                UPPER('clôture'),
                UPPER('traité'), 
                UPPER('non-traité'),
                UPPER('prioritaire'), 
                UPPER('non-prioritaire')
            )
    )t
    ON (a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
    INSERT(a.fid_libelle_long)
    VALUES(t.fid_libelle_long);