

class AddressValidator < ActiveModel::Validator
	STATES = ['AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']
	def validate(record)
		if  record.delivery_address["street_1"].nil? or record.delivery_address["street_1"].blank?
			record.errors[:delivery_address] << 'Needs a non-blank street address'
		end
		if record.delivery_address["city"].nil? or record.delivery_address["city"].blank?
			record.errors[:delivery_address] << 'Needs a non-blank city'
		end
		if record.delivery_address["state"].nil? or !(STATES.include?(record.delivery_address["state"].upcase))
			record.errors[:delivery_address] << 'Needs a valid two-letter state abbreviation. '
		end
		if (record.delivery_address["zip"].nil?) or (record.delivery_address["zip"].length != 5) or (record.delivery_address["zip"] != record.delivery_address["zip"].to_i.to_s)
			record.errors[:delivery_address] << 'Needs a valid five-digit zip code. '
		end
	end
end


class Donation < ActiveRecord::Base
	attr_accessible :user_id, :project_id, :amount, :project_customer_id, :stripe_charge_id, :stripe_card_id, :stripe_hash, :charge_successful, :reward_quantity, :reward_id, :reward_attributes, :project_participant_id, :delivery_address
	# attr_protected :stripe_charge_id, :stripe_card_id, :stripe_hash, :charge_successful
	serialize :stripe_hash, Hash
	serialize :delivery_address, Hash
	include ActiveModel::Validations
	validates_with AddressValidator,  if: "reward.delivery == 'delivery'"

	belongs_to :donator, :class_name => "User", :foreign_key => "user_id"
	belongs_to :donated_project, :class_name => "Project", :foreign_key => "project_id"
	belongs_to :project_customer, :foreign_key => "project_customer_id"
	belongs_to :reward, :class_name => "Reward", :foreign_key => "reward_id"
	belongs_to :project_participant

	def dollar_amount
		if amount
			"%#.2f" % (amount/100)
		else
			nil
		end
	end
	
	def stored_stripe_hash
		get_stripe_hash if stripe_hash.nil?
		stripe_hash
	end

	def set_stripe_hash_with_params(stripe_card, stripe_charge)
		if stripe_card
			stripe_hash[:card] = {
				:cardholder_name => stripe_card.name,
				:last4 => stripe_card.last4,
				:type => stripe_card.type,
			}
		end
		if stripe_charge
			stripe_hash[:charge] = {
				:captured => stripe_charge.captured,
				:refunded => stripe_charge.refunded,
				:failure_message => stripe_charge.failure_message,
				:failure_code => stripe_charge.failure_code,
				:dispute => stripe_charge.dispute
			}
			stripe_hash[:card] = {
				:cardholder_name => stripe_charge.card.name,
				:last4 => stripe_charge.card.last4,
				:type => stripe_charge.card.type,
			}
		end
	end

	
	def set_stripe_hash
		Stripe.api_key = donated_project.creator.stripe_secret_key
		stripe_customer = Stripe::Customer.retrieve(project_customer.stripe_customer_id)
		stripe_card = stripe_customer.cards.retrieve(stripe_card_id)
		stripe_charge = Stripe::Charge.retrieve(stripe_charge_id) if stripe_charge_id
		set_stripe_hash_with_params(stripe_card, stripe_charge)
	end

	def status
		if charge_successful.nil?
			'uncharged'
		else
			charge_successful ? 'success' : 'failure'
		end
	end


end
