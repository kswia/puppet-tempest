# class for installing and configuring tempest
#
# The class checks out the tempest repo and sets the basic config.
#
# Note that only parameters for which values are provided will be
# managed in tempest.conf.
#
class tempest(
  # Clone config
  #
  $tempest_repo_uri                         = 'git://github.com/openstack/tempest.git',
  $tempest_repo_revision                    = 'stable/havana',
  $tempest_clone_path                       = '/var/lib/tempest',
  $tempest_clone_owner                      = 'root',
  $setup_venv                               = false,

  # Glance image config
  #
  $configure_images                         = true,
  $image_name                               = undef,
  $image_name_alt                           = undef,

  # Neutron network config
  #
  $configure_networks                       = true,
  $public_network_name                      = undef,

  # [identity]
  #
  $identity_catalog_type                    = 'identity',
  $disable_ssl_certificate_validation       = false,
  $identity_uri                             = 'http://127.0.0.1:5000/v2.0/',
  $identity_uri_v3                          = 'http://127.0.0.1:5000/v3/',
  $identity_region                          = 'RegionOne',

  # non admin user
  $username                                 = 'demo',
  $password                                 = 'secret',
  $tenant_name                              = 'demo',
  # another non-admin user
  $alt_username                             = 'alt_demo',
  $alt_password                             = 'secret',
  $alt_tenant_name                          = 'alt_demo',
  # admin user
  $admin_username                           = 'admin',
  $admin_password                           = 'secret',
  $admin_tenant_name                        = 'admin',
  $admin_role                               = 'admin',

  # [compute]
  #
  $allow_tenant_isolation                   = true,
  $allow_tenant_reuse                       = true,
  $image_ref                                = undef,
  $image_ref_alt                            = undef,
  $flavor_ref                               = '1',
  $flavor_ref_alt                           = '2',
  $image_ssh_user                           = 'root',
  $image_ssh_password                       = 'password',
  $image_alt_ssh_user                       = 'root',
  $compute_build_interval                   = '10',
  $compute_build_timeout                    = '600',
  $compute_run_ssh                          = false,
  $compute_ssh_user                         = 'cirros',
  $fixed_network_name                       = 'private',
  $network_for_ssh                          = 'public',
  $ip_version_for_ssh                       = '4',
  $compute_ping_timeout                     = '60',
  $compute_ssh_timeout                      = '300',
  $ready_wait                               = '0',
  $ssh_channel_timeout                      = '60',
  $use_floatingip_for_ssh                   = true,
  $compute_catalog_type                     = 'compute',
  $compute_region                           = undef,
  $create_image_enabled                     = true,
  $resize_available                         = true,
  $change_password_available                = true,
  $live_migration_available                 = false,
  $use_block_migration_for_live_migration   = false,
  $block_migrate_supports_cinder_iscsi      = false,
  $disk_config_enabled                      = true,
  $flavor_extra_enabled                     = true,
  $volume_device_name                       = 'vdb',

  # [compute-admin]
  #
  $compute_a_username                       = undef,
  $compute_a_password                       = undef,
  $compute_a_tenant                         = undef,

  # [image]
  #
  $image_catalog_type                       = 'image',
  $image_region                             = undef,
  $image_api_version                        = '1',
  $http_image                               = 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-uec.tar.gz',

  # [network]
  #
  $network_api_version                      = '1',
  $network_catalog_type                     = 'network',
  $network_region                           = undef,
  $tenant_network_cidr                      = '10.100.0.0/16',
  $tenant_network_mask_bits                 = '24',
  $tenant_networks_reachable                = false,
  $public_network_id                        = undef,
  # Upstream has a bad default - set it to empty string.
  $public_router_id                         = '',

  # [volume]
  #
  $volume_catalog_type                      = 'volume',
  $volume_region                            = undef,
  $disk_format                              = 'raw',
  $volume_build_interval                    = '10',
  $volume_build_timeout                     = '300',
  $multi_backend_enabled                    = false,
  $backend1_name                            = 'BACKEND_1',
  $backend2_name                            = 'BACKEND_2',
  $storage_protocol                         = 'iSCSI',
  $vendor_name                              = 'Open Source',

  # [object-storage]
  #
  $object_s_catalog_type                    = 'object-store',
  $object_s_region                          = undef,
  $container_sync_timeout                   = '120',
  $container_sync_interval                  = '5',
  $accounts_quotas_available                = true,
  $container_quotas_available               = true,
  $operator_role                            = 'Member',

  # [boto]
  #
  $ec2_url                                  = 'http://localhost:8773/services/Cloud',
  $s3_url                                   = 'http://localhost:3333',
  $aws_access                               = undef,
  $aws_secret                               = undef,
  $s3_materials_path                        = '/opt/stack/devstack/files/images/s3-materials/cirros-0.3.1',
  $ari_manifest                             = 'cirros-0.3.1-x86_64-initrd.manifest.xml',
  $ami_manifest                             = 'cirros-0.3.1-x86_64-blank.img.manifest.xml',
  $aki_manifest                             = 'cirros-0.3.1-x86_64-vmlinuz.manifest.xml',
  $instance_type                            = 'm1.tiny',
  $http_socket_timeout                      = '5',
  $boto_num_retries                         = '1',
  $boto_build_timeout                       = '120',
  $boto_build_interval                      = '1',

  # [orchestration]
  #
  $orch_region                              = undef,
  $orch_build_interval                      = '1',
  $build_timeout                            = '300',
  $instance_type                            = 'm1.micro',
  $image_ref                                = 'ubuntu-vm-heat-cfntools',
  $orch_keypair_name                        = undef,

  #[dashboard]
  #
  $dashboard_url                            = 'http://localhost/',
  $dash_login_url                           = 'http://localhost/auth/login/',

  # [scenario]
  #
  $scn_img_dir                              = '/opt/stack/new/devstack/files/images/cirros-0.3.1-x86_64-uec',
  $scn_ami_img_file                         = 'cirros-0.3.1-x86_64-blank.img',
  $scn_ari_img_file                         = 'cirros-0.3.1-x86_64-initrd',
  $scn_aki_img_file                         = 'cirros-0.3.1-x86_64-vmlinuz',
  $scn_ssh_user                             = 'cirros',
  $scn_large_ops_number                     = '0',

  # [cli]
  #
  $cli_enabled                              = true,
  $cli_dir                                  = '/usr/local/bin',
  $cli_timeout                              = '15',


  # [service_available]
  #
  $cinder_available                         = true,
  $neutron_available                        = false,
  $glance_available                         = true,
  $swift_available                          = true,
  $nova_available                           = true,
  $heat_available                           = false,
  $horizon_available                        = false,

  # [stress]
  #
  $stress_max_instances                     = '32',
  $log_check_interval                       = '60',
  $default_thread_number_per_action         = '4',

  # [debug]
  #
  $debug_enable                             = true,
) {

  include 'tempest::params'

  ensure_packages([
    'git',
    'python-setuptools',
  ])

  ensure_packages($tempest::params::dev_packages)

  exec { 'install-pip':
    command => '/usr/bin/easy_install pip',
    unless  => '/usr/bin/which pip',
    require => Package['python-setuptools'],
  }

  exec { 'install-tox':
    command => "${tempest::params::pip_bin_path}/pip install -U tox",
    unless  => '/usr/bin/which tox',
    require => Exec['install-pip'],
  }

  vcsrepo { $tempest_clone_path:
    ensure   => 'present',
    source   => $tempest_repo_uri,
    revision => $tempest_repo_revision,
    provider => 'git',
    require  => Package['git'],
    user     => $tempest_clone_owner,
  }

  if $setup_venv {
    # virtualenv will be installed along with tox
    exec { 'setup-venv':
      command => "/usr/bin/python ${tempest_clone_path}/tools/install_venv.py",
      cwd     => $tempest_clone_path,
      unless  => "/usr/bin/test -d ${tempest_clone_path}/.venv",
      require => [
        Vcsrepo[$tempest_clone_path],
        Exec['install-tox'],
      ],
    }
  }

  $tempest_conf = "${tempest_clone_path}/etc/tempest.conf"

  file { $tempest_conf:
    replace => false,
    source  => "${tempest_conf}.sample",
    require => Vcsrepo[$tempest_clone_path],
    owner   => $tempest_clone_owner,
  }

  Tempest_config {
    path    => $tempest_conf,
    require => File[$tempest_conf],
  }

  tempest_config {
    'identity/catalog_type':                            value => $identity_catalog_type;
    'identity/disable_ssl_certificate_validation':      value => $disable_ssl_certificate_validation;
    'identity/uri':                                     value => $identity_uri;
    'identity/uri_v3':                                  value => $identity_uri_v3;
    'identity/identity_region':                         value => $identity_region;
    'identity/username':                                value => $username;
    'identity/password':                                value => $password;
    'identity/tenant_name':                             value => $tenant_name;
    'identity/alt_username':                            value => $alt_username;
    'identity/alt_password':                            value => $alt_password;
    'identity/alt_tenant_name':                         value => $alt_tenant_name;
    'identity/admin_username':                          value => $admin_username;
    'identity/admin_password':                          value => $admin_password;
    'identity/admin_tenant_name':                       value => $admin_tenant_name;
    'identity/admin_role':                              value => $admin_role;
    'compute/allow_tenant_isolation':                   value => $allow_tenant_isolation;
    'compute/allow_tenant_reuse':                       value => $allow_tenant_reuse;
    'compute/image_ref':                                value => $image_ref;
    'compute/image_ref_alt':                            value => $image_ref_alt;
    'compute/flavor_ref':                               value => $flavor_ref;
    'compute/flavor_ref_alt':                           value => $flavor_ref_alt;
    'compute/image_ssh_user':                           value => $image_ssh_user;
    'compute/image_alt_ssh_user':                       value => $image_alt_ssh_user;
    'compute/build_interval':                           value => $compute_build_interval;
    'compute/build_timeout':                            value => $compute_build_timeout;
    'compute/run_ssh':                                  value => $compute_run_ssh;
    'compute/ssh_user':                                 value => $compute_ssh_user;
    'compute/fixed_network_name':                       value => $fixed_network_name;
    'compute/network_for_ssh':                          value => $network_for_ssh;
    'compute/ip_version_for_ssh':                       value => $ip_version_for_ssh ;
    'compute/ping_timeout':                             value => $compute_ping_timeout;
    'compute/ssh_timeout':                              value => $compute_ssh_timeout;
    'compute/ready_wait':                               value => $ready_wait;
    'compute/ssh_channel_timeout':                      value => $ssh_channel_timeout;
    'compute/use_floatingip_for_ssh':                   value => $use_floatingip_for_ssh;
    'compute/catalog_type':                             value => $compute_catalog_type ;
    'compute/region':                                   value => $compute_region;
    'compute/create_image_enabled':                     value => $create_image_enabled ;
    'compute/resize_available':                         value => $resize_available;
    'compute/change_password_available':                value => $change_password_available;
    'compute/live_migration_available':                 value => $live_migration_available;
    'compute/use_block_migration_for_live_migration':   value => $use_block_migration_for_live_migration;
    'compute/block_migrate_supports_cinder_iscsi':      value => $block_migrate_supports_cinder_iscsi;
    'compute/disk_config_enabled':                      value => $disk_config_enabled ;
    'compute/flavor_extra_enabled':                     value => $flavor_extra_enabled;
    'compute/volume_device_name':                       value => $volume_device_name;
    'compute_admin/username':                           value => $compute_a_username;
    'compute_admin/password':                           value => $compute_a_password;
    'compute_admin/tenant_name':                        value => $compute_a_tenant ;
    'image/catalog_type':                               value => $image_catalog_type;
    'image/region':                                     value => $image_region;
    'image/api_version':                                value => $image_api_version;
    'image/http_image':                                 value => $http_image;
    'network/api_version':                              value => $network_api_version;
    'network/catalog_type':                             value => $network_catalog_type ;
    'network/region':                                   value => $network_region;
    'network/tenant_network_cidr':                      value => $tenant_network_cidr;
    'network/tenant_network_mask_bits':                 value => $tenant_network_mask_bits;
    'network/tenant_networks_reachable':                value => $tenant_networks_reachable;
    'network/public_network_id':                        value => $public_network_id;
    'network/public_router_id':                         value => $public_router_id;
    'service_available/cinder':                         value => $cinder_available;
    'service_available/glance':                         value => $glance_available;
    'service_available/heat':                           value => $heat_available;
    'service_available/horizon':                        value => $horizon_available;
    'service_available/neutron':                        value => $neutron_available;
    'service_available/nova':                           value => $nova_available;
    'service_available/swift':                          value => $swift_available;
    'stress/max_instances':                             value => $stress_max_instances;
    'stress/log_check_interval':                        value => $log_check_interval ;
    'stress/default_thread_number_per_action':          value => $default_thread_number_per_action ;
    'debug/enable':                                     value  => $debug_enable;
  }

  if $configure_images {
    if ! $image_ref and $image_name {
      # If the image id was not provided, look it up via the image name
      # and set the value in the conf file.
      tempest_glance_id_setter { 'image_ref':
        ensure            => present,
        tempest_conf_path => $tempest_conf,
        image_name        => $image_name,
        require           => File[$tempest_conf],
      }
    }
    else {
      fail('A value for either image_name or image_ref must be provided.')
    }
    if ! $image_ref_alt and $image_name_alt {
      tempest_glance_id_setter { 'image_ref_alt':
        ensure            => present,
        tempest_conf_path => $tempest_conf,
        image_name        => $image_name_alt,
        require           => File[$tempest_conf],
      }
    }
    else {
        fail('A value for either image_name_alt or image_ref_alt must \
be provided.')
    }
  }

  if $neutron_available and $configure_networks {
    if ! $public_network_id and $public_network_name {
      tempest_neutron_net_id_setter { 'public_network_id':
        ensure            => present,
        tempest_conf_path => $tempest_conf,
        network_name      => $public_network_name,
        require           => File[$tempest_conf],
      }
    }
    else {
        fail('A value for either public_network_id or public_network_name \
must be provided.')
    }
  }

}
