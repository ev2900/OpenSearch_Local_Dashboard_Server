# OpenSearch Local Hosted Dashboard Server

You can connect a self hosted OpenSearch dashboard server to an Amazon OpenSearch hosted domain. 

Amazon OpenSearch managed services provides an OpenSearch dashboard as part of a domain deployment. For various reasons you may choose to host your own dashboard server and then connect it to your OpenSearch domain. Instead of using the OpenSearch dashboard provided with Amazon OpenSearch managed service.

The instructions in the repository will provide direction to host a local OpenSearch hosted dashboard server with an Amazon OpenSearch domain. 

The instructions below provide two deployment options

* [Host OpenSearch dashboard via. Amazon ECS Fargate](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#host-opensearch-dashboard-via-amazon-ecs-fargate)
* [Host OpenSearch dashboard using Docker on Linux](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#host-opensearch-dashboard-using-docker-on-linux)

# Host OpenSearch dashboard via. Amazon ECS Fargate

These instructions will help you deploy an OpenSearch dashboard server as a task on an Amazon Elastic Container Service Fargate cluster. The Fargate task will run the OpenSearch dashboard. The dashboard can be configured with or without SSL. The configuration without SSL in the simplest.

## without SSL

To deploy an ECS container running the OpenSearch dashboard click the button. Ensure you fill out the required CloudFormation parameters 

[![Launch CloudFormation Stack](https://sharkech-public.s3.amazonaws.com/misc-public/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=opensearch-dashboard-no-ssl-ecs-fargate&templateURL=https://sharkech-public.s3.amazonaws.com/misc-public/opensearch-dashboard-no-ssl-ecs-fargate.yaml)

To access the OpenSearch dashboard hosted on the ECS container. Navigate to the fargate cluster [opensearch-dashboard-fargate-cluster](https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/opensearch-dashboard-fargate-cluster). You should see 1 task running

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/cluster.png">

Click on the task

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/ip.png">

Use the public IP address on port 5601 to navigate to the OpenSearch dashboard in your browser

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/dashboard.png">

# Host OpenSearch dashboard using Docker on Linux

These instructions will help you install and run a OpenSearch dashboard server as a docker container on a Linux machine. The docker container running the OpenSearch dashboard can be configured with or without SSL. The configuration without SSL in the simplest.

## without SSL

1. Install Docker and Docker compose

    * ```sudo apt-get install docker```
    * ```sudo apt-get install docker-compose```
    
2. Update the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) 
    
    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```

    You may need to update the image version. The image is set to version 2.5 and the version should be the same as the    
    version of OpenSearch that your Amazon OpenSearch domain is running
    
3. Run the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) file start the docker container by running ```docker-compose -f <path_to_docker_compose_simple> up```

## with SSL

These instructions will help you install and run a OpenSearch dashboard server as a docker container on a Linux machine. The docker container is configured with a self-signed certificate.

1. Install Docker and Docker compose

    * ```sudo apt-get install docker```
    * ```sudo apt-get install docker-compose```

2. Generate a local certifying authority

    If you do not have access to a certifying authority, here are instructions to create one to issue certificates. Default parameters for openssl are used.

    *Install OpenSSL*
    * ```sudo apt-get install openssl```

    *Create a private key for your certifying authority*
    * ```openssl genrsa -out root-ca-key.pem 2048```

    *Generate a self-signed certificate*
    * ```openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem -days 730```


3. Generate a node certificate

   Create a certificate signed by the certifying authority you created in the previous step.

   *Create a private key for your certificate*
   * ```openssl genrsa -out node1-key-temp.pem 2048```

   *Create a certificate request using the key*
   * ```openssl req -new -key node1-key.pem -out node1.csr```

   *Create a SAN extension file that describes the hostname used by the dashboard server. This may be necessary for some browsers. We will use 'localhost'.*
   * ```echo 'subjectAltName=DNS:localhost' > node1.ext```

   *Issue a certificate using our CA*
   * ```openssl x509 -req -in node1.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node1.pem -days 730 -extfile node1.ext```

4. Update [docker-compose-ssl.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-ssl.yaml)

    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```
    * Replace ```<CA_certificate>``` with the location of the root RA (root-ca.pem)
    * Replace ```<node_certificate>``` with the location of the issued certificate (node1.pem)
    * Replace ```<node_certificate_key>``` with the associated private key of the issued certificate
    * Replace ```<path_to_folder_w_certs_key>``` with the local path of your certificate files

    You may need to update the image version. The image is set to version 2.5 and the version should be the same as the
    version of OpenSearch that your Amazon OpenSearch domain is running

5. Run the [docker-compose-ssl.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-ssl.yaml) file start the docker container by running ```docker-compose -f <path_to_docker_compose_ssl> up```
