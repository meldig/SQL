/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère l'identifiant du dossier. Cela permet aux utilisateurs de faire des sélections dans QGIS à partir de l'identifiant de dossier.
*/

create or replace FUNCTION GET_ID_DOSSIER(v_perimetre NUMBER) RETURN NUMBER
/*
Cette fonction a pour objectif de récupérer l'identifiant du dossier de levés topo depuis celui de son périmètre.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_id_dossier NUMBER(38,0);
    BEGIN
        SELECT
            a.objectid
            INTO v_id_dossier 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_id_dossier);
    END GET_ID_DOSSIER;

/

