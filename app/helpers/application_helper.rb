module ApplicationHelper
	def admin?
		current_admin_user.admin?
	end
end
