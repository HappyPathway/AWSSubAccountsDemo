#!/bin/bash
export ORG=Darnold-DevTeam
export WORKSPACE=EC2AccountTest

function push_vault_env {
   tfe pushvars -name ${ORG}/${WORKSPACE} \
   -senv-var "VAULT_TOKEN=${VAULT_TOKEN}" \
   -env-var "VAULT_ADDR=${VAULT_ADDR}"
}

function set_vars {
    tfe pushvars -name ${TFE_ORG}/${WORKSPACE} \
    -var "aws_account_name=${AWS_ACCOUNT_NAME}" \
    -var "service_name=WebApp"
}

function main {
    terraform workspace new aws_ec2_test || terraform workspace select aws_ec2_test
    terraform init
    terraform apply -var repo=${WORKSPACE} -var description="AWS Sub Accounts" -var private=true -auto-approve
    tfe workspace new -tfe-workspace ${WORKSPACE} -vcs-id HappyPathway/${WORKSPACE}
    push_vault_env 
    set_vars
}

main
