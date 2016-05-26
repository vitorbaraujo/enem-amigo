# File: candidate.rb
# Purpose: Implementation of candidate's class 
# License : LGPL. No copyright.

# Candidate represents the students that make ENEM test

class Candidate < ActiveRecord::Base
	
	validates :general_average, presence: true

end
