class LandgrafExpressionLevel < ActiveRecord::Base
  belongs_to :landgraf_library, :class_name => "LandgrafLibrary", :foreign_key => "landgraf_library_id"
  belongs_to :mature, :class_name => "Mature", :foreign_key => "mature_id"

  def self.find_rest(id)
     self.find(id)
  end

  def to_param
    self.id
  end

end

  