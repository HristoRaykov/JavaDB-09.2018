USE gringotts;


SELECT left(first_name,1) AS 'first_letter'
FROM wizzard_deposits
WHERE deposit_group='Troll Chest'
GROUP BY first_letter;


SELECT deposit_group,
	   is_deposit_expired,
	   avg(deposit_interest)
FROM wizzard_deposits
WHERE deposit_start_date>'1985-01-01'
GROUP BY deposit_group,is_deposit_expired
ORDER BY  deposit_group DESC,is_deposit_expired;


SELECT sum(d1.deposit_amount - d2.deposit_amount) AS sum_difference
FROM wizzard_deposits d1
JOIN wizzard_deposits d2
ON d2.id=d1.id+1;


SELECT sum(
	            wd1.deposit_amount -
                (SELECT wd2.deposit_amount FROM wizzard_deposits wd2
                 WHERE wd1.id = wd2.id-1
                )
	       ) AS sum_difference
FROM wizzard_deposits wd1;


USE soft_uni;


SELECT department_id,
       min(salary) AS 'minimum_salary'
FROM employees
WHERE department_id IN (2,5,7) AND hire_date>'2000-01-01'
GROUP BY department_id;



CREATE TABLE avarage_salary
SELECT * FROM employees
WHERE salary>30000;
DELETE FROM avarage_salary
WHERE manager_id=42;
UPDATE avarage_salary
SET salary=salary+5000
WHERE department_id=1;
SELECT department_id,avg(salary) AS 'avg_salary'
FROM avarage_salary
GROUP BY department_id;


SELECT department_id,max(salary) AS 'max_salary'
FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000;

SELECT count(salary)
FROM employees
WHERE manager_id IS NULL;


SELECT department_id,
       (
		SELECT  DISTINCT e1.salary
        FROM employees e1
		WHERE e1.department_id = e2.department_id
        ORDER BY e1.salary DESC
		LIMIT 2,1
	    ) AS 'third_highest_salary'
FROM employees e2
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;


SELECT first_name,last_name,department_id
FROM employees e1
WHERE e1.salary>(
                SELECT avg(e2.salary)
                FROM employees e2
                WHERE e1.department_id=e2.department_id
                )
ORDER BY e1.department_id,e1.employee_id
LIMIT 10;


SELECT e.department_id,
        (
	        SELECT sum(salary)
            FROM employees
            WHERE department_id = e.department_id
		) AS 'total_salary'
FROM employees e
GROUP BY e.department_id
ORDER BY e.department_id;