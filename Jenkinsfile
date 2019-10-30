pipeline {
    agent none
    environment {
        KUBERNETES_SERVICE_NAME = "masbilling"
    }
    stages {
        stage('Build Docker images') {
            // when { anyOf { changeset "ci/docker/**/*";  triggeredBy cause: "UserIdCause" } }
            agent {
                label 'docker'
            }
            steps {
                checkout scm
                sh 'ls -la'
                sh 'docker build -t eu.gcr.io/mm-cloudbuild/masbilling:jenkins -f ./ci/Dockerfile ./ci'
                sh '/snap/bin/gcloud auth configure-docker --quiet'
                sh 'docker push eu.gcr.io/mm-cloudbuild/masbilling:jenkins'
            }
        }
        stage('Testing') {
            agent {
                docker {
                    label 'docker'
                    image 'eu.gcr.io/mm-cloudbuild/masbilling:jenkins'
                }
            }
            stages {
                stage('Unit Tests') {
                    steps {
                        checkout scm
                        sh 'make unit-test'
                    }
                }
            }
        }
        stage('Build & push') {
            agent {
                docker {
                    label 'docker'
                    image 'eu.gcr.io/mm-cloudbuild/masbilling:jenkins'
                }
            }
            stages {
                stage('Context') {
                    steps {
                        sh '''
                        mkdir -p ./context ./deployment
                        gsutil -m cp -r 'gs://cloudbuild-contexts/masbilling/*' ./context
                        gsutil -m cp -r 'gs://continuous-deployment-scripts/deployment/*' ./deployment
                        chmod +x ./deployment/*.sh
                        '''
                    }
                }
                stage('Build docker image') {
                    steps {
                        sh '''#!/bin/bash
                        source ./context/env.sh
                        make build-docker-image
                        '''
                    }
                }
                stage('Push docker image') {
                    steps {
                        sh '''#!/bin/bash
                        source ./context/env.sh
                        make push-docker-image
                        '''
                    }
                }
            }
        }
        stage('Deploy') {
            agent {
                docker {
                    label 'docker'
                    image 'eu.gcr.io/mm-cloudbuild/masbilling:jenkins'
                }
            }
            stages {
                stage('Deploy to K8s') {
                    steps {
                        sh '''#!/bin/bash
                        source ./context/env.sh
                        make deploy
                        '''
                    }
                }
            }
        }
    }
}