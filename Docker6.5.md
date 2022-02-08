  ````bash
  854  sudo docker build -t linux/elastic .
  855  sudo docker images
  856  sudo docker run -it --name elastic-serv -d 9d3f81fb8406
  857  sudo docker ps
  858  sudo docker exec -it elastic-serv bash
  
  
  989  sudo docker ps -a
  990  sudo docker stop elastic-serv
  991  sudo docker stop elastic-serv1
  
  1002  sudo docker system prune -a
