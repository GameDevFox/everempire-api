require 'everempire/api'

map '/api' do
  run EverEmpire::API::APP
end
