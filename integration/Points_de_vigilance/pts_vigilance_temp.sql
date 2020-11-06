/* 
Création des tables nécessaires aux points de vigilance.
1. TA_GG_POINT_VIGILANCE ;
    1.1. Création de la table TA_GG_POINT_VIGILANCE ;
    1.2. Création des commentaires sur la table et les champs ;
    1.3. Création de la clé primaire ;
    1.4. Création des métadonnées spatiales ;
    1.5. Création de l'index spatial sur le champ geom ;
    1.6. Création des clés étrangères ;
    1.7. Création des indexes sur les clés étrangères ;
2. TA_GG_PERMIS_CONSTRUIRE ;
    2.1. Création de la table TA_GG_PERMIS_CONSTRUIRE ;
    2.2. Création des commentaires sur la table et les champs ;
    2.3. Création de la clé primaire ;
    3. TA_GG_POINT_VIGILANCE_AUDIT
    3.1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT ;
    3.2. Création des commentaires sur la table et les champs ;
    3.3. Création de la clé primaire ;
    3.4. Création des clés étrangères ;
    3.5. Création des indexes ;
4. TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE ;
    4.1. Création de la table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE ;
    4.2. Création des commentaires sur la table et les champs ;
    4.3. Création de la clé primaire ;
    4.4. Création des clés étrangères ;
    4.5. Création des indexes ;
5. TEMP_POINT_VIGILANCE ;
*/

-- 1. TA_GG_POINT_VIGILANCE ;
-- La table TA_GG_POINT_VIGILANCE regroupe tous les points de vigilance utilisés dans GestionGeo.

-- 1.1. Création de la table TA_GG_POINT_VIGILANCE ;
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_lib_categorie NUMBER(38,0),
    fid_type_signalement NUMBER(38,0),
    fid_verification NUMBER(38,0),
    fid_lib_statut NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    fid_type_point NUMBER(38,0),
    commentaire VARCHAR2(4000 BYTE),
    geom SDO_GEOMETRY  
);

-- 1.2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE IS 'La table TA_GG_POINT_VIGILANCE permet d''indiquer un problème ou une interrogation sur une donnée (c-a-d un bâti ou une voirie) utilisée dans GestionGeo.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_lib_categorie IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir si le point de vigilance doit être traité en priorité ou non.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_type_signalement IS 'Clé étrangère vers la table TA_LIBELLE permettant d''indiquer le type de signalement du point : création, modification manuelle ou vérification';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_verification IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître la réponse envisagée au signalement fait lors de la création du point.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_lib_statut IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir si le point a été traité ou non.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_libelle IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître le type d''objet sur lequel porte le point de vigilance';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_type_point IS 'Champ permettant de différencier les points de vigilance des autres types de points utilisés dans gestion geo.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.commentaire IS 'Champ dans lequel l''auteur/modificateur du point de vigilance peut inscrire l''interrogation qu''il avait lors de la création/modification du point ou écrire une question à destination de l''UF TOPO.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.geom IS 'géométrie de chaque objet de type point';

-- 1.3. Création de la clé primaire ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 1.4. Création des métadonnées spatiales ;
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GG_POINT_VIGILANCE',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 1.5. Création de l'index spatial sur le champ geom ;
CREATE INDEX TA_GG_POINT_VIGILANCE_SIDX
ON G_GEO.TA_GG_POINT_VIGILANCE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 1.6. Création des clés étrangères ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIB_CATEGORIE_FK 
FOREIGN KEY (FID_LIB_CATEGORIE)
REFERENCES G_GEO.TA_LIBELLE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_FK 
FOREIGN KEY (FID_LIB_STATUT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_FK 
FOREIGN KEY (FID_TYPE_SIGNALEMENT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_VERIFICATION_FK 
FOREIGN KEY (FID_VERIFICATION)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_FK 
FOREIGN KEY (FID_TYPE_POINT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 1.7. Création des indexes sur les clés étrangères ;
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIB_CATEGORIE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIB_CATEGORIE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIBELLE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIB_STATUT)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_TYPE_SIGNALEMENT)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_VERIFICATION_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_VERIFICATION)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_TYPE_POINT)
    TABLESPACE G_ADT_INDX;

