# == Schema Information
#
# Table name: m2d_diseases
#
#  id   :integer         not null, primary key
#  doid :integer
#  name :string(255)
#


class LandgrafLibrary < ActiveRecord::Base
  has_many :landgraf_expression_levels, :order => 'expression_level DESC'
  belongs_to :landgraf_tissue_type
  belongs_to :species
  
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  
  def self.find_rest(id)
    self.find_by_name(id) or self.find(id)
  end

  def to_param
    self.name
  end
 
  def tissue_type
    self.landgraf_tissue_type
  end
 
 
end
