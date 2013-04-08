class Produto < ActiveRecord::Base

  belongs_to :servico
  attr_accessor :sub_total

  validates_presence_of :quantidade
  validates_presence_of :price
  validates_presence_of :descricao
  validates_numericality_of :quantidade, :only_integer => true, :allow_blank => true
  validates_numericality_of :price, :allow_blank => true
  validates_numericality_of :sub_total, :allow_blank => true
end
