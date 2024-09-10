# OpenSearch Local Hosted Dashboard Server

<img width="275" alt="map-user" src="https://img.shields.io/badge/cloudformation template deployments-43-blue"> <img width="85" alt="map-user" src="https://img.shields.io/badge/views-2208-green"> <img width="125" alt="map-user" src="https://img.shields.io/badge/unique visits-627-green">

You can connect a self hosted OpenSearch dashboard server to an Amazon OpenSearch (managed service) hosted domain.

Amazon OpenSearch (managed service) provides an OpenSearch dashboard as part of a domain deployment. For various reasons you may choose to host your own dashboard server and connect it to your Amazon OpenSearch (managed service) domain.

This repository provides how to instructions using two deployment options

* [OpenSearch dashboard deployment via. **Amazon Elastic Container Service** (ECS) Fargate](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#host-opensearch-dashboard-via-amazon-ecs-fargate)
* [OpenSearch dashboard deployment via. **Docker on Linux**](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#host-opensearch-dashboard-using-docker-on-linux)

# Host OpenSearch dashboard via. Amazon ECS Fargate

These instructions will help you deploy an OpenSearch dashboard server as a task on an Amazon Elastic Container Service (ECS) Fargate cluster. The Fargate task will run the OpenSearch dashboard.

To deploy an ECS task running the OpenSearch dashboard click the button below. Ensure you fill out the required CloudFormation parameters.

[![Launch CloudFormation Stack](https://sharkech-public.s3.amazonaws.com/misc-public/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=opensearch-dashboard-no-ssl-ecs-fargate&templateURL=https://sharkech-public.s3.amazonaws.com/misc-public/opensearch-dashboard-no-ssl-ecs-fargate.yaml)

Once the CloudFormation deployment completes follow the steps below to access the OpenSearch dashboard hosted on ECS

1. Navigate to the fargate cluster [opensearch-dashboard-fargate-cluster](https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/opensearch-dashboard-fargate-cluster)

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/cluster.png">

2. Click on the task

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/ip.png">

3. Use the public IP address on port 5601 in your web browser to access the OpenSearch dashboard

<img width="800" alt="map-user" src="https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/README/dashboard.png">

# Host OpenSearch dashboard using Docker on Linux

These instructions will help you configure and run an OpenSearch dashboard server as a docker container on a Linux machine. The OpenSearch dashboard service can be configured [without SSL](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#without-ssl) or [with SSL](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/tree/main#with-ssl)

## without SSL

1. Install Docker and Docker compose

    * ```sudo apt-get install docker```
    * ```sudo apt-get install docker-compose```

2. Update the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml)

    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```

    You may need to update the OpenSeach dashboard image version. The image in [the sample](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-no-ssl.yaml) is set to version 2.5. The version should be the same as the version of OpenSearch that your Amazon OpenSearch (managed service) domain is running

3. Run the [docker-compose-simple.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-simple.yaml) file and start the docker container by running ```docker-compose -f <path_to_docker_compose_simple> up```

4. In you web browser navigate to [http://localhost:5601/](http://localhost:5601/) to access the OpenSearch dashboard

## with SSL

These instructions will help you install and run a OpenSearch dashboard server as a docker container on a Linux machine. The docker container is configured with a self-signed certificate.

1. Install Docker and Docker compose

    * ```sudo apt-get install docker```
    * ```sudo apt-get install docker-compose```

2. Generate a self-signed certificate and certifying authority

    *Install OpenSSL*
    * ```sudo apt-get install openssl```

    *Run the included script*
    * ```bash generate_cert.sh```

3. Update [docker-compose-ssl.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-ssl.yaml)

    * Replace ```<domain_endpoint_url>``` with the OpenSearch domain endpoint
    * Replace ```<user_name>```
    * Replace ```<password>```

    You may need to update the OpenSeach dashboard image version. The image in [the sample](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-ssl.yaml) is set to version 2.5. The version should be the same as the version of OpenSearch that your Amazon OpenSearch (managed service) domain is running

5. Run the [docker-compose-ssl.yaml](https://github.com/ev2900/OpenSearch_Local_Dashboard_Server/blob/main/docker-compose-ssl.yaml) file start the docker container by running ```docker-compose -f <path_to_docker_compose_ssl> up```

6. In your web browser navigate to [https://localhost:5601/](https://localhost:5601/) to access the OpenSearch dashboard. If you used a self-signed certificate your web browser may flag the website as unsecure. You will have to bypass the warning on your web browser. (For Chrome, you can type thisisunsafe to bypass the warning. Be sure you are correctly accessing the URL.)
