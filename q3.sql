-- Nom de regions par ordre alphabetique, cgef lieu, et pour chaque departement de la region : code, nom et prefecture
.output output_file.txt

SELECT r.nom, r.chefLieu, d.code, d.nom, d.prefecture
FROM regions r, departements d
WHERE r.rid=d.rid
GROUP BY r.nom
ORDER BY r.nom;