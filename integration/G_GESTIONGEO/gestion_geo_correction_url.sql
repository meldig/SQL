-- Fichier SQL contenant les requetes necessaires pour corriger les chemins des dossiers IC et RECOL
--POINT DE SAUVEGARDE
SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_CORRECTION_TA_GG_DOSSIER;

-- 1. SUPPRESSION DE LA COLONNE OBJECTID.

ALTER TABLE
    TEMP_GG_FILES_LIST
DROP COLUMN
    OBJECTID;


-- 2. SUPPRESSION DES LIGNES CONTENANT DES FICHIERS Thumbs.db.

DELETE
    FROM GEO.TEMP_GG_FILES_LIST
WHERE
    LIEN LIKE '%Thumbs.db'
;

-- 3. AJOUT DE LA CLE PRIMAIRE.

-- 3.1. SUPPRESSION DE LA CONTRAINTE DE CLE PRIMAIRE

SET SERVEROUTPUT ON
DECLARE
    v_nom_1 VARCHAR2(200);
BEGIN
SELECT
    CONSTRAINT_NAME
    INTO v_nom_1
FROM
    USER_CONSTRAINTS
WHERE
    TABLE_NAME = 'TEMP_GG_FILES_LIST'
    AND CONSTRAINT_TYPE = 'P';
EXECUTE IMMEDIATE 'ALTER TABLE GEO.TEMP_GG_FILES_LIST DROP CONSTRAINT ' || v_nom_1;
END;
/


-- 3.2. RENOMMAGE DE LA COLONNE OGR_FID EN OBJECTID.

ALTER TABLE GEO.TEMP_GG_FILES_LIST RENAME COLUMN OGR_FID TO OBJECTID;


-- 3.3. VIDER LA COLONNE OBJECTID.

UPDATE GEO.TEMP_GG_FILES_LIST
SET OBJECTID = NULL;


-- 3.4. AJOUT DE LA SEQUENCE.

CREATE SEQUENCE SEQ_TEMP_GG_FILES_LIST INCREMENT BY 1 START WITH 1 NOCACHE;


-- 3.5. AJOUT DE LA SEQUENCE.

CREATE OR REPLACE TRIGGER BEF_TEMP_GG_FILES_LIST
BEFORE INSERT ON TEMP_GG_FILES_LIST FOR EACH ROW
BEGIN
    :new.OBJECTID := SEQ_TEMP_GG_FILES_LIST.nextval;
END;
/


-- 3.6. MISE A JOUT DE LA COLONNE OBJECTID.

UPDATE GEO.TEMP_GG_FILES_LIST
SET OBJECTID = SEQ_TEMP_GG_FILES_LIST.nextval;


-- 3.7. AJOUT DE LA CONTRAINTE DE CLE PRIMAIRE.

ALTER TABLE GEO.TEMP_GG_FILES_LIST
ADD CONSTRAINT TEMP_GG_FILES_LIST_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "DATA_GEO";


-- 4. AJOUT DE LA COLONNE URL.

ALTER TABLE GEO.TEMP_GG_FILES_LIST
ADD (URL VARCHAR(1000));


-- 5. UPDATE DE LA COLONNE LIEN POUR RETIRER LA SUITE DE CARACTERES '\\VOLT\infogeo\Appli_GG\' ou mettre sous la forme I\ ou RECOL\'.

UPDATE GEO.TEMP_GG_FILES_LIST
SET URL = CASE SUBSTR(LIEN,1,24)
        WHEN '\\VOLT\infogeo\Appli_GG\'
            THEN SUBSTR(LIEN,25)
        ELSE
            SUBSTR(LIEN,13)
        END
;


-- 6. AJOUT DE LA COLONNE FICHIER.

ALTER TABLE GEO.TEMP_GG_FILES_LIST
ADD (FICHIER VARCHAR(1000));


-- 7. MISE A JOUR DE LA COLONNE FICHIER.

