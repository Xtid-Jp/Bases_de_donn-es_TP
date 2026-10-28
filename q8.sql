.output output_file.txt

SELECT d.code, z.commune, z.quartier, z.departement
FROM departements d 
JOIN zus z ON z.commune LIKE '%(' || d.code || ')%';