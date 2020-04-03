-- 1. Insertion des données dans la table TA_LIBELLE_COURT

MERGE INTO ta_libelle_court tl
USING
	(
	SELECT 'COUVERT' AS LIBELLE FROM DUAL UNION
	SELECT '1' AS LIBELLE FROM DUAL UNION
	SELECT '0' AS LIBELLE FROM DUAL UNION
	SELECT 'X' AS LIBELLE FROM DUAL UNION
	SELECT 'ECLAIRE' AS LIBELLE FROM DUAL UNION
	SELECT 'NB_AIREJEU' AS LIBELLE FROM DUAL UNION
	SELECT 'NB_EQUIP' AS LIBELLE FROM DUAL UNION
	SELECT 'NB_SALLES' AS LIBELLE FROM DUAL UNION
	SELECT 'CANT' AS LIBELLE FROM DUAL UNION
	SELECT 'CL_PELEM' AS LIBELLE FROM DUAL UNION
	SELECT 'CL_PGE' AS LIBELLE FROM DUAL UNION
	SELECT 'EP' AS LIBELLE FROM DUAL UNION
	SELECT 'INT' AS LIBELLE FROM DUAL UNION
	SELECT 'RPIC' AS LIBELLE FROM DUAL UNION
	SELECT 'SECT' AS LIBELLE FROM DUAL UNION
	SELECT 'PR' AS LIBELLE FROM DUAL UNION
	SELECT 'PU' AS LIBELLE FROM DUAL UNION
	SELECT 'A101' AS LIBELLE FROM DUAL UNION
	SELECT 'A104' AS LIBELLE FROM DUAL UNION
	SELECT 'A105' AS LIBELLE FROM DUAL UNION
	SELECT 'A106' AS LIBELLE FROM DUAL UNION
	SELECT 'A107' AS LIBELLE FROM DUAL UNION
	SELECT 'A108' AS LIBELLE FROM DUAL UNION
	SELECT 'A109' AS LIBELLE FROM DUAL UNION
	SELECT 'A115' AS LIBELLE FROM DUAL UNION
	SELECT 'A119' AS LIBELLE FROM DUAL UNION
	SELECT 'A120' AS LIBELLE FROM DUAL UNION
	SELECT 'A121' AS LIBELLE FROM DUAL UNION
	SELECT 'A122' AS LIBELLE FROM DUAL UNION
	SELECT 'A123' AS LIBELLE FROM DUAL UNION
	SELECT 'A124' AS LIBELLE FROM DUAL UNION
	SELECT 'A125' AS LIBELLE FROM DUAL UNION
	SELECT 'A126' AS LIBELLE FROM DUAL UNION
	SELECT 'A203' AS LIBELLE FROM DUAL UNION
	SELECT 'A205' AS LIBELLE FROM DUAL UNION
	SELECT 'A206' AS LIBELLE FROM DUAL UNION
	SELECT 'A207' AS LIBELLE FROM DUAL UNION
	SELECT 'A208' AS LIBELLE FROM DUAL UNION
	SELECT 'A301' AS LIBELLE FROM DUAL UNION
	SELECT 'A302' AS LIBELLE FROM DUAL UNION
	SELECT 'A303' AS LIBELLE FROM DUAL UNION
	SELECT 'A304' AS LIBELLE FROM DUAL UNION
	SELECT 'A401' AS LIBELLE FROM DUAL UNION
	SELECT 'A402' AS LIBELLE FROM DUAL UNION
	SELECT 'A403' AS LIBELLE FROM DUAL UNION
	SELECT 'A404' AS LIBELLE FROM DUAL UNION
	SELECT 'A405' AS LIBELLE FROM DUAL UNION
	SELECT 'A406' AS LIBELLE FROM DUAL UNION
	SELECT 'A501' AS LIBELLE FROM DUAL UNION
	SELECT 'A502' AS LIBELLE FROM DUAL UNION
	SELECT 'A503' AS LIBELLE FROM DUAL UNION
	SELECT 'A504' AS LIBELLE FROM DUAL UNION
	SELECT 'A505' AS LIBELLE FROM DUAL UNION
	SELECT 'A506' AS LIBELLE FROM DUAL UNION
	SELECT 'A507' AS LIBELLE FROM DUAL UNION
	SELECT 'B101' AS LIBELLE FROM DUAL UNION
	SELECT 'B102' AS LIBELLE FROM DUAL UNION
	SELECT 'B103' AS LIBELLE FROM DUAL UNION
	SELECT 'B201' AS LIBELLE FROM DUAL UNION
	SELECT 'B202' AS LIBELLE FROM DUAL UNION
	SELECT 'B203' AS LIBELLE FROM DUAL UNION
	SELECT 'B204' AS LIBELLE FROM DUAL UNION
	SELECT 'B205' AS LIBELLE FROM DUAL UNION
	SELECT 'B206' AS LIBELLE FROM DUAL UNION
	SELECT 'B301' AS LIBELLE FROM DUAL UNION
	SELECT 'B302' AS LIBELLE FROM DUAL UNION
	SELECT 'B303' AS LIBELLE FROM DUAL UNION
	SELECT 'B304' AS LIBELLE FROM DUAL UNION
	SELECT 'B305' AS LIBELLE FROM DUAL UNION
	SELECT 'B306' AS LIBELLE FROM DUAL UNION
	SELECT 'B307' AS LIBELLE FROM DUAL UNION
	SELECT 'B308' AS LIBELLE FROM DUAL UNION
	SELECT 'B309' AS LIBELLE FROM DUAL UNION
	SELECT 'B310' AS LIBELLE FROM DUAL UNION
	SELECT 'B311' AS LIBELLE FROM DUAL UNION
	SELECT 'B312' AS LIBELLE FROM DUAL UNION
	SELECT 'B313' AS LIBELLE FROM DUAL UNION
	SELECT 'B315' AS LIBELLE FROM DUAL UNION
	SELECT 'B316' AS LIBELLE FROM DUAL UNION
	SELECT 'C101' AS LIBELLE FROM DUAL UNION
	SELECT 'C102' AS LIBELLE FROM DUAL UNION
	SELECT 'C104' AS LIBELLE FROM DUAL UNION
	SELECT 'C105' AS LIBELLE FROM DUAL UNION
	SELECT 'C201' AS LIBELLE FROM DUAL UNION
	SELECT 'C301' AS LIBELLE FROM DUAL UNION
	SELECT 'C302' AS LIBELLE FROM DUAL UNION
	SELECT 'C303' AS LIBELLE FROM DUAL UNION
	SELECT 'C304' AS LIBELLE FROM DUAL UNION
	SELECT 'C305' AS LIBELLE FROM DUAL UNION
	SELECT 'C401' AS LIBELLE FROM DUAL UNION
	SELECT 'C402' AS LIBELLE FROM DUAL UNION
	SELECT 'C403' AS LIBELLE FROM DUAL UNION
	SELECT 'C409' AS LIBELLE FROM DUAL UNION
	SELECT 'C501' AS LIBELLE FROM DUAL UNION
	SELECT 'C502' AS LIBELLE FROM DUAL UNION
	SELECT 'C503' AS LIBELLE FROM DUAL UNION
	SELECT 'C504' AS LIBELLE FROM DUAL UNION
	SELECT 'C505' AS LIBELLE FROM DUAL UNION
	SELECT 'C509' AS LIBELLE FROM DUAL UNION
	SELECT 'C601' AS LIBELLE FROM DUAL UNION
	SELECT 'C602' AS LIBELLE FROM DUAL UNION
	SELECT 'C603' AS LIBELLE FROM DUAL UNION
	SELECT 'C604' AS LIBELLE FROM DUAL UNION
	SELECT 'C605' AS LIBELLE FROM DUAL UNION
	SELECT 'C609' AS LIBELLE FROM DUAL UNION
	SELECT 'C701' AS LIBELLE FROM DUAL UNION
	SELECT 'C702' AS LIBELLE FROM DUAL UNION
	SELECT 'D101' AS LIBELLE FROM DUAL UNION
	SELECT 'D102' AS LIBELLE FROM DUAL UNION
	SELECT 'D103' AS LIBELLE FROM DUAL UNION
	SELECT 'D104' AS LIBELLE FROM DUAL UNION
	SELECT 'D105' AS LIBELLE FROM DUAL UNION
	SELECT 'D106' AS LIBELLE FROM DUAL UNION
	SELECT 'D107' AS LIBELLE FROM DUAL UNION
	SELECT 'D108' AS LIBELLE FROM DUAL UNION
	SELECT 'D109' AS LIBELLE FROM DUAL UNION
	SELECT 'D110' AS LIBELLE FROM DUAL UNION
	SELECT 'D111' AS LIBELLE FROM DUAL UNION
	SELECT 'D112' AS LIBELLE FROM DUAL UNION
	SELECT 'D113' AS LIBELLE FROM DUAL UNION
	SELECT 'D201' AS LIBELLE FROM DUAL UNION
	SELECT 'D202' AS LIBELLE FROM DUAL UNION
	SELECT 'D203' AS LIBELLE FROM DUAL UNION
	SELECT 'D206' AS LIBELLE FROM DUAL UNION
	SELECT 'D207' AS LIBELLE FROM DUAL UNION
	SELECT 'D208' AS LIBELLE FROM DUAL UNION
	SELECT 'D209' AS LIBELLE FROM DUAL UNION
	SELECT 'D210' AS LIBELLE FROM DUAL UNION
	SELECT 'D211' AS LIBELLE FROM DUAL UNION
	SELECT 'D212' AS LIBELLE FROM DUAL UNION
	SELECT 'D213' AS LIBELLE FROM DUAL UNION
	SELECT 'D214' AS LIBELLE FROM DUAL UNION
	SELECT 'D221' AS LIBELLE FROM DUAL UNION
	SELECT 'D231' AS LIBELLE FROM DUAL UNION
	SELECT 'D232' AS LIBELLE FROM DUAL UNION
	SELECT 'D233' AS LIBELLE FROM DUAL UNION
	SELECT 'D235' AS LIBELLE FROM DUAL UNION
	SELECT 'D236' AS LIBELLE FROM DUAL UNION
	SELECT 'D237' AS LIBELLE FROM DUAL UNION
	SELECT 'D238' AS LIBELLE FROM DUAL UNION
	SELECT 'D239' AS LIBELLE FROM DUAL UNION
	SELECT 'D240' AS LIBELLE FROM DUAL UNION
	SELECT 'D241' AS LIBELLE FROM DUAL UNION
	SELECT 'D242' AS LIBELLE FROM DUAL UNION
	SELECT 'D243' AS LIBELLE FROM DUAL UNION
	SELECT 'D301' AS LIBELLE FROM DUAL UNION
	SELECT 'D302' AS LIBELLE FROM DUAL UNION
	SELECT 'D303' AS LIBELLE FROM DUAL UNION
	SELECT 'D304' AS LIBELLE FROM DUAL UNION
	SELECT 'D305' AS LIBELLE FROM DUAL UNION
	SELECT 'D401' AS LIBELLE FROM DUAL UNION
	SELECT 'D402' AS LIBELLE FROM DUAL UNION
	SELECT 'D403' AS LIBELLE FROM DUAL UNION
	SELECT 'D404' AS LIBELLE FROM DUAL UNION
	SELECT 'D405' AS LIBELLE FROM DUAL UNION
	SELECT 'D502' AS LIBELLE FROM DUAL UNION
	SELECT 'D601' AS LIBELLE FROM DUAL UNION
	SELECT 'D602' AS LIBELLE FROM DUAL UNION
	SELECT 'D603' AS LIBELLE FROM DUAL UNION
	SELECT 'D604' AS LIBELLE FROM DUAL UNION
	SELECT 'D605' AS LIBELLE FROM DUAL UNION
	SELECT 'D606' AS LIBELLE FROM DUAL UNION
	SELECT 'D701' AS LIBELLE FROM DUAL UNION
	SELECT 'D702' AS LIBELLE FROM DUAL UNION
	SELECT 'D703' AS LIBELLE FROM DUAL UNION
	SELECT 'D704' AS LIBELLE FROM DUAL UNION
	SELECT 'D705' AS LIBELLE FROM DUAL UNION
	SELECT 'D709' AS LIBELLE FROM DUAL UNION
	SELECT 'E101' AS LIBELLE FROM DUAL UNION
	SELECT 'E102' AS LIBELLE FROM DUAL UNION
	SELECT 'E107' AS LIBELLE FROM DUAL UNION
	SELECT 'E108' AS LIBELLE FROM DUAL UNION
	SELECT 'E109' AS LIBELLE FROM DUAL UNION
	SELECT 'F101' AS LIBELLE FROM DUAL UNION
	SELECT 'F102' AS LIBELLE FROM DUAL UNION
	SELECT 'F103' AS LIBELLE FROM DUAL UNION
	SELECT 'F104' AS LIBELLE FROM DUAL UNION
	SELECT 'F105' AS LIBELLE FROM DUAL UNION
	SELECT 'F106' AS LIBELLE FROM DUAL UNION
	SELECT 'F107' AS LIBELLE FROM DUAL UNION
	SELECT 'F108' AS LIBELLE FROM DUAL UNION
	SELECT 'F109' AS LIBELLE FROM DUAL UNION
	SELECT 'F110' AS LIBELLE FROM DUAL UNION
	SELECT 'F111' AS LIBELLE FROM DUAL UNION
	SELECT 'F112' AS LIBELLE FROM DUAL UNION
	SELECT 'F113' AS LIBELLE FROM DUAL UNION
	SELECT 'F114' AS LIBELLE FROM DUAL UNION
	SELECT 'F116' AS LIBELLE FROM DUAL UNION
	SELECT 'F117' AS LIBELLE FROM DUAL UNION
	SELECT 'F118' AS LIBELLE FROM DUAL UNION
	SELECT 'F119' AS LIBELLE FROM DUAL UNION
	SELECT 'F120' AS LIBELLE FROM DUAL UNION
	SELECT 'F121' AS LIBELLE FROM DUAL UNION
	SELECT 'F201' AS LIBELLE FROM DUAL UNION
	SELECT 'F202' AS LIBELLE FROM DUAL UNION
	SELECT 'F203' AS LIBELLE FROM DUAL UNION
	SELECT 'F303' AS LIBELLE FROM DUAL UNION
	SELECT 'F304' AS LIBELLE FROM DUAL UNION
	SELECT 'F305' AS LIBELLE FROM DUAL UNION
	SELECT 'F306' AS LIBELLE FROM DUAL UNION
	SELECT 'G101' AS LIBELLE FROM DUAL UNION
	SELECT 'G102' AS LIBELLE FROM DUAL UNION
	SELECT 'G103' AS LIBELLE FROM DUAL UNION
	SELECT 'G104' AS LIBELLE FROM DUAL UNION
	SELECT 'A' AS LIBELLE FROM DUAL UNION
	SELECT 'A1' AS LIBELLE FROM DUAL UNION
	SELECT 'A2' AS LIBELLE FROM DUAL UNION
	SELECT 'A3' AS LIBELLE FROM DUAL UNION
	SELECT 'A4' AS LIBELLE FROM DUAL UNION
	SELECT 'A5' AS LIBELLE FROM DUAL UNION
	SELECT 'B' AS LIBELLE FROM DUAL UNION
	SELECT 'B1' AS LIBELLE FROM DUAL UNION
	SELECT 'B2' AS LIBELLE FROM DUAL UNION
	SELECT 'B3' AS LIBELLE FROM DUAL UNION
	SELECT 'C' AS LIBELLE FROM DUAL UNION
	SELECT 'C1' AS LIBELLE FROM DUAL UNION
	SELECT 'C2' AS LIBELLE FROM DUAL UNION
	SELECT 'C3' AS LIBELLE FROM DUAL UNION
	SELECT 'C4' AS LIBELLE FROM DUAL UNION
	SELECT 'C5' AS LIBELLE FROM DUAL UNION
	SELECT 'C6' AS LIBELLE FROM DUAL UNION
	SELECT 'C7' AS LIBELLE FROM DUAL UNION
	SELECT 'D' AS LIBELLE FROM DUAL UNION
	SELECT 'D1' AS LIBELLE FROM DUAL UNION
	SELECT 'D2' AS LIBELLE FROM DUAL UNION
	SELECT 'D3' AS LIBELLE FROM DUAL UNION
	SELECT 'D4' AS LIBELLE FROM DUAL UNION
	SELECT 'D5' AS LIBELLE FROM DUAL UNION
	SELECT 'D6' AS LIBELLE FROM DUAL UNION
	SELECT 'D7' AS LIBELLE FROM DUAL UNION
	SELECT 'E' AS LIBELLE FROM DUAL UNION
	SELECT 'E1' AS LIBELLE FROM DUAL UNION
	SELECT 'F' AS LIBELLE FROM DUAL UNION
	SELECT 'F1' AS LIBELLE FROM DUAL UNION
	SELECT 'F2' AS LIBELLE FROM DUAL UNION
	SELECT 'F3' AS LIBELLE FROM DUAL UNION
	SELECT 'G' AS LIBELLE FROM DUAL UNION
	SELECT 'G1' AS LIBELLE FROM DUAL UNION
	SELECT 'TYPEQU' AS LIBELLE FROM DUAL UNION
	SELECT 'QUALITE_XY' AS LIBELLE FROM DUAL UNION
	SELECT 'Bonne' AS LIBELLE FROM DUAL UNION
	SELECT 'Acceptable' AS LIBELLE FROM DUAL UNION
	SELECT 'Mauvaise' AS LIBELLE FROM DUAL UNION
	SELECT 'Non géolocalisé' AS LIBELLE FROM DUAL UNION
	SELECT 'type_équipement_non_géocalisé_cette_année' AS LIBELLE FROM DUAL
	) temp
