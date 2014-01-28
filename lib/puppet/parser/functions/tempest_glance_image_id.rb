#
# tempest_glance_image_id.rb
#

module Puppet::Parser::Functions
  newfunction(:tempest_glance_image_id, :type => :rvalue, :doc => <<-EOS
Extracts glance image id for given name.
params:
image_name
auth_keystone_uri
auth_tenant
auth_username
auth_password
    EOS
  ) do |arguments|

    if (arguments.size != 5) then
      raise(Puppet::ParseError, "tempest_glance_id(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end
    
    require 'json'
    require 'net/http'
    require 'net/https'
    require 'openssl'
    require 'uri'
    
    image_name = arguments[0]
    image_id = nil
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

      if os_services.has_key?('image')

        glance_uri = URI.parse(os_services['image'])
        glance_connection = Net::HTTP.new(glance_uri.host, glance_uri.port)
        if glance_uri.scheme =='https'
          glance_connection.use_ssl = true
          glance_connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        
        glance_path = glance_uri.path.chomp('/') + '/v1/images'
        glance_response = glance_connection.get(glance_path, {'X-Auth-Token' => keystone_response_json['access']['token']['id'], 'Content-Type' => 'application/json'});
        if (glance_response.code =~ /^20./)
          glance_response_json = JSON.parse(glance_response.body)
          glance_response_json['images'].each do |image|
            if image_name == image['name']
              image_id = image['id']
            end
          end
        end
      end
    end
    
    return image_id
    
  end
end

