/*
La requête ci-dessous permet de mettre à jour les statistiques des tables GestionGeo, puis de les sélectionner.
Attention cependant, la requête de mise à jour des statistiques risque de prendre beaucoup de temps et de ressources, il faudrait donc plutôt l'utiliser le soir après 17h00.
*/

-- Mise à jour des statistiques des tables GestionGeo
DECLARE
    filter_lst  DBMS_STATS.OBJECTTAB := DBMS_STATS.OBJECTTAB();
BEGIN
    filter_lst.extend(8);
    filter_lst(1).ownname := 'GEO';
    filter_lst(1).objname := 'TA_GG_%';
    filter_lst(2).ownname := 'GEO';
    filter_lst(2).objname := 'TA_SUR_TOPO_G';
    filter_lst(3).ownname := 'GEO';
    filter_lst(3).objname := 'TA_LIG_TOPO_G';
    filter_lst(4).ownname := 'GEO';
    filter_lst(4).objname := 'TA_POINT_TOPO_G';
    filter_lst(5).ownname := 'GEO';
    filter_lst(5).objname := 'TA_POINT_TOPO_F';
    filter_lst(6).ownname := 'GEO';
    filter_lst(6).objname := 'TA_LIG_TOPO_F';
    filter_lst(7).ownname := 'GEO';
    filter_lst(7).objname := 'TA_LIG_TOPO_GPS';
    filter_lst(8).ownname := 'GEO';
    filter_lst(8).objname := 'TA_POINT_TOPO_GPS';
    filter_lst(8).ownname := 'GEO';
    filter_lst(8).objname := 'TA_DOSSIER_GPS';
    DBMS_STATS.GATHER_SCHEMA_STATS(ownname=>'GEO', obj_filter_list => filter_lst);
END;

-- Sélection des statistiques des tables de GestionGeo
SELECT
    TABLE_NAME AS Nom_Table,
    COLUMN_NAME AS Nom_Champ,
    DENSITY AS Densite_utilisation,
    DATA_TYPE AS Type_donnee,
    DATA_LENGTH AS longueur_Champ,
    DATA_PRECISION AS Precision_Champ,
    NULLABLE AS Null,
    NUM_NULLS AS Nbr_Null,
    NUM_DISTINCT AS Nbr_Valeurs_Distinctes,
    LOW_VALUE AS Valeur_Minimum,
    HIGH_VALUE AS Valeur_Maximale
FROM 
    USER_TAB_COL_STATISTICS
WHERE 
    TABLE_NAME IN(
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_ETAT',
        'TA_SUR_TOPO_G',
        'TA_LIG_TOPO_G',
        'TA_POINT_TOPO_G',
        'TA_POINT_TOPO_F',
        'TA_LIG_TOPO_F',
        'TA_LIG_TOPO_GPS',
        'TA_POINT_TOPO_GPS',
        'TA_DOSSIER_GPS',
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_DOC',
        'TA_GG_DOSSIER',
        'TA_GG_ETAT',
        'TA_GG_EXTERIEUR',
        'TA_GG_FAMILLE',
        'TA_GG_FILES',
        'TA_GG_FORMAT',
        'TA_GG_GEO',
        'TA_GG_MEDIA',
        'TA_GG_POINT',
        'TA_GG_SOURCE'
    );