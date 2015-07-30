namespace :facedeployment_to_deployment do
  desc "Transfer old Face deployment records to new Deployment records"
  task fd_to_d: :environment do
      
      # return a queryset of face deployments
      all_fds = Facedeployment.all
      # loop through each of the returned queryset
      all_fds.each do |fd| 
        # create a new deployment record
        new_dep  = Deployment.new
        # assign each attribute of the deployment record using the matching attribute from the old face deployment record
        new_dep.startdate = fd.startdate
        new_dep.instrument_id = fd.instrument_id
        new_dep.reporter_id = fd.reporter_id
        new_dep.status_type = 'Deployment'
        new_dep.northing = fd.northing
        new_dep.easting = fd.easting
        new_dep.vertical = fd.vertical
        new_dep.site_id = '1'
        new_dep.comments = fd.comments + ' (Ring ' + fd.ring.to_s + ')'
       
        new_dep.save
      
      end
    
  end

end
