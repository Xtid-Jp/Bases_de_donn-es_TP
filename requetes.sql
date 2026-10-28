-- Exercice 01
-- Création des tables

-- Peuplement des tables (en supposant l'utilisation des commandes d'importation CSV de SQLite, ex: .import)

-- Partie 01

-- Exercice 02
-- Retourne le code et le nom du département qui a la préfecture à Bourges

SELECT code, nom
FROM departements
WHERE prefecture='Bourges';

-- Exercice 03
-- Pour chaque département : le code, le nom, la préfecture et le nom de la région

SELECT d.code, d.nom, d.prefecture, r.nom AS nom_region
FROM departements d
JOIN regions r ON r.rid = d.rid
ORDER BY d.code ASC;

-- Exercice 04
-- Nom de regions par ordre alphabetique, cgef lieu, et pour chaque departement de la region : code, nom et prefecture

SELECT r.nom, r.chefLieu, d.code, d.nom, d.prefecture
FROM regions r, departements d
WHERE r.rid=d.rid
GROUP BY r.nom
ORDER BY r.nom;

-- Exercice 05
-- Le code, le nom et la préfecture de tous les départements de la région CVL

SELECT d.code, d.nom, d.prefecture
FROM departements d
JOIN regions r ON (d.rid = r.rid)
where r.nom='Centre-Val de Loire';

-- Exercice 06



-- Nombre total de tuples dans la table

SELECT count(*) AS nb_voisins
FROM voisins;

-- Exercice 07
-- Une view qui construit la clôture symétrique de la relation voisins

DROP VIEW IF EXISTS voisinsSym;

CREATE VIEW voisinsSym AS
    SELECT rid1, rid2
    FROM voisins 
    UNION
        SELECT rid2, rid1
        FROM voisins;

-- Nombre total de tuples dans la table et comparaison avec celui de la question précédente

SELECT COUNT(*) nb_voisins_sym 
FROM voisinsSym;

--Exercice 08
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

-- Exercice 09



