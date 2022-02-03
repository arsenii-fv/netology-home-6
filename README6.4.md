## Домашнее задание к занятию "6.4. PostgreSQL"
### Задача 1
````
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
Подключитесь к БД PostgreSQL используя psql.
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
Найдите и приведите управляющие команды для:
    вывода списка БД
    подключения к БД
    вывода списка таблиц
    вывода описания содержимого таблиц
    выхода из psql
````
````bash
sup_db-# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 postgres  | sadm  | UTF8     | en_US.utf8 | en_US.utf8 |
 sup_db    | sadm  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | sadm  | UTF8     | en_US.utf8 | en_US.utf8 | =c/sadm          +
           |       |          |            |            | sadm=CTc/sadm
 template1 | sadm  | UTF8     | en_US.utf8 | en_US.utf8 | =c/sadm          +
           |       |          |            |            | sadm=CTc/sadm
(4 rows)

sup_db-# \c postgres
You are now connected to database "postgres" as user "sadm".

postgres-# \dt *
                  List of relations
   Schema   |          Name           | Type  | Owner
------------+-------------------------+-------+-------
 pg_catalog | pg_aggregate            | table | sadm
 pg_catalog | pg_am                   | table | sadm
 pg_catalog | pg_amop                 | table | sadm
 pg_catalog | pg_amproc               | table | sadm
 pg_catalog | pg_attrdef              | table | sadm
 pg_catalog | pg_attribute            | table | sadm
 pg_catalog | pg_auth_members         | table | sadm
 pg_catalog | pg_authid               | table | sadm
 pg_catalog | pg_cast                 | table | sadm
 pg_catalog | pg_class                | table | sadm
 pg_catalog | pg_collation            | table | sadm
 pg_catalog | pg_constraint           | table | sadm
 pg_catalog | pg_conversion           | table | sadm
 pg_catalog | pg_database             | table | sadm
 pg_catalog | pg_db_role_setting      | table | sadm
 pg_catalog | pg_default_acl          | table | sadm
 pg_catalog | pg_depend               | table | sadm
 pg_catalog | pg_description          | table | sadm
 pg_catalog | pg_enum                 | table | sadm
 pg_catalog | pg_event_trigger        | table | sadm
 pg_catalog | pg_extension            | table | sadm
 pg_catalog | pg_foreign_data_wrapper | table | sadm
 pg_catalog | pg_foreign_server       | table | sadm
 pg_catalog | pg_foreign_table        | table | sadm
 pg_catalog | pg_index                | table | sadm
 pg_catalog | pg_inherits             | table | sadm
 pg_catalog | pg_init_privs           | table | sadm
 pg_catalog | pg_language             | table | sadm
 pg_catalog | pg_largeobject          | table | sadm
 pg_catalog | pg_largeobject_metadata | table | sadm
 pg_catalog | pg_namespace            | table | sadm
 pg_catalog | pg_opclass              | table | sadm
 pg_catalog | pg_operator             | table | sadm
 pg_catalog | pg_opfamily             | table | sadm
 pg_catalog | pg_partitioned_table    | table | sadm
 pg_catalog | pg_policy               | table | sadm
 pg_catalog | pg_proc                 | table | sadm
 pg_catalog | pg_publication          | table | sadm
 pg_catalog | pg_publication_rel      | table | sadm
 pg_catalog | pg_range                | table | sadm
 pg_catalog | pg_replication_origin   | table | sadm
 pg_catalog | pg_rewrite              | table | sadm
 pg_catalog | pg_seclabel             | table | sadm
 pg_catalog | pg_sequence             | table | sadm
 pg_catalog | pg_shdepend             | table | sadm
 pg_catalog | pg_shdescription        | table | sadm
 pg_catalog | pg_shseclabel           | table | sadm
 pg_catalog | pg_statistic            | table | sadm
 pg_catalog | pg_statistic_ext        | table | sadm
 pg_catalog | pg_statistic_ext_data   | table | sadm
 pg_catalog | pg_subscription         | table | sadm
 pg_catalog | pg_subscription_rel     | table | sadm
 pg_catalog | pg_tablespace           | table | sadm
 pg_catalog | pg_transform            | table | sadm
 pg_catalog | pg_trigger              | table | sadm
 pg_catalog | pg_ts_config            | table | sadm
 pg_catalog | pg_ts_config_map        | table | sadm
 pg_catalog | pg_ts_dict              | table | sadm
 pg_catalog | pg_ts_parser            | table | sadm
 pg_catalog | pg_ts_template          | table | sadm
 pg_catalog | pg_type                 | table | sadm
 pg_catalog | pg_user_mapping         | table | sadm
