CREATE DATABASE test_db;
CREATE ROLE test_admin_user WITH LOGIN PASSWORD 'testadm';
-- ALTER USER test_admin_user WITH encrypted PASSWORD 'arsadmin';
--CREATE DATABASE test_db;
--OWNER test_admin_user;

--EXEC SQL CONNECT TO test_db USER test_admin_user;
\c test_db;
GRANT ALL PRIVILEGES ON DATABASE test_db TO test_admin_user;
--ALTER DATABASE test_db OWNER TO test_admin_user;
-- SET CONNECTION
--OWNER TO test_admin_user;
--GRANT SELECT, INSERT, UPDATE, DELETE ON test_db TO test_simple_user;
CREATE TABLE orders (
	id  		integer PRIMARY KEY,
	Наименование 	varchar(40),
	Цена		integer
);
CREATE TABLE clients (
	id integer PRIMARY KEY,
	Фамилия varchar(40),
	Страна_проживания varchar(40),
        Заказ integer,
	FOREIGN KEY (Заказ) REFERENCES orders(id)
);

CREATE USER test_simple_user WITH  PASSWORD 'testsimple';
GRANT SELECT, INSERT, UPDATE ON orders, clients TO test_simple_user;
