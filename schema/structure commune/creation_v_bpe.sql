-- CREATION DE LA VUE DES BPE.
--1.SUPPRESSION DE LA VUE SI DEJA EXISTANTE
DROP VIEW v_bpe_millesime;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.v_bpe_millesime(
    OBJECTID,
    CODE_INSEE,
    COMMUNE,
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
    CONSTRAINT "v_bpe_millesime_PK" PRIMARY KEY ("OBJECTID") DISABLE
)
AS

-- SOUS REQUETE POUR SELECTIONNER LES COMMUNES DE LA MEL
WITH
    code_insee AS (
        SELECT
            bpe.objectid,
            code.code AS CODE_INSEE,
            nom.nom AS COMMUNE
        FROM
            g_geo.ta_bpe bpe,
            g_geo.ta_code code
            INNER JOIN g_geo.ta_identifiant_commune tc ON tc.fid_identifiant = code.objectid
            INNER JOIN g_geo.ta_commune commune ON tc.fid_commune = commune.objectid
            INNER JOIN g_geo.ta_nom nom ON nom.objectid = commune.fid_nom
            INNER JOIN g_geo.ta_za_communes g ON commune.objectid = g.fid_commune
        WHERE
            commune.fid_metadonnee = 1
            AND SDO_RELATE(bpe.geom,commune.geom,'mask=inside') = 'TRUE'
            AND code.fid_libelle = 1
            AND g.fid_zone_administrative = 1
    ),

-- SOUS REQUETE POUR SELECTIONNER LES EQUIPEMENTS ET METTRE CHAQUE ATTIBUT EN COLONNE
    attribute AS (
        SELECT 
            tbpe.objectid,
            MAX(
                CASE
                WHEN tlcp.libelle_court LIKE '__' 
                AND tlcp.libelle_court NOT IN ('PR','PU','EP') THEN tlcf.libelle_court
            END) AS TYPEQU,
            MAX(
            CASE  
                WHEN tlcp.libelle_court = 'CANT' THEN tlcf.libelle_court
            END) AS CANT,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'CL_PELEM' THEN tlcf.libelle_court
            END) AS CL_PELEM,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'CL_PGE' THEN tlcf.libelle_court
            END) AS CL_PGE,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'EP' THEN tlcf.libelle_court
            END) AS EP,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'INT' THEN tlcf.libelle_court
            END) AS INT,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'RPIC' THEN tlcf.libelle_court
            END) AS RPIC,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'SECT' THEN tlcf.libelle_court
            END) AS SECT,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'COUVERT' THEN tlcf.libelle_court
            END) AS COUVERT,
            MAX(
                CASE  
                WHEN tlcp.libelle_court = 'ECLAIRE' THEN tlcf.libelle_court
            END) AS ECLAIRE,
            MAX(
                CASE
                WHEN tlc.libelle_court = 'NB_SALLES' THEN tcn.nombre
            END) AS NB_SALLES,
            MAX(
            CASE
                WHEN tlc.libelle_court = 'NB_AIREJEU' THEN tcn.nombre
            END) AS NB_AIREJEU,
            MAX(tacq.MILLESIME) AS MILLESIME
        FROM 
            g_geo.ta_bpe tbpe
        INNER JOIN g_geo.ta_bpe_caracteristique tc on tc.fid_bpe = tbpe.objectid
        INNER JOIN g_geo.ta_libelle tlf ON tc.fid_libelle_fils = tlf.objectid
        INNER JOIN g_geo.ta_libelle tlp ON tc.fid_libelle_parent = tlp.objectid
        INNER JOIN g_geo.ta_correspondance_libelle tcrf ON tcrf.fid_libelle = tlf.objectid
        INNER JOIN g_geo.ta_correspondance_libelle tcrp ON tcrp.fid_libelle = tlp.objectid
        INNER JOIN g_geo.ta_libelle_court tlcf ON tcrf.fid_libelle_court = tlcf.objectid
        INNER JOIN g_geo.ta_libelle_court tlcp ON tcrp.fid_libelle_court = tlcp.objectid
        LEFT JOIN g_geo.ta_bpe_caracteristique_nombre tcn ON tbpe.objectid = tcn.fid_bpe
        LEFT JOIN g_geo.ta_libelle tl ON tcn.fid_libelle = tl.objectid
        LEFT JOIN g_geo.ta_correspondance_libelle tcr ON tcr.fid_libelle = tl.objectid
        LEFT JOIN g_geo.ta_libelle_court tlc ON tcr.fid_libelle_court = tlc.objectid
        INNER JOIN g_geo.ta_metadonnee tm ON tbpe.fid_metadonnee = tm.objectid
        INNER JOIN g_geo.ta_date_acquisition tacq ON tm.fid_acquisition = tacq.objectid
        INNER JOIN g_geo.ta_source s ON tm.fid_source = s.objectid
        WHERE tlcp.libelle_court != 'G'
            AND s.nom_source = 'Base permanente des équipements (BPE) -  géolocalisé - Fichier détail'
        GROUP BY
            tbpe.objectid
    )
