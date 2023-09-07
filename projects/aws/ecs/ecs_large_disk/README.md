# Set Required Variables:

`AWS_DEFAULT_REGION="us-west-2"`

`key_name="efstest"`

# Validate CloudFormation
`aws cloudformation validate-template --template-body file://ecs_large_disk.yaml`

# Create the VPC and ECS Cluster
`aws cloudformation create-stack --stack-name ecs-large-disk --parameters ParameterKey=keyName,ParameterValue=efstest --capabilities CAPABILITY_IAM --template-body file://ecs_large_disk.yaml`

# Delete the VPC and ECS Cluster
`aws cloudformation delete-stack --stack-name ecs-large-disk`
