# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# Use config.yml for basic VM configuration.
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
if !File.exist?("#{dir}/config.yml")
  raise 'Configuration file not found! Please copy example.config.yml to config.yml and try again.'
end
vconfig = YAML::load_file("#{dir}/config.yml")

# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Support multiple machines https://docs.vagrantup.com/v2/multi-machine/
  config.vm.define vconfig['vagrant_machine_name'] do |box_config|

    box_config.vm.hostname = vconfig['vagrant_hostname']
    box_config.vm.network :private_network, ip: vconfig['vagrant_ip']
    box_config.ssh.insert_key = false
    box_config.ssh.forward_agent = true

    box_config.vm.box = vconfig['vagrant_box']

    # If hostsupdater plugin is installed, add all servernames as aliases.
    if Vagrant.has_plugin?("vagrant-hostsupdater")
      box_config.hostsupdater.aliases = []
      for host in vconfig['apache_vhosts']
        # Add all the hosts that aren't defined as Ansible vars.
        unless host['servername'].include? "{{"
          box_config.hostsupdater.aliases.push(host['servername'])
        end
      end
    end

    # If hostsmanager plugin is installed
    if Vagrant.has_plugin?("vagrant-hostmanager")
      box_config.vm.provision :hostmanager

      box_config.hostmanager.enabled = true
      box_config.hostmanager.manage_host = true
      box_config.hostmanager.ignore_private_ip = false
      box_config.hostmanager.include_offline = true
      box_config.hostmanager.aliases = []
      for host in vconfig['apache_vhosts']
        # Add all the hosts that aren't defined as Ansible vars.
        unless host['servername'].include? "{{"
          box_config.hostmanager.aliases.push(host['servername'])
        end
      end
    end

    for synced_folder in vconfig['vagrant_synced_folders'];
      box_config.vm.synced_folder synced_folder['local_path'], synced_folder['destination'],
        disabled: vconfig['vagrant_sync_disable'],
        type: synced_folder['type'],
        rsync__auto: "true",
        rsync__exclude: synced_folder['excluded_paths'],
        rsync__args: ["--verbose", "--archive", "--delete", "-z", "--chmod=ugo=rwX"],
        id: synced_folder['id'],
        create: synced_folder.include?('create') ? synced_folder['create'] : false,
        mount_options: synced_folder.include?('mount_options') ? synced_folder['mount_options'] : []
    end

    if is_windows
      # Provisioning configuration for shell script (for Windows).
      box_config.vm.provision "shell" do |sh|
        sh.path = "#{dir}/provisioning/JJG-Ansible-Windows/windows.sh"
        sh.args = "/provisioning/playbook.yml"
      end
    else
      # Provisioning configuration for Ansible (for Mac/Linux hosts).
      box_config.vm.provision "ansible" do |ansible|
        ansible.playbook = "#{dir}/provisioning/playbook.yml"
        ansible.sudo = true
      end
    end

    # VMware Fusion.
    box_config.vm.provider :vmware_fusion do |v, override|
      # HGFS kernel module currently doesn't load correctly for native shares.
      override.vm.synced_folder ".", "/vagrant", type: 'nfs'

      v.gui = false
      v.vmx["memsize"] = vconfig['vagrant_memory']
      v.vmx["numvcpus"] = vconfig['vagrant_cpus']
    end

    # VirtualBox.
    box_config.vm.provider :virtualbox do |v|
      v.name = vconfig['vagrant_hostname']
      v.memory = vconfig['vagrant_memory']
      v.cpus = vconfig['vagrant_cpus']
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    # Parallels.
    box_config.vm.provider :parallels do |p, override|
      override.vm.box = vconfig['vagrant_box']
      p.name = vconfig['vagrant_hostname']
      p.memory = vconfig['vagrant_memory']
      p.cpus = vconfig['vagrant_cpus']
    end


    # AWS.
    box_config.vm.provider :aws do |aws, override|
      aws.access_key_id = vconfig['aws_access_key_id']
      aws.secret_access_key = vconfig['aws_secret_key']
      aws.keypair_name = vconfig['aws_keypair_name']
      aws.security_groups = vconfig['aws_security_groups']

      aws.region = vconfig['aws_region']
      aws.ami = vconfig['aws_ami']
      aws.instance_type = vconfig['aws_instance_type']
      aws.elastic_ip = vconfig['aws_elastic_ip']

      override.ssh.username = vconfig['vagrant_user']
      override.ssh.private_key_path = vconfig['aws_ssh_private_key']
    end

  end
end
