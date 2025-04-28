# tf-aws-infra

### Step 1: Install Prerequisites

- Install Terraform
- Install and configure AWS CLI

### Step 2: Clone this Repository

```
    git clonegit@github.com:vaityomkar/tf-aws-infra.git
```

### Step 3: Intialize Terraform
```
    terraform init
```

### Step 4: Apply Terraform
```
    terraform apply
```

### Step 5: Destroy Terraform
```
    terraform destroy
```



To import an SSL certificate into AWS ACM using the AWS CLI, follow these detailed steps:

Prerequisites
Install AWS CLI:

If you haven’t installed the AWS CLI yet, you can follow the installation guide for your operating system here.
Configure AWS CLI:

Ensure you have the necessary AWS permissions to import the certificate into AWS ACM.
To configure your AWS CLI profile, run the following command:
bash
Copy code
aws configure --profile demo
Replace demo with the profile name you're using. This command will ask for:

AWS Access Key ID
AWS Secret Access Key
Default region name (e.g., us-east-1)
Default output format (e.g., json)
Prepare the Certificate Files
You need to have the following files ready:

Certificate file (.crt): The public SSL certificate (e.g., certificate.crt).
Private Key file (.key): The decrypted private key associated with the certificate (e.g., private.key).
Certificate Chain file (.ca-bundle): The certificate authority (CA) bundle for the certificate (e.g., certificate-chain.ca-bundle).
If your private key is encrypted, you must decrypt it before using it. Run the following command to decrypt the private key:

bash
Copy code
openssl rsa -in encrypted_private.key -out decrypted_private.key
This will create a decrypted version of the private key (decrypted_private.key).

Importing the Certificate into AWS ACM
Run the Import Command:

Now, you can import your SSL certificate into AWS ACM by running the following AWS CLI command:
bash
Copy code
aws acm import-certificate \
  --certificate fileb://<path-to-certificate>.crt \
  --private-key fileb://<path-to-decrypted-private-key>.key \
  --certificate-chain fileb://<path-to-ca-bundle>.ca-bundle \
  --region us-east-1 \
  --profile demo
Replace the placeholders with the actual paths to your files:

<path-to-certificate>.crt: Path to your SSL certificate file.
<path-to-decrypted-private-key>.key: Path to your decrypted private key file.
<path-to-ca-bundle>.ca-bundle: Path to your certificate chain file.
The --region flag specifies the AWS region where the ACM certificate should be imported (in this case, us-east-1), and --profile refers to the configured AWS CLI profile (demo in this example).

Example:
Assume your files are located at:

/home/user/certificates/certificate.crt
/home/user/certificates/decrypted_private.key
/home/user/certificates/certificate-chain.ca-bundle
Your command would look like this:

bash
Copy code
aws acm import-certificate \
  --certificate fileb:///home/user/certificates/certificate.crt \
  --private-key fileb:///home/user/certificates/decrypted_private.key \
  --certificate-chain fileb:///home/user/certificates/certificate-chain.ca-bundle \
  --region us-east-1 \
  --profile demo
Success Message:
If the command is successful, you should see an output similar to the following, confirming that the certificate has been imported:

json
Copy code
{
    "CertificateArn": "arn:aws:acm:us-east-1:123456789012:certificate/abc12345-6789-0abc-d123-4567abc89012"
}
The CertificateArn is the Amazon Resource Name (ARN) of the imported certificate, which you can use in other AWS services like ELB, CloudFront, or API Gateway.