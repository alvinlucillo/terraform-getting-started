# AWS region of the S3 bucket
region			 = us-east-1
# S3 bucket where Terraform stores its state data
s3bucket         = terraform-project-files
# Contains the changes to be applied to AWS infra (hence, 'plan')
terraform_plan   = .state/terraform.plan

# Describes the S3 bucket where the state file will reside
BACKEND_CONFIG = -backend-config="encrypt=true" \
	-backend-config="region=$(region)" \
	-backend-config="bucket=$(s3bucket)" \

# Assigns variables provided inline (-var) or in a .tfvars (-var-file)
TF_CONFIG = -var="region=$(region)" \
	-var-file="values.tfvars" 


init:        								# Sets up the environment or forces backend configuration changes (-reconfigure)                                      
	terraform init \
		$(TF_CONFIG) \
		-reconfigure \
		-input=true $(BACKEND_CONFIG)              


plan:    									# Compares the state file against the plan and shows the difference                                          
	terraform plan $(TF_CONFIG) -out="$(terraform_plan)"

validate:              						# Validates the syntax of the configuration                             
	terraform validate

import:      								# Imports existing infrastructure resources into the state file                                       
	terraform import \
		$(TF_CONFIG) \
		$(TF_ARGS)

apply:                           			# Applies changes to the infrastructure                   
	terraform apply $(terraform_plan)

refresh:                        			# Updates the state file with any changes to the infrastructure resources                    
	terraform refresh \
		$(TF_CONFIG) \