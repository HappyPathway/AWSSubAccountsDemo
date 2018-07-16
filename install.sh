
#!/bin/bash
ORG=Darnold-AWS-Global
WORKSPACE=AWSSubAccounts
HASHI_USER=darnold

function push_vault_env {
   WS=${2}
   tfe_org=${1}
   source ~/.tfe/${tfe_org}
   tfe pushvars -name ${tfe_org}/${WS} \
   -senv-var "VAULT_TOKEN=${VAULT_TOKEN}" \
   -env-var "VAULT_ADDR=${VAULT_ADDR}"
}

function push_aws {
  WS=${2}
  tfe_org=${1}
  source ~/.tfe/${tfe_org}
  tfe pushvars -name ${tfe_org}/${WS} \
  -senv-var "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
  -senv-var "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
  -env-var AWS_DEFAULT_REGION=us-east-1 
}

function set_vars {
    WS=${2}
    tfe_org=${1}
    source ~/.tfe/${tfe_org}
    epoch=$(date +%s)
    export AWS_ACCOUNT_EMAIL=${HASHI_USER}+hashidemos-${epoch}@hashicorp.com
    export AWS_ACCOUNT_NAME=${HASHI_USER}-hashidemos-${epoch}
    tfe pushvars -name ${TFE_ORG}/${WS} \
    -var "aws_account_email=${AWS_ACCOUNT_EMAIL}" \
    -var "aws_account_name=${AWS_ACCOUNT_NAME}"
}

function main {
    source ~/.tfe/${ORG}
    terraform apply -var repo=${WORKSPACE} -var description="AWS Sub Accounts" -var private=true
    tfe workspace new -tfe-workspace ${WORKSPACE} -vcs-id HappyPathway/${WORKSPACE}
    push_vault_env  ${WORKSPACE}
    push_aws ${ORG} ${WORKSPACE}
    set_vars ${ORG} ${WORKSPACE}
}