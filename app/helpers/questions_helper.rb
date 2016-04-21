module QuestionsHelper

  class Parser
    class << self

      def read_questions json_questions
        questions = JSON.parse(json_questions)["questions"]
        questions.each do |question|
          system_question = Question.new
          question.each do |attr, value|
            if attr == "text"
              value.each do |text|
                system_question.texts << Text.new(title: text["title"], paragraphs: text["paragraphs"],
                                    reference: text["reference"])
              end
            elsif attr == "alternatives"
              5.times do |i|
                system_question.alternatives.build
                system_question.alternatives[i].letter = value.keys[i]
                system_question.alternatives[i].description = value[value.keys[i]]
              end
            else
              eval "system_question.#{attr} = value"
            end
          end
          system_question.save
          topic_for_system_question = Topic.create(name: "Questão #{system_question.number} - Ano #{system_question.year}", question_id: system_question.id, description: "Dúvidas e respostas sobre a questão #{system_question.number} da prova do ano #{system_question.year}")
        end
      end

      def read_candidates_data candidates_data, test_year
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
    end
  end

end
