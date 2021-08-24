# Automated Deployment using Ansible

This folder contains automation scripts to deploy the app using Ansible, to ease deployment. Our hosts, which contains our developed app can triggers and transfer files to the deployment target, which is a GCP Virtual Machine.

There are two ansible `playbook` files, one for building the app, and one for installation to the GCP VM. And there is an ansible `inventory` file, to store the target host of deployment.

## How to Run

After preparing your target deployment

1. Install ansible on your local machine and the target deployment.
2. Run `ansible-playbook playbook.build.yml --inventory inventory.yml` to build the app on your local machine.
3. Run `ansible-playbook playbook.deploy.yml --inventory inventory.yml` to install the app to the target deployment.
4. SSH access to your deployment machine, and run `bundle install --path vendor/bundle` and run the app.(*)

## (*) Issue

This scripts has an issue in the installation process. When trying to install the ruby gems, ansible can't execute bundler in our rbenv environment. Hence, the gem installation and app run must be done manually with `ssh`. (At least we saved enough effort already to execute our tedious build-unbuild app scripts😎).