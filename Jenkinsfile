pipeline {
    environment {
        registry = "trucv/litecoin:0.18.1"
        registryCredential = 'dockerhub_id'
    }
    agent {
        kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: trucv/kubectl:1.20.2
    command: ['cat']
    tty: true
  - name: docker
    image: docker:latest
    command: ['cat']
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    stages {
        stage('Build Docker image') {
            steps {
                container('docker') {
                    script {
                        litecoinImage = docker.build registry
                    }
                }
            }
        }
        stage('Publish Docker image') {
            steps {
                container('docker') {
                    script {
                        docker.withRegistry( '', registryCredential ) {
                            litecoinImage.push()
                        }
                    }
                }
            }
        }
        stage('Deploy to K8') {
            steps {
                container('kubectl') {
                    withKubeConfig(credentialsId: 'k8-serviceaccount', serverUrl: 'https://kubernetes.default') {
                        sh 'kubectl create -f kubernetes/statefulset.yml'
                    }
                }
            }
        }
    }
}
