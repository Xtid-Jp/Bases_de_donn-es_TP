-- view qui sélectionne les ZUS qui se trouvent dans les communes qui sont préfectures de leur département
.output output_file.txt

DROP VIEW IF EXISTS zus_prefecture;

CREATE VIEW zus_prefecture AS
    SELECT z.departement, z.commune, z.quartier
    FROM zus z
    JOIN departements d ON (d.nom = z.departement)
    WHERE z.commune = d.prefecture
    OR z.commune LIKE d.prefecture || '%e%'
    OR z.commune LIKE '%' || d.prefecture || '%'
    OR d.prefecture LIKE '%' || z.commune || '%';

SELECT
    (SELECT COUNT(*) FROM zus_prefecture) AS "Oui",
    (SELECT COUNT(*) FROM zus) - (SELECT COUNT(*) FROM zus_prefecture) AS "Non",
    (SELECT COUNT(*) FROM zus) AS "Total";