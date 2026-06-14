Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # Database VM
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.40"
  end

  # Web VM (Apache + PHP)
  config.vm.define "web" do |web|
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.56.41"
    web.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  end
end