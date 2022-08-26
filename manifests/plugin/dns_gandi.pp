# @summary Installs and configures the dns-gandi plugin
#
# This class installs and configures the Let's Encrypt dns-gandi plugin.
# https://pypi.org/project/certbot-plugin-gandi/
#
# @param api_key Gandi production api key secret. You can get it in you security tab of your account
# @param package_name The name of the package to install when $manage_package is true.
# @param config_file The path to the configuration file.
# @param manage_package Manage the plugin package.
#
class letsencrypt::plugin::dns_gandi (
  String[1]            $api_key,
  Optional[String[1]]  $package_name   = undef,
  Stdlib::Absolutepath $config_file    = "${letsencrypt::config_dir}/dns-gandi.ini",
  Boolean              $manage_package = true,
) {
  require letsencrypt

  if $manage_package {
    if ! $package_name {
      fail('No package name provided for certbot dns gandi plugin.')
    }

    package { $package_name:
      ensure   => installed,
    }
  }

  if $api_key {
    $ini_vars = {
      'certbot_plugin_gandi:dns_api_key' => $api_key,
    }
  } else {
    fail('api_key not provided for certbot dns gandi plugin.')
  }

  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
        vars => { '' => $ini_vars },
    }),
  }
}