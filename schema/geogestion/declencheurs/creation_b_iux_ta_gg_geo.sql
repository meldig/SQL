create or replace TRIGGER B_IUX_TA_GG_GEO
BEFORE INSERT OR UPDATE ON G_GESTIONGEO.TA_GG_GEO
FOR EACH ROW
DECLARE
    v_annee VARCHAR2(2);
    v_commune VARCHAR2(3);
    v_incrementation VARCHAR2(4);
    
BEGIN
     IF INSERTING THEN -- En cas d'insertion on calcule la surface du périmètr et le dos_num
        -- 1. Calcul du DOS_NUM - PRECISION : le DOS_NUM est EN COURS D'ABANDON, merci de ne créer aucun nouveau traitement à partir de ce champ
        -- Extraction des deux derniers chiffres de l'année en cours
        SELECT
            SUBSTR(EXTRACT(year FROM sysdate), -2) 
            INTO v_annee
        FROM
            DUAL;

        -- Sélection du code commune (sur 3 chiffres) dans la laquelle se trouve le centroïde du périmètre du dossier 
        v_commune := SUBSTR(GET_CODE_INSEE_POLYGON(:new.geom), -3);

        -- Sélection d'un identifiant de dossier virtuel sur quatre chiffres :  incrémentation de 1 à partir du nombre de dossiers créés depuis le début de l'année
        SELECT
            CASE
                WHEN COUNT(id_dos)+1< 10
                    THEN
                        '000' || CAST(COUNT(id_dos)+1 AS VARCHAR2(1))
                WHEN COUNT(id_dos)+1<100
                    THEN
                        '00' || CAST(COUNT(id_dos)+1 AS VARCHAR2(2))
                WHEN COUNT(id_dos)+1<1000
                    THEN
                        '0' || CAST(COUNT(id_dos)+1 AS VARCHAR2(3))
                WHEN COUNT(id_dos)+1>=10000
                    THEN
                        CAST(COUNT(id_dos)+1 AS VARCHAR2(4))
                WHEN COUNT(id_dos)+1>=100000
                    THEN
                        'pb'
                ELSE
                    'error'
            END 
            INTO v_incrementation
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER
        WHERE
            EXTRACT(year FROM dos_dc) = EXTRACT(year FROM sysdate);

        -- Concaténation du DOS_NUM
        :new.dos_num := v_annee||v_commune||v_incrementation;

        -- On insère la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

    IF UPDATING THEN -- En cas d'édition on édite la surface du polygone dans le champ surface(m2)
        :new.SURFACE := ROUND(SDO_GEOM.SDO_AREA(:new.geom, 0.005, 'UNIT=SQ_METER'), 2);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER B_IUX_TA_GG_GEO','bjacq@lillemetropole.fr');
END;