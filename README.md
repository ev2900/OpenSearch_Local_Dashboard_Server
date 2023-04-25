# OpenSearch Local Hosted Dashboard Server

You can connect a locally hosted OpenSearch dashboard server to an Amazon OpenSearch hosted domain. 

Amazon OpenSearch managed services provides an OpenSearch dashboard as part of a domain deployment. For various reasons you may choose to host your own dashboard server and then connect it to your OpenSearch domain. Instead of using the OpenSearch dashboard provided with Amazon OpenSearch managed service.

The instructions in the repository will provide direction to host a local OpenSearch hosted dashboard server with an Amazon OpenSearch domain

## Hosting OpenSearch dashboard server via. Docker on Linux without SSL

These instructions will help you install and run a OpenSearch dashboard server as a docker container on a Linux machine. The docker container is configured in the simplest configuration without SSL

1. Install Docker 

    Install Docker following the instructions in the [install docker engine documentation](https://docs.docker.com/engine/install/) 
    
2. Update the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) 
    
    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```

    You may need 
    
3. Run the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) file start the docker container by running ```docker-compose up -f  <path_to_docker_console_simple>```
