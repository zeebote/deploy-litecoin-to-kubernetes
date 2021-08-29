# deploy-litecoin-to-kubernetes
Build docker image for litecoin and deploy it to Kubernetes with jenkins-ci

This docker build has been modified from this repo
I make a few modification to meet my requirements such as setup default args, running as non root user and using rpcauth 
for authentication instead of username and password which is going to be obsoleted. 
the image can be run as 

docker run trucv/litecoin:0.18.1

The kubernetes/statfullset.yml can be used to deploy above image to kubernetes with assumption that you already have a non storage class persistent volume. If you use pre-provisioned storage class in your cluster, please update the persistence volume claim before apply this statefulset. 
 
To deploy above image to kubernetes with kubectl

kubectl create -f kubernetes/statfullset.yml

The included Jenkinsfile can be used in Jenkins pipeline job which can build, publish, and deploy above image to kubernetes. I used docker plugin to build and publish the image to docker hub, this can be change to private registry. 
I also use kubernetes-cli plugin to create a temporary config for kubectl to deploy the image to kubernetes within the pipeline.

 
