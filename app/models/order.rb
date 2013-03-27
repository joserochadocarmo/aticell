# coding: utf-8
class Order < ActiveRecord::Base

  attr_accessor   :entrega
  attr_accessible :entrega, :tipos, :status, :nome,:endereco,
                  :telefone,:modelo,:imei,:data_saida,:total_price

  belongs_to :admin_user
  has_many :line_items, :dependent => :destroy

  validates_inclusion_of :tipos, :in => %w(ORCAMENTO OS RECIBO GARANTIA),:allow_blank => false
  validates_inclusion_of :status, :in => %w(CONCLUIDO NAOCONCLUIDO)
  validates :nome,
            :presence => true,
            :length => {:maximum => 100}
  validates :telefone,
            :presence => true,
            :length => {:maximum => 100}          

  # Named Scopes
  #scope :available, lambda{ where("available_on < ?", Date.today) }
  #scope :drafts, lambda{ where("available_on > ?", Date.today) }
  scope :orcamento, where("orders.tipos='ORCAMENTO'").order("orders.created_at DESC")
  scope :os, where("orders.tipos='OS'").order("orders.created_at DESC")
  scope :recibo, where("orders.tipos='RECIBO'").order("orders.created_at DESC")
  scope :garantia, where("orders.tipos='GARANTIA'").order("orders.created_at DESC")

  before_save :entregar?

  def checkout!
    self.checked_out_at = Time.now
    self.save
  end


  def recalculate_price!
    self.total_price = line_items.inject(0.0){|sum, line_item| sum += line_item.price }
    save!
  end

  def display_name
    ActionController::Base.helpers.number_to_currency(total_price) + 
      " - Order ##{id} (#{user.username})"
  end

  def tipos
    [
        [ '', '--Selecione--' ],
        [ 'ORCAMENTO', 'Orçamento' ],
        [ 'OS', 'O.S.' ],
        [ 'RECEBIDO', 'Recibo' ],
        [ 'GARANTIA', 'Garantia' ]
    ]
  end

  def status
    [
        [ '', '--Selecione--' ],
        [ 'CONCLUIDO', 'Concluido' ],
        [ 'NAOCONCLUIDO', 'Não Concluido' ]
    ]
  end

  def admin?
    false
  end  

  protected

  def entregar?    
    self.data_saida = Time.now if self.entrega
  end 

end
