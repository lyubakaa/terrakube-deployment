#!/bin/bash

function test_ssh_key {
    openssl rsa -inform PEM -in "$1" -noout &> /dev/null
    if [ $? != 0 ]; then
        printf "The generated key either isn't readable, doesn't exist or is invalid\n"
        exit 1
    fi
}

awsRegion=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--region) awsRegion="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$awsRegion" ]; then
    read -p "Enter the AWS region: " awsRegion
fi

if [ -z "$awsRegion" ]; then
    echo "AWS region cannot be empty."
    exit 1
fi

read -p "Enter the name for the AWS key pair: " keyPairName

if [ -z "$keyPairName" ]; then
    echo "Key pair name cannot be empty."
    exit 1
fi

scriptDir="$(pwd)"

privateKeyFile="$scriptDir/${keyPairName}.pem"
publicKeyFile="$privateKeyFile.pub"

if [ -f "$privateKeyFile" ]; then
    echo "Key pair already exists locally. Skipping key generation."
else
    ssh-keygen -m PEM -f "$privateKeyFile"

    if [ ! -f "$privateKeyFile" ]; then
        echo "Key pair generation failed."
        exit 1
    fi

    chmod 400 "$privateKeyFile"

    test_ssh_key "$privateKeyFile"
fi

ssh-keygen -y -f "$privateKeyFile" > "$publicKeyFile"

if aws ec2 describe-key-pairs --key-names "$keyPairName" --region "$awsRegion" > /dev/null 2>&1; then
    echo "Key pair already exists in AWS. Skipping upload."
else
    printf "Key will be populated in the $awsRegion region in your AWS CLI config\n"
    aws ec2 import-key-pair --region "$awsRegion" --key-name "$keyPairName" --public-key-material fileb://"$publicKeyFile"

    if [ $? -ne 0 ]; then
        echo "Failed to upload the key pair to AWS."
        exit 1
    else
        echo "Key pair uploaded successfully to AWS."
    fi
fi
