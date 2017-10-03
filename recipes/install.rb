#
# Cookbook Name:: 
# Recipe:: install
#
# Copyright 2017, tuneduc
#
# All rights reserved - Do Not Redistribute
#

apt_update 'update'

execute 'apt-get-install-linux-image' do
  command 'apt-get -y install linux-image-extra-$(uname -r)'
end

util = [ 'linux-image-extra-virtual', 'apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common' ]

util.each do |p|
  apt_package p do
    action :install
  end
end

execute 'Add Repo Docker' do
  command 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -'
end

apt_repository 'docker-ubuntu' do
  uri          'https://download.docker.com/linux/ubuntu'
  arch         'amd64'
  distribution 'trusty'
  components   ['stable']
  action :add
end

apt_update 'update'

execute 'apt-get-upgrade' do
  command 'apt-get -y upgrade'
end

apt_package 'docker-ce' do
  action :install
end

execute 'Install Docker Compose' do
  command 'curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'
end

file "/usr/local/bin/docker-compose" do
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'remove-python3.4' do
  command 'apt -y purge python3 python3-gi python3-minimal python3.4 python3.4-minimal libpython3.4-stdlib:amd64 libpython3.4-minimal:amd64 libpython3-stdlib:amd64'
end

apt_repository 'python3.6' do
  uri          'ppa:jonathonf/python-3.6'
  action :add
end

apt_package 'python3.6' do
  action :install
end

execute 'install-pip3' do
  command 'wget https://bootstrap.pypa.io/get-pip.py && python3.6 get-pip.py'
end

execute 'install-pipenv' do
  command 'pip3 install pipenv'
end

execute 'install-flask' do
  command 'pip3 install Flask'
end

execute 'install-gunicorn' do
  command 'pip3 install gunicorn'
end

