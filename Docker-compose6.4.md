version: '3.3'
volumes:
  pgdata_t:
  pgdata: {}
  pgback: {}
  #  pgadmin:
services:

  postgres:
    container_name: postgres_test
    image: postgres:13
    restart: always
    environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: sadm
            POSTGRES_DB: sup_db
            PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
          - "./pgdata:/var/lib/postgresql/data/pgdata"
          - "./pgdata:/docker-entrypoint-initdb.d"
            #  - "./test_db.sql:/docker-entrypoint-initdb.d/test_db.sql"
            # - "./data.sql:docker-entrypoint-initdb.d/data.sql"
          - "./pgdata_t:/mnt"
          - "./pgback:/opt/pgback"
    ports:
          - "5432:5432"
            #  pgadmin:
            #    image: dpage/pgadmin4:5.5
            #    environment:
            #           PGADMIN_DEFAULT_EMAIL: ars@ars.com
