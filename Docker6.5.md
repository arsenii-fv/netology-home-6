  ````bash
  854  sudo docker build -t linux/elastic .
  855  sudo docker images
  856  sudo docker run -it --name elastic-serv -d 9d3f81fb8406
  857  sudo docker ps
  858  sudo docker exec -it elastic-serv bash
  
  
  989  sudo docker ps -a
  990  sudo docker stop elastic-serv
  991  sudo docker stop elastic-serv1
  
  1002  sudo docker system prune -a # Удаление запущенных и остановленных контейнеров
  
  vagrant@netology1:~/docelastic$ sudo docker run -it --name elastic-serv --ulimit nofile=65000:65000 -d 48217ec9cd25 bash
64a98971875aa0de70a588d5b3fe39335b914a084c202454c0776b74d3a2c0dc
vagrant@netology1:~/docelastic$ sudo docker exec -it elastic-serv bash


sudo docker run -it --name elastic-serv4 --ulimit nofile=65535:65535 -d 33e8561ccd34 bash

[elastic@b55bac9a6297 bin]$ ./elasticsearch -d -p pid # execute elasticksearch

sudo sysctl -w vm.max_map_count=262144 5

vagrant@netology1:~/docelastic$ sudo sysctl -w vm.max_map_count=262145

curl -XPUT 'localhost:9200/_template/template_1' \
  -H 'Content-Type: application/json' \
  -d '**your query**'

vagrant@netology1:~/docelastic$ sudo docker start d26cf473ecd9
[elastic@d26cf473ecd9 bin]$ curl -XPUT 'http://localhost:9200/ind-1' \
> -H 'Content-Type: application/json' \
> -d '{
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
>       "number_of_replicas": 0
>     }
>   }
> }'

[elastic@038b23e6a2a0 bin]$ curl -XPUT 'http://localhost:9200/test' \
> -H 'Content-Type: application/json' \
> -d '{
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
>       "number_of_replicas": 0
>     }
>    }
> }'
