class Site < ActiveRecord::Base
  has_many :statuses, :class_name => 'Status', :foreign_key => 'site_id', :dependent => :restrict_with_exception
end
