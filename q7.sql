-- Une view qui contient les relations de voisinage entre des noms de régions et pas des identifiants

.output output_file.txt

DROP VIEW IF EXISTS voisinsSymNoms;

CREATE VIEW voisinsSymNoms AS
    SELECT r1.nom region1, r2.nom region2
    FROM voisinsSym vs
    JOIN regions r1 ON vs.rid1 = r1.rid
    JOIN regions r2 ON vs.rid2 = r2.rid;

SELECT r.nom region, count(vs.region2) nb_voisins
FROM regions r LEFT JOIN voisinsSymNoms vs ON (r.nom = vs.region1)
GROUP BY r.nom
ORDER BY nb_voisins DESC;