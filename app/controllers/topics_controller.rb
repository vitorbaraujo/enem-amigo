# File: topics_controller.rb
# Purpose: Controller of topics. 
# License : LGPL. No copyright.

# This controller creates and shows a topic
# and require params of topics.

class TopicsController < ApplicationController

	include PostsHelper

	before_action :authenticate_user
	before_action :verify_user_permission, only: [:edit, :destroy]
  before_action :authenticate_admin, only: [ :new, :create, :edit, :destroy, :update ]

  # name: new
  # explanation: instantiates an object
  # parameters:
  # -none
  # return: a topic object

	def new
		@topic = Topic.new

    assert(@topic.kind_of?(Topic))

    return @topic
	end

  # name: create
  # explanation: creates a topic
  # parameters:
  # -none
  # return: redirect_to topic object

	def create
		@topic = Topic.new(topic_params)

    assert(@topic.kind_of?(Topic))

		if @topic.save
			flash[:success] = t(:create_topic)
			return redirect_to (@topic)
		else
      #nothing to do
    end

	end

  # name: show
  # explanation: show a topic
  # parameters:
  # -none
  # return: topic object

	def show
		@topic = Topic.find(params[:id])

    assert(@topic.kind_of?(Topic))

		session[:topic_id] = @topic.id
    session_topic = session[:topic_id]

    return session_topic
	end

	# name: index
  # explanation: list all topics
  # parameters:
  # -none
  # return: topics objects

	def index
		@topics = Topic.all
    return @topics
	end

	private

  # name: topic_params
  # explanation: require topic params
  # parameters:
  # -none
  # return: topic params hash

	def topic_params
		params.require(:topic).permit(:name, :description)
	end

end
