-- Correctifs à apporter sur le schéma G_GEO en prod :

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_CORRECTIFS;

-- Correctif des tables TA_METADONNE et TA_METADONNEE_RELATION_ORGANISME
/*
ETAPE
1. Insertion des éléments manquants dans la table TA_METADONNEE_RELATION_ORGANISME
2 correction de la table TA_METADONNEE
3. Suppression des indexes
4. Suppression des colonnes devenues inutile
*/


-- 1. Insertion des éléments manquants dans la table TA_METADONNEE_RELATION_ORGANISME
/* 1.1. BDTOPO / IGN - Insertion dans la table pivot  TA_METADONNEE_RELATION_ORGANISME des objectid de TA_METADONNEE et 
TA_ORGANISME pour la BdTopo et la date d'insertion des communes de la MEL.
*/
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
    USING(
        SELECT 
            a.objectid AS fid_metadonnee,
            b.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a,
            G_GEO.TA_ORGANISME b
        WHERE
            a.objectid = 1
            AND UPPER(b.nom_organisme) = UPPER('Institut National de l''Information Geographie et Forestiere')
    )t
    ON (a.fid_metadonnee = t.fid_metadonnee AND a.fid_organisme = t.fid_organisme)
WHEN NOT MATCHED THEN
    INSERT(a.fid_metadonnee, a.fid_organisme)
    VALUES(t.fid_metadonnee, t.fid_organisme); 

/* 1.2. BDTOPO / IGN - Insertion dans la table pivot  TA_METADONNEE_RELATION_ORGANISME des objectid de TA_METADONNEE et 
TA_ORGANISME pour la BdTopo et la date d'insertion des autres communes des hauts-de-france.
*/
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
    USING(
        SELECT 
            a.objectid AS fid_metadonnee,
            b.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a,
            G_GEO.TA_ORGANISME b
        WHERE
            a.objectid = 41
            AND UPPER(b.nom_organisme) = UPPER('Institut National de l''Information Geographie et Forestiere')
    )t
    ON (a.fid_metadonnee = t.fid_metadonnee AND a.fid_organisme = t.fid_organisme)
WHEN NOT MATCHED THEN
    INSERT(a.fid_metadonnee, a.fid_organisme)
    VALUES(t.fid_metadonnee, t.fid_organisme);

/* 1.3. CONTOURS_IRIS/INSEE - Insertion dans la table pivot  TA_METADONNEE_RELATION_ORGANISME des objectid de TA_METADONNEE et 
TA_ORGANISME pour les contours iris
*/
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
    USING(
        SELECT 
            a.objectid AS fid_metadonnee,
            b.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a,
            G_GEO.TA_ORGANISME b
        WHERE
            a.objectid = 61
            AND UPPER(b.nom_organisme) = UPPER('Institut National de la Statistique et des Etudes Economiques')
    )t
    ON (a.fid_metadonnee = t.fid_metadonnee AND a.fid_organisme = t.fid_organisme)
WHEN NOT MATCHED THEN
    INSERT(a.fid_metadonnee, a.fid_organisme)
    VALUES(t.fid_metadonnee, t.fid_organisme);

-- 2 correction de la table TA_METADONNEE
-- Suppression de la contrainte TA_METADONNEE_FID_ORGANISME_FK
ALTER TABLE G_GEO.TA_METADONNEE
DROP CONSTRAINT TA_METADONNEE_FID_ORGANISME_FK;

-- Suppression de la contrainte TA_METADONNEE_FID_ECHELLE_FK
ALTER TABLE G_GEO.TA_METADONNEE
DROP CONSTRAINT TA_METADONNEE_FID_ECHELLE_FK;

-- 3. Suppression des indexes
-- 3.1. suppression de l'index de la colonne FID_ORGANISME
DROP INDEX ta_metadonnee_fid_organisme_IDX

-- 3.2. Suppression de l'index de la colonne FID_ECHELLE
DROP INDEX ta_metadonnee_fid_echelle_IDX;

-- 4. Suppression des colonnes devenues inutile
-- 4.1. Suppression de la colonne FID_ORGANISME
 ALTER TABLE G_GEO.TA_METADONNEE DROP COLUMN FID_ORGANISME;

-- 4.2. Suppression de la colonne FID_ECHELLE
 ALTER TABLE G_GEO.TA_METADONNEE DROP COLUMN FID_ECHELLE;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Correctif servant à supprimer les doublons de noms dans la table G_GEO.TA_NOM

