/*
Objectif : créer un identifiant regroupant la date de création du dossier, sa commune d'appartenance et son identifiant. 
*/
CREATE OR REPLACE FUNCTION GET_DOS_NUM(v_id_dossier NUMBER) RETURN NUMBER
/*
Cette fonction a pour objectif de créer un DOS_NUM pour chaque dossier de levé des géomètres si celui n'existe pas déjà dans TA_GG_DOS_NUM.
Pour cela, veuillez renseigner en entrée l'identifiant du périmètre du dossier (TA_GG_GEO.OBJECTID).
*/
    DETERMINISTIC
    As
    v_dos_num NUMBER(38,0);
    BEGIN
        SELECT
            COALESCE(dos_num, TO_NUMBER(TO_NUMBER(EXTRACT(year FROM date_saisie)) || SUBSTR(TO_CHAR(date_saisie), INSTR(TO_CHAR(date_saisie), '/')+1, 2) || EXTRACT(day FROM date_saisie) || TO_NUMBER(code_insee) || TO_NUMBER(id_dossier)))
            INTO v_dos_num
        FROM
            G_GESTIONGEO.V_CREATION_DOS_NUM
        WHERE
            id_perimetre = v_id_perimetre;
        RETURN TRIM(v_dos_num);
    END GET_DOS_NUM;

/

