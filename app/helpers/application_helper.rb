# File: application_helper.rb
# Purpose: Helper of Application. 
# License : LGPL. No copyright.

# The apsplication helper has one method to 
# define the tittle of home page.

module ApplicationHelper

	PAGE_TITLE = ''
	BASE_TITLE = 'Enem Amigo'

  # name: full_title
  # explanation: returns the full title depending on the current page
  # parameters:
  # page_title
  # return: the full title of enem amigo

  def full_title(page_title)
		page_title = PAGE_TITLE 
  	base_title = BASE_TITLE
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

end
