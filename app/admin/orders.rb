# coding: utf-8
ActiveAdmin.register Order, :as => "Servico" do

  controller.authorize_resource :class => Order

  controller do
    include ActiveAdminCanCan
  end
 
  # add this call - it will show only allowed action items
  active_admin_allowed_action_items 

  menu :label => "Serviços"

  filter :nome, :label =>'Nome do cliente'
  filter :status, :as => :select, :collection => proc{status}
  filter :modelo, :label =>'Modelo'
  filter :imei, :label =>'IMEI'
  filter :total_price, :label => 'Valor serviço'
  filter :created_at, :label => 'Data emissão'
  filter :data_saida

  scope :all, :default => true
  scope :orcamento
  scope :os
  scope :recibo
  scope :garantia

  index do
    column("Order", :sortable => :id) {|order| link_to "##{order.id} ", admin_order_path(order) }
    column("State")                   {|order| status_tag(order.state) }
    column("Date", :checked_out_at)
    column("Customer", :adminUser, :sortable => :user_id)
    column("Total")                   {|order| number_to_currency order.total_price }
  end

  form do |f|
    f.inputs "Dados do novo serviço" do
      f.input :admin_user_id
      f.input :tipos
      f.input :nome
      f.input :endereco
      f.input :telefone
      f.input :modelo
      f.input :imei
    end
    f.actions
  end

  action_item :only => [:edit] do
    link_to "View Site", "/"
  end

  # show do
  #   panel "Invoice" do
  #     table_for(order.line_items) do |t|
  #       t.column("Product") {|item| auto_link item.product        }
  #       t.column("Price")   {|item| number_to_currency item.price }
  #       tr :class => "odd" do
  #         td "Total:", :style => "text-align: right;"
  #         td number_to_currency(order.total_price)
  #       end
  #     end
  #   end

  #   active_admin_comments
  # end

  # sidebar :customer_information, :only => :show do
  #   attributes_table_for order.user do
  #     row("User") { auto_link order.user }
  #     row :email
  #   end
  # end

  sidebar "Active Admin Demo" do
    render('/admin/sidebar_links', :model => 'orders')
  end

end
