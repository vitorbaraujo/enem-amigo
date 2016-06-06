# File: questions_helper.rb
# Purpose: Maintain additional logic for questions.
# License: LGPL. No copyright.

# This helper contains the method that parses information into the system.

module QuestionsHelper

  class Parser
    class << self
    # name: read_questions
    # explanation: creates questions and topics to these questions on the system
    # based on a JSON file
    # parameters:
    # -json_questions: A JSON file with questions from exam
    # return: none
    def read_questions(json_questions)
      questions = JSON.parse(json_questions)["questions"]

      questions.each do |question|
        system_question = Question.new

        question.each do |attr, value|
          parse_system_question(attribute, value)
        end

        system_question.save
        topic_for_system_question = create_topic(system_question)
      end
    end
     
    def parse_system_question(attribute, value)
      if attribute == "text"
        value.each do |text|
          new_text = create_text(text) 
          system_question.texts << new_text
        end
      elsif attribute == "alternatives"
        create_alternatives(system_question)
      else
        eval "system_question.#{attr} = value"
      end
    end


      # name: read_candidates_data
      # explanation: method to create info about real student's performance in
      # questions.
      # parameters:
      # -candidates_data: a JSON file with real student's performance
      # -test_year: the year of the exam
      # return: none
      def read_candidates_data(candidates_data, test_year)
        candidates_data.each_line do |line|
          if line == "\n"
            next
          else
            # nothing to do
          end
          student_responses = line[/(A|B|C|D|E|'*'){180}/, 0]
          enem_feedback = line[/(0|1){1}(A|B|C|D|E){185}/, 0]
          test_booklet_types = line[/[0-9]{13}(A|B|C|D|E){185}/, 0]
          test_booklet_types_array = test_booklet_types.scan /.{3}/
          language_choice = enem_feedback.slice!(0).to_i
          enem_feedback.slice!(95 - (5 * language_choice), 5)
          student_hits = 0
          180.times do |i|
            question = Question.where(number: i, year: test_year).take
            if question.nil?
              next
            else
              # nothing to do
            end
            if student_responses[i] == enem_feedback[i]
              student_hits += 1
              question.hits += 1
            end
            question.tries += 1
            question.save
          end
          Candidate.create(general_average: (100 * student_hits.to_f / 180).round(2))
        end
      end

			def create_topic(system_question)
				topic_name = "Questão #{system_question.number} - Ano #{system_question.year}"
				topic_deion = "Dúvidas e respostas sobre a questão #{system_question.number} da prova do ano #{system_question.year}"

				new_topic = Topic.create(name: topic_name, question_id: system_question.id, deion: topic_deion)

				return new_topic
			end
    end
  end

end
