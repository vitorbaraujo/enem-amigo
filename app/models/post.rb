class Post < ActiveRecord::Base

  has_many :comments
  belongs_to :topic

  serialize :user_ratings, Array
  validates :content, presence: true
  belongs_to :user

  # name: count_post_rates
  # explanation: counts how many people have rated a post
  # parameters:
  # - none
  # return: an integer as described above
  def count_post_rates
    return self.user_ratings.count
  end

end

