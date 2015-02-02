ActiveAdmin.register Manufacturer do

 form do |f|
   f.inputs "Details" do
     f.input :name
     f.input :details
   end
 
   f.actions
 end
  
 permit_params :name, :details

end
