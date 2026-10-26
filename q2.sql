-- Pour chaque département : le code, le nom, la préfecture et le nom de la région

.output output_file.txt 
SELECT d.code, d.nom, d.prefecture, r.nom AS nom_region
FROM departements d
JOIN regions r ON r.rid = d.rid
ORDER BY d.code ASC;