-- 2. TA_GG_PERMIS_CONSTRUIRE ;
-- La table TA_GG_PERMIS_CONSTRUIRE permet de regrouper tous les numéros et dates de permis de construire récupéré et utilisé par lkes photo-interprètes via GestionGeo.

-- 2.1. Création de la table TA_GG_PERMIS_CONSTRUIRE ;
CREATE TABLE G_GEO.TA_GG_PERMIS_CONSTRUIRE(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY, 
    numero VARCHAR2(100 BYTE) NOT NULL, 
    debut DATE NOT NULL, 
    fin DATE NOT NULL
);

-- 2.2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE g_geo.TA_GG_PERMIS_CONSTRUIRE IS 'La table TA_GG_PERMIS_CONSTRUIRE permet de regrouper tous les numéros et dates de permis de construire récupéré et utilisé par lkes photo-interprètes via GestionGeo.' ;
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.numero IS 'Numéro du permis de construire.';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.debut IS 'Date de début de validité du permis de contruire';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.fin IS 'Date de fin de validité du permis de construire';

-- 2.3. Création de la clé primaire ;
ALTER TABLE TA_GG_PERMIS_CONSTRUIRE 
ADD CONSTRAINT TA_GG_PERMIS_CONSTRUIRE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 2.4. Création des indexes ;
CREATE INDEX TA_GG_PERMIS_CONSTRUIRE_NUMERO_IDX ON G_GEO.TA_GG_PERMIS_CONSTRUIRE(NUMERO)
    TABLESPACE G_ADT_INDX;

-- 3. TA_GG_POINT_VIGILANCE_AUDIT
-- La table TA_GG_POINT_VIGILANCE_AUDIT permet d'évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.

-- 3.1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT ;
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_point_vigilance NUMBER(38,0),
    pnom VARCHAR2(255 BYTE),
    fid_libelle NUMBER(38,0),
    date_action DATE
);

-- 3.2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE_AUDIT IS 'La table TA_GG_POINT_VIGILANCE_AUDIT permet d''évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à une action.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.pnom IS 'Pnom de l''utilisateur ayant fait une action sur un point de vigilance.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.fid_libelle IS 'Clé étrangère de la table TA_LIBELLE permettant de catégoriser les action effectuées sur un point de vigilance : insertion, édition, suppression';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.date_action IS 'Date à laquelle une action a été effectuée sur un point de vigilance.';

-- 3.3. Création de la clé primaire ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.4. Création des clés étrangères ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GEO.TA_GG_POINT_VIGILANCE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 3.5. Création des indexes ;
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_DATE_ACTION_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(DATE_ACTION)
    TABLESPACE G_ADT_INDX;

-- 4. TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE ;
-- La table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE est une table pivot permettant d'associer les points de vigilance aux permis de construire

-- 4.1. Création de la table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE ;
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_point_vigilance NUMBER(38,0),
    fid_permis_construire NUMBER(38,0)
);

-- 4.2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE IS 'La table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE est une table pivot permettant d''associer les points de vigilance aux permis de construire.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à un permis de construire.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.fid_permis_construire IS 'Clé étrangère de la table TA_GG_PERMIS_CONSTRUIRE permettant d''associer un permis de construire à un point de vigilance.';

