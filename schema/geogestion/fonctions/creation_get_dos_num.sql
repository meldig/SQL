/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère le DOS_NUM de chaque dossier. Cela permet aux utilisateurs de faire des sélections dans QGIS à partir du DOS_NUM des dossiers.
*/

create or replace FUNCTION GET_DOS_NUM(v_perimetre NUMBER) RETURN NUMBER
/*
Cette fonction a pour objectif de récupérer le DOS_NUM de chaque dossier.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_dos_num VARCHAR2(100);
    BEGIN
        SELECT
            b.dos_num
            INTO v_dos_num 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
            INNER JOIN G_GESTIONGEO.TA_GG_DOS_NUM b ON b.fid_dossier = a.objectid
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_dos_num);
    END GET_DOS_NUM;

/

