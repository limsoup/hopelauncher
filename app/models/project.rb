class Project < ActiveRecord::Base
  attr_accessible :title, :description, :goal, :content, :profile_image_id, :stretch_goals, :end_date_bad_format, :start_date_bad_format
  attr_protected :project_state, :start_date, :end_date
  validates :project_state, inclusion: {in: %w(unapproved creator_approved admin_approved approved) }
  # has_one :profile_image, :class_name => "GalleryImage"
  has_many :blocks
  belongs_to :creator, :class_name=> "User", :inverse_of => :created_projects, :foreign_key => "user_id"
  has_many :donations
  has_many :donators, :through => :donations, :class_name=> "User", :inverse_of => :donated_projects, :foreign_key => "user_id"
  has_many :followings
  has_many :followers, :through => :followings, :class_name => "User", :inverse_of => :followed_projects, :foreign_key => "user_id"
  has_many :gallery_images


  acts_as_messageable
  def name
    return title
  end


  def profile_image
    profile_image_id == nil ? nil: GalleryImage.find(self.profile_image_id)
  end

  def mail_email(*args)
    return creator.mail_email
  end

  def email
    return self.creator.email
  end

  def percent_funded
		if collected and goal
			((collected.to_f / goal.to_f )*100).to_i
		else
			20
		end
  end

  def collected
		sum = 0
		donations.each{|x| sum += x.amount if x.amount}
		sum
  end

  def start_date_bad_format
    start_date ? start_date.strftime("%m/%d/%Y") : ""
  end

  def start_date_bad_format=(bad_time)
    self.start_date = Date.strptime(bad_time,"%m/%d/%Y")
  end

  def end_date_bad_format
    end_date ? end_date.strftime("%m/%d/%Y") : ""
  end

  def end_date_bad_format=(bad_time)
    self.end_date = Date.strptime(bad_time,"%m/%d/%Y")
  end


  # def project_images_json
  #   gallery_images.collect {|g_i| {:title => g_i. :value => g_i.remote_image_url } }
  # end
end
