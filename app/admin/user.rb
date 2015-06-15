ActiveAdmin.register User do

index do
  column :id
  column :firstname
  column :surname
  column :email
  column :approved
  column :role
  actions
end


form do |f|
  f.inputs "Details" do
    f.input :firstname             
    f.input :surname               
    f.input :email    
    f.input :approved   
    f.collection_select :role, User::roles, :to_s, :humanize 
  end
  f.actions
end
  
 permit_params :firstname, 
               :surname, 
               :email,      
               :approved,
               :role

end