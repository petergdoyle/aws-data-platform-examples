#!/bin/bash

echo What is the name of the Lambda?
read lambda_name

aws lambda invoke --function-name $lambda_name --cli-binary-format raw-in-base64-out --payload '{ "key": "value" }' response.jsonaw