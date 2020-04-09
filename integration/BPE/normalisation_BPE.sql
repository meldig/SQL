-- 1 Suppression des équipements présents dans la table BPE_ENSEMBLE mais également des les tables BPE_ENSEIGNEMENT et BPE_SPORT_LOISIR
-- 1.1 suppression des BPE enseignement de la table des BPE ensemble

DELETE
FROM
	BPE_ENSEMBLE
WHERE
	"TYPEQU"
	IN
	(SELECT
		"TYPEQU"
	FROM
		BPE_ENSEIGNEMENT);
COMMIT;

-- 1.2 suppression des BPE SPORT LOISIRS de la table des BPE ensemble.

DELETE
FROM
	BPE_ENSEMBLE
WHERE
	"TYPEQU"
	IN
	(SELECT
		"TYPEQU"
	FROM
		BPE_SPORT_LOISIR);
COMMIT;

-- 3. Création de la table temporaire pour synthétiser l'ensemble des informations des 3 couches BPE

-- 3.1. Creation de la table

CREATE TABLE BPE_TOUT AS
	SELECT
		"OGR_FID",
		"id",
		"REG",
		"DEP",
		"DEPCOM",
		"DCIRIS",
		"AN",
		"TYPEQU",
		NULL AS "CANT",
		NULL AS "INT",
		NULL AS "RPIC",
		NULL AS "CL_PELEM",
		NULL AS "CL_PGE",
		NULL AS "EP",
		NULL AS "SECT",
		"LAMBERT_X",
		"LAMBERT_Y",
		"QUALITE_XY",
		NULL AS "COUVERT", 
		NULL AS "ECLAIRE",
		NULL AS "NB_AIREJEU", 
		NULL AS "NB_SALLES",
		"ORA_GEOMETRY"
	FROM 
		BPE_ENSEMBLE
		UNION ALL
			SELECT
				"OGR_FID",
				"id",
				"REG",
				"DEP",
				"DEPCOM",
				"DCIRIS",
				"AN",
				"TYPEQU",
				NULL AS "CANT",
				NULL AS "INT",
				NULL AS "RPIC",
				NULL AS "CL_PELEM",
				NULL AS "CL_PGE",
				NULL AS "EP",
				NULL AS "SECT",
				"LAMBERT_X",
				"LAMBERT_Y",
				"QUALITE_XY",
				"COUVERT", 
				"ECLAIRE",
				"NB_AIREJEU", 
				"NB_SALLES",
				"ORA_GEOMETRY"
			FROM 
				BPE_SPORT_LOISIR
		UNION ALL
			SELECT
				"OGR_FID",
				"id",
				"REG",
				"DEP",
				"DEPCOM",
				"DCIRIS",
				"AN",
				"TYPEQU",
				"CANT",
				"INT",
				"RPIC",
				"CL_PELEM",
				"CL_PGE",
				"EP",
				"SECT",
				"LAMBERT_X",
				"LAMBERT_Y",
				"QUALITE_XY",
				NULL AS "COUVERT", 
				NULL AS "ECLAIRE",
				NULL AS "NB_AIREJEU", 
				NULL AS "NB_SALLES",
				"ORA_GEOMETRY"
			FROM 
				BPE_ENSEIGNEMENT;
COMMIT;

-- 3.2 Ajout d'une colonne IDENTITY dans la table pour créer des nouveaux identifiants

ALTER TABLE BPE_TOUT
ADD IDENTITE INTEGER GENERATED ALWAYS AS IDENTITY
START WITH 1
INCREMENT BY 1
NOCACHE;
COMMIT;

-- 3.3 Correction du format des codes IRIS pour permettre une jointure avec TA_CODE afin d'insérer des données dans la table TA_BPE_RELATION_CODE
-- Les codes IRIS de la base BPE ne sont pas au bon format. Il y a d'une part un underscore entre le code INSEE et le code IRIS
-- et d'autre part pour les communes non divisés en IRIS le code IRIS est le code INSEE de la commune alors que normalement il s'agit du code INSEE suivi de quatre zéros.
-- l'instruction CASE permet suivant les cas soit de rajouter quatre zéros si le code IRIS ne comporte que 4 chiffre
-- ou de supprimer le underscore s'il y en a un.

UPDATE bpe_tout
SET "DCIRIS" = (
    CASE
        WHEN LENGTH("DCIRIS") = '5' THEN "DCIRIS" || '0000'
        WHEN dciris like '%_%' THEN REPLACE("DCIRIS",'_','')
    END)
    ;

-- 3.4 Ajout des métadonnées

INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'BPE_TOUT',
    'ORA_GEOMETRY',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
)
;
COMMIT;

-- 4. Insertion des données geometrique dans la table TA_BPE_GEOMETRIE
-- le WHERE permet de selectionner uniquement les géométries uniques et non les doublons
-- le AND permet de ne pas insérer des géométrie déja existante dans la table.

INSERT INTO ta_bpe_geom(geom)
SELECT 
    ora_geometry
