-- Création de la table ta_pdp_libelles

-- 1. Création de la table
CREATE TABLE ta_pdp_libelles(
    objectid NUMBER(38,0),
    type_libelle VARCHAR2(20),
    valeur VARCHAR2(255)
);

-- 2. Création de la clé primaire
ALTER TABLE ta_pdp_libelles 
ADD CONSTRAINT ta_pdp_libelles_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_G_MOBILITE";

-- 3. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_pdp_libelles IS 'Table de libellés des points d''intérêts utilisés dans le plan de déplacement piéton. Lien avec la table points_interet';
COMMENT ON COLUMN g_mobilite.ta_pdp_libelles.objectid IS 'Identifiant autoincrémenté de chaque libellé.';
COMMENT ON COLUMN g_mobilite.ta_pdp_libelles.type_libelle IS 'Catégories de libellé.';
COMMENT ON COLUMN g_mobilite.ta_pdp_libelles.valeur IS 'Libellé de chaque point d''intérêt dont la géométrie se situe dans la table points_interet.';

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_pdp_libelles
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_pdp_libelles
BEFORE INSERT ON ta_pdp_libelles
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_pdp_libelles.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON TABLE ta_pdp_libelles TO G_ADT_DSIG_ADM;

-- Création de la table ta_pdp_points_interet

-- 1. Création de la table
CREATE TABLE ta_pdp_points_interet(
    objectid NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    date_saisie DATE,
    date_maj DATE,
    geom SDO_GEOMETRY
);

-- 2. Création de la clé primaire (objectid)
ALTER TABLE ta_pdp_points_interet 
ADD CONSTRAINT ta_pdp_points_interet_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_G_MOBILITE";index

/*
3. Création de la clé étrangère (fid_libelle)
Par défaut oracle n'autorise pas la cascade delete sur les clés étrangères.
Pour cela il faudrait préciser ON DELETE CASCADE.
*/

ALTER TABLE ta_pdp_points_interet
ADD CONSTRAINT ta_pdp_pts_interet_fid_lib_FK 
FOREIGN KEY (fid_libelle)
REFERENCES ta_pdp_libelles(objectid)
;

-- 4. Création d'un index sur la clé étrangère
CREATE INDEX ta_pdp_pts_interet_fid_lib_IDX ON ta_pdp_points_interet(fid_libelle)
    TABLESPACE INDX_GEO;

-- 5. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_pdp_points_interet IS 'Table regroupant la géométrie de tous les points d''intérêts utilisés dans le plan de déplacement piéton.';
COMMENT ON COLUMN g_mobilite.ta_pdp_points_interet.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.ta_pdp_points_interet.id_libelle IS 'Clé étrangère permettant de faire la liaison avec la table libelles.';
COMMENT ON COLUMN g_mobilite.ta_pdp_points_interet.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.ta_pdp_points_interet.date_maj IS 'Date de mise à jour de l''objet.';

