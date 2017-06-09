# Terraform

## Note on the lambda scripts

You have to use virtual environments in the `pagerduty` and `timer` folders and install all your dependencies within them.
This will allow the dependencies to be zipped by terraform and uploaded along with the lambda scripts.

To create a virtualenv in each folder i.e. in the `lambda/pagerduty` and `lambda/timer` folders run

```
sudo apt-get install virtualenv # to install virtualenv on your system
cd pagerduty
virtualenv venv
cd ../timer
virtualenv venv
```

To work on any one of the scripts you need to activate that folder's virtual environment by running
```
source venv/bin/activate
```

**_Note_**: This is required for the terraform setup to work.

## Prerequisites

See section on setting up a service account for authentication before running the terraform commands.

Install jq

```
sudo apt-get install jq
```

## Get Terraform
If you’re on a Mac and use Homebrew, a quick brew install terraform will get you started. 
If you don’t use Homebrew, or you want to ensure you get the latest version and a stable build, download the Terraform package for your system [directly from HashiCorp](https://www.terraform.io/downloads.html) and [follow their instructions](https://www.terraform.io/intro/getting-started/install.html) to complete the install.

## Deploying the Infrastructure

To **view** the infrastructure that will be created run

```
terraform plan
```

To **create** the infrastructure defined in the *.tf files run

```
terraform apply
```

To **destroy** the the infrastructure defined in the *.tf files run

```
terraform destroy
```

## Authentication JSON File

Authenticating with Google Cloud services requires a JSON file which we call the account file.

This file is downloaded directly from the Google Developers Console. To make the process more straightforwarded, it is documented here:

1. Log into the Google Developers Console and select a project.

2. The API Manager view should be selected, click on "Credentials" on the left, then "Create credentials", and finally "Service account key".

3. Select "Compute Engine default service account" in the "Service account" dropdown, and select "JSON" as the key type.

4. Clicking "Create" will download your credentials.

5. Copy the downloaded credentials file to the current folder and rename it "serviceaccount.json"