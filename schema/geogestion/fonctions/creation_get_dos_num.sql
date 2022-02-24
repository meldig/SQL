/*
Objectif : créer un identifiant regroupant la date de création du dossier, sa commune d'appartenance et son identifiant. 
*/
CREATE OR REPLACE FUNCTION GET_DOS_NUM(v_id_perimetre NUMBER) RETURN VARCHAR
/*
Cette fonction a pour objectif de créer un DOS_NUM pour chaque dossier de levé des géomètres si celui n'existe pas déjà dans TA_GG_DOS_NUM.
Pour cela, veuillez renseigner en entrée l'identifiant du dossier (et non de sa géométrie) et son code INSEE
*/
    DETERMINISTIC
    As
    v_dos_num VARCHAR2(4000);
    BEGIN
        SELECT
            COALESCE(
                TO_CHAR(dos_num), 
                TO_CHAR(
                    TO_CHAR(EXTRACT(year FROM date_saisie)) || '_' || 
                    TO_CHAR(SUBSTR(TO_CHAR(date_saisie), INSTR(TO_CHAR(date_saisie), '/')+1, 2)) || '_' || 
                    CASE WHEN TO_NUMBER(EXTRACT(day FROM date_saisie)) < 10 THEN '0' || TO_CHAR(EXTRACT(day FROM date_saisie)) ELSE TO_CHAR(EXTRACT(day FROM date_saisie)) END|| '_' || 
                    TO_CHAR(code_insee) || '_' || 
                    TO_CHAR(id_dossier)
                )
            )
            INTO v_dos_num
        FROM
            G_GESTIONGEO.V_CREATION_DOS_NUM
        WHERE
            id_perimetre = v_id_perimetre;
        RETURN TRIM(v_dos_num);
    END GET_DOS_NUM;

/

