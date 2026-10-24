PRAGMA foreign_keys = ON; --On a besoin de cette commande pour activer les contraintes de clés étrangères

CREATE TABLE regions (
    rid INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    chefLieu TEXT NOT NULL
);

CREATE TABLE departements (
    code TEXT PRIMARY KEY,
    nom TEXT NOT NULL,
    prefecture TEXT NOT NULL,
    rid INTEGER NOT NULL,
    FOREIGN KEY (rid) REFERENCES regions(rid)
);

-- Peuplement des tables (en supposant l'utilisation des commandes d'importation CSV de SQLite, ex: .import)
-- .mode csv
-- .import regions.csv regions
-- .import departements.csv departements