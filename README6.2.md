## Домашнее задание к занятию "6.2. SQL"
### Задача 1
````
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.
````
```` yaml
version: '3.3'
volumes:
  pgdata: {}
  pgback: {}
  pgadmin:
services:
  postgres:
    image: postgres:12
    restart: always
    environment:
            POSTGRES_USER: superadmin
            POSTGRES_PASSWORD: sadm
            POSTGRES_DB: sup_db
            PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
          - "./pgdata:/var/lib/postgresql/data/pgdata"
          - "./test_db.sql:/docker-entrypoint-initdb.d/test_db.sql"
    ports:
          - "5432:5432"
  pgadmin:
    image: dpage/pgadmin4:5.5
    environment:
           PGADMIN_DEFAULT_EMAIL: ars@ars.com
           PGADMIN_DEFAULT_PASSWORD: pgadmin
           PGADMIN_LISTEN_PORT: 8080
    volumes:
         - "./pgadmin:/root/.pgadmin"
    ports:
            - "8080:8080"
    restart: always
````

### Задача 2
````
В БД из задачи 1:
    создайте пользователя test-admin-user и БД test_db
    в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
    предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    создайте пользователя test-simple-user
    предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
Таблица orders:
    id (serial primary key)
    наименование (string)
    цена (integer)
Таблица clients:
    id (serial primary key)
    фамилия (string)
    страна проживания (string, index)
    заказ (foreign key orders)
Приведите:
    итоговый список БД после выполнения пунктов выше,
    описание таблиц (describe)
    SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
    список пользователей с правами над таблицами test_db
````
```` sql
file test_db.sql
CREATE DATABASE test_db;
CREATE ROLE test_admin_user WITH LOGIN PASSWORD 'testadm';
\c test_db;
GRANT ALL PRIVILEGES ON DATABASE test_db TO test_admin_user;
CREATE TABLE orders (
        id              integer PRIMARY KEY,
        Наименование    varchar(40),
        Цена            integer );
CREATE TABLE clients (
        id integer PRIMARY KEY,
        Фамилия varchar(40),
        Страна_проживания varchar(40),
        Заказ integer,
        FOREIGN KEY (Заказ) REFERENCES orders(id));
CREATE USER test_simple_user WITH  PASSWORD 'testsimple';
GRANT SELECT, INSERT, UPDATE ON orders, clients TO test_simple_user;

postgres, sup_db, test_db

select column_name, data_type, character_maximum_length, column_default, is_nullable
from INFORMATION_SCHEMA.COLUMNS where table_name = 'clients';

SELECT * FROM information_schema.table_privileges WHERE grantee='test_simple_user'  LIMIT 10;
````

### Задача 3
````
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
Таблица orders
Наименование 	цена
Шоколад 	10
Принтер 	3000
Книга 	500
Монитор 	7000
Гитара 	4000
Таблица clients
ФИО 	Страна проживания
Иванов Иван Иванович 	USA
Петров Петр Петрович 	Canada
Иоганн Себастьян Бах 	Japan
Ронни Джеймс Дио 	Russia
Ritchie Blackmore 	Russia
Используя SQL синтаксис:
    вычислите количество записей для каждой таблицы
    приведите в ответе:
        запросы
        результаты их выполнения.
````
````
select count(*) from clients;
5
select count(*) from orders;
5
````
### Задача 4
````
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
Используя foreign keys свяжите записи из таблиц, согласно таблице:
ФИО 	Заказ
Иванов Иван Иванович 	Книга
Петров Петр Петрович 	Монитор
Иоганн Себастьян Бах 	Гитара
Приведите SQL-запросы для выполнения данных операций.
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
Подсказк - используйте директиву UPDATE.
````
````sql
INSERT INTO orders VALUES
 (1, 'Шоколад', '10' ),
 (2, 'Принтер', '3000'),
 (3, 'Книга','500'),
 (4, 'Монитор','7000'),
 (5, 'Гитара','4000');

INSERT INTO clients VALUES
 (1, 'Иванов Иван Иванович', 'USA', 3),
 (2, 'Петров Петр Петрович', 'Canada', '4'),
 (3, 'Иоганн Себастьян Бах', 'Japan', '5'),
 (4, 'Ронни Джеймс Дио', 'Russia', null),
 (5, 'Ritchie Blackmore', 'Russia', null);
 
 sudo  docker exec -i dockercom_postgres_1 psql -Usuperadmin test_db < data.sql
 
 select * from clients, orders where clients.Заказ=orders.id;
 select * from clients WHERE Заказ is not null ;

````
### Задача 5
````
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.
````
````sql
explain analyze  select * from clients, orders where clients.Заказ=orders.id;

Hash Join  (cost=23.50..37.93 rows=350 width=310) (actual time=19.725..19.728 rows=3 loops=1)
 Hash Cond: (clients."Заказ" = orders.id)
  ->  Seq Scan on clients  (cost=0.00..13.50 rows=350 width=204) (actual time=0.529..0.530 rows=5 loops=1)
  ->  Hash  (cost=16.00..16.00 rows=600 width=106) (actual time=19.186..19.187 rows=5 loops=1)
 Buckets: 1024  Batches: 1  Memory Usage: 9kB 
  ->  Seq Scan on orders  (cost=0.00..16.00 rows=600 width=106) (actual time=19.177..19.179 rows=5 loops=1)
 Planning Time: 0.084 ms       
 Execution Time: 19.746 ms
Hash Join - построение хэш таблицы
coast - затраты на каждый узел плана , начальные и конечные.
Seq Scan - последовательное, блок за блоком, чтение данных таблицы
loops - сколько раз пришлось выполнить операцию Seq Scan
rows - количество строк
width - размер строки в байтах
````
### Задача 6
````
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
Поднимите новый пустой контейнер с PostgreSQL.
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления.
````
````yml
sudo  docker exec -i dockercom_postgres_1 pg_dump -U superadmin -d test_db > pgback/test_db_bak.sql
sudo  docker-compose stop
sudo  docker-compose -f docker-com-1.yml up -d
sudo  docker exec -i docker_postgres2 psql -U superadmin sup_db < pgback/test_db_bak.sql

version: '3.3' #docker-com-1.yml
volumes:
  pgdata2: {}
  pgback: {}
  pgadmin2:
services:
  postgres:
    container_name: docker_postgres2
    image: postgres:14
    restart: always
    environment:
            POSTGRES_USER: superadmin
            POSTGRES_PASSWORD: sadm
            POSTGRES_DB: sup_db
            PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
          - "./pgdata2:/var/lib/postgresql/data/pgdata"
    ports:
          - "5432:5432"
  pgadmin:
    image: dpage/pgadmin4:5.5
    environment:
           PGADMIN_DEFAULT_EMAIL: ars@ars.com
           PGADMIN_DEFAULT_PASSWORD: pgadmin
           PGADMIN_LISTEN_PORT: 8080
    volumes:
         - "./pgadmin2:/root/.pgadmin"
    ports:
            - "8080:8080"
    restart: always

````
