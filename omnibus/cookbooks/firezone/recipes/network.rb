# frozen_string_literal: true

# Cookbook:: firezone
# Recipe:: network
#
# Copyright:: 2021, FireZone, All Rights Reserved.

# Set up wireguard interface, default routes, and firewall
# rules so that FireZone can run without a hitch.
#
# This recipe basically performs the work of wg-quick without having to
# have a configuration file.

include_recipe 'firezone::config'
include_recipe 'line::default'

require 'mixlib/shellout'

wg_path = "#{node['firezone']['install_directory']}/embedded/bin/wg"
nft_path = "#{node['firezone']['install_directory']}/embedded/sbin/nft"
awk_path = "#{node['firezone']['install_directory']}/embedded/bin/awk"
wg_interface = node['firezone']['wireguard']['interface_name']
private_key_path = "#{node['firezone']['var_directory']}/cache/wg_private_key"

# Some distros don't have route in PATH, look in /sbin
route = Mixlib::ShellOut.new("whereis route | cut -f 2 -d' '").run_command.stdout.chomp
egress_cmd = Mixlib::ShellOut.new("#{route} | grep '^default' | grep -o '[^ ]*$'")
egress_interface = egress_cmd.run_command.stdout.chomp

# Set default endpoint ip to default egress ip
egress_cmd = "ip address show dev #{egress_interface} | grep 'inet ' | #{awk_path} '{print $2}'"
egress_ip = Mixlib::ShellOut.new(egress_cmd)
egress_ip.run_command
node.default['firezone']['wireguard']['endpoint_ip'] =
  egress_ip.stdout.chomp.gsub(%r{/.*}, '')
node.default['firezone']['egress_interface'] = egress_interface

# Create wireguard interface if missing
wg_exists = Mixlib::ShellOut.new("ip link show dev #{wg_interface}")
wg_exists.run_command
if wg_exists.status.exitstatus == 1
  execute 'create_wireguard_interface' do
    command "ip link add #{wg_interface} type wireguard"
  end
end

execute 'setup_wireguard_ip' do
  # XXX: Make this configurable
  if_addr = '10.3.2.1/24'
  command "ip address replace #{if_addr} dev #{wg_interface}"
end

execute 'set_wireguard_interface_private_key' do
  command "#{wg_path} set #{wg_interface} private-key #{private_key_path}"
end

execute 'set_listen_port' do
  listen_port = node['firezone']['wireguard']['port']
  command "#{wg_path} set #{wg_interface} listen-port #{listen_port}"
end

execute 'set_mtu' do
  command "ip link set mtu 1420 up dev #{wg_interface}"
end

route '10.3.2.0/24' do
  # XXX: Make this configurable
  device wg_interface
end

replace_or_add "IPv4 packet forwarding" do
  path "/etc/sysctl.conf"
  pattern "^#net.ipv4.ip_forward=1"
  line "net.ipv4.ip_forward=1"
end

replace_or_add "IPv6 packet forwarding" do
  path "/etc/sysctl.conf"
  pattern "^#net.ipv6.conf.all.forwarding=1"
  line "net.ipv6.conf.all.forwarding=1"
end

execute "sysctl -p /etc/sysctl.conf"
