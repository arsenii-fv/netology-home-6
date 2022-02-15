## Домашнее задание к занятию "6.5. Elasticsearch"
### Задача 1
````
В этом задании вы потренируетесь в:
    установке elasticsearch
    первоначальном конфигурировании elastcisearch
    запуске elasticsearch в docker
Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:
    составьте Dockerfile-манифест для elasticsearch
    соберите docker-образ и сделайте push в ваш docker.io репозиторий
    запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины
Требования к elasticsearch.yml:
    данные path должны сохраняться в /var/lib
    имя ноды должно быть netology_test
В ответе приведите:
    текст Dockerfile манифеста
    ссылку на образ в репозитории dockerhub
    ответ elasticsearch на запрос пути / в json виде
   Подсказки:
    возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
    при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
    при некоторых проблемах вам поможет docker директива ulimit
    elasticsearch в логах обычно описывает проблему и пути ее решения
````
````bash

FROM centos:centos7
RUN yum -y update &&\
    yum -y upgrade &&\
    yum clean all
RUN yum -y install wget
RUN yum install -y perl-Digest-SHA
RUN yum install -y mc &&\
    yum install -y java-1.8.0-openjdk.x86_64
RUN yum clean all

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512
RUN shasum -a 512 -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512
RUN tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz
RUN rm elasticsearch-7.17.0-linux-x86_64.tar.gz &&\
    cd elasticsearch-7.17.0
RUN mkdir -p /var/lib/elasticsearch/data
RUN mkdir -p /var/lib/elasticsearch/logs
ADD elasticsearch.yml /elasticsearch-7.17.0/config/elasticsearch.yml
RUN groupadd elasticsearch
RUN useradd elastic -g elasticsearch -p elastic
RUN chown -R elastic:elasticsearch /elasticsearch-7.17.0
RUN chown -R elastic:elasticsearch /var/lib/elasticsearch/
#USER elastic
#RUN  ./elasticsearch-7.17.0/bin/elasticsearch -d -p pid
#USER root
# - 9200: HTTP
EXPOSE 9200
CMD ["/bin/bash"]
# - 9300: transport
EXPOSE 9300

[elastic@b55bac9a6297 bin]$ curl "http://localhost:9200"
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "_na_",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

````
### Задача 2
````
В этом задании вы научитесь:
    создавать и удалять индексы
    изучать состояние кластера
    обосновывать причину деградации доступности данных
Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:
Имя 	Количество реплик 	Количество шард
ind-1 	      0 	              1
ind-2         1                   2
ind-3 	      2                   4
Получите список индексов и их статусов, используя API и приведите в ответе на задание.
Получите состояние кластера elasticsearch, используя API.
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
Удалите все индексы.
Важно
При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
```` 
````

````
### Задача 3
````
В данном задании вы научитесь:
    создавать бэкапы данных
    восстанавливать индексы из бэкапов
Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.
Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
Приведите в ответе запрос API и результат вызова API для создания репозитория.
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
Создайте snapshot состояния кластера elasticsearch.
Приведите в ответе список файлов в директории со snapshotами.
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
Приведите в ответе запрос к API восстановления и итоговый список индексов.
Подсказки:
   возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch
````
````
````
