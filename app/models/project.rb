class Project < ActiveRecord::Base
  attr_accessible :title, :description, :goal_bad_format, :content, :profile_image_id, :stretch_goals, :end_date_bad_format, :start_date_bad_format, :short_path, :profile_image_url
  attr_protected :project_state, :start_date, :end_date, :goal
  before_create :set_short_path
  validates :project_state, inclusion: {in: %w(unapproved creator_approved admin_approved needs_work) }
  # has_one :profile_image, :class_name => "GalleryImage"
  has_many :updates
  belongs_to :creator, :class_name=> "User", :inverse_of => :created_projects, :foreign_key => "user_id"
  has_many :donations
  has_many :donators, :through => :donations, :class_name=> "User", :inverse_of => :donated_projects, :foreign_key => "user_id"
  has_many :followings
  has_many :followers, :through => :followings, :class_name => "User", :inverse_of => :followed_projects, :foreign_key => "user_id"
  has_many :gallery_images
  has_many :rewards
  has_many :project_participants

  validates :title, presence: true, length: {in: 6..55}
  validates :description, presence: true, length: {in: 1..150}
  # project content is huge, take out to prevent it from hogging caching?
  acts_as_messageable
  
  def set_short_path
    if self.short_path.nil? or self.short_path.blank?
      self.short_path = (0...3).map { (65 + rand(26)).chr }.join
      logger.ap self.short_path
      while Project.find_by_short_path(self.short_path) != nil
        self.short_path = (0...3).map { (65 + rand(26)).chr }.join
      end
    end
  end

  def active?
    Time.now > start_date and end_date > Time.now and project_state == 'admin_approved'
  end

  def name
    return title
  end

  def profile_image_url
    if self.profile_image
      self.profile_image.image.url
    else
      "Photo-Video-Slr-camera-icon.png"
    end
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
		if sum and goal and sum > 0 and goal > 0 
			((sum.to_f / goal.to_f )*100).ceil.to_i
		else
			0
		end
  end

  def collected
		sum/100
  end

  def collected_dollar_amount
    "%#.2f" % (sum/100)
  end

  def average_dollar_amount
    "%#.2f" % (sum/(100*donations.count))
  end

  def sum
    running_sum = 0
    donations.each{|x| running_sum += x.amount if x.amount}
    running_sum
  end

  def start_date_bad_format
    start_date ? start_date.strftime("%m/%d/%Y") : ""
  end

  def start_date_bad_format=(bad_time)
      self.start_date = Date.strptime(bad_time,"%m/%d/%Y") if bad_time
  end

  def end_date_bad_format
    end_date ? end_date.strftime("%m/%d/%Y") : ""
  end

  def end_date_bad_format=(bad_time)
    self.end_date = Date.strptime(bad_time,"%m/%d/%Y") if bad_time
  end

  def goal_bad_format
    goal ? goal/100 : 0.00
  end

  def goal_bad_format=(bad_goal)
    self.goal = (bad_goal.to_f)*100 if bad_goal #bad_goal[/^\s*\$\s*[\,\d]+\.\d+\s*$/])
  end

  def can_collect?
    if(end_date and goal)
      project_state == 'admin_approved' and (self.end_date < Date.tomorrow or sum > goal)
    else
      false
    end
  end


  # def project_images_json
  #   gallery_images.collect {|g_i| {:title => g_i. :value => g_i.remote_image_url } }
  # end
end
