#!/bin/bash

set -ex

gcloud projects create ${TF_VAR_terraform_project} \
    --organization ${TF_VAR_gcp_org_id} \
    --set-as-default

gcloud config set project ${TF_VAR_terraform_project}

gcloud beta billing projects link ${TF_VAR_terraform_project} \
    --billing-account ${TF_VAR_gcp_billing_id}

gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable cloudkms.googleapis.com

gcloud iam service-accounts create terraform \
    --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_VAR_terraform_credentials} \
    --iam-account terraform@${TF_VAR_terraform_project}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${TF_VAR_terraform_project} \
    --member serviceAccount:terraform@${TF_VAR_terraform_project}.iam.gserviceaccount.com \
    --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_VAR_terraform_project} \
  --member serviceAccount:terraform@${TF_VAR_terraform_project}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud organizations add-iam-policy-binding ${TF_VAR_gcp_org_id} \
  --member serviceAccount:terraform@${TF_VAR_terraform_project}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_gcp_org_id} \
  --member serviceAccount:terraform@${TF_VAR_terraform_project}.iam.gserviceaccount.com \
  --role roles/billing.user

gsutil mb -p ${TF_VAR_terraform_project} gs://${TF_VAR_terraform_remote_state}