-- 4.3. Création de la clé primaire ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4.4. Création des clés étrangères ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GEO.TA_GG_POINT_VIGILANCE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_PERMIS_CONSTRUIRE_FK 
FOREIGN KEY (FID_PERMIS_CONSTRUIRE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 4.5. Création des indexes ;
CREATE INDEX TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_POINT_VIGILANCE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_PERMIS_CONSTRUIRE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE(FID_PERMIS_CONSTRUIRE)
    TABLESPACE G_ADT_INDX;

-- 5. TEMP_POINT_VIGILANCE ;
-- Ajout des champs permettant de catégoriser les points de vigilance dans la table d'import ;
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_LIB_CATEGORIE NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_TYPE_SIGNALEMENT NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_VERIFICATION NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_LIB_STATUT NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_LIBELLE NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD FID_TYPE_POINT NUMBER(38,0);
    
    ALTER TABLE G_GEO.TEMP_POINT_VIGILANCE
    ADD COMMENTAIRE VARCHAR2(4000);/*
1. Insertion des familles liées aux points de vigilance dans G_GEO.TA_FAMILLE ;
2. Insertion des libellés longs dans G_GEO.TA_LIBELLE_LONG ;
3. Insertion dans la table pivot G_GEO.TA_FAMILLE_LIBELLE ;
4. Insertion dans la table G_GEO.TA_LIBELLE ;
5. En cas d'exeption levée, faire un ROLLBACK ;
*/

SET SERVEROUTPUT ON
BEGIN
    SAVEPOINT POINT_SAUVERGARDE_NOMENCLATURE_PTS_VIGILANCE;
-- 1. Insertion des familles liées aux points de vigilance dans G_GEO.TA_FAMILLE ;
    MERGE INTO G_GEO.TA_FAMILLE a
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

    -- 2. Insertion des libellés longs dans G_GEO.TA_LIBELLE_LONG  
    MERGE INTO G_GEO.TA_LIBELLE_LONG a
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
                                        AND UPPER(c.valeur) IN (UPPER('Création dossier'), UPPER('Modification manuelle par les topos'), UPPER('Vérification terrain'), UPPER('Vérification orthophoto'))
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
                    UPPER('bâti'),
                    UPPER('voirie (clôture, fossé et bordure)'), 
                    UPPER('Création dossier'), 
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
/*
1. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE ;
2. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE ;
3. En cas d'exeption levée, faire un ROLLBACK ;
*/
-- 1. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_ACTION
AFTER INSERT OR UPDATE OR DELETE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
    DECLARE
        username VARCHAR2(100);
        v_test NUMBER(38,0);
        v_id_insertion NUMBER(38,0);
        v_id_edition NUMBER(38,0);
        v_id_cloture NUMBER(38,0);
    BEGIN
        -- Valorisation des variables conteant l'id des libelles des actions des pnom et le pnom de chaque utilisateur
        -- Stockage du pnom
        SELECT sys_context('USERENV','OS_USER') into username from dual; 
        -- Stockage de l'id création
        SELECT 
            a.objectid 
            INTO v_id_insertion
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('insertion');

        -- Stockage de l'id édition    
        SELECT 
            a.objectid 
            INTO v_id_edition
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('édition');

-- En cas d'insertion
        IF INSERTING THEN
            INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
            VALUES(:new.objectid, username, v_id_insertion, sysdate);
        END IF;
-- En cas d'édition
        IF UPDATING THEN
            FOR i IN (SELECT objectid, fid_libelle, fid_point_vigilance FROM G_GEO.TA_GG_POINT_VIGILANCE_AUDIT WHERE :old.objectid = fid_point_vigilance) LOOP                               
                IF i.fid_libelle = v_id_edition AND i.fid_point_vigilance = :new.objectid THEN
                   UPDATE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT a
                   SET a.pnom = username,
                        a.date_action = sysdate
                    WHERE :new.objectid = a.fid_point_vigilance AND a.fid_libelle = v_id_edition;
                ELSE
                    INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
                    VALUES(:new.objectid, username, v_id_edition, sysdate);
                END IF;    
            END LOOP;          
        END IF;
-- En cas de suppression
        IF DELETING THEN
            --INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
            --VALUES(:old.objectid, username, v_id_cloture, sysdate);

            RAISE_APPLICATION_ERROR(-20001, 'Les objets de la table TA_GG_POINT_VIGILANCE ne peuvent pas être supprimés. L''objet '|| :old.objectid ||' a été restauré. Veuillez le modifier ou le déplacer.');
        END IF;

        EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_ACTION','trigger@lillemetropole.fr');
    END;
/
-- 2. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE
BEFORE INSERT OR UPDATE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
DECLARE
    modification_manuelle NUMBER(38,0);
    creation NUMBER(38,0);
    verification_terrain NUMBER(38,0);
    verification_orthophoto NUMBER(38,0);
    chantier_potentiel NUMBER(38,0);
    chantier_en_cours NUMBER(38,0);
    chantier_termine NUMBER(38,0);
    bati NUMBER(38,0);
    voirie NUMBER(38,0);
    traite NUMBER(38,0);

BEGIN
-- Valorisation des variables
    SELECT
        a.objectid
        INTO modification_manuelle
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Modification manuelle par les topos');

    SELECT
        a.objectid
        INTO creation
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Création dossier');

    SELECT
        a.objectid
        INTO verification_terrain
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Vérification terrain');

    SELECT
        a.objectid
        INTO verification_orthophoto
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Vérification orthophoto');

    SELECT
        a.objectid
        INTO chantier_potentiel
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier potentiel');

    SELECT
        a.objectid
        INTO chantier_en_cours
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier en cours');

    SELECT
        a.objectid
        INTO chantier_termine
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier terminé');

    SELECT
        a.objectid
        INTO bati
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('bâti');

    SELECT
        a.objectid
        INTO voirie
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('voirie (clôture, fossé et bordure)');

    SELECT
        a.objectid
        INTO traite
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('traité');

 -- Contrôle des associations improbables

    IF (:new.FID_TYPE_SIGNALEMENT = creation AND :new.FID_VERIFICATION = chantier_potentiel) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas aller avec une vérification de type chantier potentiel');   
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_orthophoto) AND :new.FID_VERIFICATION = chantier_termine) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type vérification ne peut pas aller avec une vérification de type chantier terminé');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_en_cours) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier en cours');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_potentiel) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier potentiel');
    END IF;

    IF UPDATING THEN
        IF (:new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_orthophoto) AND :new.FID_LIB_STATUT = traite) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type vérification ne peut pas passer en traité. Veuillez passer le signalement en "création de dossier" ou "modification manuelle par les topos" d''abord.');
        END IF;
    END IF;

    EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE','trigger@lillemetropole.fr');
