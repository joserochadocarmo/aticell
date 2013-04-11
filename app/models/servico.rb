# coding: utf-8
class Servico < ActiveRecord::Base
  
  belongs_to :admin_user
  has_many :produtos, :dependent => :destroy
  accepts_nested_attributes_for :produtos, :reject_if => :all_blank, :allow_destroy => true

  validates_inclusion_of :tipos, :in => %w(ORCAMENTO OS RECIBO GARANTIA),:allow_blank => false
  validates_inclusion_of :status, :in => %w(CONCLUIDO NAOCONCLUIDO), :allow_blank => true
  validates :nome,
            :presence => true,
            :length => {:maximum => 100}  
  validates :endereco,
            :presence => true,
            :length => {:maximum => 100}
  validates :telefone,
            :presence => true,
            :length => {:maximum => 100}          

  before_save :recalculate_price!
  before_update :entregar?,:recalculate_price!

  scope :orcamento, where("servicos.tipos='ORCAMENTO'").order("servicos.created_at DESC")
  scope :os, where("servicos.tipos='OS'").order("servicos.created_at DESC")
  scope :recibo, where("servicos.tipos='RECIBO'").order("servicos.created_at DESC")
  scope :garantia, where("servicos.tipos='GARANTIA'").order("servicos.created_at DESC")
  scope :velhos, lambda{ where("date(created_at) <= ? and data_saida is null", Date.today.months_ago(2)) }
  scope :caducos, lambda{ where("date(created_at) <= ? and data_saida is null", Date.today.months_ago(3)) }

  def recalculate_price!
    self.total_price = produtos.inject(0.0){|sum, produto| 
      produto.marked_for_destruction? ? sum += 0 : sum += (produto.price*produto.quantidade)
      sum } if produtos.any?
  end

  def display_name
    "NOTA Nº ##{id} (#{nome.capitalize}) - " + ActionController::Base.helpers.number_to_currency(total_price)
  end

  protected

  def entregar?    
    if self.entrega
      self.data_saida = Time.now
    else
      self.data_saida =nil
    end
  end 

end
