
#!/bin/bash
export ORG=Darnold-AWS-AccountManagement
export WORKSPACE=AWSSubAccounts
export HASHI_USER=darnold
export KEYBASE_USER=darnoldhashic

function push_vault_env {
   tfe pushvars -name ${ORG}/${WORKSPACE} \
   -senv-var "VAULT_TOKEN=${VAULT_TOKEN}" \
   -env-var "VAULT_ADDR=${VAULT_ADDR}"
}

function push_aws {
  tfe pushvars -name ${ORG}/${WORKSPACE} \
  -senv-var "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
  -senv-var "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
  -env-var AWS_DEFAULT_REGION=us-east-1 
}

function set_vars {
    epoch=$(date +%s)
    export AWS_ACCOUNT_EMAIL=${HASHI_USER}+hashidemos-${epoch}@hashicorp.com
    export AWS_ACCOUNT_NAME=${HASHI_USER}-hashidemos-${epoch}
    tfe pushvars -name ${TFE_ORG}/${WORKSPACE} \
    -var "aws_account_email=${AWS_ACCOUNT_EMAIL}" \
    -var "aws_account_name=${AWS_ACCOUNT_NAME}" \
    -var "keybase_user=${KEYBASE_USER}"
}

function main {
    terraform workspace new aws_accounts || terraform workspace select aws_accounts 
    terraform init
    terraform apply -var repo=${WORKSPACE} -var description="AWS Sub Accounts" -var private=true -auto-approve
    tfe workspace new -tfe-workspace ${WORKSPACE} -vcs-id HappyPathway/${WORKSPACE}
    push_vault_env ${ORG} ${WORKSPACE}
    push_aws ${ORG} ${WORKSPACE}
    set_vars ${ORG} ${WORKSPACE}
}

source ~/.tfe/${ORG}
main
