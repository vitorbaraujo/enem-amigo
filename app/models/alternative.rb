# File: alternative.rb
# Purpose: Maintain logic for alternative.
# License: LGPL. No copyright.

# This class represents the information on alternative model.

class Alternative < ActiveRecord::Base

  belongs_to :question
  validates :letter, length: { maximum: 1 }
  validates_presence_of :letter
  validates_presence_of :description

end
