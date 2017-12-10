class Kingaku < ActiveRecord::Base
  belongs_to :list
  belongs_to :member
  has_many :whos
end
