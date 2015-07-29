ActiveAdmin.register Site do
  
 form do |f|
   f.inputs "Details" do
     f.input :name
     f.input :shortname
     f.input :address
     f.input :description
     f.input :contact
     f.input :website
   end
 
   f.actions
 end
  
 permit_params :name, :shortname, :address, :description, :contact, :website

end
