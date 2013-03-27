# coding: utf-8
ActiveAdmin.register AdminUser, :as => "Usuario" do

  controller.authorize_resource :class => AdminUser    

  controller do
    include ActiveAdminCanCan
  end
 
  # add this call - it will show only allowed action items
  active_admin_allowed_action_items
  
  menu :if => proc{admin?}     

  config.batch_actions = false
  config.paginate = false

  filter :nome,:label =>'Vendedor'
  filter :username
  filter :email

  index :download_links => false do
    selectable_column
    id_column
    column 'Nome do vendedor', :nome
    column :username
    column :email
    column 'Criado em',:created_at, :format => :default
    default_actions
  end

  show :title => :nome do
    panel "Dados do usuário" do
      attributes_table_for usuario do
        row 'Nome do vendedor' do
          usuario.nome
        end
        row :username
        row :email
        row 'Criado em' do
          usuario.created_at
        end
        row 'Alterado em' do
          usuario.updated_at
        end
     end
    end
  end

  form do |f|
    f.inputs "Dados do novo usuário" do
      f.input :nome, :label => 'Nome do vendedor'
      f.input :username
      f.input :email
      f.input :password,:label => 'Senha'
      f.input :password_confirmation,:label =>'Repetir senha'
    end
    f.actions
  end
end
