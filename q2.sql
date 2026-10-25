-- Pour chaque département : le code, le nom, la préfecture et le nom de la région

.output output_file.txt 
SELECT *
FROM departements
GROUP BY code
ORDER BY code ASC;