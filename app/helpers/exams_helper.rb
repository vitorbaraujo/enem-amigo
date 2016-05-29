# File: exams_helper.rb
# Purpose: Implementation of the Exams Helper
# License: LGPL. No copyright.

# This helper contains auxiliar methods to be used in the controller of the
# exams to generate the questions for the new exam, in addition to check the
# user answers to the exam

module ExamsHelper

  BLANK_STRING = ""
  MATH_AREA = "matemática e suas tecnologias"
  SCIENCE_AREA = "ciências humanas e suas tecnologias"
  LANGUAGES_AREA = "linguagens, códigos e suas tecnologias"
  NATURE_AREA = "ciências da natureza e suas tecnologias"

  # name: fill_user_answers
  # explanation: fills the exam answers by answers given by user
  # parameters:
  # - exam: object
  # return: the exam filled with the user answers
  def fill_user_answers(exam)
    exam.questions.each do |t|
      question = Question.find(t)

      question_alternative = params[:"alternative_#{question.id}"]
      user_answer = BLANK_STRING

      if question_alternative
        user_answer = question_alternative
      else
        user_answer = "nao marcou"
      end

      exam.user_answers.push(user_answer)

      if user_answer == question.right_answer
        exam.accepted_answers = exam.accepted_answers + 1
      else
        # nothing to do
      end
    end

    return exam
  end

  # name: push_questions_auxiliar
  # explanation: creates auxiliar exam with all questions needed
  # parameters:
  # - questions: relation of questions
  # return: the auxiliar exam as described above
  def push_questions_auxiliar(questions)
    @humans_questions = questions.where(area: SCIENCE_AREA)
    @math_questions = questions.where(area: MATH_AREA)
    @language_questions = questions.where(area: LANGUAGES_AREA)
    @nature_questions = questions.where(area: NATURE_AREA)

    auxiliar_exam = Exam.new

    set_humans_questions = ((0...@humans_questions.count).to_a)
    set_humans_questions = set_humans_questions.sample(22)

    set_math_questions = ((0...@math_questions.count).to_a)
    set_math_questions = set_math_questions.sample(22)

    set_language_questions = ((0...@language_questions.count).to_a)
    set_language_questions = set_language_questions.sample(23)

    set_nature_questions = ((0...@nature_questions.count).to_a)
    set_nature_questions = set_nature_questions.sample(23)

    auxiliar_exam.questions.push(set_humans_questions)
    auxiliar_exam.questions.push(set_math_questions)
    auxiliar_exam.questions.push(set_language_questions)
    auxiliar_exam.questions.push(set_nature_questions)

    return auxiliar_exam
  end

  # name: push_questions
  # explanation: insert questions ans answers for these questions into an exam
  # parameters:
  # - auxiliar_exam: exam object
  # return: the exam ready to be answered
  def push_questions(auxiliar_exam)
    @exam = Exam.new

    for i in 0...4
      auxiliar_exam.questions[i].each do |a|
        if i == 0
          single_question = @humans_questions[a]
        elsif i == 1
          single_question = @math_questions[a]
        elsif i == 2
          single_question = @language_questions[a]
        elsif i == 3
          single_question = @nature_questions[a]
        else
          # nothing to do
        end

        @exam.questions.push(single_question.id)
        @exam.right_answers.push(single_question.right_answer)
      end
    end

    @exam.save

    return @exam
  end

end

