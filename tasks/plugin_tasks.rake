require 'progressbar'
require 'activerecord'
require 'pp'

plugin_root = File.join(File.dirname(__FILE__), "..")
app_root = File.join(plugin_root, "..", "..", "..")

namespace :mirmaid do
  namespace :plugin do
    namespace :landgraf do
      
      desc "create plugin schema"
      task :create_schema => :environment do
        ActiveRecord::Migration.verbose = false
        conn = ActiveRecord::Base.connection
        
        conn.create_table(:landgraf_libraries) do |t|
          t.string :name
          t.string :description
          t.string :malignancy_status
          t.string :RNA_amount_used
          t.string :RNA_source
          t.integer :landgraf_tissue_type_id
          t.integer :species_id
        end
        
        conn.create_table(:landgraf_expression_levels) do |t|
          t.float :expression_level
          t.string :mirna
          t.integer :mature_id
          t.integer :landgraf_library_id
        end
        
        conn.create_table(:landgraf_clone_counts) do |t|
          t.integer :total_counts
          t.integer :mature_id
        end
        
        conn.create_table(:landgraf_tissue_types) do |t|
          t.string :code
          t.string :description
        end
        
        
        #indexes
        conn.add_index :landgraf_libraries, :name
        conn.add_index :landgraf_libraries, :species_id
        conn.add_index :landgraf_expression_levels, :mature_id
        conn.add_index :landgraf_expression_levels, :landgraf_library_id
        
      end
      
      desc "drop plugin schema"
      task :drop_schema => :environment do
        ActiveRecord::Migration.verbose = false
        conn = ActiveRecord::Base.connection
        begin
          conn.drop_table(:landgraf_expression_levels)
          conn.drop_table(:landgraf_libraries)
          conn.drop_table(:landgraf_clone_counts)
          conn.drop_table(:landgraf_tissue_types)
          puts "dropped all landgraf tables"
        rescue
          # nothing to drop
        end
      end

      desc "uninstall plugin. "
      task :uninstall => ['landgraf:drop_schema']
      
      
      desc "Install Landgraf plugin"
      task :install => ['landgraf:drop_schema', 'landgraf:create_schema', 'landgraf:load_data']
      
      
      desc "Load all data from Landgraf et al."
      task :load_data => ['landgraf:load_tissue_types','landgraf:load_library_details', 'landgraf:load_clone_counts']
# 
     
     
      desc "load Brenda tissue classification from Landgraf et al. "
      task :load_tissue_types => :environment do
        datafile = plugin_root+"/data/tissue_ontology.txt"
        rows = IO.readlines(datafile)
        pbar = ProgressBar.new("Tissue ontology", rows.length)
        rows.each do |row|
          pbar.inc
          fields = row.chomp.split("\t")
          if !fields[0] =~ /\d\.\d\.\d\.\d/
            next
          end
          LandgrafTissueType.create(:code => fields[0], :description => fields[1])
          
        end
        pbar.finish
        puts "Loaded #{LandgrafTissueType.count} types of tissues from #{datafile}"
      end

      desc "Load the detailed information about each library/sample"
      task :load_library_details => [:environment, 'load_tissue_types'] do
        datafile = plugin_root+"/data/library_details.txt"
        
        rows = IO.readlines(datafile)
        header = rows.shift.chomp.split("\t")
        pbar = ProgressBar.new("Lib details..", rows.length)
        rows.each do |row|
          pbar.inc
          fields = row.split("\t")
          # puts fields[0]
          l = LandgrafLibrary.new(
            :name => fields[0],
            :description => fields[1],
            :malignancy_status => fields[4],
            :RNA_source => fields[5],
            :RNA_amount_used => fields[6]
          )
          ttype = LandgrafTissueType.find_by_code(fields[2]) or raise "unknown tissue code #{fields[2]}"
          
          l.landgraf_tissue_type = ttype
          l.species = Species.find_by_abbreviation(fields[5])
          l.save
          
        end
        pbar.finish
        puts "Loaded details about #{LandgrafLibrary.count} libraries from #{datafile}"     
      end
      

      
      desc "Load clone count data from Landgraf et al."
      task :load_clone_counts => [:environment, 'load_library_details']  do

         
         datafiles = { 'hsa' => "/data/Expression_human_sept2008.txt",
                       'mmu' =>  "/data/Expression_mouse_sept2008.txt",
                       'rno' => "/data/Expression_rat_sept2008.txt"
                     }
         datafiles.keys.each do |species_abbr|
         
           datafile = plugin_root+datafiles[species_abbr]
           
           skipped_rows = 0
           
           species = Species.find_by_abbreviation(species_abbr)
           rows = IO.readlines(datafile)
         
           header = rows.shift.chomp.split("\t")
           library_names = header.last.split(",")
         
           libraries = library_names.map { |name| LandgrafLibrary.find_or_create_by_name(name) }
         
           pbar = ProgressBar.new("Loading #{species_abbr}..", rows.length)
           rows.each do |row|
             pbar.inc
             fields = row.chomp.split("\t")
             mature_name = fields[0]
             total_copies = fields[1]  # TODO: store this in a one-to-one on Mature
             expression = fields[2].split(",")
             raise "error for #{mature_name}" if expression.length != library_names.length
           
             mats = Mature.find_best_by_name(mature_name) 

             if mats.nil? or mats.size != 1
               # warn("Ambigious miR-name '" + mature_name "'")
               skipped_rows +=1
               next
             end
             mature = mats.first
             cc = LandgrafCloneCount.create(:total_counts => total_copies)
             mature.landgraf_clone_count = cc
             mature.save
           
             expression.each_with_index do |value, idx|
               el = LandgrafExpressionLevel.new(:expression_level => value, :mirna => mature_name)
               el.mature = mature
               el.landgraf_library = libraries[idx]
               el.save
             end  
           end
           pbar.finish
           
         end
         puts "Loaded #{LandgrafExpressionLevel.count} expression values in total"
      end
      
    end
    
    desc "landgraf unit tests"
    Rake::TestTask.new(:test => :environment) do |t|
        t.libs << plugin_root+'/lib'
        t.libs << plugin_root+'/test'
        t.pattern = plugin_root+'/test/**/*_test.rb'
        t.verbose = false
    end



  end
end
