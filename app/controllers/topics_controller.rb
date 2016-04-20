class TopicsController < ApplicationController

	include PostsHelper

	before_action :authenticate_user
	before_action :verify_user_permission, only: [:edit, :destroy]
  before_action :authenticate_admin, only: [ :new, :create, :edit, :destroy, :update ]

  # name: new
  # explanation: instantiates object
  # parameters:
  # -none
  # return: topic object

	def new
		return @topic = Topic.new
	end

  # name: create
  # explanation: creates a topic
  # parameters:
  # -none
  # return: redirect_to topic object

	def create
		@topic = Topic.new(topic_params)
		if @topic.save
			flash[:success] = "Tópico criado com sucesso"
			return redirect_to(@topic)
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
		return session[:topic_id] = @topic.id
	end

	# name: index
  # explanation: list all topics
  # parameters:
  # -none
  # return: topics objects

	def index
		return @topics = Topic.all
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
