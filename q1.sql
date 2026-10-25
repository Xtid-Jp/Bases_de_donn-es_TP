-- Retourne le code et le nom du département qui a la préfecture à Bourges
.output output_file.txt

SELECT code, nom
FROM departements
WHERE prefecture='Bourges';

