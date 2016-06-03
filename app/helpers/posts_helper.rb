# File: posts_helper.rb
# Purpose: Maintain logic for posts.
# License: LGPL. No copyright.

# This helper contains auxiliary methods to be used in the controller of new posts. 

module PostsHelper

 # name: new_post
 # explanation: this method list an new post
 # parameters:
 # -none
 # return: post of enemamigo
	def new_post
		@post = Post.new
	end
end
