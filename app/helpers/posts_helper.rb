module PostsHelper

 # name: new_post
 # explanation: this method list an new post
 # parameters:
 # -none
 # return: post
	def new_post
		@post = Post.new
	end
end