-- 6. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_pdp_points_interet',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 7. Création de l'index spatial sur le champ geom
CREATE INDEX ta_pdp_points_interet_SIDX
ON ta_pdp_points_interet(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=INDX_G_MOBILITE , work_tablespace=DAta_pdp_TEMP');

-- 8. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_pdp_points_interet
START WITH 1 INCREMENT BY 1;

-- 9. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_pdp_points_interet
BEFORE INSERT ON ta_pdp_points_interet
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_pdp_points_interet.nextval;
END;

-- 10. Création du déclencheur mettant à jour les champs date_saisie et date_maj
CREATE OR REPLACE TRIGGER g_mobilite.ta_pdp_points_interet
    BEFORE INSERT OR UPDATE ON ta_pdp_points_interet
    FOR EACH ROW

    BEGIN
        IF INSERTING THEN
            :new.date_saisie := sysdate;
        END IF;

        IF UPDATING THEN
            :new.date_maj := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - g_mobilite.ta_pdp_points_interet','trigger@lillemetropole.fr');
    END;

-- 11. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_mobilite.ta_pdp_points_interet TO G_ADT_DSIG_ADM;

-- Création de la table ta_pdp_troncons

-- 1. Création de la table
CREATE TABLE ta_pdp_troncons(
    objectid NUMBER(38,0),
    fid_ligtrc NUMBER(38,0) NOT NULL,
    fid_megatrc NUMBER(38,0),
    geom SDO_GEOMETRY,
    date_saisie DATE,
    date_maj DATE
);

-- 2. Création de la clé primaire (objectid)
ALTER TABLE ta_pdp_troncons 
ADD CONSTRAINT ta_pdp_troncons_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_G_MOBILITE";

/*
3. Création des clés étrangères (fid_libelle, fid_megatrc)
Par défaut oracle n'autorise pas la cascade delete sur les clés étrangères.
Pour cela il faudrait préciser ON DELETE CASCADE.
*/

ALTER TABLE ta_pdp_troncons
ADD CONSTRAINT ta_pdp_troncons_fid_ligtrc_FK 
FOREIGN KEY (fid_ligtrc)
REFERENCES G_SIDU.ILTATRC(cnumtrc)
;

ALTER TABLE ta_pdp_troncons
ADD CONSTRAINT ta_pdp_troncons_fid_megatrc_FK 
FOREIGN KEY (fid_megatrc)
REFERENCES ta_pdp_mega_troncons(objectid)
;

-- 4. Création d'un index sur les clés étrangères
CREATE INDEX ta_pdp_troncon_fid_ligtrc_IDX ON ta_pdp_troncons(fid_ligtrc)
    TABLESPACE INDX_GEO;

CREATE INDEX ta_pdp_troncon_fid_megatrc_IDX ON ta_pdp_troncons(fid_megatrc)
    TABLESPACE INDX_GEO;

-- 5. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_pdp_troncons IS 'Table regroupant toutes les géométries des tronçons utilisés dans le plan de déplacement piéton.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.fid_ligtrc IS 'Clé étrangère faisant le lien avec la table ILTATRC du schéma g_sidu.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.fid_megatrc IS 'Clé étrangère faisant le lien avec la table mega_troncons.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.geom IS 'géométrie de l''objet de type ligne simple.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.ta_pdp_troncons.date_maj IS 'Date de mise à jour de l''objet.';

-- 6. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_pdp_troncons',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 7. Création de l'index spatial sur le champ geom
CREATE INDEX ta_pdp_troncons_SIDX
ON ta_pdp_troncons(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=LINE, tablespace=INDX_G_MOBILITE , work_tablespace=DAta_pdp_TEMP');

-- 8. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_pdp_troncons
START WITH 1 INCREMENT BY 1;

-- 9. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_pdp_troncons
BEFORE INSERT ON ta_pdp_troncons
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_pdp_troncons.nextval;
END;

-- 10. Création du déclencheur mettant à jour les champs date_saisie et date_maj
CREATE OR REPLACE TRIGGER geo.ta_pdp_troncons
    BEFORE INSERT OR UPDATE ON ta_pdp_troncons
    FOR EACH ROW

    BEGIN
        IF INSERTING THEN
            :new.date_saisie := sysdate;
        END IF;

        IF UPDATING THEN
            :new.date_maj := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.TEST_TRONCONS','trigger@lillemetropole.fr');
    END;

-- 11. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_mobilite.ta_pdp_troncons TO G_ADT_DSIG_ADM;

-- Création de la table ta_pdp_mega_troncons

-- 1. Création de la table
CREATE TABLE ta_pdp_mega_troncons(
    objectid NUMBER(38,0),
    valeur_temps NUMBER(38,2),
    date_saisie DATE,
    date_maj DATE
);

-- 2. Création de la clé primaire (objectid)
ALTER TABLE ta_pdp_mega_troncons 
ADD CONSTRAINT "ta_pdp_mega_troncons_PK" 
PRIMARY KEY ("OBJECTID") 
USING INDEX TABLESPACE "INDX_G_MOBILITE";

-- 3. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_pdp_mega_troncons IS 'Table regroupant les méga-tronçons utilisés dans le plan de déplacement piéton, c''est-à-dire que chaque méga-tronçon = la fusion de tous les tronçcons entre deux points d''intérêts.';
COMMENT ON COLUMN g_mobilite.ta_pdp_mega_troncons.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.ta_pdp_mega_troncons.valeur_temps IS 'Temps nécessaire pour parcourir chaque méga_tronçon à pied.';
COMMENT ON COLUMN g_mobilite.ta_pdp_mega_troncons.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.ta_pdp_mega_troncons.date_maj IS 'Date de mise à jour de l''objet.';

-- 8. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_pdp_mega_troncons
START WITH 1 INCREMENT BY 1;

-- 9. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_pdp_mega_troncons
BEFORE INSERT ON ta_pdp_mega_troncons
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_pdp_mega_troncons.nextval;
END;

-- 10. Création du déclencheur mettant à jour les champs date_saisie et date_maj
CREATE OR REPLACE TRIGGER geo.ta_pdp_mega_troncons
    BEFORE INSERT OR UPDATE ON ta_pdp_mega_troncons
    FOR EACH ROW

    BEGIN
        IF INSERTING THEN
            :new.date_saisie := sysdate;
        END IF;

        IF UPDATING THEN
            :new.date_maj := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.TEST_TRONCONS','trigger@lillemetropole.fr');
    END;

-- 11. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_mobilite.ta_pdp_mega_troncons TO G_ADT_DSIG_ADM;

-- Création de la vue v_pdp_mega_troncons

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW v_pdp_mega_troncons (
    id_megatrc, 
    valeur_temps, 
    geom,
    CONSTRAINT v_pdp_mega_troncons_PK PRIMARY KEY (id_megatrc) DISABLE
) AS

SELECT
    a.fid_megatrc,
    b.valeur_temps,
    SDO_UTIL.EXTRACT(
        SDO_AGGR_UNION(
            SDOAGGRTYPE(a.geom, 0.005)
        ),
        1
    ) AS geom
FROM
    ta_pdp_troncons a
    INNER JOIN ta_pdp_mega_troncons b
    ON a.FID_MEGATRC = b.objectid
WHERE
    a.FID_MEGATRC = b.objectid
GROUP BY
    a.fid_megatrc,
    b.valeur_temps
;

-- 2. Création des métadonnées spatiales de la vue v_pdp_mega_troncons
INSERT INTO USER_SDO_GEOM_METADATA(
    table_name, 
    column_name,
    diminfo, 
    srid
)
VALUES(
    'v_mega_troncons', 
    'geom', 
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),
        SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)
    ), 
    2154
);

-- 3. Création des commentaires sur la vue et les champs
COMMENT ON TABLE v_pdp_mega_troncons IS 'Vue fusionnant les géométries des troncons par méga-troncon utilisé dans le plan de déplacement piéton.';
COMMENT ON COLUMN g_mobilite.v_pdp_mega_troncons.id_megatrc IS 'Identifiant de chaque méga-tronçon.';
COMMENT ON COLUMN g_mobilite.v_pdp_mega_troncons.valeur_temps IS 'Temps nécessaire pour parcourir chaque méga_tronçon à pied.';
COMMENT ON COLUMN g_mobilite.v_pdp_mega_troncons.geom IS 'géométrie de type polyligne fusionnant les tronçons par méga-tronçon.';