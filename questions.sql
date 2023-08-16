1  Listar os empregados (nomes) que tem salário maior que seu chefe (usar o join)

SELECT e1.nome
FROM empregados e1 
JOIN empregados e2 ON e1.supervisor_id=e2.emp_id
WHERE e1.salario > e2.salario;

--  empregado | 
-- -----------+
--  Maria     |
--  Claudia   |
--  Ana       |
--  Luiz      |


2 Listar o maior salario de cada departamento (usa o group by e o IN )

SELECT e.dep_id, max(e.salario) FROM empregados e 
JOIN departamentos d ON e.dep_id=d.dep_id
GROUP BY e.dep_id
ORDER BY e.dep_id;

--  dep_id |  max  
-- --------+-------
--       1 | 10000
--       2 |  8000
--       3 |  6000
--       4 | 12200



3 Listar o dep_id, nome e o salario do funcionario com maior salario dentro de cada departamento (usar o with)

With MaioSalario AS
    (
            SELECT e.dep_id, max(e.salario) FROM empregados e JOIN departamentos d ON e.dep_id=d.dep_id GROUP BY e.dep_id 
    )
SELECT e.dep_id, e.nome, e.salario
FROM empregados e 
JOIN MaioSalario ms ON e.dep_id=ms.dep_id
WHERE e.salario = ms.max;

    
--  dep_id |  nome   | salario 
-- --------+---------+---------
--       3 | Joao    |    6000
--       1 | Claudia |   10000
--       4 | Ana     |   12200
--       2 | Luiz    |    8000


4 Listar os nomes departamentos que tem menos de 3 empregados;

SELECT e.dep_id, count(e.dep_id), d.nome
FROM empregados e
JOIN departamentos d ON e.dep_id=d.dep_id
GROUP BY e.dep_id, d.nome
HAVING e.count < 3;

--    nome    
-- -----------
--  Marketing
--  RH
--  Vendas


5 Listar os departamentos  com o número de colaboradores

SELECT d.nome, count(e.dep_id)
FROM empregados e
JOIN departamentos d ON e.dep_id=d.dep_id
GROUP BY d.nome;
    
--    nome    | count 
-- -----------+-------
--  Marketing |     1
--  RH        |     2
--  TI        |     4
--  Vendas    |     1


6 Listar os empregados que não possue o seu  chefe no mesmo departamento/ 

SELECT e1.nome, e1.dep_id
FROM empregados e1
JOIN empregados e2 ON e1.supervisor_id = e2.emp_id
WHERE e1.dep_id != e2.dep_id 
    
--  nome | dep_id 
-- ------+--------
--  Joao |      3
--  Ana  |      4


7 Listar os nomes dos  departamentos com o total de salários pagos (sliding windows function)

SELECT DISTINCT
    SUM(e.salario) OVER (PARTITION BY e.dep_id),
	d.nome
FROM empregados e
JOIN departamentos d ON e.dep_id = d.dep_id;
    
--   sum  |   nome    
-- -------+-----------
--   6000 | Vendas
--  12200 | Marketing
--  15500 | RH
--  32500 | TI



8 Listar os nomes dos colaboradores com salario maior que a média do seu departamento (dica: usar subconsultas);

SELECT nome, salario
FROM (
    SELECT
        e.nome,
        e.salario,
        AVG(e.salario) OVER (PARTITION BY e.dep_id) AS media
    FROM empregados e
    JOIN departamentos d ON e.dep_id = d.dep_id
) AS subquery
WHERE salario > media;

--   Nome   | Salário 
-- ---------+---------
--  Maria   |    9500
--  Claudia |   10000
--  Luiz    |    8000

 9  Faça uma consulta capaz de listar os dep_id, nome, salario, e as médias de cada departamento utilizando o windows function;

SELECT *
FROM (
    SELECT
		e.dep_id,
        e.nome,
        e.salario,
        AVG(e.salario) OVER (PARTITION BY e.dep_id) AS media
    FROM empregados e
    JOIN departamentos d ON e.dep_id = d.dep_id
) AS subquery

--  dep_id |   nome    | salario |  avg  
-- --------+-----------+---------+-------
--       1 | Jose      |    8000 |  8125
--       1 | Claudia   |   10000 |  8125
--       1 | Guilherme |    5000 |  8125
--       1 | Maria     |    9500 |  8125
--       2 | Luiz      |    8000 |  7750
--       2 | Pedro     |    7500 |  7750
--       3 | Joao      |    6000 |  6000
--       4 | Ana       |   12200 | 12200




10 - Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)

SELECT *
FROM (
	SELECT
        e.nome,
        e.salario,
		e.dep_id,
        AVG(e.salario) OVER (PARTITION BY e.dep_id) AS media
    FROM empregados e
    JOIN departamentos d ON e.dep_id = d.dep_id
) AS subquery
WHERE salario >= media;

--   nome   | salario | dep_id |       avg_salary       
-- ---------+---------+--------+------------------------
--  Claudia |   10000 |      1 |  8125.0000000000000000
--  Maria   |    9500 |      1 |  8125.0000000000000000
--  Luiz    |    8000 |      2 |  7750.0000000000000000
--  Joao    |    6000 |      3 |  6000.0000000000000000
--  Ana     |   12200 |      4 | 12200.0000000000000000