END;

    EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE','trigger@lillemetropole.fr');
END;
/ 
/*
Conversion des données des points de vigilance.
Objectif : passer d'un format de test en shape à un format de prod inclu dans une base de données relationnelle.
Le champ priorite correspond à plusieurs informations différentes qui sont divisées entre les FK de la table (champs préfixés par fid_)

1. Suppression des doublons géométriques ;
2. Ajout des champs permettant de catégoriser les points de vigilance ;
3. Mise à jour des nouveaux champs en fonction de la valeur du champ priorite ;
4. Insertion des données dans la table G_GEO.TA_GG_POINT_VIGILANCE ;
5. En cas d'exeption levée, faire un ROLLBACK ;
*/

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVERGARDE_CONVERSION_PTS_VIGILANCE;
-- 1. Suppression des doublons géométriques ;
DELETE 
FROM
    G_GEO.TEMP_POINT_VIGILANCE t
WHERE 
    t.ogr_fid IN(
        SELECT
            a.ogr_fid
        FROM
            G_GEO.TEMP_POINT_VIGILANCE a,
            G_GEO.TEMP_POINT_VIGILANCE b
        WHERE
            a.ora_geometry.SDO_POINT.X = b.ora_geometry.SDO_POINT.X
            AND a.ora_geometry.SDO_POINT.Y = b.ora_geometry.SDO_POINT.Y
            AND a.ogr_fid < b.ogr_fid
    );

