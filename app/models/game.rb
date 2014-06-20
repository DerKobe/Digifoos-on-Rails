class Game < ActiveRecord::Base
  # extends ....................................................................
  # includes ...................................................................
  # constants ..................................................................
  # associations ...............................................................
  belongs_to :player1, class_name: 'Player'
  belongs_to :player2, class_name: 'Player'
  belongs_to :player3, class_name: 'Player'
  belongs_to :player4, class_name: 'Player'
  belongs_to :session

  # scopes .....................................................................
  # validations ................................................................
  validates_presence_of :player1, :player2, :player3, :player4

  # callbacks ..................................................................
  # additional config ..........................................................


  # class methods ..............................................................
  # instance methods ...........................................................
  # protected instance methods .................................................
  # private instance methods ...................................................
end
