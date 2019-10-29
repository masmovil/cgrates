pipeline {
  agent none
  environment {
      KUBERNETES_SERVICE_NAME = "masbilling"
  }
  stages {
    stage('Testing') {
      agent {
        docker {
          label 'docker'
          image 'golang:1.13.1'
        }
      }
      stages {
          stage('Unit Tests') {
          steps {
            checkout scm
            sh '''#!/bin/bash
            make unit-test
            '''
          }
        }
      }
    }
    stage('Build & push') {
      agent {
        docker {
          label 'docker'
          image 'eu.gcr.io/mmdh-dev/circleci:docker-17.10.0-ce-git'
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
          image 'eu.gcr.io/mmdh-dev/circleci:docker-17.10.0-ce-git'
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