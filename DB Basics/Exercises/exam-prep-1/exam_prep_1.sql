CREATE DATABASE buhtig;

USE buhtig;

# 1
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(30) UNIQUE,
	password VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL
);

CREATE TABLE repositories(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE repositories_contributors(
	repository_id INT ,
	contributor_id INT,
	FOREIGN KEY (repository_id) REFERENCES repositories(id),
	FOREIGN KEY (contributor_id) REFERENCES users(id)
);

CREATE TABLE issues(
	id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(255) NOT NULL,
	issue_status VARCHAR(6) NOT NULL,
	repository_id INT NOT NULL,
	assignee_id INT NOT NULL,
	FOREIGN KEY (repository_id) REFERENCES repositories(id),
	FOREIGN KEY (assignee_id) REFERENCES users(id)
);

CREATE TABLE commits(
	id INT PRIMARY KEY AUTO_INCREMENT,
	message VARCHAR(255) NOT NULL,
	issue_id INT,
	repository_id INT NOT NULL,
	contributor_id INT NOT NULL,
	FOREIGN KEY (issue_id) REFERENCES issues(id),
	FOREIGN KEY (repository_id) REFERENCES repositories(id),
	FOREIGN KEY (contributor_id) REFERENCES users(id)
);

CREATE TABLE files(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	size DECIMAL(10,2) NOT NULL ,
	parent_id INT,
	commit_id INT NOT NULL,
	FOREIGN KEY (parent_id) REFERENCES files(id),
	FOREIGN KEY (commit_id) REFERENCES commits(id)
);


# 2
INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT concat('Critical Problem With ',f.name,'!'),
	   'open',
	   ceil(f.id * 2 / 3),
		c.contributor_id
FROM issues i
RIGHT JOIN commits c ON i.id = c.issue_id
RIGHT JOIN files f ON c.id = f.commit_id
WHERE f.id BETWEEN 46 AND 50;


# 3!!!
INSERT INTO repositories_contributors(contributor_id,repository_id)
SELECT *
FROM (SELECT contributor_id FROM repositories_contributors
     WHERE contributor_id=repository_id) AS t1
CROSS JOIN 
    (SELECT min(r.id) AS repository_id
    FROM repositories r
        LEFT JOIN repositories_contributors rc ON r.id = rc.repository_id
    WHERE rc.repository_id IS NULL) AS t2
WHERE t2.repository_id IS NOT NULL;

SELECT min(r.id)
FROM repositories r
LEFT JOIN repositories_contributors rc ON r.id = rc.repository_id
WHERE rc.repository_id IS NULL;


UPDATE repositories_contributors rc
JOIN repositories r ON rc.repository_id = r.id
JOIN users u ON rc.contributor_id = u.id
SET rc.repository_id = ifnull ((SELECT min(r.id) WHERE u.id IS NULL), rc.repository_id)
WHERE u.id=r.id;
# 4
DELETE repositories
FROM repositories
     LEFT JOIN issues i ON repositories.id = i.repository_id
WHERE i.id IS NULL;

DELETE FROM repositories
WHERE id NOT IN (SELECT repository_id FROM issues);

# 5
SELECT id,username
FROM users
ORDER BY id;

# 6
SELECT repository_id,contributor_id
FROM repositories_contributors
WHERE repository_id=contributor_id
ORDER BY repository_id;

# 7
SELECT id,name,size
FROM files
WHERE size>1000 AND name LIKE '%html%'
ORDER BY size DESC;

#8
SELECT  i.id,
		concat(u.username,' : ',i.title)
		AS 'issue_assignee'
FROM issues i
JOIN users u ON i.assignee_id = u.id
ORDER BY i.id DESC;


# 9
SELECT f1.id,
	   f1.name,
	   concat(f1.size,'KB')
FROM files f1
LEFT JOIN files f2 ON f1.id = f2.parent_id
WHERE f2.parent_id IS NULL
ORDER BY f1.id;

# doesn't work?
SELECT f.id,
	   f.name,
	   concat(f.size,'KB')
FROM files f
WHERE f.id NOT IN (SELECT DISTINCT parent_id FROM files)
ORDER BY f.id;


# 10
SELECT r.id,
	   r.name,
	   count(i.id) AS 'issues'
FROM repositories r
JOIN issues i ON r.id = i.repository_id
GROUP BY i.repository_id
ORDER BY issues DESC ,i.repository_id
LIMIT 5;

SELECT i.repository_id,count(i.id)
FROM issues i
GROUP BY i.repository_id;

# 11
SELECT  r.id,
	   r.name,
	   count(DISTINCT c.id) AS 'commits',
	   count(DISTINCT u.id) AS 'contributors'
FROM users u
     JOIN repositories_contributors rc ON rc.contributor_id = u.id
     JOIN repositories r ON rc.repository_id = r.id
     JOIN commits c ON r.id = c.repository_id
GROUP BY r.id
ORDER BY contributors DESC,r.id
LIMIT 1;


SELECT *
FROM users u
     JOIN repositories_contributors rc ON rc.contributor_id = u.id
     JOIN repositories r ON rc.repository_id = r.id
	 JOIN commits c ON r.id = c.repository_id;

# HAVING contributors = (
# 				    SELECT count(DISTINCT rc1.contributor_id) AS 'contributors1'
# 				    FROM repositories_contributors rc1
# 				      JOIN repositories r1 ON rc1.repository_id = r1.id
# 				      JOIN users u1 ON rc1.contributor_id = u1.id
# 				      JOIN commits c1 ON r1.id = c1.repository_id
# 					GROUP BY rc1.repository_id
# 					ORDER BY contributors1 DESC
# 					LIMIT 1)

# 12!!!
SELECT u.id,
	   u.username,
	   count(c.id) AS 'commits'
FROM users u
    LEFT JOIN issues i ON u.id = i.assignee_id
    LEFT JOIN commits c ON i.id = c.issue_id AND c.contributor_id=u.id #!!!
GROUP BY u.id
ORDER BY commits DESC ,u.id;


SELECT u.id,
	   u.username,
	   (SELECT count(c.id)
	    FROM commits c
	         JOIN issues i
		         ON c.issue_id = i.id
	    WHERE c.contributor_id= u.id AND i.assignee_id = u.id)
		   AS 'commits'
FROM users u
ORDER BY commits DESC ,u.id;

# 13!!!
SELECT left(f1.name, locate('.',f1.name)-1) AS 'file',
	   (SELECT count(id) FROM commits
	    WHERE locate(f1.name,message) >0) AS 'recursive_count'
FROM files f1
JOIN files f2 ON f1.id = f2.parent_id AND f1.id != f2.id
JOIN commits c ON f1.commit_id=c.id
WHERE f1.parent_id = f2.id AND f2.parent_id=f1.id
ORDER BY file;

SELECT left(f1.name, locate('.',f1.name)-1) AS 'file',
	   count(c.id) AS 'recursive_count'
FROM files f1
     JOIN files f2 ON f1.id = f2.parent_id AND f1.id != f2.id
     LEFT JOIN commits c ON locate(f1.name,message) >0
WHERE f1.parent_id = f2.id AND f2.parent_id=f1.id
GROUP BY f1.id
ORDER BY file;




# 14!!!
# select *
SELECT r.id,
	   r.name,
	   count(DISTINCT c.contributor_id)  AS 'users' #!!!
FROM repositories r
     LEFT JOIN commits c ON r.id = c.repository_id
GROUP BY r.id
ORDER BY users DESC,r.id;


# !!!
CREATE PROCEDURE udp_commit (username VARCHAR(30),password VARCHAR(30),
							message VARCHAR(255),issue_id INT)
BEGIN
	DECLARE user_id INT;
	DECLARE repository_id INT;
	SET user_id := (SELECT u.id FROM users u WHERE u.username=username);
	SET repository_id := (SELECT i.repository_id
	                     FROM issues i
	                     WHERE i.id = issue_id);

# 	CASE
# 	WHEN username NOT IN (SELECT users.username FROM users)
# 	THEN  #(SELECT 'Error code 45000. No such user!');
# 		SIGNAL SQLSTATE '45000'
# 		SET MESSAGE_TEXT  = 'No such user!';
# 	WHEN password NOT IN (SELECT users.password FROM users)
# 	THEN  #(SELECT 'Error code 45000. Password is incorrect!');
# 		SIGNAL SQLSTATE '45000'
# 		SET MESSAGE_TEXT  = 'Password is incorrect!';
# 	WHEN issue_id NOT IN (SELECT issues.id FROM issues)
# 	THEN  #(SELECT 'Error code 45000. The issue does not exist!');
# 		SIGNAL SQLSTATE '45000'
# 		SET MESSAGE_TEXT  = 'The issue does not exist!';
# 	ELSE
# 		INSERT INTO commits(message,issue_id,repository_id,contributor_id)
# 		VALUES
# 			   (message,issue_id,repository_id,user_id);
# 		UPDATE issues
# 		SET issue_status = 'closed'
# 		WHERE id = issue_id;
# 	END CASE;
	
	IF  1 <> (SELECT count(*) FROM users WHERE users.username = username)
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT  = 'No such user!';
	ELSEIF  1 <> (SELECT count(*) FROM users WHERE users.password = password)
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT  = 'Password is incorrect!';
	ELSEIF  1 <> (SELECT count(*) FROM issues WHERE issues.id = issue_id)
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT  = 'The issue does not exist!';
	ELSE
		INSERT INTO commits(message,issue_id,repository_id,contributor_id)
		VALUES
			   (message,issue_id,repository_id,user_id);
		UPDATE issues
			SET issue_status = 'closed'
				WHERE id = issue_id;
	END IF;
END;

CALL udp_commit('WhoDenoteBel','ajmISQi*',
                'Fixed issue: Invalid welcoming message in READ.HTML',2);

SELECT u.id,u.username,i.id,i.title,i.repository_id,c.id,c.message,c.repository_id
FROM users u
JOIN issues i ON u.id = i.assignee_id
JOIN commits c ON i.id = c.issue_id;


# 16
CREATE PROCEDURE udp_findbyextension (extension VARCHAR(100))
BEGIN
	SELECT f.id,
		   f.name,
		   concat(f.size,'KB') AS 'size'
	FROM files f
		WHERE f.name LIKE concat('%.',extension)
	ORDER BY f.id;
END;

CALL udp_findbyextension('html');
