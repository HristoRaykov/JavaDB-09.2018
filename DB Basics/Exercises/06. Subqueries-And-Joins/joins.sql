USE soft_uni;

SELECT e.employee_id,
        e.job_title,
       a.address_id,
       a.address_text
FROM employees e
JOIN addresses a ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;


SELECT e.first_name,e.last_name,t.name,a.address_text
FROM employees e
JOIN addresses a ON e.address_id=a.address_id
JOIN towns t ON a.town_id=t.town_id
ORDER BY e.first_name,last_name
LIMIT 5;


SELECT e.employee_id,e.first_name,e.last_name,d.name
FROM employees e
JOIN departments d ON e.department_id=d.department_id
WHERE d.name='Sales'
ORDER BY e.employee_id DESC;


SELECT e.employee_id,e.first_name,e.salary,d.name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary>15000
ORDER BY d.department_id DESC
LIMIT 5;


SELECT e.employee_id,e.first_name
FROM employees e
LEFT JOIN employees_projects ep
ON e.employee_id=ep.employee_id
WHERE ep.project_id is NULL
ORDER BY e.employee_id DESC
LIMIT 3;


SELECT e.first_name,e.last_name,e.hire_date,d.name AS 'dep_name'
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date>='1999-01-02 00:00:00.00' AND (d.name='Sales' OR d.name='Finance')
ORDER BY e.hire_date;


SELECT e.employee_id,e.first_name,p.name
FROM employees e
JOIN employees_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id
WHERE p.start_date>='2002-08-14 00:00:00.00' AND p.end_date IS NULL
ORDER BY e.first_name,p.name
LIMIT 5;


SELECT e.employee_id,
       e.first_name,
       CASE
	       WHEN p.start_date>'2004-12-31 23:59:59.99' THEN NULL
	       ELSE p.name
		END AS 'project_name'
FROM employees e
JOIN employees_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id
WHERE e.employee_id=24
ORDER BY project_name;


SELECT e1.employee_id,
       e1.first_name,
       e1.manager_id,
       e2.first_name AS 'manager_name'
FROM employees e1
JOIN employees e2 ON e1.manager_id=e2.employee_id
WHERE e1.manager_id IN (3,7)
ORDER BY e1.first_name;



SELECT e1.employee_id,
       concat(e1.first_name,' ',e1.last_name) AS 'employee_name',
       concat(e2.first_name,' ',e2.last_name) AS 'manager_name',
	   d.name AS 'department_name'
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.employee_id
JOIN departments d ON e1.department_id = d.department_id
ORDER BY e1.employee_id
LIMIT 5;


SELECT AVG(salary) AS 'avr_salary_by_dep'
FROM employees
GROUP BY department_id
ORDER BY avr_salary_by_dep
limit 1;

SELECT min(avr_salary_by_dep)
FROM (
     SELECT AVG(salary)
     FROM employees
     GROUP BY department_id
	) AS 'avr_salary_by_dep';


SELECT min(avr_salary_by_dep) AS 'min_average_salary'
FROM
(SELECT AVG(salary) AS 'avr_salary_by_dep'
FROM employees
GROUP BY department_id) as e ;


USE geography;


SELECT c.country_code,
	   m.mountain_range,
	   p.peak_name,
	   p.elevation
FROM countries c
JOIN mountains_countries mc ON c.country_code=mc.country_code
JOIN mountains m ON mc.mountain_id=m.id
JOIN peaks p ON m.id = p.mountain_id
WHERE p.elevation>2835 AND c.country_code='BG'
ORDER BY p.elevation DESC;

SELECT mc.country_code,
	   count(mc.mountain_id) AS 'mountain_range'
FROM mountains_countries mc
GROUP BY mc.country_code
HAVING mc.country_code IN ('BG','RU','US')
ORDER BY mountain_range DESC;



SELECT c.country_name,r.river_name
FROM countries c
LEFT JOIN countries_rivers cr ON c.country_code=cr.country_code
LEFT JOIN rivers r ON cr.river_id = r.id
JOIN continents c2 ON c.continent_code = c2.continent_code
WHERE c2.continent_name='Africa'
ORDER BY c.country_name
LIMIT 5;



CREATE TABLE cu (
SELECT continent_code,currency_code,count(currency_code) AS 'currency_usage'
FROM countries
GROUP BY continent_code,currency_code
HAVING count(currency_code)>1);

SELECT *
FROM cu as cu1
WHERE cu1.currency_usage = (SELECT MAX(cu2.currency_usage)
                             FROM cu as cu2
                             where cu1.continent_code = cu2.continent_code)
ORDER BY cu1.continent_code,cu1.currency_code;


SELECT count(c.country_code) AS 'country_count'
FROM countries c
LEFT JOIN mountains_countries mc
ON c.country_code=mc.country_code
WHERE mc.mountain_id IS NULL;


SELECT c.country_name,
       p.elevation AS 'highest_peak_elevation',
       r.length AS 'longest_river_length'
FROM countries c
LEFT JOIN mountains_countries mc ON c.country_code = mc.country_code
LEFT JOIN mountains m ON mc.mountain_id = m.id
LEFT JOIN peaks p ON m.id = p.mountain_id
LEFT JOIN countries_rivers cr ON c.country_code=cr.country_code
LEFT JOIN rivers r ON cr.river_id = r.id
GROUP BY c.country_name
HAVING max(p.elevation) AND max(r.length)
ORDER BY p.elevation DESC ,r.length DESC
LIMIT 5;