class Designation < ActiveRecord::Base
  attr_accessible :id, :title
  
  has_many :employee
  has_one :setting
  
  self.table_name = 'designation'
  
  validates_presence_of :title, :message => 'designation.blank.title'
  validates_uniqueness_of :title, :message => 'designation.unique.title'
end
