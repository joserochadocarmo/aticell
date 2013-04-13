# coding: utf-8
ActiveAdmin.register_page "Dashboard" do
  menu :label => "Home"
  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do
        panel "Últimos serviços(#{Servico.order('id desc').count})..." do
          table_for Servico.order('id desc').limit(10) do
            column("NOTA Nº"){|servico| h4 link_to("#".concat(servico.id.to_s), aticell_servico_path(servico)) } 
            column("Tipo"){|servico| servico.tipos.capitalize } 
            column("Nome do Cliente"){|servico|  link_to(servico.nome.capitalize,aticell_servico_path(servico)) } 
            column("Status")   {|servico| 
              if servico.status.blank?
                status_tag("aguardando") 
              elsif  servico.status=="CONCLUIDO"
                status_tag("CONCLUÍDO",:ok)
              else
                 status_tag("NÃO CONCLUÍDO",:error) 
              end                                      } 
            column("Total")   {|servico| number_to_currency servico.total_price                       } 
          end
        end
      end

      column do
        panel "Envelheçendo no estoque(#{Servico.velhos.count}) - 60 até 90 dias" do
          table_for Servico.velhos.order('created_at desc').limit(10) do
            column("Data emissão"){|servico|  format_date(servico.created_at) } 
            column("Tipo"){|servico| servico.tipos.capitalize } 
            column("Nome Cliente"){|servico| h4  link_to(servico.nome.capitalize, aticell_servico_path(servico)) } 
            
            column("Status")   {|servico| 
              if servico.status==""
                status_tag("---------") 
              elseif  servico.status=="CONCLUIDO"
                status_tag("CONCLUÍDO",:ok)
              else
                 status_tag("NÃO CONCLUÍDO",:error) 
              end                                      } 
            column("Total") {|servico| number_to_currency servico.total_price} 
            column("Dias")  {|servico| (Date.today.to_date- servico.created_at.to_date).to_i}
          end
        end
      end

    end # columns

  end # content
end
