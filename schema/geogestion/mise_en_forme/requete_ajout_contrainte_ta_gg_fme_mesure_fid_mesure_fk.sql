--------------------------------------------------------------
--- REQUETE_AJOUT_CONTRAINTE_TA_GG_FME_MESURE_FID_MESURE_FK --
--------------------------------------------------------------

ALTER TABLE G_GESTIONGEO.TA_GG_FME_MESURE
ADD CONSTRAINT TA_GG_FME_MESURE_FID_MESURE_FK
FOREIGN KEY("FID_MESURE")
REFERENCES G_GESTIONGEO.TA_GG_LIBELLE ("OBJECTID");

/
