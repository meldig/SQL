-- Insertion de la nomenclature IRIS
-- 1. Insertion de la nomenclature dans la table TA_LIBELLE

MERGE INTO ta_libelle t
USING 
    (
    SELECT 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' AS TYPE FROM dual
    UNION
    SELECT 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' AS TYPE FROM dual
    UNION
    SELECT 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' AS TYPE FROM dual
    UNION
    SELECT 'Communes non découpées en IRIS' AS TYPE FROM dual
    UNION
    SELECT 'code IRIS' AS TYPE FROM dual
    ) temp
  ON (temp.TYPE = t.libelle)
  WHEN NOT MATCHED THEN
  INSERT (t.libelle)
  VALUES (temp.TYPE)
  ;

-- 2. Insertion de la nomenclature dans la table TA_LIBELLE_COURT

MERGE INTO ta_libelle_court tl
USING 
    (
    SELECT 'A' AS TYPE FROM dual
    UNION
    SELECT 'D' AS TYPE FROM dual
    UNION
    SELECT 'H' AS TYPE FROM dual
    UNION
    SELECT 'Z' AS TYPE FROM dual
    ) temp
ON (temp.TYPE = tl.libelle_court)
WHEN NOT MATCHED THEN
INSERT (tl.libelle_court)
VALUES (temp.TYPE)
;


-- 3. Insertion des correspondances dans la table TA_CORRESPONDANCE_LIBELLE

INSERT INTO TA_CORRESPONDANCE_LIBELLE(fid_libelle, fid_libelle_court)
SELECT
    a.objectid AS objectid_libelle,
    b.objectid AS objectid_libelle_court
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle ='IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' and b.libelle_court='H' OR
    a.libelle ='IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' and b.libelle_court='D' OR
    a.libelle ='IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente'  and b.libelle_court='A' OR
    a.libelle ='Communes non découpées en IRIS' and b.libelle_court='Z'
;


-- 4. Insertion des familles utilisée par les données IRIS.

MERGE INTO ta_famille f
USING 
    (
    SELECT 'type de zone IRIS' AS famille FROM dual
    UNION
    SELECT 'Identifiant de zone admINistratives' AS famille FROM dual
    ) temp
ON (temp.famille = f.famille)
WHEN NOT MATCHED THEN
INSERT (f.famille)
VALUES (temp.famille);


-- 5. Insertion des correspondance familler libelle dans TA_FAMILLE_LIBELLE;

INSERT INTO TA_FAMILLE_LIBELLE(fid_famille, fid_libelle)
SELECT
    a.objectid AS objectid_famille,
    b.objectid AS objectid_libelle
FROM
    ta_famille a,
    ta_libelle b
WHERE
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'Communes non découpées en IRIS' OR
	a.famille = 'Identifiant de zone admINistratives' AND b.libelle = 'code IRIS'
;