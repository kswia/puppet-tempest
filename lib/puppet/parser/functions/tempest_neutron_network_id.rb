#
# tempest_neutron_image_id.rb
#

module Puppet::Parser::Functions
  newfunction(:tempest_neutron_network_id, :type => :rvalue, :doc => <<-EOS
Extracts neutron image id for given name.
params:
network_name
auth_keystone_uri
auth_tenant
auth_username
auth_password
    EOS
  ) do |arguments|

    if (arguments.size != 5) then
      raise(Puppet::ParseError, "tempest_neutron_network_id(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end
    
    require 'json'
    require 'net/http'
    require 'net/https'
    require 'openssl'
    require 'uri'
    
    network_name = arguments[0]
    network_id = nil
    auth_keystone_uri = arguments[1]
    auth_tenant = arguments[2]
    auth_username = arguments[3]
    auth_password = arguments[4]
    os_services = {}
    
    keystone_auth_data = JSON.generate({
      "auth" =>  { 
        "tenantName" => auth_tenant,
        "passwordCredentials" => { 
          "username" => auth_username,
          "password" => auth_password
        }
      }
    })
    
    keystone_uri = URI.parse(auth_keystone_uri)
    keystone_path = keystone_uri.path.chomp('/') + '/tokens'
    keystone_connection = Net::HTTP.new(keystone_uri.host, keystone_uri.port)
    if keystone_uri.scheme =='https'
      keystone_connection.use_ssl = true
      keystone_connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    keystone_response = keystone_connection.post(keystone_path, keystone_auth_data, {'Content-Type' => 'application/json'});
    if (keystone_response.code =~ /^20./)
      keystone_response_json = JSON.parse(keystone_response.body)
      keystone_response_json['access']['serviceCatalog'].each do |service|
        os_services[service['type']] = service['endpoints'][0]['internalURL']
      end

      if os_services.has_key?('network')

        neutron_uri = URI.parse(os_services['network'])
        neutron_connection = Net::HTTP.new(neutron_uri.host, neutron_uri.port)
        if neutron_uri.scheme =='https'
          neutron_connection.use_ssl = true
          neutron_connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        
        neutron_path = neutron_uri.path.chomp('/') + '/v2.0/networks'
        neutron_response = neutron_connection.get(neutron_path, {'X-Auth-Token' => keystone_response_json['access']['token']['id'], 'Content-Type' => 'application/json'});
        if (neutron_response.code =~ /^20./)
          neutron_response_json = JSON.parse(neutron_response.body)
          neutron_response_json['networks'].each do |network|
            if network_name == image['name']
              network_id = network['id']
            end
          end
        end
      end
    end
    
    return network_id
    
  end
end
