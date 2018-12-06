require 'aws-sdk'
require 'yaml'

prefix = ARGV[0]

array = ["parameter_vars.yml","parameter_secret_vars.yml"]

array.each do |file|
  file_content = YAML.load_file(file)
  ssm = Aws::SSM::Client.new(region: 'us-east-1')

  file_content.each do |env_hash|
      full_name = prefix + "." + env_hash["EnvVar"]
      puts full_name
      ssm.put_parameter({
        name: full_name.to_s, # required
        value: env_hash["value"].to_s, # required
        type: env_hash["ParamType"].to_s, # required, accepts String, StringList, SecureString,
        overwrite: true, # Specifies whether or not this script can overwrite existing parameters values
      })
  end
end
