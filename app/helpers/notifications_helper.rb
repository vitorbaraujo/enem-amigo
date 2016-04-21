module NotificationsHelper

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

  def first_notification
    notification = Notification.create(message: "Bem-vindo(a) ao ENEM Amigo!", visualized: false, link: help_path, sender: "ENEM Amigo")
    current_user.notifications << notification
  end

end
