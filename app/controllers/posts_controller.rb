# File: posts_controller.rb
# Purpose: Implementation of the Posts Controller
# License: LGPL. No copyright.

# This controller contains the logic involving creating, reading, updating and
# deleting posts linked to a single user. It also contains methods responsible
# for manage the quantity of people who rated a single post

class PostsController < ApplicationController

  before_action :authenticate_user
  before_action :verify_user_permission, only: [:destroy, :edit, :update]

  # name: new
  # explanation: instantiates a new post
  # parameters:
  # - none
  # return: a post object
  def new
    @post = Post.new

    assert(@post.kind_of?(Post))

    return @post
  end

  # name: create
  # explanation: fills the post object with info given by user
  # parameters:
  # - none
  # return: void
  def create
    @post = Post.new(post_params)

    assert(@post.kind_of?(Post))

    @post.user_id = current_user.id
    @post.topic_id = session[:topic_id]

    if @post.save
      flash[:success] = t(:create_post)
      redirect_to Topic.find(session[:topic_id])
    else
      render 'new'
    end
  end

  # name: show
  # explanation: shows a single post given an identifier
  # parameters:
  # - none
  # return: a post object as described above
  def show
    @post = Post.find(params[:id])

    assert(@post.kind_of?(Post))

    return @post
  end

  # name: index
  # explanation: shows a list of all posts
  # parameters:
  # - none
  # return: a relation of posts as described above
  def index
    @posts = Post.all

    return @posts
  end

  # name: edit
  # explanation: finds a post to edit given an identifier
  # parameters:
  # - none
  # return: a post object as described above
  def edit
    @post = Post.find(params[:post_id])

    assert(@post.kind_of?(Post))

    return @post
  end

  # name: update
  # explanation: fills the post object info given by user to edit a post
  # parameters:
  # - none
  # return: void
  def update
    @post = Post.find(params[:post_id])

    assert(@post.kind_of?(Post))

    if @post.update_attributes(post_params)
      flash[:success] = t(:update_post)
      redirect_to Topic.find(session[:topic_id])
    else
      render 'edit'
    end
  end

  # name: user_name
  # explanation: finds a user given an identifier, and then returns its name
  # parameters:
  # - none
  # return: a string with the name of the user found
  def user_name(user_id)
    user = User.where(id: user_id).name

    assert(user.kind_of?(User))

    return user
  end

  # name: rate_post
  # explanation: finds a post given an identifier and then mark this post as
  #  rated by user
  # parameters:
  # - none
  # return: void
  def rate_post
    render nothing: true

    post = Post.find(params[:id])

    assert(@post.kind_of?(Post))

    if not post.user_ratings.include? current_user.id
      post.user_ratings.push(current_user.id)
      post.save
    else
      redirect_to_back(root_path)
    end
  end

  # name: destroy
  # explanation: destroys a single post given an identifier
  # parameters:
  # - none
  # return: void
  def destroy
    @post = Post.find(params[:post_id])

    assert(@post.kind_of?(Post))

    @post.destroy

    flash[:success] = t(:delete_post)
    redirect_to Topic.find(session[:topic_id])
  end

  private

  # name: post_params
  # explanation: permit some parameters to be included in a post
  # parameters:
  # - none
  # return: void
  def post_params
    params.require(:post).permit(:content)
  end

end
