# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

# inicializa nota
Servico.create! do |a|
  a.id =4000
  a.tipos = 'RECIBO'
  a.nome = 'Teste 01'
  a.modelo = 'IPHONE'
end

# Remove nota
Servico.delete(4000);

# Create a default admin user
    AdminUser.create!(:email => 'admin@example.com',:username => 'admin',:nome => 'admin', :password => 'admin', :password_confirmation => 'admin',:admin => true)