FROM
    bpe_tout a
WHERE
    identite NOT IN
        (SELECT id_b
            FROM
                (SELECT
                        a.identite AS id_a,
                        b.identite AS id_b
                    FROM
                        bpe_tout a,
                        bpe_tout b
                    WHERE
                        a.identite < b.identite
                    AND
                        SDO_RELATE(a.ora_geometry, b.ora_geometry,'mask=equal') = 'TRUE'))
AND
    identite not IN
        (SELECT
            a.identite
        FROM
            bpe_tout a,
            ta_bpe_geom b
        WHERE
            SDO_RELATE(a.ora_geometry, b.geom,'mask=equal') = 'TRUE')
;
COMMIT;

-- 5. Insertion des données dans la table TA_BPE.
-- la sous requete permet de mettre le fid_metadonnées de la donnée considéré au dernier millesime.

INSERT INTO ta_bpe(objectid,fid_metadonnee)
SELECT
    a.identite,
    m.objectid
FROM
    BPE_TOUT a,
    TA_METADONNEE m
WHERE
    m.objectid IN
        (
        SELECT
            metadonnee_objectid
        FROM
            (
            SELECT
                max(a.objectid) as metadonnee_objectid,
                max(c.nom_source) as source,
                max(b.millesime) as millesime,
                max(p.url) as url,
                max(o.acronyme)as acronyme
            FROM
                ta_metadonnee a
                INNER JOIN ta_date_acquisition b ON a.fid_acquisition = b.objectid
                INNER JOIN ta_source c ON a.fid_source = c.objectid
                INNER JOIN ta_provenance p ON a.fid_provenance = p.objectid
                INNER JOIN ta_organisme o ON a.fid_organisme = o.objectid
            WHERE
                c.nom_source = ('Base Permanente des Equipements')
            )
        )
;
COMMIT;

-- 6. Insertion des données dans la table ta_bpe_relation_geom

INSERT INTO ta_bpe_relation_geom(fid_bpe,fid_bpe_geom)
SELECT
    a.identite,
    b.objectid
FROM
    bpe_tout a,
    ta_bpe_geom b
WHERE
    SDO_RELATE(a.ora_geometry, b.geom,'mask=equal') = 'TRUE'
    ;

-- 7. Insertion des données dans la table ta_bpe_caracteristique nombre

-- 7.1 Insertion des caracteristiques liés aux nb_airejeu (Nombre d'aires de pratique d'un meme type au sein de l'equipement)

INSERT INTO ta_bpe_caracteristique_quantitative(fid_bpe,fid_libelle,nombre)
(
SELECT 
	a."IDENTITE",
	b.objectid,
	a."NB_AIREJEU"
FROM 
	bpe_tout a,
	ta_libelle b
WHERE
	"NB_AIREJEU" IS NOT NULL
	AND b.libelle = ('Nombre d''aires de pratique d''un même type au sein de l''équipement')
)
;
COMMIT;

-- 7.2 Insertion des caracteristiques liés aux nb_salles(nombre de salles par theatre ou cinema)

INSERT INTO ta_bpe_caracteristique_quantitative(fid_bpe,fid_libelle,nombre)
(
SELECT 
	a."IDENTITE",
	b.objectid,
	a."NB_SALLES"
FROM 
	bpe_tout a,
	ta_libelle b
WHERE
	"NB_SALLES" IS NOT NULL
	AND b.libelle = ('Nombre de salles par théatre ou cinéma')
)
;
COMMIT;

-- 8. Insertion des données dans la table ta_bpe_caracteristique

-- 8.1 Insertion des caracteristique TYPEQU.

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE '__'
            AND
                cte2p.libelle_court  NOT IN ('PR','PU','EP')
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."TYPEQU" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('__')
    AND
        cte3.libelle_court_parent  NOT IN ('PR','PU','EP'));
COMMIT;

-- 8.2 INSERTION DES CARACTERISTIQUES LIEES AUX CANT (présence ou absence d'une cantine).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'CANT'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."CANT" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('CANT')
    )
	;
COMMIT;

-- 8.3 INSERTION DES CARACTERISTIQUES LIEES AUX CL_PELEM (présence ou absence d'une clASse pre_elementaire en ecole primaire).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'CL_PELEM'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."CL_PELEM" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('CL_PELEM')
    )
    ;
COMMIT;

-- 8.4 INSERTION DES CARACTERISTIQUES LIEES AUX CL_PGE (présence ou absence d'une clASse preparatoire aux grandes ecoles en lycee).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'CL_PGE'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."CL_PGE" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('CL_PGE')
    )
    ;
COMMIT;

-- 8.5 INSERTION DES CARACTERISTIQUES LIEES AUX EP (Appartenance ou non à un dispositif d'education prioritaire).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'EP'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."EP" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('EP')
    )
    ;
COMMIT;

-- 8.6 INSERTION DES CARACTERISTIQUES LIEES AUX INT (présence ou absence d'un internat).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'INT'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."INT" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('INT')
    )
    ;
