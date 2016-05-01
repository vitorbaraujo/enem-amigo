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
