# coding: utf-8
ActiveAdmin.register Servico do
  config.sort_order = "created_at_desc"
  actions :all, except: [:destroy]
  controller.authorize_resource :class => Servico

  controller do
    include ActiveAdminCanCan
    include ApplicationHelper
  end
 
  # add this call - it will show only allowed action items
  #active_admin_allowed_action_items 

  menu :label => "Serviços"

  filter :nome, :label =>'Nome do cliente'
  filter :status, :as => :select, :collection => proc{status}
  filter :modelo, :label =>'Modelo'
  filter :imei, :label =>'IMEI'
  filter :created_at, :label => 'Data emissão'
  filter :data_saida
  filter :id,:label =>'Nº NOTA'

  scope "Todos",:all, :default => true
  scope "Orçamento", :orcamento
  scope :os
  scope :recibo
  scope :garantia
  scope "60 dias", :velhos
  scope "90 dias", :caducos

  index do
    column("Nº NOTA", :sortable => :id) {|servico| link_to "##{servico.id} ", aticell_servico_path(servico) }
    column("Nome cliente", :nome, :sortable => :nome){|servico| link_to servico.nome.capitalize, aticell_servico_path(servico) }
    column("Data emissão", :created_at,:sortable => :created_at)
    column("Status",:status,:sortable =>:status){|servico| 
      if servico.status.blank?
        status_tag("aguardando") 
      elsif  servico.status=="CONCLUIDO"
        status_tag("CONCLUÍDO",:ok)
      else
         status_tag("NÃO CONCLUÍDO",:error) 
      end
    }
    column("Data Saída",:data_saida,:sortable => :data_saida)
    
    column("Total",:total_price,:sortable => :total_price) {|servico| number_to_currency servico.total_price }
    default_actions
  end
  
  action_item :only => [:show]  do
    link_to "Imprimir", "/"
  end

  form :partial => "/admin/servicos/form"

  show do |servico|
    
    div class: 'panel' do
      h3 'Detalhes do(a) Servico'
      div class: 'attributes_table' do
        table do
          tr do
            th 'Nome do Cliente:'
              td h2 servico.nome.capitalize
          end
          tr do
            th 'Endereço:'
              td h4 servico.endereco
            th 'Telefone:'
              td h4 servico.telefone
          end
          tr do
            th 'Modelo:'
              td servico.modelo
            th 'IMEI:'
              td servico.imei
          end
          tr do
            th 'Tipo de Serviço:'
              td servico.tipos
            th 'Status:'
              td do
                if servico.status.blank?
                  status_tag("aguardando") 
                elsif  servico.status=="CONCLUIDO"
                  status_tag("CONCLUÍDO",:ok)
                else
                   status_tag("NÃO CONCLUÍDO",:error) 
                end
      end
          end
          tr do
            th 'Entregue?:'
              td do
                if servico.entrega.blank?
                  status_tag("")
                elsif servico.entrega
                  status_tag("SIM",:ok)
                else
                  status_tag("NÃO",:error)
                end
              end
          end
        end
      end
    end

    attributes_table do
      table_for(servico.produtos) do |t|
        t.column("Quant.") {|item|  item.quantidade}
        t.column("Unid.") {|item|  item.unidade}
        t.column("Discriminação das mercadorias") {|item| auto_link item.descricao}
        t.column("P. Unitário ")   {|item| number_to_currency item.price}
        t.column("SubTotal")   {|item| number_to_currency item.price*item.quantidade}
        tr :class => "odd" do
          td "", :style => "text-align: right;"
          td "", :style => "text-align: right;"
          td "", :style => "text-align: right;"
          td "Total:", :style => "text-align: right;"
          td :class => "subtotal" do
           number_to_currency(servico.total_price)
          end
        end
      end
    end

    active_admin_comments
  end

  sidebar "Dados de Controle", :except => [:index] do
    render :partial => '/admin/sidebar_links', :locals => {:servico => servico} 
  end

  sidebar "Valor do Serviço", :except => [:index,:show] do
    attributes_table_for servico do
      row("Total") { h2("<div id='total' style='color: #932419;'></div>".html_safe) }
    end
  end

  sidebar "Valor do Serviço", :only => [:show] do
    attributes_table_for servico do
      row("Total") { h2 number_to_currency servico.total_price }
    end
  end

end
