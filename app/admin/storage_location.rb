ActiveAdmin.register StorageLocation do

 form do |f|
   f.inputs "Details" do
     f.input :code
     f.input :room
     f.input :building
     f.input :address
     f.input :comments
   end
 
   f.actions
 end
  
 permit_params :code, :room, :building, :address, :comments

end

