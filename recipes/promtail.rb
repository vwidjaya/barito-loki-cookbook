#
# Cookbook:: barito-loki
# Recipe:: promtail
#
# Copyright:: 2019, The Authors, All Rights Reserved.

service_name = node[cookbook_name]['promtail']['service_name']

barito_loki_gz_install service_name do
  version node[cookbook_name]['promtail']['version']
  prefix_root node[cookbook_name]['prefix_root']
  prefix_bin node[cookbook_name]['prefix_bin']
  prefix_temp node[cookbook_name]['prefix_temp']
  mirror_gz node[cookbook_name]['promtail']['mirror_gz']
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
end

config_file = node[cookbook_name]['promtail']['config_file']
barito_loki_config_yml_file config_file do
  config node[cookbook_name]['promtail']['config']
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
end

bin = "#{node[cookbook_name]['prefix_bin']}/#{service_name}"
barito_loki_binary_systemd service_name do
  cli_opts node[cookbook_name]['promtail']['cli_opts']
  systemd_unit node[cookbook_name]['promtail']['systemd_unit']
  bin bin
  env_vars_file config_file
  prefix_log node[cookbook_name]['promtail']['prefix_log']
  log_file_name node[cookbook_name]['promtail']['log_file_name']
end
