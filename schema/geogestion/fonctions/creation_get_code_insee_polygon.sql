/*
GET_CODE_INSEE_POLYGON : Création de la fonction permettant d'identifier la commune d'appartenance d'un polygone ou d'un multi-polygone. 
*/

create or replace FUNCTION GET_CODE_INSEE_POLYGON(v_geometry SDO_GEOMETRY) RETURN CHAR
/*
Cette fonction a pour objectif de récupérer le code INSEE de la commune dans laquelle se situe le centroïd d'un polygone, ou d'un multipolygone.
La variable v_table_name doit contenir le nom de la table dont on veut connaître le code INSEE des objets.
La variable v_geometry doit contenir le nom du champ géométrique de la table interrogée.

ATTENTION : pour les multipolygones à cheval sur deux communes, le centroïd peut ne pas se situer dans la commune que vous voulez...
*/
    DETERMINISTIC
    As
    v_code_insee CHAR(5);
    BEGIN
        SELECT 
            TRIM(b.code_insee)
            INTO v_code_insee 
        FROM
            G_REFERENTIEL.MEL_COMMUNE b
        WHERE
            SDO_RELATE(SDO_GEOM.SDO_CENTROID(v_geometry, 0.001), b.geom, 'mask=INSIDE')='TRUE';
        RETURN TRIM(v_code_insee);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'error';
    END GET_CODE_INSEE_POLYGON;

/

