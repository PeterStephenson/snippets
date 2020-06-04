#!/bin/bash

# Ubuntu setup

# Allow HTTPS packages
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

sudo apt-get update

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Beyond Compare
wget https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb
sudo apt-get update
sudo apt-get install gdebi-core
sudo gdebi bcompare-4.3.4.24657_amd64.deb

# VS code
sudo snap install --classic code

# Git
sudo apt install git
git config --global user.name "Peter Stephenson"
git config --global user.email "github@peter-stephenson.co.uk"
git config --global alias.recent "log -10 --oneline"

git config --global merge.tool bc
git config --global diff.tool bc

git config --global core.editor "code --wait"

sudo apt-get install xclip

ssh-keygen

# Rider
sudo snap install rider --classic
echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# .Net Core
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install dotnet-sdk-3.1
sudo apt-get install aspnetcore-runtime-3.1

# Powershell
sudo snap install powershell --classic

pwsh -c "PowerShellGet\Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force"
echo "Import-Module Posh-Git" | sudo tee .config/powershell/Microsoft.PowerShell_profile.ps1

echo "function Launch-Rider {                                                     
  param ( [string]$file ) 
  Start-Process rider.sh $file -RedirectStandardError /dev/null
}" | sudo tee -a .config/powershell/Microsoft.PowerShell_profile.ps1

echo "Set-Alias -Name rider -Value Launch-Rider" | sudo tee -a .config/powershell/Microsoft.PowerShell_profile.ps1

# JS
sudo apt install nodejs
sudo apt install npm

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
