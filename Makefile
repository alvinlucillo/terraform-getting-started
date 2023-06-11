# AWS region of the S3 bucket
region			 = us-east-1
# S3 bucket where Terraform stores its state data
s3bucket         = terraform-project-files
# State file name in S3 bucket
statefile        = "terraform.tfstate"
# Contains the changes to be applied to AWS infra (hence, 'plan')
terraformplan    = .state/terraform.plan

# Describes the S3 bucket where the state file will reside (i.e., backend)
BACKEND_CONFIG = -backend-config="encrypt=true" \
	-backend-config="bucket=$(s3bucket)" \
	-backend-config="key=$(statefile)" \
	-backend-config="region=$(region)"

# Assigns variables provided inline (-var) or in a .tfvars (-var-file)
# -var assigns value to the variable referenced in the project via var.variable_name
TF_CONFIG = -var="region=$(region)" \
	-var-file="values.tfvars" 

# Sets up the environment, and creates state folder and plan file
# Forces backend configuration changes (-reconfigure)  
init:        								                                    
	terraform init \
		$(TF_CONFIG) \
		-reconfigure \
		-input=true $(BACKEND_CONFIG)          

	mkdir -p .state
	touch .state/terraform.plan

# Compares the state file against the plan and shows the difference
plan:    									                                          
	terraform plan $(TF_CONFIG) -out="$(terraformplan)"

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
	terraform apply $(terraformplan)

# Updates the state file with any changes to the infrastructure resources
refresh:                        			                    
	terraform refresh \
		$(TF_CONFIG) \