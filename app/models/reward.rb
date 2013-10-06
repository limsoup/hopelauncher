class Reward < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :project_id, :description, :donation_amount_bad_format, :scale, :stock, :value_bad_format
  attr_protected :donation_amount, :value

  belongs_to :project
  has_many :donations

  

  def donation_amount_bad_format
    donation_amount ? "%#.2f" % (donation_amount/100) : 0.00
  end

  def donation_amount_bad_format=(bad_donation_amount)
    self.donation_amount = (bad_donation_amount.to_f)*100 if bad_donation_amount #bad_goal[/^\s*\$\s*[\,\d]+\.\d+\s*$/])
  end

  def value_bad_format
    value ? "%#.2f" % (value/100) : 0.00
  end

  def value_bad_format=(bad_value)
    self.value = (bad_value.to_f)*100 if bad_value #bad_goal[/^\s*\$\s*[\,\d]+\.\d+\s*$/])
  end

  def title
    self.description.slice(0..39)
  end
end