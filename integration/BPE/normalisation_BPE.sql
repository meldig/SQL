-- 1. Suppression des BPE enseignement de la table des BPE ensemble

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

-- 2. Suppression des BPE SPORT LOISIRS de la table des BPE ensemble
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

-- 3.3 Ajout des métadonnées

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

INSERT INTO ta_bpe_geom(geom)
SELECT 
    ora_geometry
FROM
    BPE_TOUT
WHERE
    "IDENTITE" NOT IN
        (SELECT id_b
            FROM
                (SELECT
                        a."IDENTITE" AS id_a,
                        b."IDENTITE" AS id_b
                    FROM
                        BPE_TOUT a,
                        BPE_TOUT b
                    WHERE
                        a."IDENTITE" < b."IDENTITE"
                    AND
                        SDO_RELATE(a.ora_geometry, b.ora_geometry,'mASk=equal') = 'TRUE'));
COMMIT;

-- 5. Insertion des données dans la table TA_BPE.

INSERT INTO ta_bpe(objectid, fid_bpe_geom,fid_metadonnee)
SELECT
	    a."IDENTITE",
	    b.objectid,
	    m.objectid
	FROM
	    BPE_TOUT a,
	    TA_BPE_GEOM b,
	    TA_METADONNEE m
	WHERE
	    SDO_RELATE(a.ora_geometry, b.geom,'mASk=equal') = 'TRUE'
	AND
		m.objectid =(SELECT
                        max(objectid)
                    FROM
                        ta_metadonnee)
	;
COMMIT;

-- 6. Insertion des données dans la table ta_bpe_caracteristique nombre

-- 6.1 Insertion des caracteristiques liés aux nb_airejeu (Nombre d'aires de pratique d'un meme type au sein de l'equipement)

INSERT INTO ta_bpe_caracteristique_nombre(fid_bpe,fid_libelle,nombre)
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

-- 6.2 Insertion des caracteristiques liés aux nb_salles(nombre de salles par theatre ou cinema)

INSERT INTO ta_bpe_caracteristique_nombre(fid_bpe,fid_libelle,nombre)
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

-- 7. Insertion des données dans la table ta_bpe_caracteristique

-- 7.1 Insertion des caracteristique TYPEQU.

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.2 INSERTION DES CARACTERISTIQUES LIEES AUX CANT (présence ou absence d'une cantine).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.3 INSERTION DES CARACTERISTIQUES LIEES AUX CL_PELEM (présence ou absence d'une clASse pre_elementaire en ecole primaire).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.4 INSERTION DES CARACTERISTIQUES LIEES AUX CL_PGE (présence ou absence d'une clASse preparatoire aux grandes ecoles en lycee).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.5 INSERTION DES CARACTERISTIQUES LIEES AUX EP (Appartenance ou non à un dispositif d'education prioritaire).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.6 INSERTION DES CARACTERISTIQUES LIEES AUX INT (présence ou absence d'un internat).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.7 INSERTION DES CARACTERISTIQUES LIEES AUX QUALITE XY (qualite d'attribution pour un equipement de ses coordonnees XY).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.8 INSERTION DES CARACTERISTIQUES LIEES AUX RPIC (Presence ou absence d'un regroupement pedagogique intercommunal concentre).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.9 INSERTION DES CARACTERISTIQUES LIEES AUX SECT (appartenance au secteur public ou prive d'enseignement).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.10 INSERTION DES CARACTERISTIQUES LIEES AUX COUVERT (equipement couvert ou non).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 7.11 INSERTION DES CARACTERISTIQUES LIEES AUX ECLAIRE (equipement couvert ou non).

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
    --2. CTE2 pour SELECTionner les correspondances entre les libelles et les libelles courts
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
    --3. CTE3 SELECTion des des correspondances à partir des cles étrangères.
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
            --4. Possibilite de mettre en filtres sur la SELECTion ex sur le libelle court parent:
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

-- 13. Suppression de la table sythétisant les informations des BPE et des metadonnées de celle-ci. 
DROP TABLE bpe_tout CASCADE CONSTRAINTS;

DELETE
FROM
    user_sdo_geom_metadata
WHERE
    table_name = 'BPE_TOUT';