-- 3. Mise à jour des nouveaux champs en fonction de la valeur du champ priorite ;
/*
Le tableau de correspondance ayant permis de créer ces règles se trouve ici :
\\volt\infogeo\UF_Acquisition\test_point_vigilance\règles_transposition_donnes_shape_en_base.xlsx
*/
    UPDATE G_GEO.TEMP_POINT_VIGILANCE
    SET
        fid_type_signalement =(
            CASE
                WHEN "priorite" IN(1, 3, 5)
                    THEN 369
                WHEN "priorite" = 2
                    THEN 372
                WHEN "priorite" = 9
                    THEN 354
                WHEN "priorite" IN(11, 12)
                    THEN 356
            END
        ),
        fid_verification =(
            CASE
                WHEN "priorite" IN(1, 3, 5, 9)
                    THEN 364
                WHEN "priorite" = 2
                    THEN 355
                WHEN "priorite" IN(11, 12)
                    THEN 371
            END
        ),
        fid_libelle =(
            CASE
                WHEN "priorite" = 5
                    THEN 359
                WHEN "priorite" IN(1, 2, 3, 9, 11, 12)
                    THEN 368
            END
        ),
        fid_lib_categorie =(
            CASE
                WHEN "priorite" IN(1, 5)
                    THEN 360
                WHEN "priorite" IN(2, 3, 9, 11, 12)
                    THEN 361
            END
        ),
            fid_lib_statut =(
            CASE
                WHEN "priorite" = 1
                    THEN 358
                WHEN "priorite" IN(2, 3, 5, 9, 11, 12)
                    THEN 362
            END
        ),
        commentaire = "commentair",
        fid_type_point = (
                            SELECT 
                                a.objectid 
                            FROM
                                G_GEO.TA_LIBELLE a
                                INNER JOIN TA_LIBELLE_LONG b ON a.fid_libelle_long = b.objectid
                            WHERE
                                UPPER(b.valeur) = UPPER('point de vigilance'))
    ;

-- 4. Insertion des données dans la table G_GEO.TA_GG_POINT_VIGILANCE ;
    MERGE INTO G_GEO.TA_GG_POINT_VIGILANCE a
        USING(
            SELECT
                b.FID_LIB_CATEGORIE,
                b.FID_TYPE_SIGNALEMENT,
                b.FID_VERIFICATION,
                b.ORA_GEOMETRY,
                b.FID_LIB_STATUT,
                b.FID_LIBELLE,
                b.COMMENTAIRE,
                b.FID_TYPE_POINT
            FROM
                G_GEO.TEMP_POINT_VIGILANCE b
            WHERE
                b."priorite" IN(1, 2, 3, 5, 9, 11, 12)
                AND b.ORA_GEOMETRY IS NOT NULL
        )t
        ON(
            a.FID_LIB_CATEGORIE = t.FID_LIB_CATEGORIE
            AND a.FID_TYPE_SIGNALEMENT = t.FID_TYPE_SIGNALEMENT
            AND a.FID_VERIFICATION = t.FID_VERIFICATION
            AND a.FID_LIB_STATUT = t.FID_LIB_STATUT
            AND a.FID_LIBELLE = t.FID_LIBELLE
            AND a.FID_TYPE_POINT = t.FID_TYPE_POINT
        )
    WHEN NOT MATCHED THEN
        INSERT(
            a.FID_LIB_CATEGORIE,
            a.FID_TYPE_SIGNALEMENT,
            a.FID_VERIFICATION,
            a.GEOM,
            a.FID_LIB_STATUT,
            a.FID_LIBELLE,
            a.COMMENTAIRE,
            a.FID_TYPE_POINT
        )
        VALUES(
            t.FID_LIB_CATEGORIE,
            t.FID_TYPE_SIGNALEMENT,
            t.FID_VERIFICATION,
            t.ORA_GEOMETRY,
            t.FID_LIB_STATUT,
            t.FID_LIBELLE,
            t.COMMENTAIRE,
            t.FID_TYPE_POINT
	);

	COMMIT;

-- 5. En cas d'exeption levée, faire un ROLLBACK ;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_CONVERSION_PTS_VIGILANCE;
END;
/ 
-- Suppression de la table d'import et de ses métadonnées spatiales ;
DROP TABLE G_GEO.TEMP_POINT_VIGILANCE CASCADE CONSTRAINTS;

DELETE
FROM 
	USER_SDO_GEOM_METADATA
WHERE
	TABLE_NAME = 'TEMP_POINT_VIGILANCE';

DROP TABLE G_GEO.TEMP_FAMILLE_POINT_VIGILANCE CASCADE CONSTRAINTS;
DROP TABLE G_GEO.TEMP_LIBELLE_POINT_VIGILANCE CASCADE CONSTRAINTS;	
COMMIT;
/ 
