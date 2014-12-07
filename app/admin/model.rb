ActiveAdmin.register Model do

 form do |f|
   f.inputs "Details" do
     f.input :modelType
     f.input :manufacturer
     f.input :modelName
   end
 
   f.actions
 end
  
 permit_params :modelType, :manufacturer, :modelName

end