UPDATE GEO.TEMP_GG_FILES_LIST
SET FICHIER = SUBSTR(
	        		URL,
	        		INSTR(URL,'\',-1)+1,
	        		LENGTH(URL)
	        		);


-- 8. AJOUT DE LA COLONNE CHEMIN.

ALTER TABLE GEO.TEMP_GG_FILES_LIST
ADD (CHEMIN VARCHAR(1000));


-- 9. MISE A JOUR DE LA COLONNE CHEMIN.

UPDATE GEO.TEMP_GG_FILES_LIST
SET CHEMIN = SUBSTR(
        			REPLACE(URL,'\','/'),
        			1,
        			INSTR(REPLACE(URL,'\','/'),'/',-1)
        			);


-- 10. AJOUT DE LA COLONNE DOS_NUM.

ALTER TABLE GEO.TEMP_GG_FILES_LIST
ADD (DOS_NUM NUMBER(34,0));


-- 11. MISE A JOUR DE LA COLONNE DOS_NUM.

MERGE INTO GEO.TEMP_GG_FILES_LIST a
USING (
    WITH CTE AS (
        SELECT
            OBJECTID,
            CASE SUBSTR(CHEMIN,LENGTH(CHEMIN)-1,1)
                WHEN '_' 
                    THEN SUBSTR(
                                CHEMIN,
                                1,
                                INSTR(
                                    CHEMIN,'_',-1)-1
                                        )
                ELSE
                    TRIM(TRIM(TRAILING '/' FROM CHEMIN))
            END CHEMIN
        FROM
            GEO.TEMP_GG_FILES_LIST
                )
        SELECT
            OBJECTID as OBJECTID_LIST,
            CAST (SUBSTR(
                SUBSTR(
                    CHEMIN,
                    INSTR(CHEMIN,'/',-1)+1,
                    LENGTH(CHEMIN)
                    ),
                1,
            INSTR(
                SUBSTR(
                    CHEMIN,
                    INSTR(CHEMIN,'/',-1)+1,
                    LENGTH(CHEMIN)
                    ),'_'
                    )-1
                    ) AS INTEGER) AS DOS_NUM_CORRIGE
        FROM
            CTE
        WHERE REGEXP_LIKE (
                           SUBSTR(
                                SUBSTR(
                                    CHEMIN,
                                    INSTR(CHEMIN,'/',-1)+1,
                                    LENGTH(CHEMIN)
                                    ),
                                1,
                            INSTR(
                                SUBSTR(
                                    CHEMIN,
                                    INSTR(CHEMIN,'/',-1)+1,
                                    LENGTH(CHEMIN)
                                    ),'_'
                                    )-1
                                    ), '[0-9]')
        AND NOT REGEXP_LIKE (
                           SUBSTR(
                                SUBSTR(
                                    CHEMIN,
                                    INSTR(CHEMIN,'/',-1)+1,
                                    LENGTH(CHEMIN)
                                    ),
                                1,
                            INSTR(
                                SUBSTR(
                                    CHEMIN,
                                    INSTR(CHEMIN,'/',-1)+1,
                                    LENGTH(CHEMIN)
                                    ),'_'
                                    )-1
                                    ), '[-]')
        )b
ON (a.OBJECTID = b.OBJECTID_LIST)
WHEN MATCHED THEN
UPDATE SET a.DOS_NUM = b.DOS_NUM_CORRIGE
;


-- 12. COMMENTAIRE DE LA TABLE
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."LIEN" IS 'Lien original vers les fichiers exporte depuis INFOGEO.';
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."OBJECTID" IS 'Clé primaire de la table TEST_GG_FILES_LIST.';
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."URL" IS 'Lien d''acces vers le fichier au format DOS_URL_FILE de la table TA_GG_DOSSIER et le fichier du dossier';
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."FICHIER" IS 'Nom du fichier du dossier.';
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."CHEMIN" IS 'Lien d''acces vers le fichier au format DOS_URL_FILE de la table TA_GG_DOSSIER';
COMMENT ON COLUMN "GEO"."TEMP_GG_FILES_LIST"."DOS_NUM" IS 'Numéro DOS_NUM de dossier de l''application GESTIONGEO auxquel se rattache le fichier';
COMMENT ON TABLE "GEO"."TEMP_GG_FILES_LIST"  IS 'Table de test regroupant les fichiers et leurs liens d''acces  pour chaque dossier de l''application GESTIONGEO.';



-- 13. CORECTION DES URLs VIDES POUR LESQUELLES UN CHEMIN ET UN DOSSIER EXISTE DANS LE DOSSIER APPLI_GG.

MERGE INTO GEO.TA_GG_DOSSIER a
USING (
        SELECT
            a.DOS_NUM,
            a.dos_url_file,
            a.dos_num as NUMERO_DU_DOSSIER,
            b.chemin as CHEMIN_SUR_APPLIGG
        FROM 
            GEO.TA_GG_DOSSIER a
        INNER JOIN
            (SELECT
                DISTINCT DOS_NUM, CHEMIN
            FROM
                GEO.TEMP_GG_FILES_LIST) b on a.dos_num = b.dos_num
        WHERE a.dos_url_file IS NULL
        )b
ON (a.DOS_NUM = b.DOS_NUM)
WHEN MATCHED THEN
UPDATE SET a.DOS_URL_FILE = b.CHEMIN_SUR_APPLIGG
;

--RESULTAT ATTENDU: 21 LIGNES MISES A JOUR


-- 14. Correction des URLs des dossiers qui existe dans la table TA_GG_DOSSIER et dans le repertoire AppliGG mais qui ont des URL differents.

MERGE INTO GEO.TA_GG_DOSSIER a
USING
    (
    SELECT DISTINCT
        a.dos_num as NUMERO_DU_DOSSIER,
        b.dos_num as liste_num,
        a.dos_url_file as CHEMIN_DOS_URL_FIL,
        b.chemin as CHEMIN_SUR_APPLIGG
    FROM 
        GEO.TA_GG_DOSSIER a
    INNER JOIN
        TEMP_GG_FILES_LIST b on a.dos_num = b.dos_num
    WHERE a.dos_url_file <> b.chemin
    )b
ON (a.dos_num = b.NUMERO_DU_DOSSIER)
WHEN MATCHED THEN
UPDATE SET a.DOS_URL_FILE = b.CHEMIN_SUR_APPLIGG
;

-- RESULTAT ATTENDU: 10 LIGNES MISES A JOUR


-- 15. CORRECTION DE LA COLONNE USER_ID: MISE A JOUR DE LA COLONNE USER_ID PAR LES VALEURS CONTENUES DANS LA COLONNE SRC_ID POUR LES USER_ID NON PRESENTS DANS LA COLONNE SRC_ID DE LA TABLE TA_GG_SOURCE.

UPDATE GEO.TA_GG_DOSSIER
SET USER_ID = SRC_ID
WHERE USER_ID NOT IN (
                    SELECT
                        SRC_ID
                    FROM
                        TA_GG_SOURCE
                        )
;

--RESULTAT ATTENDU: 446 LIGNES MISES A JOUR


-- 16. SUPPRESSION DES DOSSIERS QUI N''ONT PAS DE DOS_NUM ET DONT L''ID DOS N''EST PAS PRESENT DANS LA TABLE TA_GG_GEO.

DELETE FROM GEO.TEST_GG_DOSSIER
WHERE
    DOS_NUM IS NULL
    AND ID_DOS NOT IN (SELECT ID_DOS FROM GEO.TA_GG_GEO)
;


-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_CORRECTION_TA_GG_DOSSIER;
END;

-- 17. SUPPRESSION DES ELEMENTS TEMPORAIRE LIEE AUX URL
-- DROP TABLE TEMP_GG_FILES_LIST cascade constraints;
-- DROP SEQUENCE SEQ_TEMP_GG_FILES_LIST;