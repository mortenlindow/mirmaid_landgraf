# Extend core Mirmaid models here

Mature.class_eval do
  has_many :landgraf_expression_levels
  has_one :landgraf_clone_count
end

Species.class_eval do
  has_many :landgraf_libraries
end

