BOX_IMAGE = "ubuntu/bionic64"
NODE_COUNT = 3

Vagrant.configure("2") do |config|

#  config.vm.provision "ansible" do |ansible|
#    ansible.playbook = "provisioning/common.yml"
#  end

  config.vm.provision :shell, path: "bootstrap.sh", privileged: true

  (1..NODE_COUNT).each do |i|
    config.vm.define "server#{i}" do |server|
      server.vm.box = BOX_IMAGE
      server.vm.hostname = "server#{i}"
      server.vm.network "private_network", ip: "10.0.5.3#{i}"
      server.vm.provider "virtualbox" do |v|
          v.memory = 768
          v.cpus = 1
          unless File.exist?("disk2-server#{i}.vdi")
          v.customize ['createhd', '--format', 'VDI', '--filename', "disk2-server#{i}.vdi", '--size', 4096] # size is in MB
          end
          v.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "disk2-server#{i}.vdi"]
      end
    end
  end
end