(62 rows)

postgres-# \d+ pg_views
                         View "pg_catalog.pg_views"
   Column   | Type | Collation | Nullable | Default | Storage  | Description
------------+------+-----------+----------+---------+----------+-------------
 schemaname | name |           |          |         | plain    |
 viewname   | name |           |          |         | plain    |
 viewowner  | name |           |          |         | plain    |
 definition | text |           |          |         | extended |
View definition:
 SELECT n.nspname AS schemaname,
    c.relname AS viewname,
    pg_get_userbyid(c.relowner) AS viewowner,
    pg_get_viewdef(c.oid) AS definition
   FROM pg_class c
     LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'v'::"char";

postgres-# \q
root@0a90df7b4d88:/#
````
### Задача 2
````
Используя psql создайте БД test_database.
Изучите бэкап БД.
Восстановите бэкап БД в test_database.
Перейдите в управляющую консоль psql внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.
````
````bash
vagrant@netology1:~/docpsql$ sudo docker exec -it postgres_test bash
root@a7a0f9513b9b:/# psql -U postgres -d sup_db
psql (13.5 (Debian 13.5-1.pgdg110+1))
Type "help" for help.

sup_db=# CREATE DATABASE test_database;
CREATE DATABASE
sup_db=# CREATE DATABASE test_database;
CREATE DATABASE
sup_db=# \c test_database;
You are now connected to database "test_database" as user "sadm".
test_database=# \q
root@6042df0cf293:/mnt# psql -U sadm test_database < /mnt/test_dump.sql

test_database=# analyze orders;
ANALYZE
test_database=# SELECT * FROM pg_stats where tablename='orders';
-[ RECORD 1 ]----------+-----------------------------------------------------------------------------------------------------------------------------------------
---------
schemaname             | public
tablename              | orders
attname                | id
inherited              | f
null_frac              | 0
avg_width              | 4
n_distinct             | -1
most_common_vals       |
most_common_freqs      |
histogram_bounds       | {1,2,3,4,5,6,7,8}
correlation            | 1
most_common_elems      |
most_common_elem_freqs |
elem_count_histogram   |
-[ RECORD 2 ]----------+-----------------------------------------------------------------------------------------------------------------------------------------
---------
schemaname             | public
tablename              | orders
attname                | title
inherited              | f
null_frac              | 0
avg_width              | 16
n_distinct             | -1
most_common_vals       |
most_common_freqs      |
histogram_bounds       | {"Adventure psql time",Dbiezdmin,"Log gossips","Me and my bash-pet","My little database","Server gravity falls","WAL never lies","War an
d peace"}
correlation            | -0.3809524
most_common_elems      |
most_common_elem_freqs |
elem_count_histogram   |
-[ RECORD 3 ]----------+-----------------------------------------------------------------------------------------------------------------------------------------
---------
schemaname             | public
tablename              | orders
attname                | price
inherited              | f
null_frac              | 0
avg_width              | 4
n_distinct             | -0.875
most_common_vals       | {300}
most_common_freqs      | {0.25}
histogram_bounds       | {100,123,499,500,501,900}
correlation            | 0.5952381
most_common_elems      |
most_common_elem_freqs |
elem_count_histogram   |

test_database=#
Столбец title
Средняя ширина 16 байт

````
### Задача 3
````
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
Предложите SQL-транзакцию для проведения данной операции.
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
````
````
````
### Задача 4
````
Используя утилиту pg_dump создайте бекап БД test_database.
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
````
````
````
