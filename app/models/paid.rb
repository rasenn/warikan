class Paid < ActiveRecord::Base
  belongs_to :list
  belongs_to :pay_member , :class_name => "Member", :foreign_key => "pay_member_id"
  belongs_to :recieve_member , :class_name => "Member", :foreign_key => "recieve_member_id"

end
