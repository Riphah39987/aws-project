# 🚀 AWS Deployment - Manual Installation Guide

## Step-by-Step Installation (Choose One Method)

---

## ⚡ METHOD 1: Quick Install (Recommended)

### Install AWS CLI:
1. Download: https://awscli.amazonaws.com/AWSCLIV2.msi
2. Run the installer
3. Click "Next" → "Next" → "Install"
4. **Restart PowerShell** after installation

### Install Terraform:
1. Download: https://developer.hashicorp.com/terraform/install
2. Click "Windows" → "AMD64"
3. Extract the ZIP file
4. Move `terraform.exe` to: `C:\Windows\System32\`
5. **Restart PowerShell**

---

## 🔧 METHOD 2: Using Chocolatey

### Install Chocolatey first:
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Then install tools:
```powershell
# Install AWS CLI
choco install awscli -y

# Install Terraform
choco install terraform -y

# Restart PowerShell
```

---

## ✅ VERIFY INSTALLATION

After installing, **close and reopen PowerShell**, then run:

```powershell
# Check AWS CLI
aws --version
# Should show: aws-cli/2.x.x

# Check Terraform
terraform version
# Should show: Terraform v1.x.x
```

---

## 🔑 CONFIGURE AWS CREDENTIALS

Once both are installed:

```powershell
aws configure
```

You'll be asked for:
1. **AWS Access Key ID**: Get from AWS Console → IAM → Users → Security credentials
2. **AWS Secret Access Key**: From the same place
3. **Default region**: Enter `us-east-1`
4. **Default output format**: Enter `json`

### Verify AWS is configured:
```powershell
aws sts get-caller-identity
```

Should show your AWS account info.

---

## 🚀 DEPLOY TO AWS

Once everything is installed and configured:

```powershell
# 1. Navigate to AWS Terraform folder
cd E:\DEV\devops-multicloud-project\phase1-iac\terraform\aws

# 2. Initialize Terraform
terraform init

# 3. See what will be created
terraform plan

# 4. Deploy! (will ask for confirmation)
terraform apply
```

Type `yes` when prompted.

---

## ⏱️ DEPLOYMENT TIME

- **terraform init**: ~30 seconds
- **terraform plan**: ~1 minute
- **terraform apply**: ~15-20 minutes

---

## 💰 COST WARNING

This will create:
- EKS Cluster: $73/month
- EC2 Instances: ~$30/month
- RDS Database: ~$15/month
- NAT Gateway: ~$32/month

**Total: ~$150/month**

To destroy later: `terraform destroy`

---

## 🆘 TROUBLESHOOTING

### "aws not recognized"
- Restart PowerShell
- Check if installed: `C:\Program Files\Amazon\AWSCLIV2\aws.exe`
- Add to PATH if needed

### "terraform not recognized"
- Restart PowerShell
- Check if `terraform.exe` is in `C:\Windows\System32\`
- Or add Terraform folder to PATH

### "Access Denied" errors
- Make sure you ran `aws configure`
- Check your Access Keys are correct
- Verify with: `aws sts get-caller-identity`

---

## 📋 QUICK CHECKLIST

- [ ] AWS CLI installed (`aws --version`)
- [ ] Terraform installed (`terraform version`)
- [ ] AWS configured (`aws configure`)
- [ ] AWS verified (`aws sts get-caller-identity`)
- [ ] Ready to deploy!

---

## 🎯 NEXT STEPS AFTER INSTALLATION

1. ✅ Install AWS CLI
2. ✅ Install Terraform
3. ✅ Restart PowerShell
4. ✅ Run `aws configure`
5. ✅ Verify with `aws sts get-caller-identity`
6. ✅ Navigate to: `cd phase1-iac\terraform\aws`
7. ✅ Run: `terraform init`
8. ✅ Run: `terraform apply`

---

**Let me know when AWS CLI and Terraform are installed, and I'll help you deploy!** 🚀
