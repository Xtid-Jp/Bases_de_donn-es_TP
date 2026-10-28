-- Exercice 01
-- Création des tables

PRAGMA foreign_keys = ON; --On a besoin de cette commande pour activer les contraintes de clés étrangères

DROP TABLE IF EXISTS zus;
DROP TABLE IF EXISTS voisins;
DROP TABLE IF EXISTS departements;
DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
    rid VARCHAR(3) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    chefLieu VARCHAR(100) NOT NULL
);

CREATE TABLE departements (
    code VARCHAR(3) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    prefecture VARCHAR(100) NOT NULL,
    rid VARCHAR(3) NOT NULL,
    FOREIGN KEY (rid) REFERENCES regions(rid)
);

CREATE TABLE voisins (
    rid1 VARCHAR(3) NOT NULL,
    rid2 VARCHAR(3) NOT NULL,
    PRIMARY KEY (rid1, rid2), -- Pour éviter des doublons
    FOREIGN KEY (rid1) REFERENCES regions(rid),
    FOREIGN KEY (rid2) REFERENCES regions(rid)
);

CREATE TABLE zus (
    departement VARCHAR(100) NOT NULL,
    commune VARCHAR(100) NOT NULL,
    quartier VARCHAR(100) NOT NULL,
    PRIMARY KEY (departement, commune, quartier), -- on ne peut identifier une zus que par le triplet departement+commune+quartier
    FOREIGN KEY (departement) REFERENCES departements(nom)
);

-- Peuplement des tables (en supposant l'utilisation des commandes d'importation CSV de SQLite, ex: .import)
.mode box
.separator ','

.import regions.csv regions
.import departements.csv departements
.import voisins.csv voisins



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
-- Nom de regions par ordre alphabetique, chef lieu, et pour chaque departement de la region : code, nom et prefecture

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





.mode box
.separator ';'
.import zus.csv zus

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

SELECT count(*) nb_voisins_sym 
FROM voisinsSym;

--Exercice 08
-- Une view qui contient les relations de voisinage entre des noms de régions et pas des identifiants


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

-- 10. Donnez une requête SQL pour trouver les ZUS qui se trouvent dans plusieurs départements alors qu'il s'agit du même quartier et des mêmes communes.
SELECT *
FROM zus
WHERE commune LIKE '%(%)%';

--11. Créez une view qui sélectionne les ZUS qui se trouvent dans les communes qui sont préfectures de leur département. 
-- requête qui utilise cette view afin de retourner le nombre de ZUS dans des communes préfecture ou dans d'autres communes, ainsi que le total.

DROP VIEW IF EXISTS





