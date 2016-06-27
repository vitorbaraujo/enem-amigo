# File: exams_controller.rb
# Purpose: Maintain logic for exams.
# License: LGPL. No copyright.

# This controller lists exams for the users answer.

include ExamsHelper

class ExamsController < ApplicationController

  before_action :authenticate_user

 # name: select_exam
 # explanation: this method  associate select_exam view with this controller
 # parameters:
 # -none
 # return: select_exam
  def select_exam
  end

 # name: exams_statistics
 # explanation: this method associate exams_statistics view with this controller
 # parameters:
 # -none
 # return: exams_statistics
  def exams_statistics
  end

 # name: answer_exam
 # explanation: this method 
 # parameters:
 # -none
 # return: questions of enemamigo
  def answer_exam
    if params[:year_exam] 
      questions ||= Question.where(year: params[:year_exam])
      assert(questions.kind_of?(Question))
    else
      questions ||= Question.all
      assert(questions.kind_of?(Question))
    end

    if !questions.empty?
      auxiliar_exam ||= push_questions_auxiliar(questions)
      @exam = push_questions(auxiliar_exam)
    else
      redirect_to_back(select_exam_path)
      if params[:year_exam]
        flash[:danger] = t(:year_exam_not_found)
      else
        flash[:danger] = t(:exam_not_found)
      end
    end
  end

 # name: exam_result
 # explanation: this method list result of the exam of enemamigo
 # parameters:
 # -none
 # return: @exam.user_answers
  def exam_result
    if params[:exam_id]
      @exam = Exam.find(params[:exam_id])
      assert(exam.kind_of?(Exam))
      @exam = fill_user_answers(@exam)

      current_user.exams_total_questions += @exam.questions.count
      current_user.update_attribute(:exam_performance, current_user.exam_performance + [@exam.accepted_answers])

      @exam.save
      return @exam.user_answers
    else
      return redirect_to_back
      flash[:danger] = t(:exam_message)
    end
  end

 # name: cancel_exam
 # explanation: this method cancel of exam of enemamigo
 # parameters:
 # -none
 # return:redirect_to root_path
  def cancel_exam
    exam = Exam.find(params[:exam_id])
    assert(exam.kind_of?(Exam))
    exam.destroy
    return redirect_to root_path
  end

end
