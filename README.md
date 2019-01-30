# blocksci-docker
Docker file for citp/BlockSci
Even though there is a ready AMI for AWS, you might already have access to some infrastructure already. 

### IMPORTANT: 
Ideally build on machine, where you will run the container. Else you may run into problems when running blocksci (e.g. illegal instruction).
2nd option is to run the container and make/install blocksci inside of it.

### Instructions:
*  Compiling needs lots of ressources, don't forget to assign your containers enough ressources (on windows)
*  run with: 

    ```docker run -dti -p 8888:8888 --name=logtest priordice/blocksci:tagname```
   
*  check log for jupyter notebook token: 
    
    ```docker logs logtest```
    
*   open http://localhost:8888 and enter token
*    dockerfile does not mount any (persistent) local volume (yet), you'll need that for the blockparser. Just modify the dockerfile or add it when starting the container


