# File: topic.rb
# Purpose: Implementation of topic's class 
# License : LGPL. No copyright.

# Post represents a user's post in a topic of forum. 
# Posts allow users to iniciate a discussion.

class Topic < ActiveRecord::Base

	validates :name, presence: true, uniqueness: true
	validates :description, presence: true, uniqueness: true

	has_many :posts
	
end
