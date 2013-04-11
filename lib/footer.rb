# coding: utf-8
class Footer < ActiveAdmin::Component
	def build
		super :id => "footer"
		span "Copyright #{Date.today.year} José Neto - tom.jrc@gmail.com"
	end
end