class List < ActiveRecord::Base
  has_many :members
  has_many :kingakus
  has_many :paids
end
