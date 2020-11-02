/*
Conversion des données des points de vigilance.
Objectif : passer d'un format de test en shape à un format de prod inclu dans une base de données relationnelle.
Le champ priorite correspond à plusieurs informations différentes qui sont divisées entre les FK de la table (champs préfixés par fid_)
*/
SET SERVEROUTPUT ON
BEGIN
	SAVEPOINT POINT_SAUVERGARDE_CONVERSION_PTS_VIGILANCE;

	UPDATE G_GEO.TEMP_POINT_VIGILANCE
	SET
		fid_type_signalement =(
			CASE
				WHEN priorite IN(1, 3, 5)
					THEN 369
				WHEN priorite = 2
					THEN 372
				WHEN priorite = 9
					THEN 354
				WHEN priorite IN(11, 12)
					THEN 356
			END
		),
		fid_verification =(
			CASE
				WHEN priorite IN(1, 3, 5, 9)
					THEN 364
				WHEN priorite = 2
					THEN 355
				WHEN priorite IN(11, 12)
					THEN 371
			END
		),
		fid_libelle =(
			CASE
				WHEN priorite = 5
					THEN 359
				WHEN priorite IN(1, 2, 3, 9, 11, 12)
					THEN 368
			END
		),
		fid_lib_categorie =(
			CASE
				WHEN priorite IN(1, 5)
					THEN 360
				WHEN priorite IN(2, 3, 9, 11, 12)
					THEN 361
			END
		),
		fid_lib_statut =(
		CASE
			WHEN priorite = 1
				THEN 358
			WHEN priorite IN(2, 3, 5, 9, 11, 12)
				THEN 362
		END
		),
		fid_type_point = 363,
		commentaire = commentair
	;
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_CONVERSION_PTS_VIGILANCE;
END;
/