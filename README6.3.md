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
````bash
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 10
    -> ATTRIBUTE '{"FName": "Pretty", "SName": "James"}';
Query OK, 0 rows affected (0.18 sec)

mysql> grant select on msql_db.* to 'test'@'localhost'
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.03 sec)
mysql> flush privileges;
 
 mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"FName": "Pretty", "SName": "James"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
````

### Задача 3
````
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
    на MyISAM
    на InnoDB
````
````bash
mysql> SHOW PROFILES;
+----------+------------+--------------------------+
| Query_ID | Duration   | Query                    |
+----------+------------+--------------------------+
|        1 | 0.00174800 | DROP TABLE IF EXISTS t1  |
|        2 | 0.22693225 | CREATE TABLE T1 (id INT) |
|        3 | 0.00009400 | SET profiling = 1        |
+----------+------------+--------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
9 rows in set (0.04 sec)


mysql> show table status\G;
*************************** 1. row ***************************
           Name: T1
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 0
 Avg_row_length: 0
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: NULL
    Create_time: 2022-01-18 15:13:21
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options:
        Comment:
*************************** 2. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 2
 Avg_row_length: 8192
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-01-15 22:08:16
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options:
        Comment:
2 rows in set (0.02 sec)

mysql> show profiles;
+----------+------------+--------------------------+
| Query_ID | Duration   | Query                    |
+----------+------------+--------------------------+
|        1 | 0.00174800 | DROP TABLE IF EXISTS t1  |
|        2 | 0.22693225 | CREATE TABLE T1 (id INT) |
|        3 | 0.00009400 | SET profiling = 1        |
|        4 | 0.03263600 | show engines             |
|        5 | 0.00005475 | show msql_db status      |
|        6 | 0.00005025 | show msql_db status      |
|        7 | 0.00005200 | show mysql_db status     |
|        8 | 0.00005350 | show mysql_db status     |
|        9 | 0.00005400 | show msql_db status      |
|       10 | 0.02557625 | show table status        |
+----------+------------+--------------------------+
10 rows in set, 1 warning (0.00 sec)

mysql> ALTER TABLE msql_db.T1 engine=myisam;
Query OK, 0 rows affected (0.22 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE msql_db.orders engine=myisam;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+------------------------------------------+
| Query_ID | Duration   | Query                                    |
+----------+------------+------------------------------------------+
|       23 | 0.00004725 | ALTER TABLE msql_db.* engine="MyISAM"    |
|       24 | 0.00004825 | ALTER TABLE msql_db.* engine=MyISAM      |
|       25 | 0.00004875 | ALTER TABLE mysql_db.* engine=MyISAM     |
|       26 | 0.00005150 | ALTER TABLE msql_db.* engine=myisam      |
|       27 | 0.00011725 | SELECT DATABASE()                        |
|       28 | 0.00005100 | ALTER TABLE msql_db.* engine=myisam      |
|       29 | 0.00004450 | ALTER TABLE *.* engine=myisam            |
|       30 | 0.00042925 | ALTER TABLE msql_db engine=myisam        |
|       31 | 0.00058525 | ALTER TABLE msql_db.t1 engine=myisam     |
|       32 | 0.22254150 | ALTER TABLE msql_db.T1 engine=myisam     |
|       33 | 0.11624750 | ALTER TABLE msql_db.orders engine=myisam |
|       34 | 0.17271500 | START SLAVE                              |
|       35 | 0.00025550 | START SLAVE                              |
|       36 | 0.00023875 | START SLAVE                              |
|       37 | 0.00028400 | START REPLICA                            |
+----------+------------+------------------------------------------+
15 rows in set, 1 warning (0.00 sec)
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
