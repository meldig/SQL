/*
1. Déclencheurs temporaires d'auto-incrémentation des PK ;
2. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE ;
3. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE ;
*/

-- 1. Déclencheurs temporaires d'auto-incrémentation des PK
-- Triggers temporaires d'incrémentation des clés primaires le temps que les utilisateurs passent à QGIS 3.12.

-- TA_GG_PERMIS_CONSTRUIRE
CREATE SEQUENCE  "G_GEO"."SEQ_TA_GG_PERMIS_CONSTRUIRE"  
INCREMENT BY 1 START WITH 1;
/
CREATE OR REPLACE TRIGGER "G_GEO"."BEF_TA_GG_PERMIS_CONSTRUIRE" 
BEFORE INSERT ON G_GEO.TA_GG_PERMIS_CONSTRUIRE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_PERMIS_CONSTRUIRE.nextval;
END;
/
-- TA_GG_POINT_VIGILANCE
CREATE SEQUENCE  "G_GEO"."SEQ_TA_GG_POINT_VIGILANCE"  
INCREMENT BY 1 START WITH 1;
/
CREATE OR REPLACE TRIGGER "G_GEO"."BEF_TA_GG_POINT_VIGILANCE" 
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE.nextval;
END;
/
-- TA_GG_POINT_VIGILANCE_AUDIT
CREATE SEQUENCE  "G_GEO"."SEQ_TA_GG_POINT_VIGILANCE_AUDIT"  
INCREMENT BY 1 START WITH 1;
/
CREATE OR REPLACE TRIGGER "G_GEO"."BEF_TA_GG_POINT_VIGILANCE_AUDIT" 
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE_AUDIT.nextval;
END;
/
-- TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
CREATE SEQUENCE  "G_GEO"."SEQ_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE"  
INCREMENT BY 1 START WITH 1;
/
CREATE OR REPLACE TRIGGER "G_GEO"."BEF_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE" 
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.nextval;
END;
/

-- 2. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_ACTION
AFTER INSERT OR UPDATE OR DELETE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
    DECLARE
        username VARCHAR2(100);
        v_test NUMBER(38,0);
        v_id_creation NUMBER(38,0);
        v_id_edition NUMBER(38,0);
        v_id_cloture NUMBER(38,0);
    BEGIN
        -- Valorisation des variables conteant l'id des libelles des actions des pnom et le pnom de chaque utilisateur
        -- Stockage du pnom
        SELECT sys_context('USERENV','OS_USER') into username from dual; 
        -- Stockage de l'id création
        SELECT 
            a.objectid 
            INTO v_id_creation
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('création');

        -- Stockage de l'id édition    
        SELECT 
            a.objectid 
            INTO v_id_edition
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('édition');

        -- Stockage de l'id clôture   
        SELECT 
            a.objectid 
            INTO v_id_cloture
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('Clôture');

-- En cas d'insertion
        IF INSERTING THEN
            INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
            VALUES(:new.objectid, username, v_id_creation, sysdate);
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

            RAISE_APPLICATION_ERROR(-20001, 'Passage de l''objet '|| :old.objectid ||' en invalide.');
        END IF;

        EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_AUDIT','trigger@lillemetropole.fr');
    END;
/
-- 3. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE
BEFORE INSERT OR UPDATE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
DECLARE
    modification_manuelle NUMBER(38,0);
    creation NUMBER(38,0);
    verification_terrain NUMBER(38,0);
    verification_ortho2020 NUMBER(38,0);
    chantier_potentiel NUMBER(38,0);
    chantier_en_cours NUMBER(38,0);
    chantier_termine NUMBER(38,0);
    permis_construire NUMBER(38,0);
    demolition NUMBER(38,0);
    bati NUMBER(38,0);
    voirie NUMBER(38,0);


BEGIN
-- Valorisation des variables
    SELECT
        a.objectid
        INTO modification_manuelle
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Modification manuelle');

    SELECT
        a.objectid
        INTO creation
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Création');

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
        INTO verification_ortho2020
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Vérification ortho2020');

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
        INTO permis_construire
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('permis de construire');

    SELECT
        a.objectid
        INTO demolition
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('démolition');

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
        UPPER(b.valeur) = UPPER('voirie (clôture,fossé et bordure)');

 -- Contrôle des associations improbables

    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_LIBELLE IN(bati, voirie) AND :new.FID_VERIFICATION <> chantier_termine) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Une modification manuelle sur un bâti ou une voirie est forcément un chantier terminé');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = creation AND :new.FID_VERIFICATION = demolition) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas aller avec une vérification de type démolition');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = creation AND :new.FID_VERIFICATION = permis_construire) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas aller avec une vérification de type permis de construire');   
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = creation AND :new.FID_VERIFICATION = chantier_potentiel) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas aller avec une vérification de type chantier potentiel');   
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_ortho2020) AND :new.FID_VERIFICATION = chantier_termine) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type vérification ne peut pas aller avec une vérification de type chantier terminé');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = demolition) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type modification manuelle ne peut pas aller avec une vérification de type démolition');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = permis_construire) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type modification manuelle ne peut pas aller avec une vérification de type permis de construire');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_en_cours) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type modification manuelle ne peut pas aller avec une vérification de type chantier en cours');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_potentiel) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type modification manuelle ne peut pas aller avec une vérification de type chantier potentiel');
    END IF;

    IF UPDATING THEN
        IF (:old.FID_TYPE_SIGNALEMENT = creation AND :new.FID_TYPE_SIGNALEMENT = modification_manuelle) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas être changé en modification manuelle');
        END IF;
        IF (:old.FID_TYPE_SIGNALEMENT = creation AND :new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_ortho2020)) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas être changé en vérification');
        END IF;
    END IF;

    EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE','trigger@lillemetropole.fr');
END;
/