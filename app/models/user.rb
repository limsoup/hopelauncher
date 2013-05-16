class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles_mask
	before_save :default_role

  has_many :donated_projects, :through => :donations, :class_name => "Project", :inverse_of => :donators, :foreign_key => "project_id"
	has_many :created_projects, :class_name => "Project", :inverse_of => :creator
	has_many :donations

	ROLES = %w[admin mod author user] 

	def roles=(roles)
		roles.map! {|r| r.to_s}
		self.roles_mask = (roles & ROLES).map { |r| ROLES.index(r.to_s)**2}.sum
	end

	def roles
		(self.roles_mask || 0).to_s(2).reverse.split("").each_with_index.map { |does_have, index| ROLES[index].to_sym if does_have =='1' }.compact # & ((2**ROLES.count)-1)
	end

	def role?(role)
		roles.include?(role)
	end

	def default_role
		roles = [:user]
	end

end