/*
Objectif : rediriger la FK de TA_IRIS.FID_NOM ver le bon TA_NOM.OBJECTID puisqu'il y a des doublons de noms.
On redirige d'abord les clés étrangères afin de supprimer après les doublons dans TA_NOM.
Résultat attendu : 32 lignes
*/
UPDATE G_GEO.TA_IRIS
SET FID_NOM = (
			CASE
				-- est vers Est
				WHEN FID_NOM = 9024 THEN 6108
				-- gare vers Gare
				WHEN FID_NOM = 9049 THEN 6367
				-- jardins vers Jardins
				WHEN FID_NOM = 9081 THEN 6717
				-- justice vers Justice
				WHEN FID_NOM = 9082 THEN 6739
				-- nord vers Nord
				WHEN FID_NOM = 9147 THEN 224
				-- nord est vers Nord Est
				WHEN FID_NOM = 9148 THEN 7580
				-- nord ouest vers Nord Ouest
				WHEN FID_NOM = 9149 THEN 7582	
				-- ouest vers Ouest
				WHEN FID_NOM = 9154 THEN 7677	
				-- sud vers Sud
				WHEN FID_NOM = 9233 THEN 8493	
				-- sud est vers Sud Est
				WHEN FID_NOM = 9234 THEN 8494	
				-- sud ouest vers Sud Ouest
				WHEN FID_NOM = 9238 THEN 8500	
				-- zone d'activité vers Zone d'activite
				WHEN FID_NOM = 9282 THEN 8982				
			END
			)
WHERE FID_NOM IN (9024,9049,9081,9082,9147,9148,9149,9154,9233,9234,9238,9282);

/*
Objectif : supprimer les noms en doublon
Résultat attendu : 12 lignes supprimées
*/
DELETE FROM G_GEO.TA_NOM
WHERE OBJECTID IN (9024,9049,9081,9082,9147,9148,9149,9154,9233,9234,9238,9282);

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Correctif BPE

/* Correctif de libelle BPE
Résultat attendu : 8 lignes fusionnées
*/
UPDATE G_GEO.TA_LIBELLE_LONG
SET VALEUR = (
            CASE
                WHEN OBJECTID = 38 THEN 'Aide sociale à l''enfance : action éducative'
                WHEN OBJECTID = 63 THEN 'CHRS Centre d''hébergement et de réadaptation sociale'
                WHEN OBJECTID = 95 THEN 'Enfants handicapés : services à domicile ou ambulatoires'
                WHEN OBJECTID = 134 THEN 'Lycée d''enseignement général et/ou technologique'
                WHEN OBJECTID = 137 THEN 'Magasin d''articles de sports et de loisirs'
                WHEN OBJECTID = 182 THEN 'Réparation automobile et de matériel agricole'
                WHEN OBJECTID = 188 THEN 'SGT : Section enseignement général et technologique'
                WHEN OBJECTID = 204 THEN 'Spécialiste en radiodiagnostic et imagerie médicale'
            END
            )
WHERE OBJECTID IN (38,63,95,134,137,182,188,204);

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Correctif Territorie et Unité territoriale

/* Insertion de 'Identifiants des divisions territoriales de la MEL' dans la table G_GEO.TA_FAMILLE. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql. L'utilisation du Merge permet d'insérer toutes
les familles qui ne sont pas encore présentes dans la table, en l'occurrence il s'agit de 'Identifiants des divisions territoriales de la MEL'.
Résultat attendu : 1 ligne fusionnée
*/
MERGE INTO G_GEO.TA_FAMILLE a
    USING(
        SELECT 'types de commune' AS FAMILLE FROM DUAL
        UNION
        SELECT 'zone supra-communale' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Identifiants de zone administrative' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Identifiants des divisions territoriales de la MEL' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Division territoriale de la MEL' AS FAMILLE FROM DUAL
        UNION
        SELECT 'Etablissements de Coopération Intercommunale (EPCI)' AS FAMILLE FROM DUAL
    )t
    ON(
        UPPER(a.valeur) = UPPER(t.famille)
    )
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.famille);

/* Insertion de 'code territoire' et 'code unité territoriale' dans la table G_GEO.TA_LIBELLE_LONG. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql. L'utilisation du Merge permet d'insérer tous
les libellés long qui ne sont pas encore présents dans la table, en l'occurrence il s'agit des deux libellés mentionnés ci-dessus.
Résultat attendu : 2 lignes fusionnées
*/
MERGE INTO G_GEO.TA_LIBELLE_LONG a
    USING(
            SELECT 'département' AS libelle FROM DUAL 
            UNION
            SELECT 'région' AS libelle FROM DUAL
            UNION
            SELECT 'commune simple' AS libelle FROM DUAL 
            UNION
            SELECT 'commune associée' AS libelle FROM DUAL 
            UNION
            SELECT 'Métropole' AS libelle FROM DUAL
            UNION
            SELECT 'Unité Territoriale' AS libelle FROM DUAL
            UNION
            SELECT 'code unité territoriale' AS libelle FROM DUAL
            UNION
            SELECT 'Territoire' AS libelle FROM DUAL
            UNION
            SELECT 'code insee' AS libelle FROM DUAL
            UNION
            SELECT 'code département' AS libelle FROM DUAL
            UNION
            SELECT 'code région' AS libelle FROM DUAL
            UNION
            SELECT 'code territoire' AS libelle FROM DUAL
    ) t
    ON (UPPER(a.valeur) = UPPER(t.libelle))
