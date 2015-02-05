class StorageLocation < ActiveRecord::Base
  has_many :statuses, :class_name => 'Status', :foreign_key => 'storage_location_id', :dependent => :restrict_with_exception
end
