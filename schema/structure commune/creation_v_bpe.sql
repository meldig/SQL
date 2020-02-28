-- CREATION DE LA VUE DES BPE.
--1.SUPPRESSION DE LA VUE SI DEJA EXISTANTE
DROP VIEW v_bpe;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.v_bpe(
    OBJECTID,
    CODE_INSEE,
    TYPEQU,
    CANT,
    CL_PELEM,
    CL_PGE,
    EP,
    INT,
    RPIC,
    SECT,
    COUVERT,
    ECLAIRE,
    NB_AIREJEU,
    NB_SALLES,
    SOURCE,
    geom,
    CONSTRAINT "v_bpe_PK" PRIMARY KEY ("OBJECTID") DISABLE
)
AS
    WITH 
-- sous selection pour obtenir les equipements
    bpe AS (
        SELECT
            distinct(fid_bpe) AS OBJECTID
        FROM
            g_geo.ta_bpe_caracteristique
        ), 
-- sous selection pour obtenir les codes insee
    code_insee AS (
        SELECT
            bpe.objectid,
            code.code AS CODE_INSEE
        FROM
            g_geo.ta_bpe bpe,
            g_geo.ta_code code
            INNER JOIN g_geo.ta_identifiant_commune tc ON tc.fid_identifiant = code.objectid
            INNER JOIN g_geo.ta_commune commune ON tc.fid_commune = commune.objectid
        WHERE
            commune.fid_metadONnee = 1
            AND SDO_RELATE(bpe.geom,commune.geom,'mASk=inside') = 'TRUE'
            AND code.fid_libelle = 1
        ),
-- sous selection de la colonne TYPEQU
    typequ AS (
        SELECT 
            tc.fid_bpe,
            tlcf.libelle_court AS TYPEQU
        FROM 
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE 
            tlcp.libelle_court LIKE '__' 
            AND tlcp.libelle_court NOT IN ('PR','PU','EP')
        ),
-- sous selection de la colonne CANT
    sc AS (
        SELECT 
            tc.fid_bpe,
            tlcf.libelle_court AS CANT
        FROM 
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE 
            tlcp.libelle_court = 'CANT'
        ),
-- sous selection de la colonne CL_PELEM
    clpelem AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS CL_PELEM
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'CL_PELEM'
        ),
-- sous selection de la colonne CL_PGE
    clpge AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS CL_PGE
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'CL_PGE'
        ),
-- sous selection de la colonne EP
    ep AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS EP
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'EP'
        ),
-- sous selection de la colonne INT
    internat AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS INT
        FROM 
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'INT'
        ),
-- sous selection de la colonne RPIC
    rpic AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS RPIC
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'RPIC'
        ),
-- sous selection de la colonne SECT
    sect AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS SECT
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'SECT'
        ),
-- sous selection de la colonne COUVERT
    couvert AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS COUVERT
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'COUVERT'
        ),
-- sous selection de la colonne ECLAIRE
    eclaire AS (
        SELECT
            tc.fid_bpe,
            tlcf.libelle_court AS ECLAIRE
        FROM
            g_geo.ta_bpe_caracteristique tc
            LEFT JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
            LEFT JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        WHERE
            tlcp.libelle_court = 'ECLAIRE'
        ),
-- sous selection de la colonne NB_AIREJEU
    nbairejeu AS (
        SELECT
            tc.fid_bpe,
            tc.nombre AS NB_AIREJEU
        FROM
            g_geo.ta_bpe_caracteristique_nombre tc
            LEFT JOIN g_geo.ta_libelle tl ON tc.fid_libelle = tl.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcr ON tcr.fid_libelle = tl.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlc ON tcr.fid_libelle_court = tlc.objectid
        WHERE
            tlc.libelle_court = 'NB_AIREJEU'
        ),
-- sous selection de la colonne NB_SALLES
    nbsalles AS (
        SELECT
            tc.fid_bpe,
            tc.nombre AS NB_SALLES
        FROM
            g_geo.ta_bpe_caracteristique_nombre tc
            LEFT JOIN g_geo.ta_libelle tl ON tc.fid_libelle = tl.objectid
            LEFT JOIN g_geo.ta_bpe_correspONdance_libelle tcr ON tcr.fid_libelle = tl.objectid
            LEFT JOIN g_geo.ta_bpe_libelle_court tlc ON tcr.fid_libelle_court = tlc.objectid
        WHERE
            tlc.libelle_court = 'NB_SALLES'
        )
