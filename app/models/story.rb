class Story < ActiveResource::Base
  
  PIVOTAL_TOKEN = "685e423325a75527368de1316f8311b8"
  PIVOTAL_PROJECT_ID = "35087" 
  
  self.site = "http://www.pivotaltracker.com/services/v3/projects/35087"
  headers['X-TrackerToken'] = "685e423325a75527368de1316f8311b8"
    
end
