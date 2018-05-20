Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "machine-hostname"

  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__auto: true

  #Forward HTTP port
  config.vm.network "forwarded_port", guest: 80, host: 8081
  #Forward MySQL port
  config.vm.network "forwarded_port", guest: 3306, host: 3306 

  #TODO: TEST
  #config.vm.provider "virtualbox" do |vb|
  #  vb.memory = "512"
  #  vb.cpus = 1
  #end


  # Provision env tools (repos, tools, etc)
  config.vm.provision "shell", path: "provision-scripts/setup_tools.sh"

  # Provision HTTP server
  config.vm.provision 'shell' do |s|
    apache_servername = 'machine-hostname.dev'
    apache_dirpath = '/vagrant'
    apache_port = '80'
    apache_directives = ''
    s.path = 'provision-scripts/setup_apache.sh'
    s.args = [apache_servername, apache_dirpath, apache_port, apache_directives]
  end

  # Provision PHP
  config.vm.provision 'shell' do |s|
    s.path = 'provision-scripts/setup_php.sh'
  end

  # Provision MariaDB
  config.vm.provision 'shell' do |s|
    mariadb_username = 'username'
    mariadb_password = 'password'
    mariadb_rootpassword = 'root'
    mariadb_database = 'dbname'
    s.path = 'provision-scripts/setup_mariadb.sh'
    s.args = [mariadb_username, mariadb_password, mariadb_rootpassword, mariadb_database]
  end

end
