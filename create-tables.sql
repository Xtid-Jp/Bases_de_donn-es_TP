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

.mode box
.separator ';'
.import zus.csv zus