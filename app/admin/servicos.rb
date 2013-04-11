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

  member_action :generate_pdf do
    @servico=nil
    @servico = Servico.find(params[:id])
    pdf=generate_arquivo(@servico)
    send_data pdf.render, :filename => "#{@servico.tipos} Nota Nº#{@servico.id} .pdf", type: "application/pdf", :disposition => 'inline'
  end

  action_item :only => :show do
    link_to "Imprimir", generate_pdf_aticell_servico_path(resource)
  end

end

include ActionView::Helpers::NumberHelper
include ActionView::Helpers::RawOutputHelper

EMPTY_CHECKBOX   = "\u2610"
CHECKED_CHECKBOX = "\u2611" # "☑"  I don't use this, but you could.
EXED_CHECKBOX    = "\u2612" # "☒"
CHECKBOX_FONT    = "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

def generate_arquivo(servico)
    # Generate invoice
    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape,:margin => [30,10,40,10])

    # Title
    pdf.image "#{Rails.root}/public/images/galaxy.jpg",:at => [0, 545],:width => 40, :height => 70
    pdf.image "#{Rails.root}/public/images/computador.jpg",:at => [233, 545],:width => 80, :height => 70

    pdf.dash(4)
    pdf.stroke_vertical_line(0, 550 ,:at => 420 )
    pdf.undash

    pdf.move_up 20
    
    pdf.text_box "Aticell", :size => 25,:style => :bold, :at => [43, 545]
    pdf.move_up 8
    pdf.text_box "Celulares \n #{Prawn::Text::NBSP * 5}  e \n Informática",:size => 12,:style => :italic,:at => [50, 520]

    string = "Assist. Técnica \n Acessórios p/ Celulares Compra, Venda e Troca \n  Desbloqueio e Chip"

    pdf.text_box string, :at => [ 125, 540],:width => 120, :height => 80,:overflow => :shrink_to_fit,:leading => 6,:size => 10,:character_spacing => 0

    pdf.text_box "#{Prawn::Text::NBSP * 2} Fone: \n 3205-4227",:size => 15,:style => :bold,:at => [50, 470]

    pdf.text_box "Av. Itaberaí Qd. 26 Lt. 01 - Vila Jd. São Judas Tadeu",:size => 13,:style => :bold,:at => [0, 430]

    pdf.rounded_rectangle [-05, 550],420, 140, 20
    pdf.rounded_rectangle [425, 550],400, 150, 20
    pdf.stroke_vertical_line(550, 410 ,:at => 320 )

    pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf" do
      pdf.text_box "#{servico.tipos=='ORCAMENTO' ? EXED_CHECKBOX : EMPTY_CHECKBOX} ORÇAMENTO", :size => 11,:at => [325, 540]
      pdf.text_box "#{servico.tipos=='OS' ? EXED_CHECKBOX : EMPTY_CHECKBOX} O.S.", :size => 11,:at => [325, 523]
      pdf.text_box "#{servico.tipos=='RECIBO' ? EXED_CHECKBOX : EMPTY_CHECKBOX} RECIBO", :size => 11,:at => [325, 507]
      pdf.text_box "#{servico.tipos=='GARANTIA' ? EXED_CHECKBOX : EMPTY_CHECKBOX} GARANTIA", :size => 11,:at => [325, 490]
    end

    pdf.fill_color "cc3300"
    pdf.text_box "#{servico.id.to_s.rjust(5,"0")}", :size => 13,:at => [340, 470]
    pdf.fill_color "000000"

    pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf" do
      pdf.text_box "#{servico.status=='CONCLUIDO' ? EXED_CHECKBOX : EMPTY_CHECKBOX} CONCLUÍDO", :size => 8,:at => [325, 445]
      pdf.text_box "#{servico.status=='NAOCONCLUIDO' ? EXED_CHECKBOX : EMPTY_CHECKBOX} NÃO CONCLUÍDO", :size => 8,:at => [325, 430]
    end

    pdf.rounded_rectangle [-05, 410],420, 90, 20

    pdf.text_box "Data da Emissão: #{servico.created_at.strftime("%m/%d/%Y") }", :size => 11,:at => [5, 400]
    pdf.text_box "Nome: #{servico.nome.capitalize }", :size => 11,:at => [5, 385]
    pdf.text_box "Endereço: #{servico.endereco }", :size => 11,:at => [5, 370]
    pdf.text_box "Telefone: #{servico.telefone }", :size => 11,:at => [5, 355]
    pdf.text_box "Modelo: #{servico.modelo }", :size => 11,:at => [5, 340]
    pdf.text_box "IMEI: #{servico.imei }", :size => 11,:at => [235, 340]
    if servico.data_saida.blank?
      pdf.text_box "Data da Saída: __/____/____", :size => 11,:at => [235, 400],:style =>:bold
    else
      pdf.text_box "Data da Saída: #{servico.data_saida.strftime("%m/%d/%Y") }", :size => 11,:at => [235, 400],:style =>:bold
    end

    pdf.move_down 235
    #pdf.draw_text "#{t('.created_at')}: #{l(invoice.created_at, :format => :short)}", :at => [pdf.bounds.width / 2, pdf.bounds.height - 30]

    # Items
    header = ['Quant.', 'Unid', 'Discriminação das mercadorias', 'P. Unitário','Total R$']
    items = servico.produtos.collect do |item|
      [item.quantidade.to_s, item.unidade,item.descricao, number_to_currency(item.price), number_to_currency(item.price*item.quantidade)]
    end
    
    items = items + [["", "", "Discount:", "#{number_with_delimiter(servico.total_price)}%"]] \
                  + [["", "", "Sub-total:", "#{number_to_currency(servico.total_price)}"]] \
                  + [["", "", "Total:", "#{number_to_currency(servico.total_price)}"]]

    pdf.table [header] + items, :header => true, :width => pdf.bounds.width do
      row(-4..-1).borders = []
      row(-4..-1).column(2).align = :right
      row(0).style :font_style => :bold
      row(-1).style :font_style => :bold
    end
    
                     # :border_style => :grid,
                     # :headers => header,
                     # :width => pdf.bounds.width,
                     # :row_colors => %w{cccccc eeeeee},
                     # :align => { 0 => :right, 1 => :left, 2 => :right, 3 => :right, 4 => :right }


    # Terms
    #if invoice.terms != ''
      pdf.move_down 20
      pdf.text 'Terms', :size => 18
      pdf.text servico.nome
    #end

    # Notes
    # if invoice.notes != ''
    #   pdf.move_down 20
    #   pdf.text 'Notes', :size => 18
    #   pdf.text invoice.notes
    # end

    # Footer
    pdf.draw_text "Generated at #{l(Time.now, :format => :short)}", :at => [0, 0]
    pdf
end