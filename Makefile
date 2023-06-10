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

# Sets up the environment or forces backend configuration changes (-reconfigure)  
init:        								                                    
	terraform init \
		$(TF_CONFIG) \
		-reconfigure \
		-input=true $(BACKEND_CONFIG)              

# Compares the state file against the plan and shows the difference
plan:    									                                          
	terraform plan $(TF_CONFIG) -out="$(terraform_plan)"

# Validates the syntax of the configuration
validate:              						                             
	terraform validate

# Imports existing infrastructure resources into the state file
import:      								                                       
	terraform import \
		$(TF_CONFIG) \
		$(TF_ARGS)

# Applies changes to the infrastructure
apply:                           			                   
	terraform apply $(terraform_plan)

# Updates the state file with any changes to the infrastructure resources
refresh:                        			                    
	terraform refresh \
		$(TF_CONFIG) \