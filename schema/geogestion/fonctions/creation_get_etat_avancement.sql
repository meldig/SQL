/*
GET_ID_DOSSIER : Cette fonction permet d'ajouter dans la table TA_GG_GEO un champ calculé qui récupère l'état d'avancement du dossier. 
Cela permet aux utilisateurs de faire des filtres dans QGIS à partir de l'état d'avancement des dossiers.
*/

create or replace FUNCTION GET_ETAT_AVANCEMENT(v_perimetre NUMBER) RETURN CHAR
/*
Cette fonction a pour objectif de récupérer l'identifiant de l'état d'avancement de chaque dossier.
Cette fonction a été créée spécifiquement pour créer des champs calculés dans la table TA_GG_GEO et améliorer la visibilité des données dans QGIS.
Merci de ne pas utiliser cette fonction pour autre chose, sans avoir prévenu le gestionnaire du schéma au préalable (bjacq).
*/
    DETERMINISTIC
    As
    v_etat_avancement VARCHAR2(100);
    BEGIN
        SELECT
            b.libelle_long
            INTO v_etat_avancement 
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
            INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b ON b.objectid = a.fid_etat_avancement
        WHERE
            a.fid_perimetre = v_perimetre;
        RETURN TRIM(v_etat_avancement);
    END GET_ETAT_AVANCEMENT;

/

