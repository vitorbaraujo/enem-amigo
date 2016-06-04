# File: comment.rb
# Purpose: Implementation of comment's class 
# License : LGPL. No copyright.

# Comments are present in the application’s forum 
# where discussions are held among users.
# These comments allow interaction between users.

class Comment < ActiveRecord::Base
  
  serialize :user_ratings, Array
  validates :content, presence: true

  belongs_to :post
  belongs_to :user

  # name: count_comment_rates
  # explanation: this method counts user ratings of a comment
  # parameters:
  # -none
  # return: amout of user ratings

	def count_comment_rates
    ratings_count = self.user_ratings.count
    return ratings_count
  end
end
