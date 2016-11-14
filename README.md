# shmenkins

## Initial setup

Run `$ sudo ./setup.sh` to install the build tools (`cfgen`, `awscli`, `terraform`).
Create a versioned S3 bucket in the same region where lambda will be.

## How to build individual service

```
$ cd infra/<resource_group>
$ ./init.sh
$ terraform apply
```

## Directory Layout

Directory | Description
----------|----------------
lambda | Lambda source code (python)
infra | Infrastructure source code (terraform)
util | Various utilities (bash, python)
cfg | Configuration files

## AWS resources
Single S3 bucket for everything.

S3 bucket directory layout
```
s3_bucket
├── branch_1
│   └── group_1
│       ├── lambda_function_1.whl
│       ├── terraform.tfstate
│       └── other_dependencies
└── master
    ├── group_1
    │   ├── lambda_function_1.whl
    │   ├── terraform.tfstate
    │   └── other_dependencies
    └── group_2
        ├── lambda_function_2.whl
        ├── terraform.tfstate
        └── other_dependencies
```
