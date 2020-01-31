/*
La table ta_thematique regroupe toutes les thématiques utilisées dans le schéma GEO. 
Exemple : le thème "contrôle de dossiers" qui est utilisé avec la table ta_grille.
*/

-- 1. Création de la table ta_thematique

CREATE TABLE ta_thematique(
    objectid NUMBER(38,0),
    thematique VARCHAR2(4000),
    geo_ds DATE
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_thematique IS 'Table regroupant toutes les thématiques utilisées dans la table ta_grille';
COMMENT ON COLUMN geo.ta_thematique.objectid IS 'Identifiant autoincrémenté de chaque thématique.';
COMMENT ON COLUMN geo.ta_thematique.thematique IS 'Thématique décrivant l''utilisation de la grille ta_grille.';
COMMENT ON COLUMN geo.ta_thematique.geo_ds IS 'Date de création de la thématique.';

-- 3. Création de la clé primaire
ALTER TABLE 
  ta_thematique 
ADD CONSTRAINT 
  ta_thematique_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX 
TABLESPACE 
  "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_thematique
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_thematique
BEFORE INSERT ON ta_thematique
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_thematique.nextval;
END;

-- 6. Création du déclencheur d'insertion de la date de création de la thématique dans le champ geo_ds
CREATE OR REPLACE TRIGGER ta_thematique_geo_ds
    BEFORE INSERT ON ta_thematique
    FOR EACH ROW

    BEGIN
        IF INSERTING THEN
            :new.geo_ds := sysdate;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - geo.ta_grille','trigger@lillemetropole.fr');
    END;

-- 7. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_thematique TO G_ADT_DSIG_ADM;