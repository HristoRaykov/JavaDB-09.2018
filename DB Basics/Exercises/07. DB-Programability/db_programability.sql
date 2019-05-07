USE `soft_uni`;


# 1
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
	BEGIN
		SELECT first_name,last_name
		FROM employees
		WHERE salary > 35000
		ORDER BY first_name,last_name;
	END;

CALL usp_get_employees_salary_above_35000();

# 2
CREATE PROCEDURE usp_get_employees_salary_above (number DOUBLE)
	BEGIN
		SELECT first_name,last_name
		FROM employees
		WHERE salary >= number
		ORDER BY first_name,last_name,employee_id;
	END;

CALL usp_get_employees_salary_above(48100);


# 3
CREATE PROCEDURE usp_get_towns_starting_with (str VARCHAR(20))
	BEGIN
		SELECT name AS 'town_name'
		FROM towns
		WHERE  lower(name) LIKE  lower(concat(str,'%'))
		ORDER BY town_name;
	END;

CALL usp_get_towns_starting_with ('b');

# 4
CREATE PROCEDURE usp_get_employees_from_town (town VARCHAR(50))
	BEGIN
		SELECT e.first_name,e.last_name
		FROM towns t
		JOIN addresses a ON t.town_id=a.town_id
		JOIN employees e ON a.address_id=e.address_id
		WHERE t.name=town
		ORDER BY e.first_name,e.last_name,e.employee_id;
	END;

CALL usp_get_employees_from_town('Sofia');

# 5
CREATE FUNCTION ufn_get_salary_level (salary DOUBLE) RETURNS VARCHAR(20)
	BEGIN
		DECLARE salary_level VARCHAR(20);
		SET salary_level :=
			(
			SELECT

				(CASE
					WHEN salary < 30000 THEN 'Low'
					WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
					WHEN salary > 50000 THEN 'High'
				END) AS 'salary_level'
			);
		RETURN salary_level;
	END;


SELECT ufn_get_salary_level(13500.00);


# 6
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(20))
	BEGIN
		SELECT first_name,last_name
		FROM employees
		WHERE
			CASE
				WHEN salary_level = 'Low' THEN salary < 30000
				WHEN salary_level = 'Average' THEN salary BETWEEN 30000 AND 50000
				WHEN salary_level = 'High' THEN salary > 50000
			END
		ORDER BY first_name DESC , last_name DESC ;
	END;

CALL usp_get_employees_by_salary_level('High');


# 7
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50),word VARCHAR(50))
RETURNS TINYINT
	BEGIN
		DECLARE i INT;
		DECLARE result TINYINT;
		SET i := 1;
		SET result := 1;
		WHILE i <= char_length(word) DO
			IF locate(substr(lower(word),i,1),lower(set_of_letters)) = 0 THEN SET result := 0;
			END IF;
			SET i := i +1;
		END WHILE;
		RETURN result;
	END;

SELECT ufn_is_word_comprised('oistmiahf','Sofia');


# 8
CREATE PROCEDURE usp_get_holders_full_name ()
	BEGIN
		SELECT concat(first_name,' ',last_name) AS 'full_name'
		FROM account_holders
		ORDER BY full_name, id;
	END;

CALL usp_get_holders_full_name();


#9
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (balance_threshold DECIMAL)
	BEGIN
		SELECT ah.first_name,ah.last_name
		FROM account_holders ah
		JOIN accounts a ON ah.id = a.account_holder_id
		GROUP BY a.account_holder_id
		HAVING sum(a.balance) > balance_threshold
		ORDER BY a.id,ah.first_name,ah.last_name;
	END;


CALL usp_get_holders_with_balance_higher_than(7000);


# 10
CREATE FUNCTION ufn_calculate_future_value (sum DOUBLE,interest DOUBLE, years INT)
RETURNS DOUBLE
	BEGIN
		DECLARE result DOUBLE;
		SET result :=  sum * pow(1 + interest,years);
		RETURN result;
	END;

SELECT ufn_calculate_future_value(1000, 0.1, 5);

SELECT ufn_calculate_future_value(1000.55, 0.08, 5);


# 11
CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT, interest_rate DECIMAL(13,4))
	BEGIN
		SELECT  account_id,
		        ah.first_name,
		        ah.last_name,
				a.balance AS 'current_balance',
				round(ufn_calculate_future_value(a.balance,interest_rate,5),4)
				AS 'balance_in_5_years'
		FROM account_holders ah
		JOIN accounts a ON ah.id = a.account_holder_id
		WHERE a.id=account_id;
	END;

CALL usp_calculate_future_value_for_account(1, 0.1);


# 12
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL)
	BEGIN
		START TRANSACTION;
		UPDATE accounts a
		SET a.balance = a.balance + money_amount
		WHERE a.id = account_id;
		IF (SELECT a.balance FROM accounts a WHERE a.id=account_id) >= 0 THEN COMMIT ;
		ELSE
			ROLLBACK ;
		END IF;
	END;


# 13
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(38,4))
	BEGIN
		START TRANSACTION;
			UPDATE accounts a
			SET a.balance = a.balance - money_amount
			WHERE a.id = account_id;
		IF (SELECT a.balance FROM accounts a WHERE a.id=account_id) >= 0 AND money_amount > 0
		THEN  COMMIT ;
		ELSE ROLLBACK ;
		END IF;
	END;


# 14
CREATE PROCEDURE usp_transfer_money (from_account_id INT, to_account_id INT, amount DECIMAL(38,4))
	BEGIN
		START TRANSACTION;
			UPDATE accounts
			SET balance = balance - amount WHERE id = from_account_id;
			UPDATE accounts
			SET balance = balance + amount WHERE id = to_account_id;
			IF (SELECT a.id  FROM accounts a WHERE a.id=from_account_id) IS NOT NULL
				AND
               (SELECT a.id  FROM accounts a WHERE a.id=to_account_id) IS NOT NULL
				AND
				amount>0
				AND
               (SELECT balance FROM accounts WHERE id=from_account_id) >= amount
			THEN COMMIT;
			ELSE ROLLBACK;
			END IF;
	END;

CALL usp_transfer_money(1,2,10);

# 15
CREATE TABLE logs (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
	account_id INT NOT NULL,
	old_sum DECIMAL(38,4),
	new_sum DECIMAL(38,4)
);

CREATE TRIGGER tr_balance_change
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
	VALUES  (OLD.id,OLD.balance,NEW.balance);
END;

# CALL usp_deposit_money(1,10);


# 16
CREATE TABLE notification_emails (
	id INT PRIMARY KEY AUTO_INCREMENT,
	recipient INT NOT NULL,
	subject TEXT,
	body TEXT
);

CREATE TRIGGER tr_logs_insert
	AFTER INSERT ON logs
	FOR EACH ROW
	BEGIN
		INSERT INTO notification_emails(recipient, subject, body)
		VALUES  (
			    NEW.account_id,
			     concat('Balance change for account:', ' ',NEW.account_id),
			     concat('On',' ',
			            DATE_FORMAT(now(),'%b %d %y at %r'),' ',
			            'your balance was changed from',' ',
			            NEW.old_sum,' ',
			            'to',' ',
			            NEW.new_sum,
			            '.'));
	END;
