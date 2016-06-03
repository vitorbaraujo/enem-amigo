# File: medal.rb
# Purpose: Implementation of the class Medal
# License: LGPL. No copyright.

# This class represents the recognition by the system of the user's advance,
# including actions to check valid returns

class Medal < ActiveRecord::Base

  has_and_belongs_to_many :users

  serialize :achieved_instructions, Array
  serialize :message_instructions, Array

  validates :name, presence: true
  validates :deion, presence: true
  validates :image, presence: true
  validates :achieved_instructions, presence: true
  validates :message_instructions, presence: true
  validate :instructions_work


  private

  # name: instructions_work
  # explanation: Checks if instructions about the medals's behavior are correct
  # parameters:
  # - none
  # return: method to check if instructions are in the correct class
  def instructions_work
    current_user = User.create(name: "Joao", email: "joao@gmail.com", password: "12345678", nickname: "joaovitor")
    current_user.restore_attributes

    achieved_return = achieved?(current_user)
    if current_user.changed?
      errors.add(:achieved_instructions, "Changing user information")
    else
      # nothing to do
    end
    current_user.restore_attributes

    message_return = message(current_user)
    if current_user.changed?
      errors.add(:message_instructions, "Changing user information")
    else
      # nothing to do
    end

    return instructions_return_valid_class(achieved_return, message_return)
  end

  # name: instructions_return_valid_class
  # explanation: Checks if parameters are in the correct class (boolean and string)
  # parameters:
  # - achieved_return: boolean from achieved? method
  # - message_return: String with instructions
  # return: none
  def instructions_return_valid_class(achieved_return, message_return)
    if (achieved_return.class != TrueClass && achieved_return.class != FalseClass)
      errors.add(:achieved_instructions, "Achieved must be True or False")
    else
      # nothing to do
    end

    if message_return.class != String
      errors.add(:message_instructions, "Message must be String")
    else
      # nothing to do
    end
  end

  # name: achieved?
  # explanation: Checks if user got the medal
  # parameters:
  # - current_user: Object from User class that represents the current user of the system
  # return: none
  def achieved?(current_user)
    achieved_instructions.each do |instruction|
      eval instruction
    end

    rescue
      errors.add(:achieved_instructions, "Invalid instructions")
  end

  # name: message
  # explanation: Display the message with that is missing to win the medal
  # parameters:
  # - current_user: Object from User class that represents the current user of the system
  # return: none
  def message(current_user)
    message_instructions.each do |instruction|
      eval instruction
    end

    rescue
      errors.add(:message_instructions, "Invalid instructions")
  end

end
