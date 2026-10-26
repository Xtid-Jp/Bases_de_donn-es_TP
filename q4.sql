-- Le code, le nom et la préfecture de tous les départements de la région CVL

.output output_file.txt

SELECT d.code, d.nom, d.prefecture
FROM departements d
where d.rid='CVL'

