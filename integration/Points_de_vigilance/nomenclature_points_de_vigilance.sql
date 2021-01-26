/*
1. Insertion des familles liées aux points de vigilance dans G_GEO.TEMP_FAMILLE ;
2. Insertion des libellés longs dans G_GEO.TEMP_LIBELLE_LONG ;
3. Insertion dans la table pivot G_GEO.TEMP_FAMILLE_LIBELLE ;
4. Insertion dans la table G_GEO.TEMP_LIBELLE ;
5. En cas d'exeption levée, faire un ROLLBACK ;
*/

SET SERVEROUTPUT ON
BEGIN
    SAVEPOINT POINT_SAUVERGARDE_NOMENCLATURE_PTS_VIGILANCE;
-- 1. Insertion des familles liées aux points de vigilance dans G_GEO.TEMP_FAMILLE ;
    MERGE INTO G_GEO.TEMP_FAMILLE a
        USING(
            SELECT
                "valeur"
            FROM
                G_GEO.TEMP_FAMILLE_POINT_VIGILANCE
        )t
        ON (UPPER(a.valeur) = UPPER(t.valeur))
    WHEN NOT MATCHED THEN
        INSERT(a.valeur)
        VALUES(t.valeur);

    -- 2. Insertion des libellés longs dans G_GEO.TEMP_LIBELLE_LONG  
    MERGE INTO G_GEO.TEMP_LIBELLE_LONG a
        USING(
            SELECT
                "valeur"
            FROM
                G_GEO.TEMP_LIBELLE_POINT_VIGILANCE
        )t
        ON (UPPER(a.valeur) = UPPER(t.valeur))
    WHEN NOT MATCHED THEN
        INSERT(a.valeur)
        VALUES(t.valeur);
        
    -- 3. Insertion dans la table pivot G_GEO.TEMP_FAMILLE_LIBELLE
    MERGE INTO G_GEO.TEMP_FAMILLE_LIBELLE a
        USING(
            SELECT *
                FROM
                    (
                        SELECT
                            b.objectid AS fid_famille,
                            b.valeur AS famille,
                            CASE
                                WHEN UPPER(b.valeur) = UPPER('type de signalement des points de vigilance') 
                                        AND UPPER(c.valeur) IN (UPPER('Modification manuelle par les topos'), UPPER('Vérification terrain'), UPPER('Vérification orthophoto'))
                                    THEN c.objectid
                                WHEN UPPER(b.valeur) = UPPER('type de vérification des points de vigilance') 
                                        AND UPPER(c.valeur) IN (UPPER('chantier potentiel'), UPPER('chantier en cours'), UPPER('chantier terminé'))
                                    THEN c.objectid
                                WHEN UPPER(b.valeur) = UPPER('catégories des points de vigilance') 
                                        AND UPPER(c.valeur) IN (UPPER('prioritaire'), UPPER('non-prioritaire'))
                                    THEN c.objectid
                                WHEN UPPER(b.valeur) = UPPER('éléments de vigilance') 
                                        AND UPPER(c.valeur) IN (UPPER('bâti'), UPPER('voirie (clôture, fossé et bordure)'))
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
                            G_GEO.TEMP_FAMILLE b,
                            G_GEO.TEMP_LIBELLE_LONG c
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

    -- 4. Insertion dans la table G_GEO.TEMP_LIBELLE
    MERGE INTO G_GEO.TEMP_LIBELLE a
        USING(
            SELECT
                b.objectid AS fid_libelle_long
            FROM
                G_GEO.TEMP_LIBELLE_LONG b
            WHERE
                UPPER(b.valeur) IN(
                    UPPER('bâti'),
                    UPPER('voirie (clôture,fossé et bordure)'),  
                    UPPER('Modification manuelle par les topos'),
                    UPPER('Vérification terrain'), 
                    UPPER('Vérification orthophoto'),
                    UPPER('chantier potentiel'),
                    UPPER('chantier en cours'),
                    UPPER('chantier terminé'),
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
COMMIT;
-- 5. En cas d'exeption levée, faire un ROLLBACK
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_NOMENCLATURE_PTS_VIGILANCE;
END;
/