ON (temp.LIBELLE = tl.libelle_court)
WHEN NOT MATCHED THEN
INSERT (tl.libelle_court)
VALUES (temp.LIBELLE)
;


-- 2. Insertion des données dans la table TA_LIBELLE
MERGE INTO ta_libelle l
USING
	(
	SELECT 'Contenu du fichier Base Permanente des Equipements' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement couvert ou non' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement avec au moin une partie couverte' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement non couvert' AS LIBELLE FROM DUAL UNION
	SELECT 'Sans objet' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement eclaire ou non' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement avec au moins une partie eclairée' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipement non éclairé' AS LIBELLE FROM DUAL UNION
	SELECT 'Nombre d''aires de pratique d''un même type au sein de l''équipement' AS LIBELLE FROM DUAL UNION
	SELECT 'Nombre d''équipement' AS LIBELLE FROM DUAL UNION
	SELECT 'Nombre de salles par théatre ou cinéma' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence ou absence d''un cantine' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence d''une cantine' AS LIBELLE FROM DUAL UNION
	SELECT 'Absence d''une cantine' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence ou absence d''une classe pré-élémentaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence d''une classe pré-élémentaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Absence d''une classe pré-élémentaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence ou absence d''un classe préparatoire aux grandes écoles en lycée' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence d''une classe préparatoire aux grandes écoles' AS LIBELLE FROM DUAL UNION
	SELECT 'absence d''une classe préparatoire aux grandes écoles' AS LIBELLE FROM DUAL UNION
	SELECT 'Appartenance ou non à un dispositif d''éducation prioritaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Appartenance à un EP' AS LIBELLE FROM DUAL UNION
	SELECT 'Non appartenance à un EP' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence ou absence d''un internat' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence  d''un internat' AS LIBELLE FROM DUAL UNION
	SELECT 'absence d''un internat' AS LIBELLE FROM DUAL UNION
	SELECT 'Présence ou absence d''un regroupement pédagogique intercommunal concentré' AS LIBELLE FROM DUAL UNION
	SELECT 'Regroupement pédagogique' AS LIBELLE FROM DUAL UNION
	SELECT 'pas de regroupement pédagogique' AS LIBELLE FROM DUAL UNION
	SELECT 'Appartenance au Secteur public ou privé d''enseignement' AS LIBELLE FROM DUAL UNION
	SELECT 'Secteur privé' AS LIBELLE FROM DUAL UNION
	SELECT 'Secteur public' AS LIBELLE FROM DUAL UNION
	SELECT 'Police' AS LIBELLE FROM DUAL UNION
	SELECT 'Gendarmerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Cour d’appel (CA)' AS LIBELLE FROM DUAL UNION
	SELECT 'Tribunal de grande instance (TGI)' AS LIBELLE FROM DUAL UNION
	SELECT 'Tribunal d’instance (TI)' AS LIBELLE FROM DUAL UNION
	SELECT 'Conseil des prud’hommes (CPH)' AS LIBELLE FROM DUAL UNION
	SELECT 'Tribunal de commerce (TCO)' AS LIBELLE FROM DUAL UNION
	SELECT 'Réseau spécialisé Pôle Emploi' AS LIBELLE FROM DUAL UNION
	SELECT 'Direction Générale des Finances Publiques (DGFIP)' AS LIBELLE FROM DUAL UNION
	SELECT 'Direction Régionale des Finances Publiques (DRFIP)' AS LIBELLE FROM DUAL UNION
	SELECT 'Direction Départementale des Finances Publiques (DDFIP)' AS LIBELLE FROM DUAL UNION
	SELECT 'Réseau de proximité Pôle Emploi' AS LIBELLE FROM DUAL UNION
	SELECT 'Réseau partenarial Pôle Emploi' AS LIBELLE FROM DUAL UNION
	SELECT 'Maison de justice et du droit' AS LIBELLE FROM DUAL UNION
	SELECT 'Antenne de justice' AS LIBELLE FROM DUAL UNION
	SELECT 'Conseil départemental d''accès au droit (CDAD)' AS LIBELLE FROM DUAL UNION
	SELECT 'Banque, Caisse d’Épargne' AS LIBELLE FROM DUAL UNION
	SELECT 'Pompes funèbres' AS LIBELLE FROM DUAL UNION
	SELECT 'Bureau de poste' AS LIBELLE FROM DUAL UNION
	SELECT 'Relais poste' AS LIBELLE FROM DUAL UNION
	SELECT 'Agence postale' AS LIBELLE FROM DUAL UNION
	SELECT 'Réparation auto et de matériel agricole' AS LIBELLE FROM DUAL UNION
	SELECT 'Contrôle technique automobile' AS LIBELLE FROM DUAL UNION
	SELECT 'Location auto-utilitaires légers' AS LIBELLE FROM DUAL UNION
	SELECT 'École de conduite' AS LIBELLE FROM DUAL UNION
	SELECT 'Maçon' AS LIBELLE FROM DUAL UNION
	SELECT 'Plâtrier peintre' AS LIBELLE FROM DUAL UNION
	SELECT 'Menuisier, charpentier, serrurier' AS LIBELLE FROM DUAL UNION
	SELECT 'Plombier, couvreur, chauffagiste' AS LIBELLE FROM DUAL UNION
	SELECT 'Électricien' AS LIBELLE FROM DUAL UNION
	SELECT 'Entreprise générale du bâtiment' AS LIBELLE FROM DUAL UNION
	SELECT 'Coiffure' AS LIBELLE FROM DUAL UNION
	SELECT 'Vétérinaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Agence de travail temporaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Restaurant - Restauration rapide' AS LIBELLE FROM DUAL UNION
	SELECT 'Agence immobilière' AS LIBELLE FROM DUAL UNION
	SELECT 'A506 – Pressing - Laverie automatique' AS LIBELLE FROM DUAL UNION
	SELECT 'Institut de beauté - Onglerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Hypermarché' AS LIBELLE FROM DUAL UNION
	SELECT 'Supermarché' AS LIBELLE FROM DUAL UNION
	SELECT 'Grande surface de bricolage' AS LIBELLE FROM DUAL UNION
	SELECT 'Supérette' AS LIBELLE FROM DUAL UNION
	SELECT 'Épicerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Boulangerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Boucherie charcuterie' AS LIBELLE FROM DUAL UNION
	SELECT 'Produits surgelés' AS LIBELLE FROM DUAL UNION
	SELECT 'Poissonnerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Librairie papeterie journaux' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin de vêtements' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin d''équipements du foyer' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin de chaussures' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin d''électroménager, audio vidéo' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin de meubles' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin d''art. de sports et de loisirs' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin de revêtements murs et sols' AS LIBELLE FROM DUAL UNION
	SELECT 'Droguerie quincaillerie bricolage' AS LIBELLE FROM DUAL UNION
	SELECT 'Parfumerie - Cosmétique' AS LIBELLE FROM DUAL UNION
	SELECT 'Horlogerie Bijouterie' AS LIBELLE FROM DUAL UNION
	SELECT 'Fleuriste - Jardinerie - Animalerie' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin d’optique' AS LIBELLE FROM DUAL UNION
	SELECT 'Magasin de matériel médical et orthopédique' AS LIBELLE FROM DUAL UNION
	SELECT 'Station service' AS LIBELLE FROM DUAL UNION
	SELECT 'École maternelle' AS LIBELLE FROM DUAL UNION
	SELECT 'École maternelle de RPI dispersé' AS LIBELLE FROM DUAL UNION
	SELECT 'École élémentaire' AS LIBELLE FROM DUAL UNION
	SELECT 'École élémentaire de RPI dispersé' AS LIBELLE FROM DUAL UNION
	SELECT 'Collège' AS LIBELLE FROM DUAL UNION
	SELECT 'Lycée d''enseignement général et/ou techno.' AS LIBELLE FROM DUAL UNION
	SELECT 'Lycée d''enseignement professionnel' AS LIBELLE FROM DUAL UNION
	SELECT 'Lycée technique et/ou professionnel agricole' AS LIBELLE FROM DUAL UNION
	SELECT 'SGT : SECTion enseignement général et techno.' AS LIBELLE FROM DUAL UNION
	SELECT 'SEP : SECTion enseignement professionnel' AS LIBELLE FROM DUAL UNION
	SELECT 'STS CPGE' AS LIBELLE FROM DUAL UNION
	SELECT 'Formation santé' AS LIBELLE FROM DUAL UNION
	SELECT 'Formation commerce' AS LIBELLE FROM DUAL UNION
	SELECT 'Autre formation post bac non universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'UFR' AS LIBELLE FROM DUAL UNION
	SELECT 'Institut universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'École d''ingénieurs' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement général supérieur privé' AS LIBELLE FROM DUAL UNION
	SELECT 'Écoles d’’enseignement supérieur agricole' AS LIBELLE FROM DUAL UNION
	SELECT 'Autre enseignement supérieur' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre de formation d''apprentis (hors agriculture)' AS LIBELLE FROM DUAL UNION
	SELECT 'GRETA' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre dispensant de la formation continue agricole' AS LIBELLE FROM DUAL UNION
	SELECT 'Formation aux métiers du sport' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre dispensant des formations d’apprentissage agricole' AS LIBELLE FROM DUAL UNION
	SELECT 'Autre formation continue' AS LIBELLE FROM DUAL UNION
	SELECT 'Résidence universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Restaurant universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Établissement santé court séjour' AS LIBELLE FROM DUAL UNION
	SELECT 'Établissement santé moyen séjour' AS LIBELLE FROM DUAL UNION
	SELECT 'Établissement santé long séjour' AS LIBELLE FROM DUAL UNION
	SELECT 'Établissement psychiatrique avec hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre lutte cancer' AS LIBELLE FROM DUAL UNION
	SELECT 'Urgences' AS LIBELLE FROM DUAL UNION
	SELECT 'Maternité' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre de santé' AS LIBELLE FROM DUAL UNION
	SELECT 'Structure psychiatrique en ambulatoire' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre médecine préventive' AS LIBELLE FROM DUAL UNION
	SELECT 'Dialyse' AS LIBELLE FROM DUAL UNION
	SELECT 'Hospitalisation à domicile' AS LIBELLE FROM DUAL UNION
	SELECT 'Maison de santé pluridisciplinaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Médecin généraliste' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en cardiologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en dermatologie vénéréologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en gastro-entérologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en psychiatrie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en ophtalmologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en oto-rhino-laryngologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en pédiatrie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en pneumologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spéc. en radiodiagnostic et imagerie médicale' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en stomatologie' AS LIBELLE FROM DUAL UNION
	SELECT 'Spécialiste en gynécologie (médicale et/ou obstétrique)' AS LIBELLE FROM DUAL UNION
	SELECT 'Chirurgien dentiste' AS LIBELLE FROM DUAL UNION
	SELECT 'Sage-femme' AS LIBELLE FROM DUAL UNION
	SELECT 'Infirmier' AS LIBELLE FROM DUAL UNION
	SELECT 'Masseur kinésithérapeute' AS LIBELLE FROM DUAL UNION
	SELECT 'Orthophoniste' AS LIBELLE FROM DUAL UNION
	SELECT 'Orthoptiste' AS LIBELLE FROM DUAL UNION
	SELECT 'Pédicure-podologue' AS LIBELLE FROM DUAL UNION
	SELECT 'Audio prothésiste' AS LIBELLE FROM DUAL UNION
	SELECT 'Ergothérapeute' AS LIBELLE FROM DUAL UNION
	SELECT 'Psychomotricien' AS LIBELLE FROM DUAL UNION
	SELECT 'Manipulateur ERM' AS LIBELLE FROM DUAL UNION
	SELECT 'Diététicien' AS LIBELLE FROM DUAL UNION
	SELECT 'Psychologue' AS LIBELLE FROM DUAL UNION
	SELECT 'Pharmacie' AS LIBELLE FROM DUAL UNION
	SELECT 'Laboratoire d''analyses et de biologie médicales' AS LIBELLE FROM DUAL UNION
	SELECT 'Ambulance' AS LIBELLE FROM DUAL UNION
	SELECT 'Transfusion sanguine' AS LIBELLE FROM DUAL UNION
	SELECT 'Établissement thermal' AS LIBELLE FROM DUAL UNION
	SELECT 'Personnes âgées : hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Personnes âgées : soins à domicile' AS LIBELLE FROM DUAL UNION
	SELECT 'Personnes âgées : services d''aide' AS LIBELLE FROM DUAL UNION
	SELECT 'Personnes âgées : foyers restaurants' AS LIBELLE FROM DUAL UNION
	SELECT 'Personnes âgées : services de repas à domicile' AS LIBELLE FROM DUAL UNION
	SELECT 'Crèche' AS LIBELLE FROM DUAL UNION
	SELECT 'Enfants handicapés : hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Enfants handicapés.: soins à domicile' AS LIBELLE FROM DUAL UNION
	SELECT 'Adultes handicapés : hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Adultes handicapés : services d’aide' AS LIBELLE FROM DUAL UNION
	SELECT 'Travail protégé' AS LIBELLE FROM DUAL UNION
	SELECT 'Adultes handicapés : services de soins à domicile' AS LIBELLE FROM DUAL UNION
	SELECT 'Aide sociale à l''enfance : hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Aide sociale à l''enfance : action éduc.' AS LIBELLE FROM DUAL UNION
	SELECT 'CHRS Centre d''héberg. et de réadapt. sociale' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre provisoire d''hébergement' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre accueil demandeur d''asile' AS LIBELLE FROM DUAL UNION
	SELECT 'Autres établissements pour adultes et familles en difficulté' AS LIBELLE FROM DUAL UNION
	SELECT 'Taxi - VTC' AS LIBELLE FROM DUAL UNION
	SELECT 'Aéroport' AS LIBELLE FROM DUAL UNION
	SELECT 'Gare de voyageurs d’intérêt national' AS LIBELLE FROM DUAL UNION
	SELECT 'Gare de voyageurs d’intérêt régional' AS LIBELLE FROM DUAL UNION
	SELECT 'Gare de voyageurs d’intérêt local' AS LIBELLE FROM DUAL UNION
	SELECT 'Bassin de natation' AS LIBELLE FROM DUAL UNION
	SELECT 'Boulodrome' AS LIBELLE FROM DUAL UNION
	SELECT 'Tennis' AS LIBELLE FROM DUAL UNION
	SELECT 'Équipement de cyclisme' AS LIBELLE FROM DUAL UNION
	SELECT 'Domaine skiable' AS LIBELLE FROM DUAL UNION
	SELECT 'Centre équestre' AS LIBELLE FROM DUAL UNION
	SELECT 'Athlétisme' AS LIBELLE FROM DUAL UNION
	SELECT 'Terrain de golf' AS LIBELLE FROM DUAL UNION
	SELECT 'Parcours sportif/santé' AS LIBELLE FROM DUAL UNION
	SELECT 'Sports de glace' AS LIBELLE FROM DUAL UNION
	SELECT 'Plateaux et terrains de jeux extérieurs' AS LIBELLE FROM DUAL UNION
	SELECT 'Salles spécialisées' AS LIBELLE FROM DUAL UNION
	SELECT 'Terrain de grands jeux' AS LIBELLE FROM DUAL UNION
	SELECT 'Salles de combat' AS LIBELLE FROM DUAL UNION
	SELECT 'Salles non spécialisées' AS LIBELLE FROM DUAL UNION
	SELECT 'Roller-Skate-Vélo bicross ou freestyle' AS LIBELLE FROM DUAL UNION
	SELECT 'Sports nautiques' AS LIBELLE FROM DUAL UNION
	SELECT 'Bowling' AS LIBELLE FROM DUAL UNION
	SELECT 'Salles de remise en forme' AS LIBELLE FROM DUAL UNION
	SELECT 'Salles multisports (gymnase)' AS LIBELLE FROM DUAL UNION
	SELECT 'Baignade aménagée' AS LIBELLE FROM DUAL UNION
	SELECT 'Port de plaisance - Mouillage' AS LIBELLE FROM DUAL UNION
	SELECT 'Boucle de randonnée' AS LIBELLE FROM DUAL UNION
	SELECT 'Cinéma' AS LIBELLE FROM DUAL UNION
	SELECT 'Musée' AS LIBELLE FROM DUAL UNION
	SELECT 'Conservatoire' AS LIBELLE FROM DUAL UNION
	SELECT 'Théâtre - Art de rue - Pôle cirque' AS LIBELLE FROM DUAL UNION
	SELECT 'Agence de voyages' AS LIBELLE FROM DUAL UNION
	SELECT 'Hôtel' AS LIBELLE FROM DUAL UNION
	SELECT 'Camping' AS LIBELLE FROM DUAL UNION
	SELECT 'Information touristique' AS LIBELLE FROM DUAL UNION
	SELECT 'Services aux particuliers' AS LIBELLE FROM DUAL UNION
	SELECT 'Services publics' AS LIBELLE FROM DUAL UNION
	SELECT 'Services généraux' AS LIBELLE FROM DUAL UNION
	SELECT 'Services automobiles' AS LIBELLE FROM DUAL UNION
	SELECT 'Artisanat du bâtiment' AS LIBELLE FROM DUAL UNION
	SELECT 'Autres services à la population' AS LIBELLE FROM DUAL UNION
	SELECT 'Commerces' AS LIBELLE FROM DUAL UNION
	SELECT 'Grandes surfaces' AS LIBELLE FROM DUAL UNION
	SELECT 'Commerces alimentaires' AS LIBELLE FROM DUAL UNION
	SELECT 'Commerces spécialisés non alimentaires' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement du premier degré' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement du second degré premier cycle' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement du second degré second cycle' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement supérieur non universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Enseignement supérieur universitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Formation continue' AS LIBELLE FROM DUAL UNION
	SELECT 'Autres services de l''éducation' AS LIBELLE FROM DUAL UNION
	SELECT 'Santé' AS LIBELLE FROM DUAL UNION
	SELECT 'Etablissements et services de santé' AS LIBELLE FROM DUAL UNION
	SELECT 'Fonctions médicales et para-médicales' AS LIBELLE FROM DUAL UNION
	SELECT 'autres établissements et services à caractère sanitaire' AS LIBELLE FROM DUAL UNION
	SELECT 'Action sociale pour personnes agées' AS LIBELLE FROM DUAL UNION
	SELECT 'Action sociale pour enfants en bas-âge' AS LIBELLE FROM DUAL UNION
	SELECT 'Action sociale pour handicapés' AS LIBELLE FROM DUAL UNION
	SELECT 'Autres services d''action sociale' AS LIBELLE FROM DUAL UNION
	SELECT 'Transports et déplacements' AS LIBELLE FROM DUAL UNION
	SELECT 'Infrastructures de transports' AS LIBELLE FROM DUAL UNION
	SELECT 'Sports, loisirs et culture' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipements sportifs' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipements de loisirs' AS LIBELLE FROM DUAL UNION
	SELECT 'Equipements culturels et socioculturels' AS LIBELLE FROM DUAL UNION
	SELECT 'Tourisme' AS LIBELLE FROM DUAL UNION
	SELECT 'Type d''équipement' AS LIBELLE FROM DUAL UNION
	SELECT 'Indicateur de la qualité de la géolocalisation de l''équipement' AS LIBELLE FROM DUAL UNION
	SELECT 'l''écart des coordonées (x,y) fournies avec la réalité du terrain est inférieur à 100m' AS LIBELLE FROM DUAL UNION
	SELECT 'l''écart des coordonées (x,y) fournies avec la réalité du terrain est compris entre 100 m et 500 m' AS LIBELLE FROM DUAL UNION
	SELECT 'l''écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées' AS LIBELLE FROM DUAL UNION
	SELECT 'pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l''Insee.' AS LIBELLE FROM DUAL UNION
	SELECT 'pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d''équipements dont la géolocalisation n''est pas mise à disposition cette année.' AS LIBELLE FROM DUAL UNION
	SELECT 'fichier Sport-Loisir' AS LIBELLE FROM DUAL UNION
	SELECT 'fichier Enseignement' AS LIBELLE FROM DUAL UNION
	SELECT 'fichier Ensemble' AS LIBELLE FROM DUAL
	) temp
