# AWS Deployment Script
# This script will deploy all infrastructure to AWS

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AWS Infrastructure Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "[1/4] Checking prerequisites..." -ForegroundColor Yellow

# Check AWS CLI
try {
    $awsVersion = aws --version 2>&1
    Write-Host "✓ AWS CLI found: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ AWS CLI not found! Please install it first." -ForegroundColor Red
    exit 1
}

# Check Terraform
try {
    $tfVersion = terraform version 2>&1 | Select-Object -First 1
    Write-Host "✓ Terraform found: $tfVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Terraform not found! Please install it first." -ForegroundColor Red
    exit 1
}

# Verify AWS credentials
Write-Host ""
Write-Host "[2/4] Verifying AWS credentials..." -ForegroundColor Yellow
try {
    $identity = aws sts get-caller-identity 2>&1 | ConvertFrom-Json
    Write-Host "✓ AWS Account: $($identity.Account)" -ForegroundColor Green
    Write-Host "✓ User: $($identity.Arn)" -ForegroundColor Green
} catch {
    Write-Host "✗ AWS credentials not configured!" -ForegroundColor Red
    Write-Host "Please run: aws configure" -ForegroundColor Yellow
    exit 1
}

# Cost warning
Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "  COST WARNING" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "This deployment will cost approximately:" -ForegroundColor Yellow
Write-Host "  • EKS Control Plane: `$73/month" -ForegroundColor White
Write-Host "  • EC2 Instances: ~`$30/month" -ForegroundColor White
Write-Host "  • RDS Database: ~`$15/month" -ForegroundColor White
Write-Host "  • NAT Gateway: ~`$32/month" -ForegroundColor White
Write-Host "  • Total: ~`$150/month" -ForegroundColor Red
Write-Host ""
Write-Host "To destroy resources later, run: terraform destroy" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Do you want to continue? (yes/no)"
if ($confirm -ne 'yes') {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit 0
}

# Navigate to AWS Terraform directory
Write-Host ""
Write-Host "[3/4] Initializing Terraform..." -ForegroundColor Yellow
Set-Location -Path "E:\DEV\devops-multicloud-project\phase1-iac\terraform\aws"

# Initialize Terraform
Write-Host "Running: terraform init" -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Terraform init failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Terraform initialized successfully" -ForegroundColor Green

# Show plan
Write-Host ""
Write-Host "[4/4] Creating deployment plan..." -ForegroundColor Yellow
Write-Host "Running: terraform plan" -ForegroundColor Cyan
Write-Host ""
terraform plan

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Terraform plan failed!" -ForegroundColor Red
    exit 1
}

# Deploy
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ready to Deploy!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Resources to be created:" -ForegroundColor White
Write-Host "  ✓ VPC with subnets" -ForegroundColor Green
Write-Host "  ✓ Internet Gateway & NAT Gateway" -ForegroundColor Green
Write-Host "  ✓ EKS Kubernetes Cluster" -ForegroundColor Green
Write-Host "  ✓ EKS Node Group (2 instances)" -ForegroundColor Green
Write-Host "  ✓ S3 Bucket" -ForegroundColor Green
Write-Host "  ✓ RDS MySQL Database" -ForegroundColor Green
Write-Host "  ✓ Security Groups & IAM Roles" -ForegroundColor Green
Write-Host ""
Write-Host "Estimated deployment time: 15-20 minutes" -ForegroundColor Yellow
Write-Host ""

$deploy = Read-Host "Start deployment? (yes/no)"
if ($deploy -ne 'yes') {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting deployment..." -ForegroundColor Green
Write-Host "Running: terraform apply -auto-approve" -ForegroundColor Cyan
Write-Host ""

# Apply with auto-approve
terraform apply -auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Deployment Successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    # Get outputs
    Write-Host "Deployment Outputs:" -ForegroundColor Cyan
    terraform output
    
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Configure kubectl:" -ForegroundColor White
    Write-Host "   aws eks update-kubeconfig --region us-east-1 --name devops-eks-cluster" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "2. Verify cluster:" -ForegroundColor White
    Write-Host "   kubectl get nodes" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. Deploy application:" -ForegroundColor White
    Write-Host "   kubectl apply -f ../../../phase2-cicd/sample-app/k8s/deployment.yaml" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Deployment Failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check the error messages above." -ForegroundColor Yellow
    Write-Host "You can retry with: terraform apply" -ForegroundColor Yellow
    exit 1
}
