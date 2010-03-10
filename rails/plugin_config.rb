# Setup plugin integration with core mirmaid framework

config.to_prepare do

  # Register plugin and menu items
  MIRMAID_CONFIG.add_plugin_resource "Landgraf", :landgraf_library
  MIRMAID_CONFIG.add_plugin_resource "Landgraf", :landgraf_expression_level
  # MIRMAID_CONFIG.add_plugin_resource "Landgraf", :landgraf_times_cloned
  
  
  # Add plugin routes to/from core framework
  MIRMAID_CONFIG.add_plugin_route :mature, :landgraf_expression_level, [:one,:many]
end