ON (temp.LIBELLE = l.libelle)
WHEN NOT MATCHED THEN
INSERT (l.libelle)
VALUES (temp.LIBELLE)
;
commit;

-- 3. Insertion des données dans la table TA_CORRESPONDANCE_LIBELLE

INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement couvert ou non')and b.libelle_court =('COUVERT');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement avec au moin une partie couverte')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement non couvert')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Sans objet')and b.libelle_court =('X');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement eclaire ou non')and b.libelle_court =('ECLAIRE');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement avec au moins une partie eclairée')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipement non éclairé')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Nombre d''aires de pratique d''un même type au sein de l''équipement')and b.libelle_court =('NB_AIREJEU');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Nombre d''équipement')and b.libelle_court =('NB_EQUIP');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Nombre de salles par théatre ou cinéma')and b.libelle_court =('NB_SALLES');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence ou absence d''un cantine')and b.libelle_court =('CANT');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence d''une cantine')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Absence d''une cantine')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence ou absence d''une classe pré-élémentaire')and b.libelle_court =('CL_PELEM');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence d''une classe pré-élémentaire')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Absence d''une classe pré-élémentaire')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence ou absence d''un classe préparatoire aux grandes écoles en lycée')and b.libelle_court =('CL_PGE');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence d''une classe préparatoire aux grandes écoles')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('absence d''une classe préparatoire aux grandes écoles')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Appartenance ou non à un dispositif d''éducation prioritaire')and b.libelle_court =('EP');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Appartenance à un EP')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Non appartenance à un EP')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence ou absence d''un internat')and b.libelle_court =('INT');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence  d''un internat')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('absence d''un internat')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Présence ou absence d''un regroupement pédagogique intercommunal concentré')and b.libelle_court =('RPIC');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Regroupement pédagogique')and b.libelle_court =('1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('pas de regroupement pédagogique')and b.libelle_court =('0');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Appartenance au Secteur public ou privé d''enseignement')and b.libelle_court =('SECT');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Secteur privé')and b.libelle_court =('PR');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Secteur public')and b.libelle_court =('PU');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Police')and b.libelle_court =('A101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Gendarmerie')and b.libelle_court =('A104');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Cour d’appel (CA)')and b.libelle_court =('A105');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tribunal de grande instance (TGI)')and b.libelle_court =('A106');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tribunal d’instance (TI)')and b.libelle_court =('A107');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Conseil des prud’hommes (CPH)')and b.libelle_court =('A108');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tribunal de commerce (TCO)')and b.libelle_court =('A109');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Réseau spécialisé Pôle Emploi')and b.libelle_court =('A115');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Direction Générale des Finances Publiques (DGFIP)')and b.libelle_court =('A119');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Direction Régionale des Finances Publiques (DRFIP)')and b.libelle_court =('A120');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Direction Départementale des Finances Publiques (DDFIP)')and b.libelle_court =('A121');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Réseau de proximité Pôle Emploi')and b.libelle_court =('A122');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Réseau partenarial Pôle Emploi')and b.libelle_court =('A123');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Maison de justice et du droit')and b.libelle_court =('A124');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Antenne de justice')and b.libelle_court =('A125');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Conseil départemental d''accès au droit (CDAD)')and b.libelle_court =('A126');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Banque, Caisse d’Épargne')and b.libelle_court =('A203');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Pompes funèbres')and b.libelle_court =('A205');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Bureau de poste')and b.libelle_court =('A206');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Relais poste')and b.libelle_court =('A207');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Agence postale')and b.libelle_court =('A208');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Réparation auto et de matériel agricole')and b.libelle_court =('A301');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Contrôle technique automobile')and b.libelle_court =('A302');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Location auto-utilitaires légers')and b.libelle_court =('A303');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École de conduite')and b.libelle_court =('A304');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Maçon')and b.libelle_court =('A401');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Plâtrier peintre')and b.libelle_court =('A402');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Menuisier, charpentier, serrurier')and b.libelle_court =('A403');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Plombier, couvreur, chauffagiste')and b.libelle_court =('A404');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Électricien')and b.libelle_court =('A405');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Entreprise générale du bâtiment')and b.libelle_court =('A406');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Coiffure')and b.libelle_court =('A501');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Vétérinaire')and b.libelle_court =('A502');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Agence de travail temporaire')and b.libelle_court =('A503');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Restaurant - Restauration rapide')and b.libelle_court =('A504');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Agence immobilière')and b.libelle_court =('A505');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('A506 – Pressing - Laverie automatique')and b.libelle_court =('A506');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Institut de beauté - Onglerie')and b.libelle_court =('A507');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Hypermarché')and b.libelle_court =('B101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Supermarché')and b.libelle_court =('B102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Grande surface de bricolage')and b.libelle_court =('B103');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Supérette')and b.libelle_court =('B201');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Épicerie')and b.libelle_court =('B202');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Boulangerie')and b.libelle_court =('B203');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Boucherie charcuterie')and b.libelle_court =('B204');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Produits surgelés')and b.libelle_court =('B205');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Poissonnerie')and b.libelle_court =('B206');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Librairie papeterie journaux')and b.libelle_court =('B301');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin de vêtements')and b.libelle_court =('B302');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin d''équipements du foyer')and b.libelle_court =('B303');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin de chaussures')and b.libelle_court =('B304');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin d''électroménager, audio vidéo')and b.libelle_court =('B305');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin de meubles')and b.libelle_court =('B306');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin d''art. de sports et de loisirs')and b.libelle_court =('B307');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin de revêtements murs et sols')and b.libelle_court =('B308');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Droguerie quincaillerie bricolage')and b.libelle_court =('B309');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Parfumerie - Cosmétique')and b.libelle_court =('B310');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Horlogerie Bijouterie')and b.libelle_court =('B311');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Fleuriste - Jardinerie - Animalerie')and b.libelle_court =('B312');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin d’optique')and b.libelle_court =('B313');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Magasin de matériel médical et orthopédique')and b.libelle_court =('B315');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Station service')and b.libelle_court =('B316');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École maternelle')and b.libelle_court =('C101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École maternelle de RPI dispersé')and b.libelle_court =('C102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École élémentaire')and b.libelle_court =('C104');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École élémentaire de RPI dispersé')and b.libelle_court =('C105');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Collège')and b.libelle_court =('C201');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Lycée d''enseignement général et/ou techno.')and b.libelle_court =('C301');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Lycée d''enseignement professionnel')and b.libelle_court =('C302');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Lycée technique et/ou professionnel agricole')and b.libelle_court =('C303');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('SGT : SECTion enseignement général et techno.')and b.libelle_court =('C304');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('SEP : SECTion enseignement professionnel')and b.libelle_court =('C305');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('STS CPGE')and b.libelle_court =('C401');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Formation santé')and b.libelle_court =('C402');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Formation commerce')and b.libelle_court =('C403');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autre formation post bac non universitaire')and b.libelle_court =('C409');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('UFR')and b.libelle_court =('C501');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Institut universitaire')and b.libelle_court =('C502');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('École d''ingénieurs')and b.libelle_court =('C503');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement général supérieur privé')and b.libelle_court =('C504');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Écoles d’’enseignement supérieur agricole')and b.libelle_court =('C505');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autre enseignement supérieur')and b.libelle_court =('C509');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre de formation d''apprentis (hors agriculture)')and b.libelle_court =('C601');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('GRETA')and b.libelle_court =('C602');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre dispensant de la formation continue agricole')and b.libelle_court =('C603');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Formation aux métiers du sport')and b.libelle_court =('C604');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre dispensant des formations d’apprentissage agricole')and b.libelle_court =('C605');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autre formation continue')and b.libelle_court =('C609');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Résidence universitaire')and b.libelle_court =('C701');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Restaurant universitaire')and b.libelle_court =('C702');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Établissement santé court séjour')and b.libelle_court =('D101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Établissement santé moyen séjour')and b.libelle_court =('D102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Établissement santé long séjour')and b.libelle_court =('D103');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Établissement psychiatrique avec hébergement')and b.libelle_court =('D104');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre lutte cancer')and b.libelle_court =('D105');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Urgences')and b.libelle_court =('D106');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Maternité')and b.libelle_court =('D107');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre de santé')and b.libelle_court =('D108');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Structure psychiatrique en ambulatoire')and b.libelle_court =('D109');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre médecine préventive')and b.libelle_court =('D110');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Dialyse')and b.libelle_court =('D111');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Hospitalisation à domicile')and b.libelle_court =('D112');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Maison de santé pluridisciplinaire')and b.libelle_court =('D113');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Médecin généraliste')and b.libelle_court =('D201');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en cardiologie')and b.libelle_court =('D202');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en dermatologie vénéréologie')and b.libelle_court =('D203');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en gastro-entérologie')and b.libelle_court =('D206');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en psychiatrie')and b.libelle_court =('D207');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en ophtalmologie')and b.libelle_court =('D208');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en oto-rhino-laryngologie')and b.libelle_court =('D209');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en pédiatrie')and b.libelle_court =('D210');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en pneumologie')and b.libelle_court =('D211');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spéc. en radiodiagnostic et imagerie médicale')and b.libelle_court =('D212');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en stomatologie')and b.libelle_court =('D213');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Spécialiste en gynécologie (médicale et/ou obstétrique)')and b.libelle_court =('D214');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Chirurgien dentiste')and b.libelle_court =('D221');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Sage-femme')and b.libelle_court =('D231');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Infirmier')and b.libelle_court =('D232');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Masseur kinésithérapeute')and b.libelle_court =('D233');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Orthophoniste')and b.libelle_court =('D235');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Orthoptiste')and b.libelle_court =('D236');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Pédicure-podologue')and b.libelle_court =('D237');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Audio prothésiste')and b.libelle_court =('D238');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Ergothérapeute')and b.libelle_court =('D239');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Psychomotricien')and b.libelle_court =('D240');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Manipulateur ERM')and b.libelle_court =('D241');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Diététicien')and b.libelle_court =('D242');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Psychologue')and b.libelle_court =('D243');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Pharmacie')and b.libelle_court =('D301');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Laboratoire d''analyses et de biologie médicales')and b.libelle_court =('D302');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Ambulance')and b.libelle_court =('D303');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Transfusion sanguine')and b.libelle_court =('D304');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Établissement thermal')and b.libelle_court =('D305');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Personnes âgées : hébergement')and b.libelle_court =('D401');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Personnes âgées : soins à domicile')and b.libelle_court =('D402');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Personnes âgées : services d''aide')and b.libelle_court =('D403');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Personnes âgées : foyers restaurants')and b.libelle_court =('D404');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Personnes âgées : services de repas à domicile')and b.libelle_court =('D405');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Crèche')and b.libelle_court =('D502');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enfants handicapés : hébergement')and b.libelle_court =('D601');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enfants handicapés.: soins à domicile')and b.libelle_court =('D602');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Adultes handicapés : hébergement')and b.libelle_court =('D603');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Adultes handicapés : services d’aide')and b.libelle_court =('D604');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Travail protégé')and b.libelle_court =('D605');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Adultes handicapés : services de soins à domicile')and b.libelle_court =('D606');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Aide sociale à l''enfance : hébergement')and b.libelle_court =('D701');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Aide sociale à l''enfance : action éduc.')and b.libelle_court =('D702');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('CHRS Centre d''héberg. et de réadapt. sociale')and b.libelle_court =('D703');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre provisoire d''hébergement')and b.libelle_court =('D704');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre accueil demandeur d''asile')and b.libelle_court =('D705');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autres établissements pour adultes et familles en difficulté')and b.libelle_court =('D709');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Taxi - VTC')and b.libelle_court =('E101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Aéroport')and b.libelle_court =('E102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt national')and b.libelle_court =('E107');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt régional')and b.libelle_court =('E108');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt local')and b.libelle_court =('E109');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Bassin de natation')and b.libelle_court =('F101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Boulodrome')and b.libelle_court =('F102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tennis')and b.libelle_court =('F103');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Équipement de cyclisme')and b.libelle_court =('F104');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Domaine skiable')and b.libelle_court =('F105');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Centre équestre')and b.libelle_court =('F106');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Athlétisme')and b.libelle_court =('F107');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Terrain de golf')and b.libelle_court =('F108');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Parcours sportif/santé')and b.libelle_court =('F109');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Sports de glace')and b.libelle_court =('F110');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Plateaux et terrains de jeux extérieurs')and b.libelle_court =('F111');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Salles spécialisées')and b.libelle_court =('F112');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Terrain de grands jeux')and b.libelle_court =('F113');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Salles de combat')and b.libelle_court =('F114');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Salles non spécialisées')and b.libelle_court =('F116');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Roller-Skate-Vélo bicross ou freestyle')and b.libelle_court =('F117');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Sports nautiques')and b.libelle_court =('F118');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Bowling')and b.libelle_court =('F119');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Salles de remise en forme')and b.libelle_court =('F120');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Salles multisports (gymnase)')and b.libelle_court =('F121');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Baignade aménagée')and b.libelle_court =('F201');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Port de plaisance - Mouillage')and b.libelle_court =('F202');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Boucle de randonnée')and b.libelle_court =('F203');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Cinéma')and b.libelle_court =('F303');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Musée')and b.libelle_court =('F304');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Conservatoire')and b.libelle_court =('F305');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Théâtre - Art de rue - Pôle cirque')and b.libelle_court =('F306');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Agence de voyages')and b.libelle_court =('G101');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Hôtel')and b.libelle_court =('G102');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Camping')and b.libelle_court =('G103');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Information touristique')and b.libelle_court =('G104');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Services aux particuliers')and b.libelle_court =('A');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Services publics')and b.libelle_court =('A1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Services généraux')and b.libelle_court =('A2');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Services automobiles')and b.libelle_court =('A3');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Artisanat du bâtiment')and b.libelle_court =('A4');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autres services à la population')and b.libelle_court =('A5');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Commerces')and b.libelle_court =('B');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Grandes surfaces')and b.libelle_court =('B1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Commerces alimentaires')and b.libelle_court =('B2');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Commerces spécialisés non alimentaires')and b.libelle_court =('B3');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement')and b.libelle_court =('C');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement du premier degré')and b.libelle_court =('C1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement du second degré premier cycle')and b.libelle_court =('C2');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement du second degré second cycle')and b.libelle_court =('C3');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement supérieur non universitaire')and b.libelle_court =('C4');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Enseignement supérieur universitaire')and b.libelle_court =('C5');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Formation continue')and b.libelle_court =('C6');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autres services de l''éducation')and b.libelle_court =('C7');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Santé')and b.libelle_court =('D');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Etablissements et services de santé')and b.libelle_court =('D1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Fonctions médicales et para-médicales')and b.libelle_court =('D2');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('autres établissements et services à caractère sanitaire')and b.libelle_court =('D3');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Action sociale pour personnes agées')and b.libelle_court =('D4');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Action sociale pour enfants en bas-âge')and b.libelle_court =('D5');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Action sociale pour handicapés')and b.libelle_court =('D6');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Autres services d''action sociale')and b.libelle_court =('D7');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Transports et déplacements')and b.libelle_court =('E');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Infrastructures de transports')and b.libelle_court =('E1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Sports, loisirs et culture')and b.libelle_court =('F');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipements sportifs')and b.libelle_court =('F1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipements de loisirs')and b.libelle_court =('F2');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Equipements culturels et socioculturels')and b.libelle_court =('F3');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tourisme')and b.libelle_court =('G');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Tourisme')and b.libelle_court =('G1');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Type d''équipement')and b.libelle_court =('TYPEQU');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('Indicateur de la qualité de la géolocalisation de l''équipement')and b.libelle_court =('QUALITE_XY');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('l''écart des coordonées (x,y) fournies avec la réalité du terrain est inférieur à 100m')and b.libelle_court =('Bonne');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('l''écart des coordonées (x,y) fournies avec la réalité du terrain est compris entre 100 m et 500 m')and b.libelle_court =('Acceptable');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('l''écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées')and b.libelle_court =('Mauvaise');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l''Insee.')and b.libelle_court =('Non géolocalisé');
INSERT INTO ta_correspondance_libelle (fid_libelle,fid_libelle_court)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle = ('pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d''équipements dont la géolocalisation n''est pas mise à disposition cette année.')and b.libelle_court =('type_équipement_non_géocalisé_cette_année');
commit;

