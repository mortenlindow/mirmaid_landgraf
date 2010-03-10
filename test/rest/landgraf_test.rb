require 'test_helper_rest'

class RestTestCasePlugin < RestTestCase
  
  class LandgrafLibrary < ActiveResource::Base
    self.site = MIRMAID_URL
  end
  
  class LandgrafExpressionLevel < ActiveResource::Base
    self.site = MIRMAID_URL
  end
  
end
  
class LandgrafLibraryTest < RestTestCasePlugin
  
  # test "REST id is DOID" do
  #   assert_equal(5520,M2dDisease.find(5520).doid)
  # end
  # 
  # test "disease link has one disease" do
  #   assert_equal(5520,M2dDisease.find(:one,:from=>"/m2d_disease_links/5520+hsa-miR-1+19179615/m2d_disease").doid)
  # end

end

class LandgrafExpressionLevelTest < RestTestCasePlugin
  
  # test "REST id is DOID+matureID+PMID" do
  #   assert_equal("5520+hsa-miR-1+19179615",M2dDiseaseLink.find("5520+hsa-miR-1+19179615").name)
  # end
  # 
  # test "mature has many disease links" do
  #   assert(M2dDiseaseLink.find(:all,:from=>"/matures/hsa-miR-1/m2d_disease_links").size > 0)
  # end
  # 
  # test "disease link has one mature" do
  #   assert("hsa-miR-1",Mature.find(:one,:from=>"/m2d_disease_links/5520+hsa-miR-1+19179615/mature").name)
  # end
  # 
  # test "disease has many disease links" do
  #   assert(M2dDiseaseLink.find(:all,:from=>"/m2d_diseases/5520/m2d_disease_links").size > 0)
  # end

end