COMMIT;

-- 8.7 INSERTION DES CARACTERISTIQUES LIEES AUX QUALITE XY (qualite d'attribution pour un equipement de ses coordonnees XY).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'QUALITE_XY'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."QUALITE_XY" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('QUALITE_XY')
    )
    ;
COMMIT;

-- 8.8 INSERTION DES CARACTERISTIQUES LIEES AUX RPIC (Presence ou absence d'un regroupement pedagogique intercommunal concentre).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'RPIC'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."RPIC" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('RPIC')
    )
    ;
COMMIT;

-- 8.9 INSERTION DES CARACTERISTIQUES LIEES AUX SECT (appartenance au secteur public ou prive d'enseignement).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'SECT'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."SECT" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('SECT')
    )
    ;
COMMIT;

-- 8.10 INSERTION DES CARACTERISTIQUES LIEES AUX COUVERT (equipement couvert ou non).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'COUVERT'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."COUVERT" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('COUVERT')
    )
    ;
COMMIT;

-- 8.11 INSERTION DES CARACTERISTIQUES LIEES AUX ECLAIRE (equipement couvert ou non).

INSERT INTO ta_bpe_caracteristique (fid_bpe, fid_libelle_fils,fid_libelle_parent)
SELECT
    "IDENTITE",
    libelle_fils_objectid,
    libelle_parent_objectid
FROM(
    WITH
    cte1 AS (
            SELECT
                tlf.objectid AS libelle_fils_objectid,
                tlf.libelle AS libelle_fils,
                tlp.objectid AS libelle_parent_objectid,
                tlp.libelle AS libelle_parent
            FROM 
                ta_relation_libelle tr
            INNER JOIN
                ta_libelle tlf
            ON
                tlf.objectid = tr.fid_libelle_fils
            INNER JOIN
                ta_libelle tlp
            ON
                tlp.objectid = tr.fid_libelle_parent
            ),
    --2. CTE2 pour selection les correspondances entre les libelles et les libelles courts
            cte2 AS
            (
            SELECT 
                tl.objectid AS libelle_objectid,
                tl.libelle AS libelle,
                tlc.objectid AS libelle_court_ojectid,
                tlc.libelle_court AS libelle_court
            FROM
                ta_correspondance_libelle tc
            INNER JOIN
                ta_libelle tl
            ON
                tc.fid_libelle=tl.objectid
            INNER JOIN
                ta_libelle_court tlc
            ON
                tc.fid_libelle_court=tlc.objectid
            ),
    --3. CTE3 selection des des correspondances à partir des cles étrangères.
            cte3 AS
            (
            SELECT 
                cte1.libelle_fils_objectid,
                cte1.libelle_fils,
                cte2f.libelle_court AS libelle_court_fils,
                cte1.libelle_parent_objectid,
                cte1.libelle_parent,
                cte2p.libelle_court AS libelle_court_parent
            FROM
                cte1
            INNER JOIN
                cte2 cte2f
            ON
                cte1.libelle_fils_objectid = cte2f.libelle_objectid
            INNER JOIN
             cte2 cte2p
            ON
                cte1.libelle_parent_objectid = cte2p.libelle_objectid
            --4. Possibilite de mettre en filtres sur la selection ex sur le libelle court parent:
            WHERE
                cte2p.libelle_court LIKE 'ECLAIRE'
            )
    SELECT
        a."IDENTITE", cte3.libelle_fils_objectid, cte3.libelle_parent_objectid
    FROM 
        bpe_tout a,
        cte3
    WHERE
        a."ECLAIRE" = cte3.libelle_court_fils
    AND
        cte3.libelle_court_parent
    LIKE
        ('ECLAIRE')
    )
    ;
COMMIT;


--9 Insertion des données dans la table TA_BPE_RELATION_CODE
-- 9.1 Insertion des relations BPE IRIS

INSERT INTO ta_bpe_relation_code(fid_bpe,fid_code)
SELECT
    a.identite,
    b.objectid
FROM
    bpe_tout a
    INNER JOIN ta_code b ON a.dciris = b.code
    INNER JOIN ta_libelle c ON b.fid_libelle = c.objectid
WHERE
    c.libelle ='code iris';

-- 9.2 Insertion des relations BPE Communes

INSERT INTO ta_bpe_relation_code(fid_bpe,fid_code)
SELECT
    a.identite,
    b.objectid
FROM
    bpe_tout a
    INNER JOIN ta_code b ON a.depcom = b.code
    INNER JOIN ta_libelle c ON b.fid_libelle = c.objectid
WHERE
    c.libelle ='code insee';

-- 10. Suppression de la table sythétisant les informations des BPE et des metadonnées de celle-ci. 
-- 10.1 Suppression de la table
DROP TABLE bpe_tout CASCADE CONSTRAINTS;

-- 10.2 Suppresion des metadonnées spatiales
DELETE
FROM
    user_sdo_geom_metadata
WHERE
    table_name = 'BPE_TOUT';