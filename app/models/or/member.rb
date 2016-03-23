class Member < ActiveRecord::Base
  belongs_to :list
  has_many :kingakus
end
