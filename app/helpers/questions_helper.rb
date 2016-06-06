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

    NUMBER_OF_QUESTIONS_IN_A_EXAM = 180

      # name: read_candidates_data
      # explanation: method to create info about real student's performance in
      # questions.
      # parameters:
      # -candidates_data: a JSON file with real student's performance
      # -test_year: the year of the exam
      # return: none
      def read_candidates_data(candidates_data, test_year)
        candidates_data.each_line do |line|
          if line != "\n"
            student_responses = regex_to_find_student_response(line)
            enem_feedback = regex_to_find_enem_feedback(line)
            text_booklet_types = regex_to_find_test_booklet_types(line)
            test_booklet_types_array = test_booklet_types.scan(/.{3}/)

            language_choice = enem_feedback.slice!(0).to_i
            enem_feedback.slice!(95 - (5 * language_choice), 5)
            student_hits = 0
            i = 0

            parse_questions_response(test_year, student_hits, enem_feedback, students_responses)

            create_candidate(student_hits)
          else
            # nothing to do
          end
        end
      end

      # name: parse_questions_response
      # explanation: method to create info about real student's tries and accepted
      # answers.
      # parameters:
      # - test_year: the year of the exam
      # - enem_feedback: questions of ENEM
      # - student_hits: number of questions a student got right
      # - students_responses: questions a student tried to answer
      # return: void
      def parse_questions_response(test_year, student_hits, enem_feedback, students_responses)
        for i in 0...NUMBER_OF_QUESTIONS_IN_A_EXAM
          question = Question.where(number: i, year: test_year).take

          if !question.nil?
            if student_responses[i] == enem_feedback[i]
              student_hits = student_hits + 1
              question.hits = question.hits + 1
            end

            question.tries = question.tries + 1
            question.save
          else
            # nothing to do
          end
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

      # name: create_alternatives
      # explanation: creates alternatives for questions for user  the system
      # questions.
      # parameters:
      # -candidates_data: a JSON file with a JSON file with alternatives for questions for user  the system
      # return: none
       def create_alternatives(system_question)
        5.times do |i|
          system_question.alternatives.build
          system_question.alternatives[i].letter = value.keys[i]
          system_question.alternatives[i].deion = value[value.keys[i]]
        end
      end

      # name: create_topic
      # explanation: creates a topic for a question in the system
      # parameters:
      # - system_question: a question from the system
      # return: topic
			def create_topic(system_question)
				topic_name = "Questão #{system_question.number} - Ano #{system_question.year}"
				topic_deion = "Dúvidas e respostas sobre a questão #{system_question.number} da prova do ano #{system_question.year}"

				new_topic = Topic.create(name: topic_name, question_id: system_question.id, deion: topic_deion)

				return new_topic
			end

      # name: create_text
      # explanation: creates a text with given json hash
      # parameters:
      # - text: hash extracted from a json file
      # return: object of type Text
      def create_text(text)
        new_text = Text.new(title: text["title"], paragraphs: text["paragraphs"], reference: text["reference"])

        return new_text
      end

      # name: create candidate
      # explanation: creates a candidate based on a real candidate of ENEM with
      # a average of questions hit
      # parameters:
      # - student_hits: questions a real candidate got right
      # return: Candidate
      def create_candidate(student_hits)
        average = (100 * student_hits.to_f / 180).round(2)

        Candidate.create(general_average: average)

        return Candidate
      end

      # name: regex_to_find_student_response
      # explanation: use a regex to find a response from a real student in a json
      # file
      # parameters:
      # - line: line of the json file
      # return: hash
      def regex_to_find_student_response(line)
        student_response = line[/(A|B|C|D|E|'*'){180}/, 0]

        return student_response
      end

      # name: regex_to_find_enem_feedback
      # explanation: use a regex to find enem feedback of a json line
      # parameters:
      # - line: line of the json file
      # return: hash
      def regex_to_find_enem_feedback(line)
        enem_feedback = line[/(0|1){1}(A|B|C|D|E){185}/, 0]

        return enem_feedback
      end

      # name: regex_to_find_test_booklet_types
      # explanation: use a regex to find test booklet types of a json line
      # parameters:
      # - line: line of the json file
      # return: hash
      def regex_to_find_test_booklet_types(line)
        test_booklet_types = line[/[0-9]{13}(A|B|C|D|E){185}/, 0]

        return test_booklet_types
      end
    end
  end
end
