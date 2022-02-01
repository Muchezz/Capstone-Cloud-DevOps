[![CircleCI](https://circleci.com/gh/Muchezz/Covid19-analysis/tree/main.svg?style=svg)](https://circleci.com/gh/Muchezz/Covid19-analysis/tree/main)

# Project
Deploying a Flask application container to AWS EKS and viweing the webpage via the Elastic Load Balancer.
In this project I am working with:

- AWS
- CircleCI to implement Continuous Integration and Continuous Deployment
- Linting using Makefile 
- Docker
- Kubernetes clusters
- Flask 

# Steps in Completing the Project 

## Prerequisites
- AWS account
- A Circleci Account. In this configure:
    - Add the AWS credentials as environment variables. Configure AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION
- Your App to deploy

## Tools
1. Circleci
2. Amazon Elastic Kubernetes Service (EKS)
3. Dockerhub (Alternatively, you can push your image to AWS ECR)
4. Kubernetes
5. CloudFormation
6. eksctl

## Steps
1. Fork the project to your Github Account
2. Add the AWS credentials as environment variables. Configure 
 
  - AWS_ACCESS_KEY_ID, 
  - AWS_SECRET_ACCESS_KEY 
  - AWS_DEFAULT_REGION
 
3. Complete your Dockerfile to build the image of your app
4. Add Makefile for linting
5. Complete your  ``` .circleci/config.yml ```. Implement Build and deploy jobs with CircleCI `kubernetes` and `AWS EKS `orbs.

    ```yml 
    orbs:
          aws-eks: circleci/aws-eks@2.1.1
          kubernetes: circleci/kubernetes@0.4.0
          
    ```
    - Using the `Makefile` you can add more linting stages.
    - Build and push your docker image to Dockerhub. Example:
    ```yml
    build-and-push-image:
    machine: true
    steps:
         - checkout
         - run: |
            docker build -t greentropikal/covid19-analysis:latest .
            echo $DOCKERHUB_PASSWORD | docker login -u $DOCKER_USER --password-stdin
            docker push greentropikal/covid19-analysis:latest
    ```

    - In the workflow create the cluster and all the required VPC-related resources to run Kubernetes on AWS.
      ```yml
       
        create-cluster:
            docker:
            - image: << pipeline.parameters.executor>>
            steps:
            - aws-eks/install-aws-iam-authenticator:
                release-tag: ''
            - aws-eks/create-cluster:
                cluster-name: << pipeline.parameters.cluster-name >>
                node-type: t3.medium
        ```

    - Some of the resources created using this simple command are NATGateway, eks cluster, ec2,      loadbalancer and so many more. Check out the [template](template.yml) here for more.

    - Use the `deploy-application` command to deploy your application to eks. This is where you declare your deployment strategy. The main commands are:
      ```yml
        
            - aws-eks/update-kubeconfig-with-authenticator:
                cluster-name: << pipeline.parameters.cluster-name >>
                install-kubectl: true
                aws-region: << pipeline.parameters.aws-region >>
            - kubernetes/create-or-update-resource:
                get-rollout-status: true
                resource-file-path: deployment/deploy.yml
                resource-name: deployment/covid19-analysis
            - kubernetes/create-or-update-resource:
                resource-file-path: deployment/app-service.yml

        ```
    - Test your application to check if everything is working out fine.
6. Push your code to github and the pipeline will do the rest.


## Links
- [circleci/aws-eks orb](https://circleci.com/developer/orbs/orb/circleci/aws-eks).
