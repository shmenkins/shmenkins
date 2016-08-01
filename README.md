# shmenkins

## How To Build
### Prerequisites
Create `terraform.tfvars` in project root.
```
aws_access_key="<your_aws_access_key>"
aws_secret_key="<your_aws_secret_key>"
aws_account_id="<your_aws_account_id>"
aws_region="<aws_region>"
s3_bucket="<aws_s3_bucket>"
```

```
$ ./shmenkins build
```
Will build lambda.

## How To Deploy

```
$ ./shmenkins upload
$ ./shmenkins plan-deploy
$ ./shmenkins do-deploy
```

## Directory Layout

Directory | Description
----------|----------------
src/lambda | Lambda source code (python)
src/infra | Infrastructure source code (terraform)
src/util | Various utilities (bash, python)
cfg | Configuration files
