# File: users_helper.rb
# Purpose: Maintain logic for users.
# License: LGPL. No copyright.

# This helper contains auxiliary methods to be used in the controller of ranking and level of the users. 


module UsersHelper

 # name: top10
 # explanation: this method the ten users with the highest score
 # parameters:
 # -none
 #return: ranking of enemamigo
  def top10
    ranking = User.all.order(:points).reverse
    @top10 = ranking.take(10)
  end

 # name: find_level
 # explanation: this method level of user without updating it
 # parameters:
 # -none
 #return: level of enemamigo
  def find_level user_points
    @user_level = (Math.sqrt 2*user_points).to_i
  end

 # name: update user level
 # explanation: this method update user level
 # parameters:
 # -none
 #return: level of enemamigo
  def update_user_level
    current_user.update_attribute(:level,@user_level)
    @user_level = current_user.level
  end
  
end
