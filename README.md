<p align="center"><img src="https://raw.githubusercontent.com/srowlands/govcms-devkit/master/docs/images/govcms-devkit-logo.png" alt="Drupal VM Logo" /></p>

[![Build Status](https://travis-ci.org/srowlands/govcms-devkit.svg?branch=master)](https://travis-ci.org/srowlands/govcms-devkit) [![Documentation Status](https://readthedocs.org/projects/drupal-vm/badge/?version=latest)](http://docs.drupalvm.com)

govCMS-devkit is a development environment builder based off the excellent [Drupal VM](http://www.drupalvm.com/), built with Vagrant + Ansible.

This project aims to make spinning up a local (VM) or remote (AWS) govCMS test/development environment using a standardised toolset.  It provides three options for install:
  1. Install in a local VM (VirtualBox, Parallels or VMware)
  2. Install on a remote AWS server
  3. Install on a remote AWS server (include CI with Jenkins)

It will install the following on an Ubuntu 14.04 (by default) linux environment:

  - Apache 2.4.x
  - PHP 5.5.x (configurable)
  - MySQL 5.5.x
  - Drush (configurable)
  - govCMS 2.x
  - Optional:
    - Varnish 4.x
    - Apache Solr 4.10.x (configurable)
    - Selenium, for testing your sites via Behat
    - Memcached
    - XHProf, for profiling your code
    - XDebug, for debugging your code
    - Adminer, for accessing databases directly
    - Pimp my Log, for easy viewing of log files
    - MailHog, for catching and debugging email
    - Jenkins, for building Pull Request environments

It should take 10-15 minutes to build or rebuild the VM from scratch on a decent broadband connection.

## Customizing the VM

This codebase comes with preconfigured config files for the govCMS distribution. There are a couple places where you can customize the VM for your needs:

  - `config.yml`: Contains variables like the VM domain name and IP address, PHP and MySQL configuration, etc.
  - `drupal.make`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (more about [Drush make files](https://www.drupal.org/node/1432374)).

## Quick Start Guide

This Quick Start Guide will help you quickly build a govCMS environment using the Drupal.org release of govCMS.

### Install dependencies (Vagrant, Ansible)

  1. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  2. [Mac/Linux only] Install [Ansible](http://docs.ansible.com/intro_installation.html).

  Note for Windows users: Ansible will be installed inside the VM, and everything will be configured internally (unlike on Mac/Linux hosts). See JJG-Ansible-Windows for more information.

  Note for Linux users: If NFS is not already installed on your host, you will need to install it to use the default NFS synced folder configuration. See guides for Debian/Ubuntu, Arch, and RHEL/CentOS.

  Note on versions: Please make sure you're running the latest stable version of Vagrant, VirtualBox, and Ansible, as the current version of Drupal VM is tested with the latest releases. As of June 2015: Vagrant 1.7.2, VirtualBox 4.3.26, and Ansible 1.9.2.

## Install in a local VM (VirtualBox, Parallels or VMware)

  1. Download this project and put it wherever you want.
  2. Configure for each VM platform as below:
    - VirtualBox:
      - Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
      - Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
      - Copy `example.config.vm-vbox.yml` to `config.yml` 
    - Parallels:
      - Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
      - Copy `example.config.vm-parallels.yml` to `config.yml`
    - Type in `vagrant plugin install vagrant-parallels`
    - VMware
      - Download and install the [Vagrant VMware integration plugin](http://www.vagrantup.com/vmware)
      - Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
      - Copy `example.config.vm-vmware.yml` to `config.yml`
  2. Create a local directory (default /var/www/govcms-vm) where govCMS will be installed. You may change this location in `config.yml` (`local_path`, inside `vagrant_synced_folders`).
  3. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  4. [Mac/Linux only] Install Ansible Galaxy roles required for this VM: `$ sudo ansible-galaxy install -r provisioning/requirements.yml --force`
  5. Run `vagrant plugin install vagrant-hostmanager` to add entries to your hosts file for you
  5. Type in `vagrant up`, and let Vagrant do its magic.
  6. Once complete open your browser and access [http://govcms.dev/](http://govcms.dev/). The default login for this admin account is `admin` for both username and password.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### Extra software/utilities

By default, this VM includes the extras listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - adminer
      # - jenkins
      - mailhog
      - memcached
      - pimpmylog
      # - solr
      # - selenium
      - varnish
      - xdebug
      - xhprof

If you don't want or need one or more of these extras, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

### Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `config.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](https://leanpub.com/ansible-for-devops).

## Install on a remote AWS server

  1. Login to the [EC2 console](https://console.aws.amazon.com/ec2/home) and generate a new key-pair in the region you wish to provision (default is Sydney ap-southeast-2).
  2. Create a new security group ensuring (at least) SSH access is allowed anywhere (port 22) to install.
  3. Download this project and put it wherever you want.
  4. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  5. Copy `example.config.aws.yml` to `config.yml`
  6. Edit the `config.yml` file and provide AWS key, secret, and path to key-pair .pem file.
  7. Run `vagrant plugin install vagrant-aws` to install the [AWS provider](https://github.com/mitchellh/vagrant-aws)
  8. Run `vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box` to add a dummy box
  9. Run `vagrant plugin install vagrant-hostmanager` to add entries to your hosts file for you
  9. Run `vagrant up --provider=aws`
  10. Visit http://govcms.dev/ in a browser

## Install on a remote AWS server (include CI with Jenkins)

This will install Jenkins and pre-configure with a pull-request environment builder, which will:
  - Monitor GitHub repository of your choosing for new Pull Requests
  - Clone the current master dev database & files into a new environment with PR code merged into master
  - Comment on Pull Requests with a success/fail message and link to new PR environment

It makes the following assumptions:
  - Your GitHub repository contains a Drupal theme folder at the root of the repository.

### Pre-build actions

In order to use the pre-configured Jenkins pull-request environment builder you will need to perform the following steps:

  1. Prepare AWS/EC2
    - Allocate a new elastic IP in the EC2 console, take note of this IP address to enter in config.yml.
    - Ensure you have a security group configured in EC2 that allows incoming TCP connections in port 22,80,8000 from valid IPs

  2. Prepare GitHub
    - Create a new GitHub repository containing 1 or more drupal themes at the root (public or private).
    - Create a new GitHub 'bot' user and [add an SSH key](https://github.com/settings/ssh).
      - The user needs to have administrator rights for your repository (must be owner (user repo) or must have Push, Pull & Administrative rights (organization repo))
    - Generate a new [Personal Access Token](https://github.com/settings/tokens/new) and store somewhere safe.
      - Needs repo, gist, notifications, user, admin:* scopes

  3. Perform the same steps as above (remote AWS server), but copy the `example.config.aws-jenkins.yml` file instead at step 5.
  4. Update the additional variables in the `config.yml` file:
    - `jenkins_github_repo` (git URL to theme repository to monitor)
    - `jenkins_github_url` (URL to GitHub repository)
    - `jenkins_github_stub` (GitHub stub)
    - `jenkins_github_token` (token value generated above)
    - `aws_elastic_ip` (IP address allocated above)
  5. Once complete, visit http://govcms.dev:8000/ in a browser.

  6. Prepare Jenkins
    - [RECOMMENDED] Configure Jenkins security to avoid non-authenticated access.
    - Go to the [job configuration screen](http://govcms.dev:8000/job/govcms_pull_request_builder/configure).
    - Under "Source Code Management" section add credentials (SSH Username with private key).
      - This should be the SSH key allocated to the 'bot' user above. Remember to enter the passphrase if you entered one when generating.
    - Under "Build Environment > SSH Agent Credentials" select the same credentials created above.
    - Under "Build Environment > Job Passwords" paste the token value into the `GITHUB_TOKEN` password field.


## License

This project is licensed under the MIT open source license.

## Author
  - Stuart Rowlands (stuart.rowlands@acquia.com)

## Credits
  - [Jeff Geerling](http://jeffgeerling.com/) for Drupal-VM, which this project is based on.
  - [Lullabot](http://lullabot.com/) for the example Jenkins PRB scripts.

<p align="center"><img src="https://raw.githubusercontent.com/srowlands/govcms-devkit/master/docs/images/drupal-vm-logo.png" alt="Drupal VM Logo" /></p>

## About Drupal-VM

Please read the [Drupal VM Wiki](https://github.com/geerlingguy/drupal-vm/wiki) for help getting Drupal VM configured and integrated with your development workflow.

[Jeff Geerling](http://jeffgeerling.com/), owner of [Midwestern Mac, LLC](http://www.midwesternmac.com/), created this project in 2014 so he could accelerate his Drupal core and contrib development workflow. This project, and others like it, are also featured as examples in Jeff's book, [Ansible for DevOps](https://leanpub.com/ansible-for-devops).

### Documentation

Full Drupal VM documentation is available at http://docs.drupalvm.com/

## Using Drupal VM

Drupal VM is built to integrate with every developer's workflow. Many guides for using Drupal VM for common development tasks are available on the [Drupal VM Wiki](https://github.com/geerlingguy/drupal-vm/wiki):

  - [Syncing Folders](http://docs.drupalvm.com/en/latest/extras/syncing-folders/)
  - [Connect to the MySQL Database](http://docs.drupalvm.com/en/latest/extras/mysql/)
  - [Use Apache Solr for Search](http://docs.drupalvm.com/en/latest/extras/solr/)
  - [Use Drush with Drupal VM](http://docs.drupalvm.com/en/latest/extras/drush/)
  - [Use Drupal Console with Drupal VM](http://docs.drupalvm.com/en/latest/extras/drupal-console/)
  - [Use Varnish with Drupal VM](http://docs.drupalvm.com/en/latest/extras/varnish/)
  - [Use MariaDB instead of MySQL](http://docs.drupalvm.com/en/latest/extras/mariadb/)
  - [View Logs with Pimp my Log](http://docs.drupalvm.com/en/latest/extras/pimpmylog/)
  - [Profile Code with XHProf](http://docs.drupalvm.com/en/latest/extras/xhprof/)
  - [Debug Code with XDebug](http://docs.drupalvm.com/en/latest/extras/xdebug/)
  - [Catch Emails with MailHog](http://docs.drupalvm.com/en/latest/extras/mailhog/)
  - [Test with Behat and Selenium](http://docs.drupalvm.com/en/latest/extras/behat/)
  - [PHP 7 on Drupal VM](http://docs.drupalvm.com/en/latest/other/php-7/)
  - [Drupal 6 Notes](http://docs.drupalvm.com/en/latest/other/drupal-6/)
