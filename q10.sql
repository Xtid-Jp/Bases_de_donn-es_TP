-- Une requête qui compte le nbre de ZUS de chaque département en incluant sa région 

.output output_file.txt

SELECT d.nom AS departement, 
    (SELECT r.nom FROM regions r WHERE r.rid = d.rid) AS nom_region, 
    (SELECT COUNT(*) FROM zus z WHERE z.departement = d.nom) AS nb_dept_zus
FROM departements d
ORDER BY nb_dept_zus DESC