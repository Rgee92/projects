# Flow Logs
Flow logs will automatically be collected for every Elastic Network Interface in the created VPC.
The logs can be found in the AWS console under `Cloudwatch -> Logs -> "$stackname-vpcLogGroup"`

# Guard Duty
Guard duty detector is enabled. Guard duty continuously monitors for malicious activity and unauthorized behavior to protect your AWS accounts and workloads. Findings of any malicious activity will be listed in Guard Duty Findings AWS Console.

Guard Duty will list Findings every 15 minutes according to any of these finding types:
https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-active.html

```
export AWS_PROFILE='default'
export AWS_REGION='us-west-2'
```

# Validate Stack
`aws cloudformation validate-template --template-body file://vpc_flow_logs_guard_duty.yaml`

# Create Stack
`aws cloudformation create-stack --stack-name vpc-flow-log-guard-duty --capabilities CAPABILITY_IAM --template-body file://vpc_flow_log_guard_duty.yaml`

# Update Stack
`aws cloudformation update-stack --stack-name vpc-flow-log-guard-duty --capabilities CAPABILITY_IAM --template-body file://vpc_flow_log_guard_duty.yaml`

# Delete Stack
`aws cloudformation update-stack --stack-name vpc-flow-log-guard-duty`