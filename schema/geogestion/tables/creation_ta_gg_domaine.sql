/*
TA_GG_DOMAINE : Cette table a pour objectif de lister les differents domaines qui utilisent des classes d'objet.
*/

-- 1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_GG_DOMAINE(
    objectid NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID.NEXTVAL NOT NULL,
    domaine VARCHAR2(4000 BYTE)
);

-- 2. Commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOMAINE IS 'Liste des domaines regroupant les donnees geographiques';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOMAINE.OBJECTID IS 'Clé primaire auto-incrémentée de la table (identifiant interne du domaine).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOMAINE.DOMAINE IS 'Libelle du domaine';

-- 3. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOMAINE 
ADD CONSTRAINT TA_GG_DOMAINE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_ADMIN_SIG;

/