WHEN NOT MATCHED THEN
    INSERT(a.valeur)
    VALUES(t.libelle);

/* Insertion dans la table pivot G_GEO.TA_FAMILLE_LIBELLE des objectids de la famille et des libellés longs insérés ci-dessus. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql.
Résultat attendu : 2 lignes fusionnées
*/
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
    USING(
        SELECT
            y.fid_famille,
            y.fid_libelle_long
        FROM
            (SELECT DISTINCT
                a.objectid AS fid_famille,
                CASE
                    WHEN UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('commune simple')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('commune associée')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('zone supra-communale') AND UPPER(b.valeur) = UPPER('département')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('zone supra-communale') AND UPPER(b.valeur) = UPPER('région')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Etablissements de Coopération Intercommunale (EPCI)') AND UPPER(b.valeur) = UPPER('Métropole')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Division territoriale de la MEL') AND UPPER(b.valeur) = UPPER('Territoire')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Division territoriale de la MEL') AND UPPER(b.valeur) = UPPER('Unité Territoriale')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code insee')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code département')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('code région')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants des divisions territoriales de la MEL') AND UPPER(b.valeur) = UPPER('code unité territoriale')
                    THEN b.objectid
                    WHEN UPPER(a.valeur) = UPPER('Identifiants des divisions territoriales de la MEL') AND UPPER(b.valeur) = UPPER('code territoire')
                    THEN b.objectid
                END AS fid_libelle_long
            FROM
                G_GEO.TA_FAMILLE a,
                G_GEO.TA_LIBELLE_LONG b
        )y
        WHERE
            y.fid_famille IS NOT NULL
            AND y.fid_libelle_long IS NOT NULL
    )t
    ON(a.fid_famille = t.fid_famille AND a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
    INSERT(a.fid_famille, a.fid_libelle_long)
    VALUES(t.fid_famille, t.fid_libelle_long);


/* Insertion dans la table G_GEO.TA_LIBELLE des objectids des libellés longs insérés ci-dessus. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql.
Résultat attendu : 2 lignes fusionnées
*/
MERGE INTO G_GEO.TA_LIBELLE a
    USING(
        SELECT
            b.objectid AS fid_libelle_long
        FROM
            G_GEO.TA_LIBELLE_LONG b
        WHERE
            UPPER(b.valeur) IN(
                    UPPER('département'),
                    UPPER('région'), 
                    UPPER('commune simple'), 
                    UPPER('commune associée'), 
                    UPPER('Métropole'), 
                    UPPER('Unité Territoriale'), 
                    UPPER('code unité territoriale'), 
                    UPPER('Territoire'), 
                    UPPER('code insee'), 
                    UPPER('code département'), 
                    UPPER('code région'), 
                    UPPER('code territoire'))
    )t
    ON (a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
    INSERT(a.fid_libelle_long)
    VALUES(t.fid_libelle_long);

/* Correction des noms d'un Territoire et d'une Unité Territoriale
Résultat attendu : 2 lignes mises à jour
*/
UPDATE G_GEO.TA_NOM
SET VALEUR = 'Territoire Lillois'
WHERE VALEUR = 'Lille-Lomme-Hellemmes';
COMMIT ;

UPDATE G_GEO.TA_NOM
SET VALEUR = 'Marcq en Baroeul-la-Bassee'
WHERE VALEUR = 'La Basse-Marcq en Baroeul';
COMMIT ;

/* Insertion des codes territoire et codes unité territoriale dans la table G_GEO.TA_CODE. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql. L'utilisation du Merge permet d'insérer tous
les codes qui ne sont pas encore présents dans la table, en l'occurrence il s'agit des deux types de codes mentionnés ci-dessus.
Résultat attendu : 12 lignes fusionnées
*/
MERGE INTO G_GEO.TA_CODE a
    USING(
            SELECT *
            FROM
                (WITH
                    C_1 AS(
                        SELECT '1' AS code
                        FROM DUAL
                        UNION
                        SELECT '2' AS code
                        FROM DUAL
                        UNION
                        SELECT '3' AS code
                        FROM DUAL
                        UNION
                        SELECT '4' AS code
                        FROM DUAL
                        UNION
                        SELECT '5' AS code
                        FROM DUAL
                        UNION
                        SELECT '6' AS code
                        FROM DUAL
                        UNION
                        SELECT '7' AS code
                        FROM DUAL
                        UNION
                        SELECT '8' AS code
                        FROM DUAL
                        UNION
                        SELECT '02' AS code
                        FROM DUAL
                        UNION
                        SELECT '59' AS code
                        FROM DUAL
                        UNION
                        SELECT '60' AS code
                        FROM DUAL
                        UNION
                        SELECT '62' AS code
                        FROM DUAL
                        UNION
                        SELECT '80' AS code
                        FROM DUAL
                        UNION
                        SELECT '32' AS code
                        FROM DUAL
                    )
                SELECT
                    CASE
                        WHEN UPPER(c.valeur) = UPPER('code territoire') AND a.code IN('1', '2', '3', '4', '5', '6', '7', '8') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code unité territoriale') AND a.code IN('1', '2', '3', '4') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code département') AND a.code IN('02', '59', '60', '62', '80') THEN a.code
                        WHEN UPPER(c.valeur) = UPPER('code région') AND a.code = '32' THEN a.code
                    END AS code,
                    b.objectid AS libelle,
                    c.valeur AS libelle_long
                FROM
                    C_1 a,
                    G_GEO.TA_LIBELLE b 
                    INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
                )x
            WHERE
                x.code IS NOT NULL
                AND x.libelle IS NOT NULL            
    ) t
    ON (a.valeur = t.code AND a.fid_libelle = t.libelle)
WHEN NOT MATCHED THEN
    INSERT(a.valeur, a.fid_libelle)
    VALUES(t.code, t.libelle);

/* Insertion dans la table pivot G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE des objectids des codes et des zones administratives des Territoires et des Unités Territoriales. 
Ce code est issu du fichier Insertion_des_communes_des_hauts_de_france.sql.
Objectif : associer chaque territoiren et unité territoriale à son code.
Résultat attendu : 12 ligne fusionnées.
*/
MERGE INTO G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE a
USING(
    SELECT *
    FROM
        (
            SELECT DISTINCT
                    CASE
                        WHEN UPPER(b.valeur) = UPPER('Territoire Est') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '5' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Tourquennois') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '2' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire des Weppes') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '1' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Lillois') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '8' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Couronne Nord de Lille') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '6' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Couronne Sud de Lille') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '7' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire Roubaisien') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '3' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Territoire de la Lys') AND UPPER(d.valeur) = UPPER('Territoire') AND e.valeur = '4' AND UPPER(g.valeur) = UPPER('Code Territoire')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Lille-Seclin') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '1' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Marcq en Baroeul-la-Bassee') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '2' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Roubaix-Villeneuve d''Ascq') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '3' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Tourcoing-Armentières') AND UPPER(d.valeur) = UPPER('Unité Territoriale') AND e.valeur = '4' AND UPPER(g.valeur) = UPPER('Code Unité Territoriale')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Aisne') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '02' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Nord') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '59' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Pas-de-Calais') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '62' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Somme') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '80' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Oise') AND UPPER(d.valeur) = UPPER('département') AND e.valeur = '60' AND UPPER(g.valeur) = UPPER('code département')
                            THEN e.objectid
                        WHEN UPPER(b.valeur) = UPPER('Hauts-de-France') AND UPPER(d.valeur) = UPPER('région') AND e.valeur = '32' AND UPPER(g.valeur) = UPPER('code région')
                            THEN e.objectid
                    END AS ID_CODE,
                    e.valeur AS code,
                    a.objectid AS ID_ZONE_ADMIN,
                    b.valeur AS NOM_ZONE_ADMIN
                FROM
                    G_GEO.TA_ZONE_ADMINISTRATIVE a
                    INNER JOIN G_GEO.TA_NOM b ON b.objectid = a.fid_nom
                    INNER JOIN G_GEO.TA_LIBELLE c ON c.objectid = a.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG d ON d.objectid = c.fid_libelle_long,
                    G_GEO.TA_CODE e
                    INNER JOIN G_GEO.TA_LIBELLE f ON f.objectid = e.fid_libelle
                    INNER JOIN G_GEO.TA_LIBELLE_LONG g ON g.objectid = f.fid_libelle_long
                WHERE
                    UPPER(d.valeur) IN(UPPER('Territoire'), UPPER('Unité Territoriale'), UPPER('département'), UPPER('région'))
                    AND UPPER(g.valeur) IN(UPPER('code territoire'), UPPER('code unité territoriale'), UPPER('code département'), UPPER('code région'))
        ) a
    WHERE
        a.ID_CODE IS NOT NULL
) t
ON (a.fid_zone_administrative = t.ID_ZONE_ADMIN AND a.fid_identifiant = t.ID_CODE)
WHEN NOT MATCHED THEN
    INSERT(a.fid_zone_administrative, a.fid_identifiant)
    VALUES(t.id_zone_admin, t.id_code);

COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_CORRECTIFS;
END;
/