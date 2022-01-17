## Домашнее задание к занятию "6.3. MySQL"

### Задача 1
````
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
Изучите бэкап БД и восстановитесь из него.
Перейдите в управляющую консоль mysql внутри контейнера.
Используя команду \h получите список управляющих команд.
Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
Приведите в ответе количество записей с price > 300.
```` 
````bash
vagrant@netology1:~/docmysql$ sudo docker exec -it doc_mysql_db bash

root@840ca3f3429c:/mnt/msqlback# mysqldump -uroot -pmadm  msql_db > /mnt/msqlback/msql_db_bak.sql
root@840ca3f3429c:/# mysqldump -u root -p  msql_db >/mnt/msqlback/msql_db_bak.sql

Enter password:
root@840ca3f3429c:/# mysqladmin -u root -p create  msql1
root@840ca3f3429c:/# mysql -u root -p  msql1 < /mnt/msqlback/msql_db_bak.sql

vagrant@netology1:~/docmysql$ sudo docker exec -it doc_mysql_db bash
root@840ca3f3429c:/# mysql -u root -
mysql   -> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          25
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.27 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 2 hours 5 min 37 sec

Threads: 4  Questions: 229  Slow queries: 0  Opens: 439  Flush tables: 3  Open tables: 358  Queries per second avg: 0.030
--------------
mysql> use msql_db;
Database changed
mysql> show tables;
+-------------------+
| Tables_in_msql_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select * from orders where price>300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.03 sec)

````
````
### Задача 2
````
Создайте пользователя test в БД c паролем test-pass, используя:
плагин авторизации mysql_native_password
    срок истечения пароля - 180 дней
    количество попыток авторизации - 3
    максимальное количество запросов в час - 100
    аттрибуты пользователя:
        Фамилия "Pretty"
        Имя "James"
Предоставьте привелегии пользователю test на операции SELECT базы test_db.
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
````
````
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'new_password'
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 100;
Query OK, 0 rows affected (0.18 sec)

CREATE USER 'jim'@'localhost'
    ATTRIBUTE '{"fname": "James", "lname": "Scott", "phone": "123-456-7890"}';

mysql> grant select on msql_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)

UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';
````

### Задача 3
````
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
    на MyISAM
    на InnoDB
````
````
````
### Задача 4
````
Изучите файл my.cnf в директории /etc/mysql.
Измените его согласно ТЗ (движок InnoDB):
    Скорость IO важнее сохранности данных
    Нужна компрессия таблиц для экономии места на диске
    Размер буффера с незакомиченными транзакциями 1 Мб
    Буффер кеширования 30% от ОЗУ
    Размер файла логов операций 100 Мб
Приведите в ответе измененный файл my.cnf.
````
````
````
