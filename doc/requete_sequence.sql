/*
Lors de la création d'une colonne de type identity, oracle créer automatiquement une séquence.
Cette requête permet de retrouver le nom des séquences utilisées par les colonnes d'une table determinée.
*/

SELECT
    t.NAME AS TABLE_NAME,
    u.username,
    c.name AS IDENTITY_COLUMN_NAME,
    s.NAME AS SEQUENCE_NAME
FROM
   sys.IDNSEQ$ os
   INNER JOIN sys.obj$ t ON (t.obj# = os.obj#)
   INNER JOIN sys.obj$ s ON (s.obj# = os.seqobj#)
   INNER JOIN sys.col$ c ON (c.obj# = t.obj# AND c.col# = os.intcol#)
   INNER JOIN all_users u ON (u.user_id = t.owner#)
WHERE t.NAME = 'NOM_TABLE'
AND u.username = 'NOM_SCHEMA';