# OpenSearch Local Hosted Dashboard Server

You can connect a locally hosted OpenSearch dashboard server to an Amazon OpenSearch hosted domain. 

Amazon OpenSearch managed services provides an OpenSearch dashboard as part of a domain deployment. For various reasons you may choose to host your own dashboard server and then connect it to your OpenSearch domain. Instead of using the OpenSearch dashboard provided with Amazon OpenSearch managed service.

The instructions in the repository will provide direction to host a local OpenSearch hosted dashboard server with an Amazon OpenSearch domain

## Hosting OpenSearch dashboard server via. Docker on Linux without SSL

These instructions will help you install and run a OpenSearch dashboard server as a docker container on a Linux machine. The docker container is configured in the simplest configuration without SSL

1. Install Docker and Docker compose

    * ```sudo apt-get install docker```
    * ```sudo apt-get install docker-compose```
    
2. Update the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) 
    
    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```

    You may need to update the image version. The image is set to version 2.5 and the version should be the same as the    
    version of OpenSearch that your Amazon OpenSearch domain is running
    
3. Run the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) file start the docker container by running ```docker-compose -f <path_to_docker_console_simple> up```

## Hosting OpenSearch dashboard server via. Docker on Linux with SSL

* Install openssl ```sudo apt-get install openssl```

* Generate a private key ```openssl genrsa -out root-ca-key.pem 2048```

* Using private key generate a root certificate ```openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem -days 365```

* ```openssl genrsa -out admin-key-temp.pem 2048```
* ```openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem```
* ```openssl req -new -key admin-key.pem -out admin.csr```

* ```rm admin-key-temp.pem```
* ```rm admin.csr```

You are left with
| Name              | Type                | 
|-------------------|-------------------- | 
| root-ca.pem       |  Certificate        | 
| root-ca-key.pem   |  Encryption key     | 
| admin-key.pem     |  Encryption key     | 

