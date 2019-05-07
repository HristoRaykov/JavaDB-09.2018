USE soft_uni;

SELECT first_name,last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;


SELECT first_name,last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

SELECT first_name FROM employees e
WHERE (year(e.hire_date) BETWEEN 1995 AND 2005)
  AND (department_id IN (3,10))
ORDER BY e.employee_id;


SELECT first_name,last_name FROM employees e
WHERE e.job_title NOT LIKE '%engineer%'
ORDER BY e.employee_id;

SELECT name FROM towns
WHERE char_length(name) IN (5,6)
ORDER BY name;


SELECT town_id,name FROM towns
WHERE lower(left(name,1)) IN ('m','k','b','e')
ORDER BY name;


SELECT town_id,name FROM towns
WHERE lower(left(name,1)) NOT IN ('r','b','d')
ORDER BY name;

CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name,last_name FROM employees
WHERE year(hire_date) > 2000;


SELECT first_name,last_name FROM employees
WHERE char_length(last_name) = 5;


use geography;


SELECT country_name,iso_code FROM countries
WHERE (length(lower(country_name))-length(replace(lower(country_name), 'a', ''))/length('a'))>2
ORDER BY iso_code;


SELECT peak_name,
	   river_name,
	   lower(
		   concat(
			   substr(peak_name, 1, char_length(peak_name) - 1),
			   river_name
			   )
			) AS mix
FROM peaks,rivers
WHERE lower(right(peak_name,1))=lower(left(river_name,1))
ORDER BY mix;


use diablo;


SELECT name,
       date_format(start,'%Y-%m-%d') as start
FROM games
WHERE year(start) BETWEEN 2011 AND  2012
ORDER BY start
LIMIT 50;


SELECT  user_name,
		substr(email,locate('@',email)+1)
	    AS 'Email Provider'
FROM users
ORDER BY `Email Provider`,user_name;


SELECT user_name,ip_address
FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;


SELECT name AS 'game',
       CASE
		    WHEN hour(start) BETWEEN 0 AND 11 THEN 'Morning'
		    WHEN hour(start) BETWEEN 12 AND 17 THEN 'Afternoon'
		    WHEN hour(start) BETWEEN 18 AND 24 THEN 'Evening'
		END
            AS 'Part of the Day',
       CASE
	       WHEN duration<=3 THEN 'Extra Short'
	       WHEN duration BETWEEN 4 AND 6 THEN 'Short'
	       WHEN duration BETWEEN 7 AND 10 THEN 'Long'
	       ELSE 'Extra Long'
	       END
            AS 'Duration'
FROM games;


USE orders;


SELECT product_name,
	   order_date,
	   adddate(order_date,3) as 'pay_due',
	   adddate(order_date,INTERVAL 1 MONTH) AS 'deliver_due'
FROM orders;