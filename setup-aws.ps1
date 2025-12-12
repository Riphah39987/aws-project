# AWS Deployment Setup Script
# Run this to install required tools and deploy to AWS

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AWS Deployment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Please run this script as Administrator" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Step 1: Install Chocolatey if not installed
Write-Host "[1/5] Checking Chocolatey..." -ForegroundColor Yellow
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "✓ Chocolatey installed" -ForegroundColor Green
} else {
    Write-Host "✓ Chocolatey already installed" -ForegroundColor Green
}

# Step 2: Install AWS CLI
Write-Host ""
Write-Host "[2/5] Checking AWS CLI..." -ForegroundColor Yellow
if (!(Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Host "Installing AWS CLI..." -ForegroundColor Green
    choco install awscli -y
    refreshenv
    Write-Host "✓ AWS CLI installed" -ForegroundColor Green
} else {
    Write-Host "✓ AWS CLI already installed" -ForegroundColor Green
}

# Step 3: Install Terraform
Write-Host ""
Write-Host "[3/5] Checking Terraform..." -ForegroundColor Yellow
if (!(Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Terraform..." -ForegroundColor Green
    choco install terraform -y
    refreshenv
    Write-Host "✓ Terraform installed" -ForegroundColor Green
} else {
    Write-Host "✓ Terraform already installed" -ForegroundColor Green
}

# Step 4: Configure AWS
Write-Host ""
Write-Host "[4/5] AWS Configuration" -ForegroundColor Yellow
Write-Host ""
Write-Host "You need to configure AWS with your credentials." -ForegroundColor White
Write-Host ""
Write-Host "To get your AWS Access Keys:" -ForegroundColor Cyan
Write-Host "1. Go to: https://console.aws.amazon.com/" -ForegroundColor White
Write-Host "2. Search for 'IAM' and click on it" -ForegroundColor White
Write-Host "3. Click 'Users' → Your username → 'Security credentials'" -ForegroundColor White
Write-Host "4. Click 'Create access key' → 'CLI' → 'Create'" -ForegroundColor White
Write-Host "5. Copy both Access Key ID and Secret Access Key" -ForegroundColor White
Write-Host ""

$configure = Read-Host "Do you want to configure AWS now? (y/n)"

if ($configure -eq 'y' -or $configure -eq 'Y') {
    Write-Host ""
    Write-Host "Running: aws configure" -ForegroundColor Green
    Write-Host "Please enter your AWS credentials when prompted:" -ForegroundColor Yellow
    Write-Host ""
    aws configure
    
    # Verify configuration
    Write-Host ""
    Write-Host "Verifying AWS configuration..." -ForegroundColor Yellow
    $verify = aws sts get-caller-identity 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ AWS configured successfully!" -ForegroundColor Green
        Write-Host $verify
    } else {
        Write-Host "✗ AWS configuration failed. Please check your credentials." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "⚠️  Skipping AWS configuration. You'll need to run 'aws configure' manually." -ForegroundColor Yellow
}

# Step 5: Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed Tools:" -ForegroundColor White
Write-Host "  ✓ Chocolatey" -ForegroundColor Green
Write-Host "  ✓ AWS CLI" -ForegroundColor Green
Write-Host "  ✓ Terraform" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. If you haven't configured AWS, run: aws configure" -ForegroundColor White
Write-Host "2. Navigate to: cd phase1-iac\terraform\aws" -ForegroundColor White
Write-Host "3. Initialize: terraform init" -ForegroundColor White
Write-Host "4. Deploy: terraform apply" -ForegroundColor White
Write-Host ""
Write-Host "Cost Warning: Deploying to AWS will cost ~$150/month" -ForegroundColor Red
Write-Host "To destroy resources later: terraform destroy" -ForegroundColor Yellow
Write-Host ""
