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
```` yml
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
### Задача 5
````
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.
````
### Задача 6
````
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
Поднимите новый пустой контейнер с PostgreSQL.
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления.
````
