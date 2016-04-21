module UsersHelper

 # name: new_post
 # explanation: this method the ten users with the highest score
 # parameters:
 # -none
 #return: ranking
  def top10
    ranking = User.all.order(:points).reverse
    @top10 = ranking.take(10)
  end

 # name: new_post
 # explanation: this method level of user without updating it
 # parameters:
 # -none
 #return: level
  def find_level user_points
    @user_level = (Math.sqrt 2*user_points).to_i
  end

 # name: new_post
 # explanation: this method update user level
 # parameters:
 # -none
 #return: level 
  def update_user_level
    current_user.update_attribute(:level,@user_level)
    @user_level = current_user.level
  end
  
end
