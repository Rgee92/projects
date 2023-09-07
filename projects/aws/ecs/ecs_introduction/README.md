# Set Required Variables:

`AWS_DEFAULT_REGION="us-west-2"`

# Validate CloudFormation
`aws cloudformation validate-template --template-body file://ecs_introduction.yaml`

# Create the VPC and ECS Cluster
`aws cloudformation create-stack --stack-name ecs-introduction --capabilities CAPABILITY_IAM --template-body file://ecs_introduction.yaml`

# Delete the VPC and ECS Cluster
`aws cloudformation delete-stack --stack-name ecs-introduction
