#!/bin/bash
set -euo pipefail

############################################
# System Updates & Base Tools
############################################
dnf update -y
dnf install -y dnf-plugins-core unzip wget curl python3 python3-pip

############################################
# Install AWS CLI v2
############################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

############################################
# Install Terraform (HashiCorp Repo)
############################################
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf install -y terraform

############################################
# Install Java 21 (Amazon Corretto)
############################################
dnf install -y java-21-amazon-corretto-devel fontconfig

############################################
# Install Jenkins
############################################
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install -y jenkins

############################################
# Jenkins Temp Directory Fix
############################################
mkdir -p /var/lib/jenkins/tmp
chown jenkins:jenkins /var/lib/jenkins/tmp
chmod 700 /var/lib/jenkins/tmp

mkdir -p /etc/systemd/system/jenkins.service.d
cat > /etc/systemd/system/jenkins.service.d/override.conf <<'EOF'
[Service]
Environment="JAVA_OPTS=-Djava.io.tmpdir=/var/lib/jenkins/tmp"
EOF

############################################
# Install Jenkins Plugins
############################################
curl -fLs -o /tmp/jenkins-plugin-manager.jar \
  https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.14.0/jenkins-plugin-manager-2.14.0.jar

curl -fLs -o /tmp/plugins.yaml \
  https://raw.githubusercontent.com/aaron-dm-mcdonald/new-jenkins-s3-test/refs/heads/main/plugins.yaml

sudo -u jenkins java -jar /tmp/jenkins-plugin-manager.jar \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory /var/lib/jenkins/plugins \
  --plugin-file /tmp/plugins.yaml

############################################
# Start Jenkins
############################################
systemctl daemon-reload
systemctl enable --now jenkins

############################################
# Log Versions for BAM‑1 Verification
############################################
echo "===== Installed Versions ====="
terraform -version
aws --version
python3 --version
java --version
echo "=============================="
