ActiveAdmin.register Model do

 form do |f|
      
   f.inputs "Content" do
     f.input :instrument_type, :collection => InstrumentType.all.map{ |it| [it.name, it.id] }
     f.input :manufacturer, :collection => Manufacturer.all.map{ |manufacturer| [manufacturer.name, manufacturer.id] }
   end
   
   f.inputs "Details" do
     f.input :name, label: "Model name"
     f.input :details
   end
 
   f.actions
 end
  
 permit_params :name, :details, :instrument_type_id, :manufacturer_id

end