-- 4. Insertion des données dans la table TA_RELATION_LIBELLE

insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('fichier Sport-Loisir')and b.libelle =('Contenu du fichier Base Permanente des Equipements');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('fichier Enseignement')and b.libelle =('Contenu du fichier Base Permanente des Equipements');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement couvert ou non')and b.libelle =('fichier Sport-Loisir');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement eclaire ou non')and b.libelle =('fichier Sport-Loisir');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Nombre d''aires de pratique d''un même type au sein de l''équipement')and b.libelle =('fichier Sport-Loisir');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Nombre d''équipement')and b.libelle =('fichier Sport-Loisir');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Nombre de salles par théatre ou cinéma')and b.libelle =('fichier Sport-Loisir');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence ou absence d''un cantine')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence ou absence d''une classe pré-élémentaire')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence ou absence d''un classe préparatoire aux grandes écoles en lycée')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Appartenance ou non à un dispositif d''éducation prioritaire')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence ou absence d''un internat')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence ou absence d''un regroupement pédagogique intercommunal concentré')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Appartenance au Secteur public ou privé d''enseignement')and b.libelle =('fichier Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement avec au moin une partie couverte')and b.libelle =('Equipement couvert ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement non couvert')and b.libelle =('Equipement couvert ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Equipement couvert ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement avec au moins une partie eclairée')and b.libelle =('Equipement eclaire ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipement non éclairé')and b.libelle =('Equipement eclaire ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Equipement eclaire ou non');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence d''une cantine')and b.libelle =('Présence ou absence d''un cantine');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Absence d''une cantine')and b.libelle =('Présence ou absence d''un cantine');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Présence ou absence d''un cantine');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence d''une classe pré-élémentaire')and b.libelle =('Présence ou absence d''une classe pré-élémentaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Absence d''une classe pré-élémentaire')and b.libelle =('Présence ou absence d''une classe pré-élémentaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Présence ou absence d''une classe pré-élémentaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence d''une classe préparatoire aux grandes écoles')and b.libelle =('Présence ou absence d''un classe préparatoire aux grandes écoles en lycée');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('absence d''une classe préparatoire aux grandes écoles')and b.libelle =('Présence ou absence d''un classe préparatoire aux grandes écoles en lycée');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Présence ou absence d''un classe préparatoire aux grandes écoles en lycée');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Appartenance à un EP')and b.libelle =('Appartenance ou non à un dispositif d''éducation prioritaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Non appartenance à un EP')and b.libelle =('Appartenance ou non à un dispositif d''éducation prioritaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Appartenance ou non à un dispositif d''éducation prioritaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Présence  d''un internat')and b.libelle =('Présence ou absence d''un internat');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('absence d''un internat')and b.libelle =('Présence ou absence d''un internat');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Présence ou absence d''un internat');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Regroupement pédagogique')and b.libelle =('Présence ou absence d''un regroupement pédagogique intercommunal concentré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('pas de regroupement pédagogique')and b.libelle =('Présence ou absence d''un regroupement pédagogique intercommunal concentré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sans objet')and b.libelle =('Présence ou absence d''un regroupement pédagogique intercommunal concentré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Secteur privé')and b.libelle =('Appartenance au Secteur public ou privé d''enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Secteur public')and b.libelle =('Appartenance au Secteur public ou privé d''enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Police')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Gendarmerie')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Cour d’appel (CA)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tribunal de grande instance (TGI)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tribunal d’instance (TI)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Conseil des prud’hommes (CPH)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tribunal de commerce (TCO)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Réseau spécialisé Pôle Emploi')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Direction Générale des Finances Publiques (DGFIP)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Direction Régionale des Finances Publiques (DRFIP)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Direction Départementale des Finances Publiques (DDFIP)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Réseau de proximité Pôle Emploi')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Réseau partenarial Pôle Emploi')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Maison de justice et du droit')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Antenne de justice')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Conseil départemental d''accès au droit (CDAD)')and b.libelle =('Services publics');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Banque, Caisse d’Épargne')and b.libelle =('Services généraux');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Pompes funèbres')and b.libelle =('Services généraux');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Bureau de poste')and b.libelle =('Services généraux');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Relais poste')and b.libelle =('Services généraux');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Agence postale')and b.libelle =('Services généraux');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Réparation auto et de matériel agricole')and b.libelle =('Services automobiles');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Contrôle technique automobile')and b.libelle =('Services automobiles');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Location auto-utilitaires légers')and b.libelle =('Services automobiles');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École de conduite')and b.libelle =('Services automobiles');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Maçon')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Plâtrier peintre')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Menuisier, charpentier, serrurier')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Plombier, couvreur, chauffagiste')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Électricien')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Entreprise générale du bâtiment')and b.libelle =('Artisanat du bâtiment');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Coiffure')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Vétérinaire')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Agence de travail temporaire')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Restaurant - Restauration rapide')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Agence immobilière')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('A506 – Pressing - Laverie automatique')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Institut de beauté - Onglerie')and b.libelle =('Autres services à la population');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Hypermarché')and b.libelle =('Grandes surfaces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Supermarché')and b.libelle =('Grandes surfaces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Grande surface de bricolage')and b.libelle =('Grandes surfaces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Supérette')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Épicerie')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Boulangerie')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Boucherie charcuterie')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Produits surgelés')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Poissonnerie')and b.libelle =('Commerces alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Librairie papeterie journaux')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin de vêtements')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin d''équipements du foyer')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin de chaussures')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin d''électroménager, audio vidéo')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin de meubles')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin d''art. de sports et de loisirs')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin de revêtements murs et sols')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Droguerie quincaillerie bricolage')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Parfumerie - Cosmétique')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Horlogerie Bijouterie')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Fleuriste - Jardinerie - Animalerie')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin d’optique')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Magasin de matériel médical et orthopédique')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Station service')and b.libelle =('Commerces spécialisés non alimentaires');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École maternelle')and b.libelle =('Enseignement du premier degré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École maternelle de RPI dispersé')and b.libelle =('Enseignement du premier degré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École élémentaire')and b.libelle =('Enseignement du premier degré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École élémentaire de RPI dispersé')and b.libelle =('Enseignement du premier degré');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Collège')and b.libelle =('Enseignement du second degré premier cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Lycée d''enseignement général et/ou techno.')and b.libelle =('Enseignement du second degré second cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Lycée d''enseignement professionnel')and b.libelle =('Enseignement du second degré second cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Lycée technique et/ou professionnel agricole')and b.libelle =('Enseignement du second degré second cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('SGT : SECTion enseignement général et techno.')and b.libelle =('Enseignement du second degré second cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('SEP : SECTion enseignement professionnel')and b.libelle =('Enseignement du second degré second cycle');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('STS CPGE')and b.libelle =('Enseignement supérieur non universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Formation santé')and b.libelle =('Enseignement supérieur non universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Formation commerce')and b.libelle =('Enseignement supérieur non universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autre formation post bac non universitaire')and b.libelle =('Enseignement supérieur non universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('UFR')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Institut universitaire')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('École d''ingénieurs')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement général supérieur privé')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Écoles d’’enseignement supérieur agricole')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autre enseignement supérieur')and b.libelle =('Enseignement supérieur universitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre de formation d''apprentis (hors agriculture)')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('GRETA')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre dispensant de la formation continue agricole')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Formation aux métiers du sport')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre dispensant des formations d’apprentissage agricole')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autre formation continue')and b.libelle =('Formation continue');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Résidence universitaire')and b.libelle =('Autres services de l''éducation');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Restaurant universitaire')and b.libelle =('Autres services de l''éducation');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Établissement santé court séjour')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Établissement santé moyen séjour')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Établissement santé long séjour')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Établissement psychiatrique avec hébergement')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre lutte cancer')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Urgences')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Maternité')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre de santé')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Structure psychiatrique en ambulatoire')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre médecine préventive')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Dialyse')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Hospitalisation à domicile')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Maison de santé pluridisciplinaire')and b.libelle =('Etablissements et services de santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Médecin généraliste')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en cardiologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en dermatologie vénéréologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en gastro-entérologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en psychiatrie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en ophtalmologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en oto-rhino-laryngologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en pédiatrie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en pneumologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spéc. en radiodiagnostic et imagerie médicale')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en stomatologie')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Spécialiste en gynécologie (médicale et/ou obstétrique)')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Chirurgien dentiste')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sage-femme')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Infirmier')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Masseur kinésithérapeute')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Orthophoniste')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Orthoptiste')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Pédicure-podologue')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Audio prothésiste')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Ergothérapeute')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Psychomotricien')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Manipulateur ERM')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Diététicien')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Psychologue')and b.libelle =('Fonctions médicales et para-médicales');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Pharmacie')and b.libelle =('autres établissements et services à caractère sanitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Laboratoire d''analyses et de biologie médicales')and b.libelle =('autres établissements et services à caractère sanitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Ambulance')and b.libelle =('autres établissements et services à caractère sanitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Transfusion sanguine')and b.libelle =('autres établissements et services à caractère sanitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Établissement thermal')and b.libelle =('autres établissements et services à caractère sanitaire');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Personnes âgées : hébergement')and b.libelle =('Action sociale pour personnes agées');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Personnes âgées : soins à domicile')and b.libelle =('Action sociale pour personnes agées');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Personnes âgées : services d''aide')and b.libelle =('Action sociale pour personnes agées');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Personnes âgées : foyers restaurants')and b.libelle =('Action sociale pour personnes agées');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Personnes âgées : services de repas à domicile')and b.libelle =('Action sociale pour personnes agées');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Crèche')and b.libelle =('Action sociale pour enfants en bas-âge');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enfants handicapés : hébergement')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enfants handicapés.: soins à domicile')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Adultes handicapés : hébergement')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Adultes handicapés : services d’aide')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Travail protégé')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Adultes handicapés : services de soins à domicile')and b.libelle =('Action sociale pour handicapés');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Aide sociale à l''enfance : hébergement')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Aide sociale à l''enfance : action éduc.')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('CHRS Centre d''héberg. et de réadapt. sociale')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre provisoire d''hébergement')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre accueil demandeur d''asile')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autres établissements pour adultes et familles en difficulté')and b.libelle =('Autres services d''action sociale');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Taxi - VTC')and b.libelle =('Infrastructures de transports');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Aéroport')and b.libelle =('Infrastructures de transports');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt national')and b.libelle =('Infrastructures de transports');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt régional')and b.libelle =('Infrastructures de transports');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Gare de voyageurs d’intérêt local')and b.libelle =('Infrastructures de transports');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Bassin de natation')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Boulodrome')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tennis')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Équipement de cyclisme')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Domaine skiable')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Centre équestre')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Athlétisme')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Terrain de golf')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Parcours sportif/santé')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sports de glace')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Plateaux et terrains de jeux extérieurs')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Salles spécialisées')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Terrain de grands jeux')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Salles de combat')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Salles non spécialisées')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Roller-Skate-Vélo bicross ou freestyle')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sports nautiques')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Bowling')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Salles de remise en forme')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Salles multisports (gymnase)')and b.libelle =('Equipements sportifs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Baignade aménagée')and b.libelle =('Equipements de loisirs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Port de plaisance - Mouillage')and b.libelle =('Equipements de loisirs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Boucle de randonnée')and b.libelle =('Equipements de loisirs');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Cinéma')and b.libelle =('Equipements culturels et socioculturels');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Musée')and b.libelle =('Equipements culturels et socioculturels');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Conservatoire')and b.libelle =('Equipements culturels et socioculturels');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Théâtre - Art de rue - Pôle cirque')and b.libelle =('Equipements culturels et socioculturels');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Agence de voyages')and b.libelle =('Tourisme');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Hôtel')and b.libelle =('Tourisme');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Camping')and b.libelle =('Tourisme');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Information touristique')and b.libelle =('Tourisme');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Services aux particuliers')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Services publics')and b.libelle =('Services aux particuliers');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Services généraux')and b.libelle =('Services aux particuliers');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Services automobiles')and b.libelle =('Services aux particuliers');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Artisanat du bâtiment')and b.libelle =('Services aux particuliers');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autres services à la population')and b.libelle =('Services aux particuliers');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Commerces')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Grandes surfaces')and b.libelle =('Commerces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Commerces alimentaires')and b.libelle =('Commerces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Commerces spécialisés non alimentaires')and b.libelle =('Commerces');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement du premier degré')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement du second degré premier cycle')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement du second degré second cycle')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement supérieur non universitaire')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Enseignement supérieur universitaire')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Formation continue')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autres services de l''éducation')and b.libelle =('Enseignement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Santé')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Etablissements et services de santé')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Fonctions médicales et para-médicales')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('autres établissements et services à caractère sanitaire')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Action sociale pour personnes agées')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Action sociale pour enfants en bas-âge')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Action sociale pour handicapés')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Autres services d''action sociale')and b.libelle =('Santé');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Transports et déplacements')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Infrastructures de transports')and b.libelle =('Transports et déplacements');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Sports, loisirs et culture')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipements sportifs')and b.libelle =('Sports, loisirs et culture');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipements de loisirs')and b.libelle =('Sports, loisirs et culture');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Equipements culturels et socioculturels')and b.libelle =('Sports, loisirs et culture');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tourisme')and b.libelle =('Type d''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Tourisme')and b.libelle =('Tourisme');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('l''écart des coordonées (x,y) fournies avec la réalité du terrain est inférieur à 100m')and b.libelle =('Indicateur de la qualité de la géolocalisation de l''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('l''écart des coordonées (x,y) fournies avec la réalité du terrain est compris entre 100 m et 500 m')and b.libelle =('Indicateur de la qualité de la géolocalisation de l''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('l''écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées')and b.libelle =('Indicateur de la qualité de la géolocalisation de l''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l''Insee.')and b.libelle =('Indicateur de la qualité de la géolocalisation de l''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d''équipements dont la géolocalisation n''est pas mise à disposition cette année.')and b.libelle =('Indicateur de la qualité de la géolocalisation de l''équipement');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Type d''équipement')and b.libelle =('fichier Ensemble');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('Indicateur de la qualité de la géolocalisation de l''équipement')and b.libelle =('fichier Ensemble');
insert into ta_relation_libelle (fid_libelle_fils,fid_libelle_parent)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_libelle b
WHERE
    a.libelle = ('fichier Ensemble')and b.libelle =('Contenu du fichier Base Permanente des Equipements');
commit;


-- 5 Insertion des information dans la table TA_FAMILLE

INSERT INTO TA_FAMILLE(famille)
VALUES ('BPE');

-- 6 Insertion des information dans la table TA_FAMILLE_LIBELLE

INSERT INTO ta_famille_libelle (fid_libelle,fid_famille)
SELECT
    a.objectid,
    b.objectid
FROM
    ta_libelle a,
    ta_famille b
WHERE
    a.libelle IN (
    	'Contenu du fichier Base Permanente des Equipements',
		'Equipement couvert ou non',
		'Equipement avec au moin une partie couverte',
		'Equipement non couvert',
		'Sans objet',
		'Equipement eclaire ou non',
		'Equipement avec au moins une partie eclairée',
		'Equipement non éclairé',
		'Nombre d''aires de pratique d''un même type au sein de l''équipement',
		'Nombre d''équipement',
		'Nombre de salles par théatre ou cinéma',
		'Présence ou absence d''un cantine',
		'Présence d''une cantine',
		'Absence d''une cantine',
		'Présence ou absence d''une classe pré-élémentaire',
		'Présence d''une classe pré-élémentaire',
		'Absence d''une classe pré-élémentaire',
		'Présence ou absence d''un classe préparatoire aux grandes écoles en lycée',
		'Présence d''une classe préparatoire aux grandes écoles',
		'absence d''une classe préparatoire aux grandes écoles',
		'Appartenance ou non à un dispositif d''éducation prioritaire',
		'Appartenance à un EP',
		'Non appartenance à un EP',
		'Présence ou absence d''un internat',
		'Présence  d''un internat',
		'absence d''un internat',
		'Présence ou absence d''un regroupement pédagogique intercommunal concentré',
		'Regroupement pédagogique',
		'pas de regroupement pédagogique',
		'Appartenance au Secteur public ou privé d''enseignement',
		'Secteur privé',
		'Secteur public',
		'Police',
		'Gendarmerie',
		'Cour d’appel (CA)',
		'Tribunal de grande instance (TGI)',
		'Tribunal d’instance (TI)',
		'Conseil des prud’hommes (CPH)',
		'Tribunal de commerce (TCO)',
		'Réseau spécialisé Pôle Emploi',
		'Direction Générale des Finances Publiques (DGFIP)',
		'Direction Régionale des Finances Publiques (DRFIP)',
		'Direction Départementale des Finances Publiques (DDFIP)',
		'Réseau de proximité Pôle Emploi',
		'Réseau partenarial Pôle Emploi',
		'Maison de justice et du droit',
		'Antenne de justice',
		'Conseil départemental d''accès au droit (CDAD)',
		'Banque, Caisse d’Épargne',
		'Pompes funèbres',
		'Bureau de poste',
		'Relais poste',
		'Agence postale',
		'Réparation auto et de matériel agricole',
		'Contrôle technique automobile',
		'Location auto-utilitaires légers',
		'École de conduite',
		'Maçon',
		'Plâtrier peintre',
		'Menuisier, charpentier, serrurier',
		'Plombier, couvreur, chauffagiste',
		'Électricien',
		'Entreprise générale du bâtiment',
		'Coiffure',
		'Vétérinaire',
		'Agence de travail temporaire',
		'Restaurant - Restauration rapide',
		'Agence immobilière',
		'A506 – Pressing - Laverie automatique',
		'Institut de beauté - Onglerie',
		'Hypermarché',
		'Supermarché',
		'Grande surface de bricolage',
		'Supérette',
		'Épicerie',
		'Boulangerie',
		'Boucherie charcuterie',
		'Produits surgelés',
		'Poissonnerie',
		'Librairie papeterie journaux',
		'Magasin de vêtements',
		'Magasin d''équipements du foyer',
		'Magasin de chaussures',
		'Magasin d''électroménager, audio vidéo',
		'Magasin de meubles',
		'Magasin d''art. de sports et de loisirs',
		'Magasin de revêtements murs et sols',
		'Droguerie quincaillerie bricolage',
		'Parfumerie - Cosmétique',
		'Horlogerie Bijouterie',
		'Fleuriste - Jardinerie - Animalerie',
		'Magasin d’optique',
		'Magasin de matériel médical et orthopédique',
		'Station service',
		'École maternelle',
		'École maternelle de RPI dispersé',
		'École élémentaire',
		'École élémentaire de RPI dispersé',
		'Collège',
		'Lycée d''enseignement général et/ou techno.',
		'Lycée d''enseignement professionnel',
		'Lycée technique et/ou professionnel agricole',
		'SGT : SECTion enseignement général et techno.',
		'SEP : SECTion enseignement professionnel',
		'STS CPGE',
		'Formation santé',
		'Formation commerce',
		'Autre formation post bac non universitaire',
		'UFR',
		'Institut universitaire',
		'École d''ingénieurs',
		'Enseignement général supérieur privé',
		'Écoles d’’enseignement supérieur agricole',
		'Autre enseignement supérieur',
		'Centre de formation d''apprentis (hors agriculture)',
		'GRETA',
		'Centre dispensant de la formation continue agricole',
		'Formation aux métiers du sport',
		'Centre dispensant des formations d’apprentissage agricole',
		'Autre formation continue',
		'Résidence universitaire',
		'Restaurant universitaire',
		'Établissement santé court séjour',
		'Établissement santé moyen séjour',
		'Établissement santé long séjour',
		'Établissement psychiatrique avec hébergement',
		'Centre lutte cancer',
		'Urgences',
		'Maternité',
		'Centre de santé',
		'Structure psychiatrique en ambulatoire',
		'Centre médecine préventive',
		'Dialyse',
		'Hospitalisation à domicile',
		'Maison de santé pluridisciplinaire',
		'Médecin généraliste',
		'Spécialiste en cardiologie',
		'Spécialiste en dermatologie vénéréologie',
		'Spécialiste en gastro-entérologie',
		'Spécialiste en psychiatrie',
		'Spécialiste en ophtalmologie',
		'Spécialiste en oto-rhino-laryngologie',
		'Spécialiste en pédiatrie',
		'Spécialiste en pneumologie',
		'Spéc. en radiodiagnostic et imagerie médicale',
		'Spécialiste en stomatologie',
		'Spécialiste en gynécologie (médicale et/ou obstétrique)',
		'Chirurgien dentiste',
		'Sage-femme',
		'Infirmier',
		'Masseur kinésithérapeute',
		'Orthophoniste',
		'Orthoptiste',
		'Pédicure-podologue',
		'Audio prothésiste',
		'Ergothérapeute',
		'Psychomotricien',
		'Manipulateur ERM',
		'Diététicien',
		'Psychologue',
		'Pharmacie',
		'Laboratoire d''analyses et de biologie médicales',
		'Ambulance',
		'Transfusion sanguine',
		'Établissement thermal',
		'Personnes âgées : hébergement',
		'Personnes âgées : soins à domicile',
		'Personnes âgées : services d''aide',
		'Personnes âgées : foyers restaurants',
		'Personnes âgées : services de repas à domicile',
		'Crèche',
		'Enfants handicapés : hébergement',
		'Enfants handicapés.: soins à domicile',
		'Adultes handicapés : hébergement',
		'Adultes handicapés : services d’aide',
		'Travail protégé',
		'Adultes handicapés : services de soins à domicile',
		'Aide sociale à l''enfance : hébergement',
		'Aide sociale à l''enfance : action éduc.',
		'CHRS Centre d''héberg. et de réadapt. sociale',
		'Centre provisoire d''hébergement',
		'Centre accueil demandeur d''asile',
		'Autres établissements pour adultes et familles en difficulté',
		'Taxi - VTC',
		'Aéroport',
		'Gare de voyageurs d’intérêt national',
		'Gare de voyageurs d’intérêt régional',
		'Gare de voyageurs d’intérêt local',
		'Bassin de natation',
		'Boulodrome',
		'Tennis',
		'Équipement de cyclisme',
		'Domaine skiable',
		'Centre équestre',
		'Athlétisme',
		'Terrain de golf',
		'Parcours sportif/santé',
		'Sports de glace',
		'Plateaux et terrains de jeux extérieurs',
		'Salles spécialisées',
		'Terrain de grands jeux',
		'Salles de combat',
		'Salles non spécialisées',
		'Roller-Skate-Vélo bicross ou freestyle',
		'Sports nautiques',
		'Bowling',
		'Salles de remise en forme',
		'Salles multisports (gymnase)',
		'Baignade aménagée',
		'Port de plaisance - Mouillage',
		'Boucle de randonnée',
		'Cinéma',
		'Musée',
		'Conservatoire',
		'Théâtre - Art de rue - Pôle cirque',
		'Agence de voyages',
		'Hôtel',
		'Camping',
		'Information touristique',
		'Services aux particuliers',
		'Services publics',
		'Services généraux',
		'Services automobiles',
		'Artisanat du bâtiment',
		'Autres services à la population',
		'Commerces',
		'Grandes surfaces',
		'Commerces alimentaires',
		'Commerces spécialisés non alimentaires',
		'Enseignement',
		'Enseignement du premier degré',
		'Enseignement du second degré premier cycle',
		'Enseignement du second degré second cycle',
		'Enseignement supérieur non universitaire',
		'Enseignement supérieur universitaire',
		'Formation continue',
		'Autres services de l''éducation',
		'Santé',
		'Etablissements et services de santé',
		'Fonctions médicales et para-médicales',
		'autres établissements et services à caractère sanitaire',
		'Action sociale pour personnes agées',
		'Action sociale pour enfants en bas-âge',
		'Action sociale pour handicapés',
		'Autres services d''action sociale',
		'Transports et déplacements',
		'Infrastructures de transports',
		'Sports, loisirs et culture',
		'Equipements sportifs',
		'Equipements de loisirs',
		'Equipements culturels et socioculturels',
		'Tourisme',
		'Type d''équipement',
		'Indicateur de la qualité de la géolocalisation de l''équipement',
		'l''écart des coordonées (x,y) fournies avec la réalité du terrain est inférieur à 100m',
		'l''écart des coordonées (x,y) fournies avec la réalité du terrain est compris entre 100 m et 500 m',
		'l''écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées',
		'pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l''Insee.',
		'pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d''équipements dont la géolocalisation n''est pas mise à disposition cette année.',
		'fichier Sport-Loisir',
		'fichier Enseignement',
		'fichier Ensemble'
	)and b.famille =('BPE');