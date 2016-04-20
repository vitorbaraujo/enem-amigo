class Comment < ActiveRecord::Base
  serialize :user_ratings, Array
  validates :content, presence: true

  belongs_to :post
  belongs_to :user

  # name: count_comment_rates
  # explanation: this method counts user ratings
  # parameters:
  # -none
  # return: amout of user ratings

	def count_comment_rates
    return self.user_ratings.count
  end
end
