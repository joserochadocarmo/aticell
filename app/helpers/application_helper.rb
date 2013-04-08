# coding: utf-8
module ApplicationHelper
	
	def admin?
		current_admin_user.admin?
	end

	def status
		[
	        [ 'Concluido', 'CONCLUIDO' ],
	        [ 'Não Concluido', 'NAOCONCLUIDO' ]
	    ]
	end

	def tipos
    [
        [ 'Orçamento','ORCAMENTO' ],
        [ 'O.S.','OS' ],
        [ 'Recibo', 'RECIBO' ],
        [ 'Garantia','GARANTIA' ]
    ]
	end
end
