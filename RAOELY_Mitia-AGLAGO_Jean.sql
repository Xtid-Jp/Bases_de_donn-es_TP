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





-- Peuplement des tables (en supposant l'utilisation des commandes d'importation CSV de SQLite, ex: .import)
.mode box
.separator ','

.import regions.csv regions
.import departements.csv departements



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

CREATE TABLE voisins (
    rid1 VARCHAR(3) NOT NULL,
    rid2 VARCHAR(3) NOT NULL,
    PRIMARY KEY (rid1, rid2), -- Pour éviter des doublons
    FOREIGN KEY (rid1) REFERENCES regions(rid),
    FOREIGN KEY (rid2) REFERENCES regions(rid)
);

.import voisins.csv voisins


-- Nombre total de tuples dans la table

SELECT count(*) AS nb_voisins
FROM voisins;

-- Exercice 07
-- Une view qui construit la clôture symétrique de la relation voisins

--On remarque que dans la table voisins par exemple CVL qui a comme voisin NOR on pas le sens NOR CVL
-- vu qu'on considére que c'est symétrique 

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

-- On voit que le nombre de lignes  voisinsSym est d'au plus le nombre de ligne de voisins * 2


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


-- Exercice 09 

/* 
    En analysant le format dans lequel les données on été publiées, nous remarquons quelques problèmes :
    1- les données dans une même colonne ne sont pas du même type (la colonne commune contient des noms de communes mais aussi des numéros de département entre parenthèses)
    2- les données ne sont pas atomiques (plusieurs nom de quatier ou de commune dans la même colonne séparés par des virgules ou liés par un et)
*/

CREATE TABLE zus (
    departement VARCHAR(100) NOT NULL,
    commune VARCHAR(100) NOT NULL,
    quartier VARCHAR(100) NOT NULL,
    PRIMARY KEY (departement, commune, quartier), -- on ne peut identifier une zus que par le triplet departement+commune+quartier
    FOREIGN KEY (departement) REFERENCES departements(nom)
);

.mode box
.separator ';'
.import zus.csv zus


-- Exercice 10. Donnez une requête SQL pour trouver les ZUS qui se trouvent dans plusieurs départements alors qu'il s'agit du même quartier et des mêmes communes.
SELECT *
FROM zus
WHERE commune LIKE '%(%)%';

/*
    La manière la plus correct serait d'avoir une table commune (id, nom) et une table quartier (id, nom) et d'avoir 
    la table zus(departement, id_commune, id_quartier) avec des clés étrangères vers les deux autres tables.
    On utiliserait alors des jointures pour faire les recherches et on aurait des données atomiques dans les colonnes commune et quartier
     .
*/

-- Exercice 11. Créez une view qui sélectionne les ZUS qui se trouvent dans les communes qui sont préfectures de leur département. 
-- requête qui utilise cette view afin de retourner le nombre de ZUS dans des communes préfecture ou dans d'autres communes, ainsi que le total.

DROP VIEW IF EXISTS zus_prefecture;

CREATE VIEW zus_prefecture AS
SELECT z.commune
FROM zus z, departements d
WHERE z.departement = d.nom
AND 
(z.commune LIKE ('%' || d.prefecture || '%')
OR d.prefecture LIKE ('%' || z.commune || '%'));

SELECT (SELECT count(*) FROM zus_prefecture) AS 'Oui',
(SELECT count(*) - (SELECT count(*) FROM zus_prefecture) FROM zus) AS 'Non',
(SELECT count(*) FROM zus) AS 'Total';


-- Exercice 12. Donnez une requête SQL qui compte, en ordre décroissant, le nombre de ZUS de chaque département
-- en incluant aussi sa région dans le résultat (en faisant aussi apparaître les départements sans ZUS avec compteur 0)

DROP VIEW  IF EXISTS nombre_zus_par_departement;
CREATE VIEW nombre_zus_par_departement AS
SELECT d.nom as nom_departement, r.nom, COUNT(z.commune) AS nb_zus_par_departement
FROM departements d
JOIN regions r ON (d.rid=r.rid)
LEFT JOIN zus z ON (d.nom=z.departement)
GROUP BY d.nom
ORDER BY nb_zus_par_departement DESC;

SELECT * FROM nombre_zus_par_departement;


-- Exercice 13. Donnez une requête SQL qui compte, en ordre décroissant, le nombre de ZUS de chaque région.
DROP VIEW IF EXISTS nombre_zus_par_region;
CREATE VIEW  nombre_zus_par_region AS
SELECT r.nom as nom_region, COUNT(*) as nb_zus_par_region
FROM departements d
JOIN regions r ON (d.rid=r.rid)
LEFT JOIN zus z ON (d.nom=z.departement)
GROUP BY r.nom
ORDER BY nb_zus_par_region DESC;

SELECT * FROM nombre_zus_par_region;

--14. Donnez deux formulations différentes pour la requête qui retourne les noms des régions pour lesquelles tous les départements ont au moins un ZUS.


-- Version 01
SELECT r.nom
FROM regions r
WHERE NOT EXISTS (
    SELECT *
    FROM departements d
    WHERE d.rid = r.rid
    AND NOT EXISTS (
        SELECT *
        FROM zus z
        WHERE z.departement = d.nom
        )
    );

-- Version 02
SELECT r.nom
FROM regions r
JOIN departements d ON r.rid = d.rid
GROUP BY r.nom
HAVING COUNT(DISTINCT d.code) = (
    SELECT COUNT(DISTINCT z.departement)
    FROM zus z
    WHERE z.departement IN (
        SELECT nom FROM departements WHERE rid = r.rid
    )
);
















