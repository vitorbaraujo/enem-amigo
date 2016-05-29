# File: text.rb
# Purpose: Implementation of the class Text
# License: LGPL. No copyright.

# This class contains attributes to parse the json information from the question
# database into the system

class Text < ActiveRecord::Base

  belongs_to :question

  serialize :paragraphs, Array

end