-- jointure totale
        SELECT 
            tc.OBJECTID,
            code_insee.CODE_INSEE,
            typequ.TYPEQU,
            sc.CANT,
            clpelem.CL_PELEM,
            clpge.CL_PGE,
            ep.EP,
            internat.INT,
            rpic.RPIC,
            sect.SECT,
            couvert.COUVERT,
            eclaire.ECLAIRE,
            nbairejeu.NB_AIREJEU,
            nbsalles.NB_SALLES,
            CONCAT(CONCAT(f.nom_source, ' - '), h.acrONyme) AS source,
            tbpe.geom
        FROM
            bpe tc
            LEFT JOIN code_insee ON tc.OBJECTID = code_insee.objectid
            LEFT JOIN typequ ON tc.OBJECTID = typequ.fid_bpe
            LEFT JOIN sc ON tc.OBJECTID = sc.fid_bpe
            LEFT JOIN clpelem ON tc.OBJECTID = clpelem.fid_bpe
            LEFT JOIN clpge ON tc.OBJECTID = clpge.fid_bpe
            LEFT JOIN ep ON tc.OBJECTID = ep.fid_bpe
            LEFT JOIN internat ON tc.OBJECTID = internat.fid_bpe
            LEFT JOIN rpic ON tc.OBJECTID = rpic.fid_bpe
            LEFT JOIN sect ON tc.OBJECTID = sect.fid_bpe
            LEFT JOIN couvert ON tc.OBJECTID = couvert.fid_bpe
            LEFT JOIN eclaire ON tc.OBJECTID = eclaire.fid_bpe
            LEFT JOIN nbairejeu ON tc.OBJECTID = nbairejeu.fid_bpe
            LEFT JOIN nbsalles ON tc.OBJECTID = nbsalles.fid_bpe
            LEFT JOIN g_geo.ta_bpe tbpe ON tc.OBJECTID = tbpe.objectid
            INNER JOIN g_geo.ta_metadONnee e ON  e.objectid = tbpe.fid_metadONnee
            INNER JOIN g_geo.ta_source f ON e.fid_source = f.objectid
            INNER JOIN g_geo.ta_organisme h ON e.fid_organisme = h.objectid
        ;

-- 2. CréatiON des commentaires de table et de colONnes
COMMENT ON TABLE v_bpe IS 'Vue proposant les équipements actuellement dispONible sur le territoire de la MEL';
COMMENT ON COLUMN v_bpe.OBJECTID IS 'Identifiant de l''equipement';
COMMENT ON COLUMN v_bpe.CODE_INSEE IS 'Commune d''implantatiON de l''équipements';
COMMENT ON COLUMN v_bpe.TYPEQU IS 'type d''équipement';
COMMENT ON COLUMN v_bpe.CANT IS 'Présence ou absence d''une cantine';
COMMENT ON COLUMN v_bpe.CL_PELEM IS 'Présence ou absence d''une clASse pré-élémentaire en école élémentaire';
COMMENT ON COLUMN v_bpe.CL_PGE IS 'Présence ou absence d''une clASse préparatoire aux grandes écoles en lycée';
COMMENT ON COLUMN v_bpe.EP IS 'Appartenance ou nON à un dispositif d''éducatiON prioritaire';
COMMENT ON COLUMN v_bpe.INT IS 'Présence ou absence d''un internat';
COMMENT ON COLUMN v_bpe.RPIC IS 'Présence ou absence d''un regroupement pédagogique intercommunal cONcentré';
COMMENT ON COLUMN v_bpe.SECT IS 'Appartenance au secteur publice ou privé d''enseignement';
COMMENT ON COLUMN v_bpe.COUVERT IS 'Equipement couvert ou nON';
COMMENT ON COLUMN v_bpe.ECLAIRE IS 'Equipement éclairé ou nON';
COMMENT ON COLUMN v_bpe.NB_AIREJEU IS 'Nombre d''aires de pratique d''un même type au sein de l''equipement';
COMMENT ON COLUMN v_bpe.NB_SALLES IS 'Nombre de salles par théâtre ou cinéma';
COMMENT ON COLUMN v_bpe.SOURCE IS 'Source de la dONnée avec l''organisme créateur de la source.';
COMMENT ON COLUMN v_bpe.geom IS 'Géométrie de chaque équipement';