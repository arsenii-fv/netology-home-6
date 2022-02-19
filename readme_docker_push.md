Pro tip

You can push a new image to this repository using the CLI
    
    docker tag local-image:tagname new-repo:tagname
    docker push new-repo:tagname

Make sure to change tagname with your desired image repository tag.

vagrant@netology1:~/docelastic$ sudo docker tag 722b40f043b6 arseniidoc/netology-home5:elastic

vagrant@netology1:~/docelastic$ sudo docker image  ls
REPOSITORY                  TAG       IMAGE ID       CREATED        SIZE
linux/elastic               latest    722b40f043b6   3 hours ago    2.24GB
arseniidoc/netology-home5   elastic   722b40f043b6   3 hours ago    2.24GB
elasticsearch/doc           ver3.1    722b40f043b6   3 hours ago    2.24GB
centos                      centos7   eeb6ee3f44bd   5 months ago   204MB
vagrant@netology1:~/docelastic$
vagrant@netology1:~/docelastic$ sudo docker push arseniidoc/netology-home5:elastic
