class LineItem < ActiveRecord::Base
  belongs_to :order

  #attr_accessible :
  validates_numericality_of :quantidade, :only_integer => true, :allow_blank => true
  validates_numericality_of :prince, :allow_blank => true
end