-- SELECTION TOTALE
        SELECT 
            tbpe.OBJECTID,
            code_insee.CODE_INSEE,
            code_insee.COMMUNE,
            attribute.TYPEQU,
            attribute.CANT,
            attribute.CL_PELEM,
            attribute.CL_PGE,
            attribute.EP,
            attribute.INT,
            attribute.RPIC,
            attribute.SECT,
            attribute.COUVERT,
            attribute.ECLAIRE,
            attribute.NB_AIREJEU,
            attribute.NB_SALLES,
            CONCAT(CONCAT(CONCAT(CONCAT(f.nom_source, ' - '), h.acronyme),' - '), attribute.MILLESIME) AS source,
            tbpe.geom
        FROM
            g_geo.ta_bpe tbpe
            LEFT JOIN code_insee ON tbpe.OBJECTID = code_insee.objectid
            LEFT JOIN attribute ON tbpe.OBJECTID = attribute.objectid
            INNER JOIN g_geo.ta_metadonnee e ON  e.objectid = tbpe.fid_metadONnee
            INNER JOIN g_geo.ta_source f ON e.fid_source = f.objectid
            INNER JOIN g_geo.ta_organisme h ON e.fid_organisme = h.objectid
;


-- 2. CREATION DES COMMENTAIRE DE LA VUE ET DES COLONNES
COMMENT ON TABLE v_bpe_millesime IS 'Vue proposant les équipements actuellement disponible sur le territoire de la MEL';
COMMENT ON COLUMN v_bpe_millesime.OBJECTID IS 'Identifiant de l''equipement';
COMMENT ON COLUMN v_bpe_millesime.CODE_INSEE IS 'Code de la commune d''implantatiON de l''équipement';
COMMENT ON COLUMN v_bpe_millesime.COMMUNE IS 'Commune d''implantation de l''equipement';
COMMENT ON COLUMN v_bpe_millesime.TYPEQU IS 'type d''équipement';
COMMENT ON COLUMN v_bpe_millesime.CANT IS 'Présence ou absence d''une cantine';
COMMENT ON COLUMN v_bpe_millesime.CL_PELEM IS 'Présence ou absence d''une clASse pré-élémentaire en école élémentaire';
COMMENT ON COLUMN v_bpe_millesime.CL_PGE IS 'Présence ou absence d''une clASse préparatoire aux grandes écoles en lycée';
COMMENT ON COLUMN v_bpe_millesime.EP IS 'Appartenance ou nON à un dispositif d''éducatiON prioritaire';
COMMENT ON COLUMN v_bpe_millesime.INT IS 'Présence ou absence d''un internat';
COMMENT ON COLUMN v_bpe_millesime.RPIC IS 'Présence ou absence d''un regroupement pédagogique intercommunal cONcentré';
COMMENT ON COLUMN v_bpe_millesime.SECT IS 'Appartenance au secteur publice ou privé d''enseignement';
COMMENT ON COLUMN v_bpe_millesime.COUVERT IS 'Equipement couvert ou nON';
COMMENT ON COLUMN v_bpe_millesime.ECLAIRE IS 'Equipement éclairé ou nON';
COMMENT ON COLUMN v_bpe_millesime.NB_AIREJEU IS 'Nombre d''aires de pratique d''un même type au sein de l''equipement';
COMMENT ON COLUMN v_bpe_millesime.NB_SALLES IS 'Nombre de salles par théâtre ou cinéma';
COMMENT ON COLUMN v_bpe_millesime.SOURCE IS 'Source de la dONnée avec l''organisme créateur de la source.';
COMMENT ON COLUMN v_bpe_millesime.geom IS 'Géométrie de chaque équipement';