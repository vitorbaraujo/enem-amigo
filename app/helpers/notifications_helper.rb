# File: notifications_helper.rb
# Purpose: Maintain additional logic for notifications.
# License: LGPL. No copyright.

# This helper maintain methods to create a notification, to create a battle
# answer notification and to create the first notification in the system.

module NotificationsHelper

  # name: new_battle_notification
  # explanation: sends an user a message that he is being challenged by another user
  # parameters:
  # - battle: an object of Battle class
  # return: none
  def new_battle_notification(battle)
    message = "#{current_user.name} convidou você para uma batalha"
    if battle.category != ""
      message += ' da categoria ' + battle.category
    else
      # nothing to do
    end
    notification = Notification.create(message: message, user: battle.player_2, battle: battle, visualized: false, link: battles_path, sender: current_user.name)
    battle.notifications << notification
    battle.player_2.notifications << notification
  end

  # name: battle_answer_notification
  # explanation: sends notification to player that challenged another about another's answer
  # parameters:
  # - battle: an object of Battle Class
  # - answer: an String with the answer from user
  # return: none
  def battle_answer_notification(battle, answer)
    message = "#{current_user.name} "
    if answer
      message = message + ""
    else
      message = message + "não "
    end
    message = message + "aceitou seu convite para uma batalha"

    notification = Notification.create(message: message, user: battle.player_1, battle: battle, visualized: false, link: battles_path, sender: current_user.name)
    battle.player_1.notifications << notification
  end

  # name: first_notification
  # explanation: creates a notification welcoming user to the system
  # parameters:
  # - none
  # return: none
  def first_notification
    notification = Notification.create(message: "Bem-vindo(a) ao ENEM Amigo!", visualized: false, link: help_path, sender: "ENEM Amigo")
    current_user.notifications << notification
  end

end
