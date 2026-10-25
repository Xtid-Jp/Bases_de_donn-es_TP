-- Nom de regions par ordre alphabetique, chef lieu, et pour chaque departement de la region : code, nom et prefecture
.output output_file.txt


SELECT r.nom, r.chefLieu, d.code, d.nom, d.prefecture
FROM departements d, regions r
WHERE d.rid=r.rid
GROUP BY d.nom
ORDER BY r.nom ASC;