class Story < ActiveResource::Base
  
  PIVOTAL_TOKEN = "c336965c1c9d3e7da95a04de723afe53"
  PIVOTAL_PROJECT_ID = "35087" 
  
  self.site = "http://www.pivotaltracker.com/services/v3/projects/35087"
  headers['X-TrackerToken'] = "c336965c1c9d3e7da95a04de723afe53"
    
end
