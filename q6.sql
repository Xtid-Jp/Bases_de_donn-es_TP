-- Une view qui construit la clôture symétrique de la relation voisins

.output output_file.txt

DROP VIEW IF EXISTS voisinsSym;

CREATE VIEW voisinsSym AS
    SELECT rid1, rid2
    FROM voisins 
    UNION
        SELECT rid2, rid1
        FROM voisins;

-- Nombre total de tuples dans la table et comparaison avec celui de la question précédente

SELECT count(*) nb_voisins_sym 
FROM voisinsSym;

