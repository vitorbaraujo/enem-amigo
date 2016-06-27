# File: comments_controller.rb
# Purpose: Controller of comments. 
# License : LGPL. No copyright.

# This controller creates, delete and edit a comment,
# control the rates,
# and require params of comments.

class CommentsController < ApplicationController

  before_action :authenticate_user
  before_action :verify_user_permission, only: [:destroy, :edit]

  # name: new
  # explanation: instantiates an object
  # parameters:
  # -none
  # return: a comment object

  def new
    @comment = Comment.new

    assert(@comment.kind_of?(Comment))

    return @comment
  end

  # name: create
  # explanation: creates a comment
  # parameters:
  # -none
  # return: topic or new_post_comment_path

  def create
    @comment = Comment.new(comment_params)

    assert(@comment.kind_of?(Comment))

    @comment.user_id = current_user.id

    assert(@comment.user_id.kind_of?(Comment))

    @comment.post_id = params[:post_id]

    assert(@comment.post_idkind_of?(Comment))

    if @comment.save
      flash[:success] = t(:created_comment)
      return redirect_to (Topic.find(session[:topic_id]))
    else
      return redirect_to (new_post_comment_path(params[:post_id]))
    end

  end

  # name: edit
  # explanation: find a comment to update
  # parameters:
  # -none
  # return: a comment object

  def edit
    @comment = Comment.find(params[:comment_id])
    
    assert(@comment.kind_of?(Comment))

    return @comment
  end

  # name: update
  # explanation: update a comment
  # parameters:
  # -none
  # return: a topic or edit_post_comment_path

  def update
    @comment = Comment.find(params[:comment_id])

    assert(@comment.kind_of?(Comment))

    if @comment.update_attributes(comment_params)
      flash[:success] = t(:update_comment)
      return redirect_to (Topic.find(session[:topic_id]))
    else
      return redirect_to (edit_post_comment_path(session[:topic_id]))
    end

  end

  # name: rate_comment
  # explanation: rate a comment
  # parameters:
  # -none
  # return: root_path or save comment 

  def rate_comment
    render nothing: true

    comment = Comment.find(params[:id])

    assert(comment.kind_of?(Comment))

    if !(comment.user_ratings.include? current_user.id)
      comment.user_ratings.push(current_user.id)
      return comment.save
    else
      return redirect_to_back (root_path)
    end

  end

  # name: destroy
  # explanation: delete a comment
  # parameters:
  # -none
  # return: topic 

  def destroy
    @comment = Comment.find(params[:comment_id

    assert(@comment.kind_of?(Comment))

    @comment.destroy

    flash[:success] = t(:delete_comment)

    return redirect_to (Topic.find(session[:topic_id]))
  end

  # name: show
  # explanation: show a comment
  # parameters:
  # -none
  # return: comment object

  def show
    @comment = Comment.find(params[:id])
    return @comment
  end

  private

  # name: comment_params
  # explanation: require comment params
  # parameters:
  # -none
  # return: comment params hash

  def comment_params
    params.require(:comment).permit(:content)
  end

end



