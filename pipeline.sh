#!/bin/bash

# SETUP inicial
#set -e

export AWS_ACCOUNT="905418103129"
export AWS_PAGER=""
export APP_NAME="linuxtips-app"
export CLUSTER_NAME="linuxtips-ecs-cluster"
export BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# CI da app

echo "app-ci"

cd app/

echo "APP - LINT"

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.59.1
golangci-lint run ./... -E errcheck

echo "APP - TEST"   

go test -v ./...

# CI terraform
echo "Terraform-ci"
cd ../terraform

echo "terraform format"

terraform fmt --recursive --check

echo "terraform validate"
terraform validate

echo "CI - TERRAFORM INIT"
terraform init -backend-config=environment/$BRANCH_NAME/backend.tfvars

# BUILD app
echo "APP - BUILD"
cd ../app

#bump de versão utilizando a ultima tag de commit do git 
echo "build - bump de versao"
GIT_COMMIT_HASH=$(git rev-parse --short HEAD)
echo $GIT_COMMIT_HASH

echo "Build - loogin ECR"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com
echo "Login no ECR realizado com sucesso"

echo "Build - creat repository if not exists"

REPOSITORY_NAME="golang/$APP_NAME"

set +e

# Verificar se o repositório já existe
REPO_EXISTS=$(aws ecr describe-repositories --repository-names $REPOSITORY_NAME 2>&1)

if [[ $REPO_EXISTS == *"RepositoryNotFoundException"* ]]; then
  echo "Repositório $REPOSITORY_NAME não encontrado. Criando..."
  
  # Criar o repositório
  aws ecr create-repository --repository-name $REPOSITORY_NAME
  
  if [ $? -eq 0 ]; then
    echo "Repositório $REPOSITORY_NAME criado com sucesso."
  else
    echo "Falha ao criar o repositório $REPOSITORY_NAME."
    exit 1
  fi
else
  echo "Repositório $REPOSITORY_NAME já existe."
fi

set -e

echo "Build - docker build"

docker build -t app .

docker tag app:latest $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH

# PUBLISH APP

echo "BUILD - DOCKER PUBLISH"

docker push $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH

# APPLY terraform - CD
cd ../terraform

REPOSITORY_TAG=$AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH

echo "DEPLOY - TERRAFORM PLAN"
terraform plan -var-file=environment/$BRANCH_NAME/terraform.tfvars -var container_image=$REPOSITORY_TAG

echo "DEPLOY - TERRAFORM APPLY"
terraform apply --auto-approve -var-file=environment/$BRANCH_NAME/terraform.tfvars -var container_image=$REPOSITORY_TAG

echo "DEPLOY - WAIT DEPLOY"

aws ecs wait services-stable --cluster $CLUSTER_NAME --services $APP_NAME