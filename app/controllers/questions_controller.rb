# File: questions_controller.rb
# Purpose: Maintain logic for questions.
# License: LGPL. No copyright.

# This controller sets the behavior for showing questons to user.


class QuestionsController < ApplicationController

  before_action :authenticate_user
  before_action :authenticate_admin, only: [:new, :create, :edit, :destroy, :update]

  include QuestionsHelper

 # name: index
 # explanation: this method order questions by year and number
 # parameters: 
 # -none
 # return: questions of enemamigo
  def index
    @questions ||= Question.all.order(:year, :number)
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: edit
 # explanation: this method retrieves a single question from id and rertun it to edit view
 # parameters:
 # -none
 # return: question of enemamigo
  def edit
    @question ||= Question.find(params[:id])
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: update
 # explanation: this method retrieves a single question from id and update it 
 # parameters:
 # -none
 # return: question of enemamigo
  def update
    @question ||= Question.find(params[:id])
    assert(@questions.kind_of?(Question))
    check_update ||= @question.update_attributes(question_params)
    if check_update
      flash[:success] = t(:update_question)
      return redirect_to question_path
    else
      return render('edit')
    end
  end

 # name: show
 # explanation: this method order questions 
 # parameters:
 # -none
 # return: questions of enemamigo
  def show
    @question ||= Question.find(params[:id])
    assert(@questions.kind_of?(Question))
    return @question
  end

 # name: edit
 # explanation: this method order questions 
 # parameters:
 # -none
 # return: questions of enemamigo
  def destroy
    @question ||= Question.find(params[:id])
    assert(@questions.kind_of?(Question))
    @question.destroy
    flash[:success] = t(:delete_question)
    return redirect_to questions_path
  end

 # name: answer
 # explanation: this method order questions 
 # parameters:
 # -none
 # return: questions of enemamigo
  def answer
    question ||= Question.find(params[:id])
    assert(questions.kind_of?(Question))
    @answer_letter ||= params[:alternative]

    if params[:alternative].blank?
      redirect_to_back(root_path)
    else
      current_user.update_attribute(:tried_questions, current_user.tried_questions << question.id)
      question.update_attribute(:users_tries, question.users_tries + 1)

      @correct_answer ||= (@answer_letter == question.right_answer)

      respond_to do |format|
        format.html { redirect_to questions_path }
        format.js { @correct_answer }
      end

      if @correct_answer
        question.update_attribute(:users_hits, question.users_hits + 1)
      
        question_include ||= current_user.accepted_questions.include? question.id
        if !question_include
          current_user.accepted_questions.push(question.id)
          current_user.update_attribute(:points, current_user.points + 4)
        else 
          # nothing to do 
        end
      end
    end
  end

 # name: category
 # explanation: this method  associate category view with this controller
 # parameters:
 # -none
 # return: category
  def category
  end

 # name: nature
 # explanation: this method searches for questions from specific area   
 # parameters:
 # -none
 # return: questions of enemamigo
  def nature
    @questions ||= Question.where(area: "ciências da natureza e suas tecnologias").order(:year, :number)
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: humans
 # explanation: this method searches for questions from specific area  
 # parameters:
 # -none 
 # return: questions of enemamigo
  def humans
    @questions ||= Question.where(area: "ciências humanas e suas tecnologias").order(:year, :number)
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: languages
 # explanation: this method searches for questions from specific area  
 # parameters:
 # -none
 # return: questions of enemamigo
  def languages
    @questions ||= Question.where(area: "linguagens, códigos e suas tecnologias").order(:year, :number)
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: math
 # explanation: this method searches for questions from specific area  
 # parameters:
 # -none
 # return: questions of enemamigo
  def math
    @questions ||= Question.where(area: "matemática e suas tecnologias").order(:year, :number)
    assert(@questions.kind_of?(Question))
    return @questions
  end

 # name: recommended
 # explanation: this method searches for questions from recommended 
 # parameters:
 # -none
 # return: questions of enemamigo
  def recommended
    areas ||= ["ciências da natureza e suas tecnologias",
             "ciências humanas e suas tecnologias",
             "linguagens, códigos e suas tecnologias",
             "matemática e suas tecnologias"]
    @questions ||= []
    areas.each do |area|
      classification = current_user.classification(area)
      @questions ||= @questions | instance_eval("Question.#{classification}_questions('#{area}')")
      return @questions
    end
    
    @questions ||= @questions.select { |q| !current_user.accepted_questions.include? q.id }
    return @questions
  end

 # name: upload_questions
 # explanation: this method upload questions the enemamigo
 # parameters:
 # -none
 # return: redirect_to questions_path
  def upload_questions
    uploaded_file = params[:questions_file]

    if uploaded_file.nil?
      raise Exception
    else
      # nothing to do 
    end

    file_content = uploaded_file.read
      assert(file_content.nil? == false)
    Parser.read_questions(file_content)

    flash[:success] = t(:upload_message_question)
    return redirect_to questions_path
  end

 # name: upload_candidates_data
 # explanation: this method upload data from candidates 
 # parameters:
 # -none
 # return:redirect_to Question.find(params[:id]).next_questionh
  def upload_candidates_data
    uploaded_file = params[:candidates_data_file]

   if uploaded_file.nil?
      raise Exception
   else
      # nothing to do
    end

    file_content = uploaded_file.read

    Parser.read_candidates_data(file_content, params[:test_year])

    flash[:success] = t(:upload_message_data)
    return redirect_to questions_path
  end

 # name: next_questions
 # explanation: this method redirects to next question 
 # parameters:
 # -none
 # return:redirect_to Question.find(params[:id]).next_questionh
  def next_question
    return redirect_to Question.find(params[:id]).next_question
    assert(@questions.kind_of?(Question))
  end

  private

 # name: question_params
 # explanation: this method udes to collet all the fields from object questions
 # parameters:
 # -none
 # return: question_params
  def question_params
    params.require(:question).permit(:year, :area, :number, :enunciation, :reference, :image, :right_answer, :alternatives_attributes => [:id, :letter, :description])
  end

end
