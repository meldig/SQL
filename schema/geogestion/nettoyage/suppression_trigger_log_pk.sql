-- suppression des triggers d'incrementation des tables de log

-- 1. Suppression du trigger d'incrementation de la clé primaire B_XUD_TA_OCSMEL_LOG de la table TA_OCSMEL_LOG
DROP TRIGGER B_XUD_TA_OCSMEL_LOG;

-- 2. Suppression du trigger d'incrementation de la clé primaire B_IXX_TA_RTGE_POINT_LOG_PK de la table TA_RTGE_POINT_LOG
DROP TRIGGER B_IXX_TA_RTGE_POINT_PRODUCTION_LOG_PK;

-- 3. Suppression du trigger d'incrementation de la clé primaire B_IXX_TA_RTGE_LINEAIRE_LOG_PK de la table TA_RTGE_LINEAIRE_LOG
DROP TRIGGER B_IXX_TA_RTGE_LINEAIRE_PRODUCTION_LOG_PK;